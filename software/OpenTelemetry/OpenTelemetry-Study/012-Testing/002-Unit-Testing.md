Based on the comprehensive Table of Contents provided, here is a detailed explanation of **Part XII, Section B: Unit Testing Instrumentation**.

---

# 012-Testing / 002-Unit-Testing.md

## Unit Testing Instrumentation

When developers add OpenTelemetry (OTel) to an application, they often treat it as "fire and forget." However, observability code is still code. If you write custom logic to create spans, add specific attributes based on business rules, or record exceptions, that logic can break.

**Unit Testing Instrumentation** focuses on verifying that your application emits the correct telemetry data without requiring a full backend (like Jaeger or Prometheus) to be running.

### 1. The Core Concept: The `InMemorySpanExporter`

In a production environment, OTel sends data over the network (via OTLP) to a Collector. In a unit test environment, this is undesirable because it introduces network latency, requires external infrastructure, and makes assertions difficult.

To solve this, OpenTelemetry SDKs provide an **`InMemorySpanExporter`**.

*   **What it does:** Instead of sending spans to a server, it stores finished spans in a simple List/Array in the computer's memory.
*   **Why it's useful:** Your test code can access this list, inspect the spans, and make assertions (e.g., "Did I get exactly one span?", "Does this span have the attribute `user_id: 123`?").

#### The Test Architecture
1.  **Initialize SDK:** Create a `TracerProvider`.
2.  **Configure Exporter:** Attach an `InMemorySpanExporter`.
3.  **Configure Processor:** Use a `SimpleSpanProcessor` (crucial for tests) instead of `BatchSpanProcessor`.
4.  **Run Logic:** Execute the business function you want to test.
5.  **Assert:** Query the exporter for finished spans and verify the data.

### 2. Implementation Examples

Here is how this concept is applied in the two most common OTel languages.

#### A. Node.js / TypeScript Example

In JavaScript, you use the `InMemorySpanExporter` from the basic SDK package.

```typescript
import * as assert from 'assert';
import { BasicTracerProvider, SimpleSpanProcessor, InMemorySpanExporter } from '@opentelemetry/sdk-trace-base';
import { trace } from '@opentelemetry/api';

// 1. Setup the Test Harness
const memoryExporter = new InMemorySpanExporter();
const provider = new BasicTracerProvider();

// Use SimpleSpanProcessor. 
// BatchProcessor sends data asynchronously and might delay your test assertions.
provider.addSpanProcessor(new SimpleSpanProcessor(memoryExporter));

// Register the provider globally (or pass it via Dependency Injection)
trace.setGlobalTracerProvider(provider);

// --- The Code Under Test ---
function processPayment(amount: number) {
    const tracer = trace.getTracer('payment-service');
    return tracer.startActiveSpan('process_payment', (span) => {
        span.setAttribute('payment.amount', amount);
        if (amount < 0) {
            span.recordException(new Error("Invalid amount"));
            span.setStatus({ code: 2 }); // Error
        }
        span.end();
    });
}

// --- The Unit Test ---
describe('Payment Instrumentation', () => {
    
    beforeEach(() => {
        // Clear previous traces before every test
        memoryExporter.reset(); 
    });

    it('should create a span with correct attributes', () => {
        // Act
        processPayment(500);

        // Assert
        const spans = memoryExporter.getFinishedSpans();
        
        assert.strictEqual(spans.length, 1);
        assert.strictEqual(spans[0].name, 'process_payment');
        assert.strictEqual(spans[0].attributes['payment.amount'], 500);
    });

    it('should record exceptions for invalid amounts', () => {
        // Act
        processPayment(-10);

        // Assert
        const spans = memoryExporter.getFinishedSpans();
        const events = spans[0].events;
        
        assert.strictEqual(events.length, 1);
        assert.strictEqual(events[0].name, 'exception'); // OTel standard event name
    });
});
```

#### B. Go Example

Go has a dedicated library `go.opentelemetry.io/otel/sdk/trace/tracetest` specifically for this.

```go
package main

import (
	"context"
	"testing"

	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/sdk/trace"
	"go.opentelemetry.io/otel/sdk/trace/tracetest"
)

func TestMyFunction(t *testing.T) {
	// 1. Create the InMemory Exporter
	exporter := tracetest.NewInMemoryExporter()

	// 2. Create the TracerProvider with the exporter
	tp := trace.NewTracerProvider(
		trace.WithSyncer(exporter), // 'Syncer' is Go's version of SimpleSpanProcessor
	)

	// 3. Get a tracer
	tracer := tp.Tracer("test-tracer")

	// 4. Run the logic (The Code Under Test)
	ctx := context.Background()
	_, span := tracer.Start(ctx, "my-operation")
	span.SetAttributes(attribute.String("test.key", "test.value"))
	span.End()

	// 5. Retrieve Spans (Snapshots)
	spans := exporter.GetSpans()

	// 6. Assertions
	if len(spans) != 1 {
		t.Errorf("Expected 1 span, got %d", len(spans))
	}
	if spans[0].Name() != "my-operation" {
		t.Errorf("Expected name 'my-operation', got %s", spans[0].Name())
	}
	
	// Check attributes
	found := false
	for _, attr := range spans[0].Attributes() {
		if attr.Key == "test.key" && attr.Value.AsString() == "test.value" {
			found = true
		}
	}
	if !found {
		t.Error("Attribute test.key not found")
	}
}
```

### 3. Mocking the TracerProvider

While `InMemorySpanExporter` tests the *data* produced, sometimes you want to unit test code that *uses* OTel, but you don't actually care about the telemetry in that specific test. You just want to make sure the call doesn't crash or that the dependencies are satisfied.

In this case, you use **No-Op (No Operation) Implementations** or **Mocks**.

#### The No-Op Provider
Every OTel SDK comes with a default "No-Op" implementation. If you call `trace.getTracer()` without registering a provider, you get a No-Op tracer. It implements the interface but does nothing.

*   **Use Case:** You are testing a database service. You don't want to assert on spans, but the service requires a Tracer in its constructor. You pass `trace.getTracerProvider().getTracer('noop')`.

#### Mocking Frameworks
If you are using Mockito (Java), Jest (JS), or GoMock (Go), you can mock the `Tracer` interface itself.

*   **Use Case:** You want to ensure your code handles a failure in the tracing system (rare) or you want to ensure `span.end()` was actually called exactly once, without setting up the full SDK pipeline.

### 4. Common Pitfalls in Unit Testing OTel

1.  **Batch vs. Simple Processor:**
    *   **Mistake:** Using `BatchSpanProcessor`. This processor buffers spans and sends them on a timer (e.g., every 5 seconds).
    *   **Result:** Your test finishes and assertions run *before* the processor exports the spans to memory. The list is empty, and the test fails.
    *   **Fix:** Always use `SimpleSpanProcessor` (or `WithSyncer` in Go) for unit tests. It writes to the exporter immediately when `span.end()` is called.

2.  **Global State Pollution:**
    *   **Mistake:** Registering the TracerProvider globally (`trace.setGlobalTracerProvider`) in one test and not cleaning it up.
    *   **Result:** Test B fails because it received spans from Test A, or Test B tries to register a new global provider and fails.
    *   **Fix:** Ideally, use Dependency Injection to pass the Tracer into your classes. If you must use Globals, ensure you have a `tearDown` or `afterEach` block that resets the Global provider.

3.  **Context Propagation:**
    *   Testing if your code correctly extracts a `traceparent` header from an incoming HTTP request is a specific type of unit test.
    *   You need to mock the HTTP headers object, pass it to the `propagator.extract()` method, and assert that the resulting Context object contains the expected TraceID.

### Summary Checklist for Unit Testing

When writing these tests, ensure you are verifying:
1.  **Cardinality:** Is the correct number of spans created? (e.g., 1 function call = 1 span).
2.  **Naming:** Is the Span name distinct and low-cardinality?
3.  **Attributes:** Are the business-critical attributes (IDs, status codes) present and correct?
4.  **Status:** If the code threw an error, is the Span Status set to `Error`?
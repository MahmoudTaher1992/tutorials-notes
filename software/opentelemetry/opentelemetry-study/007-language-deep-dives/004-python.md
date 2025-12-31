Here is a detailed study guide for the **Python Deep Dive** section of your OpenTelemetry curriculum.

***

# Module 007-D: Python Implementation Deep Dive

**File Path:** `software/OpenTelemetry/OpenTelemetry-Study/007-Language-Deep-Dives/004-Python.md`

## Overview
Python is one of the most widely supported languages in the OpenTelemetry ecosystem. Its dynamic nature allows for powerful **Automatic Instrumentation** (monkey patching), while its support for Decorators makes **Manual Instrumentation** clean and readable.

This module explores how to implement OTel in Python, ranging from zero-code cli-wrappers to writing custom decorators for complex business logic, and understanding vendor-specific distributions.

---

## 1. The Python OTel Ecosystem
Before writing code, it is critical to understand how the Python OTel libraries are packaged. Python enforces a strict separation between the API and the SDK.

| Package | Purpose |
| :--- | :--- |
| **`opentelemetry-api`** | The interfaces. Library authors (e.g., the maintainers of `requests` or `django`) only import this. It contains no implementation logic (No-Op by default). |
| **`opentelemetry-sdk`** | The implementation. This handles sampling, processing, and exporting. The end-user application installs this. |
| **`opentelemetry-instrumentation-*`** | Specific libraries that hook into frameworks (e.g., `opentelemetry-instrumentation-flask`, `opentelemetry-instrumentation-psycopg2`). |
| **`opentelemetry-distro`** | A meta-package that configures default settings (often provided by vendors like AWS or Splunk). |

---

## 2. Automatic Instrumentation (Zero-Code)

Python offers one of the robust auto-instrumentation experiences via the `opentelemetry-instrument` agent. This works by hooking into the import system and patching supported libraries at runtime.

### The Workflow
1.  **Install the agent:**
    ```bash
    pip install opentelemetry-distro opentelemetry-exporter-otlp
    ```
2.  **Bootstrap:** (Scans your installed packages and installs matching OTel instrumentations)
    ```bash
    opentelemetry-bootstrap -a install
    ```
3.  **Run:** Wrap your application start command.
    ```bash
    export OTEL_SERVICE_NAME="my-python-service"
    export OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317"

    opentelemetry-instrument python app.py
    # OR for WSGI/ASGI servers
    opentelemetry-instrument gunicorn main:app
    ```

**Pros:** Instant visibility into HTTP requests, DB queries, and AWS SDK calls without changing code.
**Cons:** Can be opaque; harder to debug if the monkey-patching conflicts with other libraries.

---

## 3. Manual Instrumentation & Decorators

While auto-instrumentation covers the edges (HTTP/DB), you often need to measure internal functions (business logic). Python's **Decorators** are the standard way to do this.

### A. Setting up the Boilerplate
If you aren't using the CLI agent, you must configure the SDK globally in your `main` entry point.

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter

# 1. Set the Tracer Provider
provider = TracerProvider()
trace.set_tracer_provider(provider)

# 2. Add an Exporter (e.g., Console or OTLP)
processor = BatchSpanProcessor(ConsoleSpanExporter())
provider.add_span_processor(processor)

# 3. Get a Tracer
tracer = trace.get_tracer("my.service.name")
```

### B. The `with` Context Manager
The most basic way to create a span.
```python
def process_data():
    with tracer.start_as_current_span("process_data_task") as span:
        span.set_attribute("data.size", 1024)
        # Your logic here
        print("Processing...")
```

### C. Using Decorators for Tracing
Decorators allow you to wrap functions cleanly. You can write your own, or use the pattern below.

#### Option 1: The Manual Decorator Pattern
You can create a reusable decorator to automatically trace any function it decorates.

```python
import functools
from opentelemetry import trace

tracer = trace.get_tracer(__name__)

def instrument_with_otel(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        # Start a new span with the function name
        with tracer.start_as_current_span(func.__name__) as span:
            # Capture arguments as attributes (be careful with PII!)
            span.set_attribute("code.function", func.__name__)
            try:
                return func(*args, **kwargs)
            except Exception as e:
                # Record exception details automatically
                span.record_exception(e)
                span.set_status(trace.Status(trace.StatusCode.ERROR))
                raise e
    return wrapper

@instrument_with_otel
def calculate_tax(amount):
    if amount < 0:
        raise ValueError("Negative amount")
    return amount * 0.2
```

**Why do this?** It keeps your business logic clean. You don't have `tracer.start...` cluttering every function.

---

## 4. Distributions (Distros)

Because configuring OpenTelemetry can be verbose (setting propagators, exporters, sampling, resource detectors), vendors provide "Distributions."

A **Distro** in Python is a pre-packaged version of the OTel SDK that sets defaults optimized for a specific backend.

### A. AWS Distro (ADOT Python)
*   **Package:** `aws-opentelemetry-distro`
*   **What it does:**
    *   Configures the ID Generator to be X-Ray compatible (X-Ray requires specific Trace ID formats).
    *   Sets the default propagator to `xray` (instead of `tracecontext`).
    *   Includes AWS Resource Detectors (ECS, EKS, Lambda).

### B. Splunk Distribution
*   **Package:** `splunk-opentelemetry`
*   **What it does:**
    *   Defaults the exporter to SignalFx/Splunk formats (or OTLP).
    *   Injects specific metadata required for Splunk Observability Cloud.
    *   Configures memory limits and batch sizes optimized for their ingest.

### C. Azure Monitor Distro
*   **Package:** `azure-monitor-opentelemetry`
*   **What it does:**
    *   Directly exports to Azure Application Insights.
    *   Handles Azure Active Directory (AAD) authentication automatically.
    *   Maps OTel attributes to standard Azure Monitor columns.

**Implementation difference:**
Instead of `opentelemetry-instrument`, you might run:
```bash
splunk-py-trace python main.py
```
*Always check the vendor documentation, as they override the standard OTel entry points.*

---

## 5. AsyncIO and Context Propagation

Python 3.7+ relies heavily on `asyncio` (FastAPI, newer Django).

### The Challenge
In threaded apps (Flask), context (TraceID) is stored in **Thread-Local Storage**.
In async apps (FastAPI), threads are reused. If you store a TraceID in a thread local, requests will get mixed up.

### The Solution: `contextvars`
OpenTelemetry Python uses the standard library `contextvars` module to manage context.
*   The OTel Context Manager automatically handles the "Token" logic to ensure that when an `await` yields execution, the Trace Context is preserved when execution resumes.

**Warning for Manual Threads:**
If you manually spawn a thread (`threading.Thread`), the context **is not** passed automatically. You must manually propagate it:

```python
from opentelemetry import context

def worker():
    # Context needs to be attached here
    with tracer.start_as_current_span("worker_span"):
        pass

# Capture current context
ctx = context.get_current()
# Pass it to the thread
t = threading.Thread(target=context.attach(ctx) and worker) # Pseudo-code, requires explicit context passing helpers
```
*Ideally, use `opentelemetry.context.attach` and `detach` or specific OTel thread wrappers.*

---

## 6. Summary Checklist

When deep-diving into Python OTel, ensure you master these concepts:

1.  **Monkey Patching:** How `opentelemetry-instrument` re-writes library calls at runtime.
2.  **Decorators:** How to write a wrapper that starts a span, catches exceptions, sets the Error status, and re-raises the exception.
3.  **ContextVars:** Why `threading.local()` fails in FastAPI/Asyncio and how OTel solves this.
4.  **Distros:** Knowing when to use the vanilla OTel SDK versus a vendor-specific package (AWS/Azure) to save configuration headaches.
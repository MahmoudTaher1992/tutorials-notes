This is a comprehensive, granular Table of Contents for studying **OpenTelemetry (OTel)**, structured to match the depth and organization of your React guide. It covers everything from architectural theory to deep-dive collector configuration and production scaling.

# OpenTelemetry: Comprehensive Study Table of Contents

## Part I: Observability Fundamentals & Core Principles

### A. Introduction to Observability
- Monitoring vs. Observability (The "Unknown Unknowns")
- The Three Pillars: Traces, Metrics, and Logs
- The role of vendor-neutrality (Lock-in avoidance)
- High Cardinality vs. High Dimensionality
- The place of OTel in modern DevOps and SRE

### B. The OpenTelemetry Architecture
- **API vs. SDK**: The Separation of Concerns
- The OTel Protocol (OTLP)
- The Data Pipeline: Provider, TextMapPropagator, Exporters
- Semantic Conventions (Standardizing naming schemes)
- Resource Detection (identifying the source environment)

## Part II: Tracing (Distributed Tracing)

### A. Anatomy of a Trace
- **Spans**: The building block (Name, Timestamp, Duration)
- Trace Identity (`TraceId` vs. `SpanId`)
- Parent/Child relationships and DAGs (Directed Acyclic Graphs)
- Span Kinds (Client, Server, Producer, Consumer, Internal)
- Span Status and Error Handling

### B. Context Propagation
- The "Glue" of Distributed Tracing
- W3C Trace Context Standard (`traceparent`, `tracestate`)
- B3 Propagation (Zipkin legacy)
- Baggage: Propagating arbitrary key-value pairs
- Process boundaries and Header manipulation

### C. Advanced Tracing Concepts
- Span Events (Logging within a span)
- Span Links (Connecting causal relationships across traces)
- Span Attributes vs. Resource Attributes
- Recording Exceptions

## Part III: Metrics & Aggregation

### A. Metric Instruments
- **Synchronous Instruments**:
  - Counter (Monotonic)
  - UpDownCounter
  - Histogram (Distribution of values)
- **Asynchronous Instruments** (Observable):
  - Observable Counter
  - Observable Gauge
  - Observable UpDownCounter

### B. Aggregation and Temporality
- Delta vs. Cumulative Temporality
- Aggregation Types (Sum, Last Value, Histogram, Explicit Bucket Histogram)
- Exponential Histograms (High-fidelity, low-cost)
- Cardinality Explosion Risks

### C. Views and Overrides
- Filtering unwanted metrics
- Renaming metrics or changing descriptions
- Changing bucket boundaries for Histograms
- Dropping attributes to control cardinality

## Part IV: Logs (The Logging Signal)

### A. Structured Logging
- The limitations of unstructured text logs
- The OTel Log Data Model
- Mapping legacy logging libraries to OTel (Log Appenders)

### B. Correlation
- Injecting `TraceId` and `SpanId` into Logs
- The concept of "Exemplars" (Connecting metrics to traces)
- Log transmission via OTLP

## Part V: Instrumentation Strategies

### A. Zero-Code (Auto-Instrumentation)
- How Java Agent / Python Distros work (Bytecode manipulation/Monkey patching)
- Pros and Cons: Ease of use vs. Control
- Configuration via Environment Variables

### B. Manual Instrumentation
- Getting the `Tracer` and `Meter`
- Creating custom Spans to measure specific logic
- Adding business-specific attributes
- Writing Custom Propagators or Samplers

### C. Libraries and Frameworks
- Instrumentation Libraries (e.g., `opentelemetry-instrumentation-express`, `opentelemetry-go-contrib`)
- Database instrumentation (SQL, Redis, MongoDB)
- HTTP Client/Server instrumentation

## Part VI: The OpenTelemetry Collector

### A. Collector Basics
- Architecture: Receivers, Processors, Exporters
- Deployment Modes: Agent (Sidecar) vs. Gateway (Aggregator)
- Configuration: `config.yaml` structure
- Extensions (Health check, Pprof, Z-Pages)

### B. Core Processors (The Processing Pipeline)
- **Batch Processor**: Performance optimization
- **Memory Limiter**: Preventing OOM crashes
- **Resource Processor**: Adding/modifying metadata (cloud region, k8s pod)
- **Attributes Processor**: Filtering/Redacting sensitive data (PII)

### C. Advanced Collector Usage
- **Tail Sampling Processor**: Intelligent retention (Sample 100% errors, 1% success)
- **Transform Processor (OTTL)**: OpenTelemetry Transformation Language for complex logic
- **Routing Processor**: Sending different data to different backends
- **Load Balancing Exporter**: Scaling the gateway layer

## Part VII: Language-Specific Implementation Deep Dives

### A. Java
- The Java Agent approach
- Spring Boot Integration (Micrometer Tracing Bridge)
- JMX Metrics gathering

### B. Go
- Context handling in Go (`context.Context`)
- Manual wiring of SDK components
- Goroutines and Context propagation

### C. JavaScript / TypeScript (Node.js & Browser)
- Node.js automatic instrumentation
- **OTel for the Browser (RUM)**:
  - `ZoneContextManager`
  - Document Load instrumentation
  - Handling CORS with OTLP

### D. Python
- Decorators for tracing
- Distros (Splunk, AWS, Azure variations)

## Part VIII: Sampling Strategies

### A. Head Sampling (Client-Side)
- AlwaysOn, AlwaysOff, TraceIDRatioBased
- ParentBased sampling (respecting upstream decisions)
- Pros: Low overhead; Cons: Low fidelity for errors

### B. Tail Sampling (Collector-Side)
- Wait for the full trace to arrive
- Policies: Latency, StatusCode, Probabilistic, Composite
- Architecture requirements (Load balancing by TraceID)

## Part IX: Backends and Visualization

### A. Integration Targets
- **Prometheus**: Pull-based metrics, Exporters vs. Prometheus Remote Write
- **Jaeger / Zipkin**: Trace visualization
- **Grafana**: Visualizing OTel data (Tempo for traces, Mimir for metrics, Loki for logs)
- **Elasticsearch (ELK)**: Storing OTel logs

### B. Cloud & Vendor Integrations
- AWS Distro for OpenTelemetry (ADOT) / X-Ray
- Google Cloud Trace / Stackdriver
- Azure Monitor
- Sending to Datadog, New Relic, Honeycomb, Dynatrace via OTLP

## Part X: Infrastructure & Kubernetes

### A. Kubernetes Operator
- The `OpenTelemetryCollector` CRD
- Automatic Sidecar Injection
- Auto-instrumentation Injection (`Instrumentation` CRD)
- Target Allocator (Scraping Prometheus endpoints in k8s)

### B. Infrastructure Monitoring
- Host Metrics Receiver (CPU, RAM, Disk)
- Kubelet Stats Receiver
- Receiver scrapers (Redis, PostgreSQL, Nginx receivers)

## Part XI: Performance, Security & Governance

### A. Performance Tuning
- Managing SDK overhead in the application
- Tuning Batch Processor sizes and timeouts
- Memory management in the Collector
- Handling Backpressure

### B. Data Security
- Redacting PII (Credit Cards, Emails) via Processors
- Implementing Authentication (OIDC, Basic Auth, Bearer Token)
- TLS/mTLS encryption between Agents and Gateways

### C. Cost Management
- Filtering high-cardinality attributes
- Dropping unnecessary spans (e.g., Health checks)
- Metric aggregation in the Collector to reduce storage costs

## Part XII: Testing and Quality Assurance

### A. Trace-Based Testing
- Concepts: Testing the *behavior* of the system via traces
- Tools: **Tracetest**, Malabi
- Asserting against Span attributes and timing

### B. Unit Testing Instrumentation
- `InMemorySpanExporter` for verifying logic
- Mocking the TracerProvider

## Part XIII: Emerging Frontiers (2025 Era)

### A. Profiling (The Fourth Signal)
- Continuous Profiling concepts (CPU, Memory flamegraphs)
- OTel Profiling Data Model (Stabilization phase)
- eBPF Integration

### B. Client-Side/RUM Evolution
- Session Replay integration
- Web Vitals metrics via OTel

### C. OpAMP (Open Agent Management Protocol)
- Remote configuration management of Fleets of Collectors
- Status reporting

## Part XIV: Workflow & Developer Experience

### A. Local Development
- Running the OTel Demo Application (Webstore)
- Viewing traces locally (Jaeger All-in-One, Aspire Dashboard)

### B. Debugging OTel
- Self-diagnostics (`OTEL_DIAG_LEVEL`)
- The `debug` exporter (Console output)
- Troubleshooting "Broken Traces"

### C. CI/CD Integration
- Observability in CI pipelines (OTel Maven/Gradle plugins, GitHub Actions)
# Jaeger: Comprehensive Study Table of Contents

## Part I: Observability & Tracing Fundamentals

### A. Introduction to Distributed Tracing
- The Three Pillars of Observability (Metrics, Logs, Traces)
- Monoliths vs. Microservices Debugging Challenges
- What is Distributed Tracing? (The "Story" of a Request)
- Key Concepts:
  - **Trace**: The full journey
  - **Span**: An individual unit of work
  - **Tags**: Key-value pairs for metadata
  - **Logs/Events**: Time-stamped events inside a span
  - **Baggage**: Data carried across process boundaries
- The Google Dapper Paper influence

### B. The Jaeger Project
- History (Uber engineering) and CNCF Graduation
- Jaeger vs. Zipkin (History and Compatibility)
- OpenTracing (Legacy) vs. OpenTelemetry (Modern Standard)
- The "Hot R.O.D." (Rides on Demand) Example Application

## Part II: Jaeger Architecture & Components

### A. Core Components
- **Jaeger Client** (Deprecated/Transitioning to OpenTelemetry SDKs)
- **Jaeger Agent**: The sidecar/daemon listener
- **Jaeger Collector**: Validating, transforming, and saving spans
- **Jaeger Query**: Retrieving traces for the UI
- **Jaeger Ingester**: Reading from Kafka (Async architecture)
- **Jaeger UI**: The visual frontend

### B. Deployment Topologies
- **All-in-One**: Single binary for development/testing
- **Direct to Storage**: Agent -> Collector -> DB
- **Streaming/Asynchronous**: Agent -> Collector -> Kafka -> Ingester -> DB
- When to scale which component

## Part III: Instrumentation (The Data Source)

### A. The Shift to OpenTelemetry (OTel)
- Why Jaeger Clients are being deprecated
- OpenTelemetry Architecture (Collector, SDKs, Exporters)
- Configuring OTel to export to Jaeger (OTLP vs. Jaeger Thrift)

### B. Instrumentation Strategies
- **Auto-Instrumentation**: Agents (Java, Python, Node.js) and Zero-code setup
- **Manual Instrumentation**: Creating Spans programmatically
  - Starting and finishing spans
  - Child-of vs. Follows-from references
  - Adding semantic conventions (HTTP status, DB types)
  - Handling Context Propagation (Inject/Extract)

### C. Context Propagation Deep Dive
- HTTP Headers (B3, W3C TraceContext, Jaeger-native)
- Propagation across Async boundaries (Message queues, Kafka, gRPC)
- Baggage items: Use cases and overhead risks

## Part IV: Storage Backends & Persistence

### A. Supported Storage Backends
- **Memory**: For testing/ephemeral usage
- **Elasticsearch / OpenSearch**: The most common production standard
- **Cassandra**: Legacy heavy-write preference
- **Badger**: Local persistent storage
- **gRPC Plugin**: Creating custom storage adaptors (e.g., ClickHouse, PostgreSQL)

### B. Storage Operations
- Index cleaning and rollover strategies
- Schema management
- Calculating storage requirements based on span volume

## Part V: The Jaeger UI & Visualization

### A. Navigating the UI
- The Search Pane: Filtering by Service, Operation, Tags, and Duration
- The Trace Timeline View: Waterfall analysis
- The Critical Path: Identifying the bottleneck
- Trace Comparison: Diffing two traces (Error vs. Success)

### B. Visualizing Dependencies
- System Architecture DAG (Directed Acyclic Graph)
- Service Dependency Graph generation (Spark jobs vs. real-time derivation)

## Part VI: Sampling Strategies (Managing Volume)

### A. Head-Based Sampling (Decision at start)
- **Constant**: Sample everything (100%) or nothing
- **Probabilistic**: Sample a percentage (e.g., 0.1%)
- **Rate Limiting**: Bucketed token approach (e.g., 10 traces/sec per service)
- **Guaranteed Throughput**: Combination of Probabilistic and Lower bound

### B. Adaptive Sampling
- How the Collector instructs the Agent/Client
- Dynamic adjustment based on traffic volume
- Configuration and Per-operation sampling strategies

### C. Tail-Based Sampling (Decision at end)
- Why Head-based misses errors
- Buffer-and-decide architecture (OpenTelemetry Collector usage)
- Sampling policies: "Keep if status=error" or "Keep if latency > 2s"

## Part VII: Production Deployment & Kubernetes

### A. Kubernetes Integration
- **Jaeger Operator**: Managing the lifecycle via CRDs
- Sidecar vs. DaemonSet deployment for Agents
- Security Contexts and Resource Limits
- Ingress configuration for the UI and Collector

### B. Streaming Architecture with Kafka
- Why use Kafka? (Handling burst traffic, decoupling storage)
- Topic configuration and partitioning strategy
- Running the Ingester component

## Part VIII: Performance Tuning & Scalability

### A. Component Scaling
- Scaling Collectors (CPU bound)
- Scaling Elasticsearch for heavy write loads
- Memory tuning for Java/Go binaries

### B. Optimization
- Reducing Span size (Limit logs, efficient tagging)
- Tuning `queue-size` and `workers` in Collectors
- Handling "Hot Partitions" in Kafka

## Part IX: Service Performance Monitoring (SPM)

### A. Metrics from Traces
- Deriving RED metrics (Rate, Errors, Duration) from span data
- The Monitoring Tab in Jaeger UI

### B. Integration with Prometheus
- Sending derived metrics to Prometheus
- Remote storage configuration

## Part X: Security & Multi-Tenancy

### A. Access Control
- Securing the UI (OAuth / OIDC integration)
- Securing the Collector/Query APIs (TLS/mTLS)

### B. Multi-Tenancy
- Passing `x-scope-orgid` headers (via Reverse Proxy or OTel)
- Separating indices per tenant in Elasticsearch
- Data segregation strategies

### C. Data Privacy
- Data Scrubbing/Sanitization (PII in tags/logs)
- Obfuscation strategies in the OpenTelemetry Collector processor

## Part XI: Advanced Analysis & Troubleshooting

### A. Analyzing Complex Flows
- Tracing Database queries (SQL sanitization)
- Tracing Cache hits vs. misses
- Asynchronous workflows and long-running transactions

### B. Troubleshooting Jaeger Itself
- **Self-Monitoring**: Checking Jaeger's own metrics (Prometheus endpoint)
- Common Errors:
  - `UDPSender` errors (Packet size limits)
  - Clock Skew issues between services
  - Dropped spans reporting

## Part XII: Service Mesh Integration

### A. Istio & Envoy
- How Envoy generates traces automatically
- Connecting Istio to the Jaeger Collector
- Distributed tracing without code changes (limitations thereof)

### B. Linkerd & Consul
- Integration patterns and configurations

## Part XIII: Ecosystem & Alternatives

### A. Comparison
- Jaeger vs. **Zipkin** (The ancestor)
- Jaeger vs. **Grafana Tempo** (High volume, object storage focus)
- Jaeger vs. **Signoz** / **SkyWalking** (APM bundles)
- Jaeger vs. SaaS (Datadog, Honeycomb, New Relic)

### B. The Future
- Jaeger v2 (Replatforming on top of OpenTelemetry Collector)
- The convergence of Metrics, Logs, and Traces

## Part XIV: Development Workflow

### A. Local Development
- Running Jaeger via Docker Compose
- Viewing local traces during feature development

### B. CI/CD Integration
- Using traces to validate deployments (Trace-based testing)
- **Tracetest**: Assertion testing against Jaeger traces

## Part XV: Reference & Tooling

### A. CLI Tools
- `jaeger-all-in-one`
- `jaeger-query` CLI arguments
- `es-rollover` tools

### B. Configuration Management
- Environment Variables vs. YAML Config
- CLI Flags reference
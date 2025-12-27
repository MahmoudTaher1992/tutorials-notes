Here is a comprehensive study Table of Contents for **Prometheus**, structured with the same level of depth, architectural breakdown, and modern ecosystem awareness as your React example.

# Prometheus: Comprehensive Study Table of Contents

## Part I: Prometheus Fundamentals & Architecture

### A. Core Concepts and Philosophy
- **The Pull Model**: Why Prometheus pulls (scrapes) vs. Push models
- Time Series Data: Dimensions, Labels, and Samples
- The Prometheus Ecosystem (CNCF, OpenMetrics)
- Prometheus vs. Other Monitoring Systems (InfluxDB, Nagios, Zabbix, Datadog)
- Use Cases: White-box vs. Black-box monitoring

### B. Architecture Deep Dive
- **The Prometheus Server**: Retrieval, Storage, PromQL Engine
- **Service Discovery**: Mechanism for dynamic targets
- **The TSDB (Time Series Database)**: Local storage fundamentals
- **Alertmanager**: Handling alerts independently
- **Pushgateway**: Handling short-lived jobs

## Part II: The Data Model & Metric Types

### A. Metric Primitives
- **Counter**: Monotonically increasing values (restarts, errors)
- **Gauge**: Values that go up and down (memory usage, temperature)
- **Histogram**: Sampling observations (buckets, `_bucket`, `_sum`, `_count`)
- **Summary**: Client-side quantiles (pros/cons vs. Histograms)
- Naming Conventions and Best Practices

### B. Labels and Cardinality
- The Power of Dimensionality
- Label Naming Conventions
- **Cardinality Explosion**: What it is, why it kills performance, and how to avoid it
- Internal Labels (`__name__`, `instance`, `job`)

## Part III: PromQL (Prometheus Query Language)

### A. PromQL Basics
- Instant Vectors vs. Range Vectors
- Selecting Series (Matchers: `=`, `!=`, `=~`, `!~`)
- Lookback Deltas and Staleness

### B. Operators and Aggregation
- Binary Operators (Arithmetic, Comparison, Logical)
- Vector Matching: `on`, `ignoring`, `group_left`, `group_right`
- Aggregation Operators: `sum`, `min`, `max`, `avg`, `topk`, `quantile`

### C. Functions and Logic
- **Rate Functions**: `rate()` vs. `irate()` vs. `increase()`
- **Histogram Functions**: `histogram_quantile()` and `apdex` scores
- Prediction Functions: `predict_linear`, `deriv`
- Temporal Functions: `changes`, `resets`
- Subqueries: Syntax and Use Cases

## Part IV: Instrumentation & Client Libraries

### A. Direct Instrumentation
- Official Client Libraries: Go, Python, Java/JVM, Ruby
- Custom Registries and Collectors
- Decorators and Middleware for Web Frameworks
- The `/metrics` endpoint exposition format

### B. The Exporter Ecosystem
- **Node Exporter**: OS and Hardware metrics
- **Blackbox Exporter**: Probing endpoints (HTTP, DNS, TCP, ICMP)
- Database Exporters: MySQL, Postgres, Redis
- JMX Exporter: Bridging Java to Prometheus
- Writing a Custom Exporter (Guidelines and patterns)

## Part V: Service Discovery (SD) & Relabeling

### A. Service Discovery Mechanisms
- Static Configs (File-based SD)
- **Cloud SD**: AWS EC2, GCE, Azure
- **Kubernetes SD**: Nodes, Services, Pods, Ingress
- Generic SD: Consul, DNS

### B. Relabeling (The ETL of Prometheus)
- The Relabeling Lifecycle (Before scraping vs. After scraping)
- Action Types: `replace`, `keep`, `drop`, `map`, `hashmod`, `labelmap`
- Metric Relabeling: Dropping heavy metrics at ingestion
- Target Relabeling: Dynamic labeling based on metadata

## Part VI: Alerting & Rule Management

### A. Recording Rules
- Pre-computing expensive queries
- Naming conventions (`level:metric:operation`)
- Performance benefits of recording rules

### B. Alerting Rules
- Defining Alerts: `expr`, `for`, `labels`, `annotations`
- Templating in Alerts (Go templates)
- Testing Alerts with `promtool` unit tests

### C. Alertmanager
- Grouping, Inhibiting, and Silencing
- Routing Tree: Configuring Receivers (Slack, PagerDuty, OpsGenie, Email)
- High Availability Alertmanager clusters
- Notification Templates

## Part VII: Visualization & Dashboards

### A. Grafana Integration
- Adding Prometheus Data Sources
- Variables and Dashboard Templating (Label values)
- Visualizing Histograms (Heatmaps)
- Annotations from Prometheus Alerts

### B. Ad-hoc Visualization
- Prometheus Web UI (Graphing and Table view)
- Console Templates (Legacy/Native approach)

## Part VIII: Storage, Retention & Reliability

### A. Local Storage Internals
- The Write-Ahead Log (WAL)
- Memory Mapping and Head Blocks
- Block Compaction and Retention Policies
- Snapshots and Backups

### B. Remote Storage Integration
- **Remote Write / Remote Read** APIs
- Long-term storage adapters

## Part IX: Scaling & High Availability (The "Meta-Frameworks")

### A. Basic Scaling
- Federation (Hierarchical scraping)
- Functional Sharding (Splitting by function/service)

### B. Long-Term Storage & Global View
- **Thanos**: Sidecars, Store Gateway, Compactor, Receiver
- **Cortex / Mimir**: Multi-tenant, horizontally scalable architecture
- **VictoriaMetrics**: High-performance alternative storage
- Architecture comparisons (Complexity vs. Scalability)

## Part X: Prometheus in Kubernetes (Cloud Native)

### A. The Prometheus Operator
- Custom Resource Definitions (CRDs): `ServiceMonitor`, `PodMonitor`, `PrometheusRule`
- The `kube-prometheus-stack` (Helm charts)
- Managing Configuration via Manifests

### B. Kubernetes Monitoring Patterns
- Monitoring Control Plane (API Server, etcd, Scheduler)
- Monitoring Workloads (Sidecars vs. Exporters)
- Resource Metrics vs. Custom Metrics API (HPA integration)

## Part XI: Security & Authentication

### A. Securing the Server
- TLS Configuration
- Basic Authentication (built-in vs. reverse proxy)
- Role-Based Access Control (RBAC) in Kubernetes

### B. Secure Scraping
- Scrape authentication (Bearer tokens, TLS certificates)
- Protecting the `/metrics` endpoint

## Part XII: Interoperability & OpenTelemetry

### A. OpenTelemetry (OTel)
- OTel Metrics vs. Prometheus Metrics
- Using OTel Collector to scrape and export to Prometheus
- Future of OTel and Prometheus convergence

### B. Integration with other tools
- Logging integration (Loki)
- Tracing integration (Tempo/Jaeger) - correlation via Exemplars

## Part XIII: Performance Tuning & Troubleshooting

### A. Self-Monitoring
- Key Prometheus metrics to watch (`prometheus_tsdb_...`, `scrape_duration...`)
- Detecting "Slow Rules" and Query Load

### B. Troubleshooting
- Debugging Scrape Failures (Context deadlines, body size limits)
- Handling "Missing Data" gaps
- Analyzing High Memory Usage (Cardinality analysis)

## Part XIV: Operational Best Practices (SRE)

### A. Defining Objectives
- SLOs (Service Level Objectives) & SLIs (Service Level Indicators)
- The "Four Golden Signals" (Latency, Traffic, Errors, Saturation)
- RED Method (Rate, Errors, Duration)
- USE Method (Utilization, Saturation, Errors)

### B. Life Cycle Management
- Version Upgrades
- Configuration Management (GitOps for Prometheus rules)

## Part XV: Tooling & Developer Experience

### A. CLI Tools
- **promtool**: Syntax checking, linting, and rule testing
- **amtool**: Interact with Alertmanager via CLI

### B. Ecosystem Utilities
- `prom-label-proxy`: Enforcing multitenancy
- `pint`: Linter for Prometheus rules (static analysis)
This Table of Contents mirrors the structure, depth, and categorization of your React example but focuses entirely on **Datadog**. It moves from fundamental concepts and agent installation to deep-dive observability pillars (Metrics, Logs, APM), and finally into advanced administration, security, and developer workflows.

# Datadog: Comprehensive Study Table of Contents

## Part I: Datadog Fundamentals & Core Principles

### A. Introduction to Observability
- The Three Pillars: Metrics, Logs, and Traces
- Motivation: Monitoring vs. Observability
- Datadog Architecture Overview (SaaS + Agent)
- Comparison: Datadog vs. Prometheus/Grafana, New Relic, Splunk
- The Unified Service Tagging Schema (`env`, `service`, `version`)

### B. The Datadog Agent
- Agent Architecture (Core Agent, Trace Agent, Process Agent)
- Installation Strategies (Host, Container, Cloud-native)
- Configuration: `datadog.yaml` deep dive
- Managing Environments and Secrets in Configuration
- Troubleshooting Agent Status (`agent status`, `flare`)
- Agentless Monitoring (Cloud Integrations)

## Part II: Infrastructure Monitoring & Integrations

### A. Host and Container Monitoring
- The Host Map & Infrastructure List
- System Metrics (CPU, Mem, Disk, I/O)
- Container Monitoring (Docker, Containerd)
- **Kubernetes (K8s) Deep Dive**:
  - The Cluster Agent vs. Node Agent
  - DaemonSets and Helm Charts
  - Autodiscovery (Annotations vs. Labels)
  - Kube State Metrics

### B. Cloud & Integrations
- Cloud Provider Integrations (AWS, Azure, GCP)
- Metric Polling vs. Metric Streams (e.g., AWS CloudWatch Metric Streams)
- Installing 3rd Party Integrations (Postgres, Redis, Nginx, Kafka)
- Custom Checks (writing Python checks for the Agent)

### C. Serverless Monitoring
- AWS Lambda Layers & Extension
- Cold Starts and Invocation Metrics
- Serverless View vs. Standard Infra View

## Part III: Log Management

### A. Log Ingestion
- Log Collection Methods (Agent, HTTP API, AWS Lambda Forwarder)
- Multi-line aggregation
- Scrubbing and Redaction (PII Protection) before sending

### B. Processing and Pipelines
- Ingestion vs. Indexing (Decoupling storage from search)
- Pipelines and Processors
- **Grok Parser**: Syntax and Custom Patterns
- Remappers (Date, Status, Service, Message)
- Attributes: Facets vs. Measures

### C. Log Explorer & Archiving
- Search Syntax and Wildcards
- Live Tail
- Patterns and Clustering
- Log Archives (S3/GCS/Azure Blob)
- Log Rehydration: Querying archived logs

## Part IV: Application Performance Monitoring (APM)

### A. Tracing Fundamentals
- Spans, Traces, and Root Spans
- The Flame Graph visualization
- Retention Filters and Ingestion Controls
- Trace Context Propagation (Headers)

### B. Instrumentation
- **Auto-Instrumentation**: Java, Python, Node.js, Ruby, Go, .NET
- **Manual Instrumentation**: Using `dd-trace` libraries
- Custom Spans and Tags
- OpenTelemetry vs. Datadog Tracing

### C. Profiling and Correlation
- Continuous Profiler (CPU, Heap, Wall Time, Lock contention)
- Linking Traces to Logs (Injection)
- Linking Traces to Infrastructure
- Deployment Tracking

### D. Distributed Tracing & Service Map
- Understanding Upstream/Downstream dependencies
- The Service Map visualization
- Detecting bottlenecks and latency

## Part V: Digital Experience Monitoring (DEM)

### A. Real User Monitoring (RUM)
- Browser and Mobile SDK setup
- Views, Actions, Resources, Long Tasks, and Errors
- Core Web Vitals (LCP, FID, CLS)
- Session Replay (Privacy settings and recording)

### B. Synthetics
- API Tests (HTTP, SSL, DNS, WebSocket)
- Browser Tests (Selenium-style recording)
- Private Locations (Testing internal endpoints)
- CI/CD Integration for Synthetics

### C. Error Tracking
- Issue Grouping and Aggregation
- Source Maps support

## Part VI: Alerting & Incident Management

### A. Monitors
- **Monitor Types**: Metric, Log, APM, Integration, Process, Custom Check
- **Evaluation Logic**: Simple Alert, Multi Alert, Query Alert
- Thresholds, Recovery Thresholds, and Delays
- No Data / Missing Data logic

### B. Advanced Alerting
- Anomaly Detection (Algorithmic)
- Outlier Detection
- Forecast Monitors
- Composite Monitors (Logic gates: A && B)
- Slo/SLI Alerts (Burn rates)

### C. Notification & Incident Response
- Variables and Markdown in Notifications
- Integration: Slack, PagerDuty, Jira, Webhooks
- Downtimes (Scheduled maintenance windows)
- Incident Management Tool (declaring incidents, post-mortems)

## Part VII: Visualization & Reporting

### A. Dashboards
- **Timeboards** (Troubleshooting/Correlation) vs. **Screenboards** (Status/Storytelling)
- Widget Types: Timeseries, Query Value, Top List, Heatmap, Change, Table
- Template Variables (Dynamic dashboarding)
- Powerpacks (Reusable dashboard groups)

### B. Notebooks
- Data storytelling with Notebooks
- Post-mortem analysis documents

### C. Metrics Advanced Math
- Formulas and Functions
- Aggregations (Avg, Sum, Max, Min)
- Rollups (Time and Space aggregation)

## Part VIII: Security Monitoring

### A. Cloud Security Management (CSM)
- Misconfigurations (CSPM)
- Cloud Workload Security (CWS)
- Real-time threat detection

### B. Application Security (AppSec)
- Application Security Management (ASM)
- WAF capabilities (In-app firewall)
- Vulnerability Management (Code-level CVE detection)

## Part IX: Database & Network Monitoring

### A. Database Monitoring (DBM)
- Query Metrics and Explain Plans
- Host vs. Database view
- Supported Engines (Postgres, MySQL, SQL Server)

### B. Network Performance Monitoring (NPM)
- Flow logs vs. eBPF-based NPM
- Network Map (Cross-AZ traffic, DNS resolution)
- Connection tracing

## Part X: Developer Experience & Automation

### A. Datadog API
- Authentication (API Keys vs. Application Keys)
- Rate Limits and Best Practices
- Querying Metrics and Events via API

### B. Infrastructure as Code (IaC)
- **Terraform Provider**: Managing Monitors, Dashboards, and Synthetics as Code
- **Datadog CLI** (dog)
- Managing Dashboards via JSON

### C. CI/CD Visibility
- Pipeline Execution Monitoring (GitHub Actions, GitLab CI, Jenkins)
- Flaky Test Management
- Quality Gates

## Part XI: Cost Management & Governance

### A. Understanding Billing
- Committed Use vs. On-Demand
- High Water Marks
- Estimating Log Indexing Costs

### B. Governance Tools
- Tag Policies
- Role-Based Access Control (RBAC)
- Audit Trail
- Teams and Ownership

## Part XII: Certification & Advanced Scenarios

### A. Official Certifications
- Datadog Fundamentals
- Log Management Fundamentals
- APM & Distributed Tracing Fundamentals

### B. Advanced Use Cases
- Monitoring Service Mesh (Istio/Linkerd)
- IoT Monitoring
- Multi-cloud Strategy with Datadog
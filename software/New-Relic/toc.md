This is a comprehensive study path for **New Relic**. It mirrors the structure and depth of your React TOC, moving from the philosophy of observability to deep technical instrumentation, query languages (NRQL), and platform administration.

# New Relic: Comprehensive Study Table of Contents

## Part I: Observability Fundamentals & Core Concepts

### A. Introduction to Observability
- Monitoring vs. Observability (The "Why" vs. The "What")
- The MELT Framework (Metrics, Events, Logs, Traces)
- The Four Golden Signals (Latency, Traffic, Errors, Saturation)
- New Relic Architecture (SaaS platform, One Realm)
- The Entity Explorer and Data Hierarchy

### B. The New Relic Platform Ecosystem
- Full-Stack Observability Overview
- **APM** (Application Performance Monitoring)
- **Infrastructure** (Hosts, Containers, K8s)
- **Browser** (Real User Monitoring) and **Mobile**
- **Synthetics** (Proactive Monitoring)
- **Logs in Context**

## Part II: Instrumentation & Agent Installation

### A. Getting Data In (Ingestion)
- Guided Install (CLI) vs. Manual Installation
- License Keys vs. User Keys vs. Ingest Keys
- Host-level Integrations (Linux/Windows)
- Cloud Integrations (AWS CloudWatch, Azure, GCP)

### B. APM Agents Deep Dive
- Installing Agents (Java, Node.js, Python, .NET, Ruby, Go, PHP)
- Configuring `newrelic.yml` / `newrelic.ini`
- Environment Variables for Configuration
- Naming Applications (Rollup names vs. Specific names)
- Managing Agent Versions and Updates

### C. OpenTelemetry & Open Standards
- Introduction to OpenTelemetry (OTel)
- Sending OTel Data to New Relic
- New Relic Agents vs. OTel Collectors
- Prometheus Remote Write Integration

## Part III: Application Performance Monitoring (APM)

### A. Analyzing Transactions
- Throughput, Response Time, and Error Rate
- Apdex Score (Application Performance Index) - Theory and Configuration
- Transaction Traces (Slow transactions)
- Key Transactions (Prioritizing critical paths)

### B. Database & External Services
- Database Monitoring (Slow Queries, Query Analysis)
- External Services (HTTP calls to other APIs)
- Service Maps (Visualizing dependencies)
- N+1 Query Problems identification

### C. Distributed Tracing
- Understanding Spans and Traces
- Head-based vs. Tail-based Sampling
- Infinite Tracing (Serverless tracing)
- Cross-Application Tracing (Legacy) vs. Distributed Tracing

## Part IV: Infrastructure & Kubernetes

### A. Host Monitoring
- CPU, Memory, Disk, and Network utilization
- Process usage and inventory
- Storage and Filesystem monitoring

### B. Kubernetes & Containers
- The Kubernetes Cluster Explorer
- New Relic vs. Pixie (eBPF-based observability)
- Pod, Node, and Container metrics
- Control Plane Monitoring

## Part V: Querying & Visualization (NRQL)

### A. NRQL (New Relic Query Language) Fundamentals
- Syntax Structure (`SELECT`, `FROM`, `WHERE`)
- Aggregation Functions (`average`, `max`, `count`, `sum`)
- Time Windows (`SINCE`, `UNTIL`, `COMPARE WITH`)
- Grouping (`FACET`) and Ordering

### B. Advanced NRQL Patterns
- Subqueries and Nested Aggregation
- Time Series and Sliding Windows (`TIMESERIES`)
- Filter and Case Logic (`filter()`, `cases()`)
- Funnels (`funnel()`) for Conversion tracking
- Math operations and Casting
- Querying Metrics vs. Events vs. Logs

### C. Dashboards & Data Apps
- Creating Custom Dashboards
- Widget Types (Billboards, Line charts, Pie charts, Tables)
- Markdown and Images in Dashboards
- Dashboard Variables (Template variables for filtering)
- Exporting and PDF Generation

## Part VI: Digital Customer Experience (Frontend)

### A. Browser Monitoring (RUM)
- Lite vs. Pro vs. SPA Agents
- Page Load Timing (Navigation Timing API)
- Core Web Vitals (LCP, FID, CLS)
- JavaScript Error Analysis and Source Maps
- Session Replay (recording user interactions)

### B. Synthetic Monitoring
- Ping Monitors (Availability)
- Simple Browser Monitors
- Scripted Browser Monitors (Selenium/WebDriver JS)
- API Tests
- Secure Credentials in Scripts
- Private Minions (Monitoring behind firewalls)

### C. Mobile Monitoring
- Crash Analysis and Interaction Tracing
- HTTP Requests and Network Errors
- Handled Exceptions vs. Crashes

## Part VII: Alerting & Applied Intelligence (AIOps)

### A. Alerting Architecture
- Policies and Conditions
- NRQL Alert Conditions (Static vs. Baseline)
- Signal Loss and Gap Filling
- Notification Channels (Slack, PagerDuty, Webhooks, Email)
- Workflows and Destinations

### B. Incident Intelligence & AIOps
- Issue Aggregation (Reducing noise)
- Correlation Logic (Decisions)
- Anomaly Detection
- Root Cause Analysis (RCA) suggestions

## Part VIII: Logging Management

### A. Log Ingestion Strategies
- Log Forwarding Plugins (Fluentd, Fluent Bit, Logstash)
- Infrastructure Agent Log Forwarding
- API-based Log Ingestion

### B. Log Analysis
- Logs in Context (Linking Logs to APM Traces)
- Parsing Rules and Grok Patterns
- Querying Logs via NRQL
- Live Tail and filtering
- Obfuscation and Drop Filters (PII Security)

## Part IX: Programmability & APIs

### A. NerdGraph (GraphQL API)
- Exploring the GraphiQL Explorer
- Querying Entities and Data
- Mutations: Creating Dashboards/Alerts via API
- Tagging and Metadata Management

### B. Rest API (Legacy)
- Differences between REST and GraphQL endpoints
- Usage scenarios

### C. Custom Observability
- Custom Events (Insights API)
- Custom Metrics (Metric API)
- Custom Attributes in Agents (`addCustomAttribute`)
- New Relic CodeStream (IDE Integration)

## Part X: Service Level Management (SRE)

### A. Service Level Indicators (SLIs)
- Defining SLIs based on MELT
- Good vs. Bad Events

### B. Service Level Objectives (SLOs)
- Creating Service Levels in New Relic
- Error Budgets and Burn Rates
- Alerting on Burn Rates

## Part XI: Administration, Security & Governance

### A. User Management
- Users, Groups, and Roles
- Role-Based Access Control (RBAC)
- SAML/SSO Configuration
- SCIM Provisioning

### B. Data Management
- Data Retention Policies
- Ingest Limits and Cost Management
- Audit Logs
- Drop Rules (Managing High Cardinality data)

### C. Terraform Provider
- Infrastructure as Code (IaC) for New Relic
- Managing Alerts and Dashboards via Terraform

## Part XII: Advanced Workflows & Optimization

### A. Workloads
- Grouping Entities into Workloads
- Workload Status and Status Rollups

### B. Errors Inbox
- Triage and Assignment
- Integration with Jira/Issue Trackers
- Regression Detection

### C. Troubleshooting Performance Issues
- Thread Profiling (Java/Node/Python)
- Memory Profiling and Leak Detection
- Identifying "Noisy Neighbors" in Cloud Environments
Here is the bash script to generate your Datadog study directory structure.

### Instructions:
1.  Copy the code block below.
2.  Save it to a file named `create_datadog_study.sh`.
3.  Make it executable: `chmod +x create_datadog_study.sh`.
4.  Run it: `./create_datadog_study.sh`.

```bash
#!/bin/bash

# Define the root directory name
ROOT="Datadog-Study-Notes"

# Create Root Directory
echo "Creating root directory: $ROOT"
mkdir -p "$ROOT"
cd "$ROOT"

# Function to create file with content
create_file() {
    local filepath="$1"
    local title="$2"
    local content="$3"
    
    echo "Creating file: $filepath"
    cat > "$filepath" <<EOF
# $title

$content
EOF
}

# ==========================================
# Part I: Datadog Fundamentals & Core Principles
# ==========================================
DIR="001-Datadog-Fundamentals"
mkdir -p "$DIR"

create_file "$DIR/001-Introduction-to-Observability.md" "Introduction to Observability" \
"- The Three Pillars: Metrics, Logs, and Traces
- Motivation: Monitoring vs. Observability
- Datadog Architecture Overview (SaaS + Agent)
- Comparison: Datadog vs. Prometheus/Grafana, New Relic, Splunk
- The Unified Service Tagging Schema (\`env\`, \`service\`, \`version\`)"

create_file "$DIR/002-The-Datadog-Agent.md" "The Datadog Agent" \
"- Agent Architecture (Core Agent, Trace Agent, Process Agent)
- Installation Strategies (Host, Container, Cloud-native)
- Configuration: \`datadog.yaml\` deep dive
- Managing Environments and Secrets in Configuration
- Troubleshooting Agent Status (\`agent status\`, \`flare\`)
- Agentless Monitoring (Cloud Integrations)"

# ==========================================
# Part II: Infrastructure Monitoring & Integrations
# ==========================================
DIR="002-Infrastructure-Monitoring"
mkdir -p "$DIR"

create_file "$DIR/001-Host-and-Container-Monitoring.md" "Host and Container Monitoring" \
"- The Host Map & Infrastructure List
- System Metrics (CPU, Mem, Disk, I/O)
- Container Monitoring (Docker, Containerd)
- **Kubernetes (K8s) Deep Dive**:
  - The Cluster Agent vs. Node Agent
  - DaemonSets and Helm Charts
  - Autodiscovery (Annotations vs. Labels)
  - Kube State Metrics"

create_file "$DIR/002-Cloud-and-Integrations.md" "Cloud & Integrations" \
"- Cloud Provider Integrations (AWS, Azure, GCP)
- Metric Polling vs. Metric Streams (e.g., AWS CloudWatch Metric Streams)
- Installing 3rd Party Integrations (Postgres, Redis, Nginx, Kafka)
- Custom Checks (writing Python checks for the Agent)"

create_file "$DIR/003-Serverless-Monitoring.md" "Serverless Monitoring" \
"- AWS Lambda Layers & Extension
- Cold Starts and Invocation Metrics
- Serverless View vs. Standard Infra View"

# ==========================================
# Part III: Log Management
# ==========================================
DIR="003-Log-Management"
mkdir -p "$DIR"

create_file "$DIR/001-Log-Ingestion.md" "Log Ingestion" \
"- Log Collection Methods (Agent, HTTP API, AWS Lambda Forwarder)
- Multi-line aggregation
- Scrubbing and Redaction (PII Protection) before sending"

create_file "$DIR/002-Processing-and-Pipelines.md" "Processing and Pipelines" \
"- Ingestion vs. Indexing (Decoupling storage from search)
- Pipelines and Processors
- **Grok Parser**: Syntax and Custom Patterns
- Remappers (Date, Status, Service, Message)
- Attributes: Facets vs. Measures"

create_file "$DIR/003-Log-Explorer-and-Archiving.md" "Log Explorer & Archiving" \
"- Search Syntax and Wildcards
- Live Tail
- Patterns and Clustering
- Log Archives (S3/GCS/Azure Blob)
- Log Rehydration: Querying archived logs"

# ==========================================
# Part IV: Application Performance Monitoring (APM)
# ==========================================
DIR="004-APM"
mkdir -p "$DIR"

create_file "$DIR/001-Tracing-Fundamentals.md" "Tracing Fundamentals" \
"- Spans, Traces, and Root Spans
- The Flame Graph visualization
- Retention Filters and Ingestion Controls
- Trace Context Propagation (Headers)"

create_file "$DIR/002-Instrumentation.md" "Instrumentation" \
"- **Auto-Instrumentation**: Java, Python, Node.js, Ruby, Go, .NET
- **Manual Instrumentation**: Using \`dd-trace\` libraries
- Custom Spans and Tags
- OpenTelemetry vs. Datadog Tracing"

create_file "$DIR/003-Profiling-and-Correlation.md" "Profiling and Correlation" \
"- Continuous Profiler (CPU, Heap, Wall Time, Lock contention)
- Linking Traces to Logs (Injection)
- Linking Traces to Infrastructure
- Deployment Tracking"

create_file "$DIR/004-Distributed-Tracing.md" "Distributed Tracing & Service Map" \
"- Understanding Upstream/Downstream dependencies
- The Service Map visualization
- Detecting bottlenecks and latency"

# ==========================================
# Part V: Digital Experience Monitoring (DEM)
# ==========================================
DIR="005-DEM"
mkdir -p "$DIR"

create_file "$DIR/001-RUM.md" "Real User Monitoring (RUM)" \
"- Browser and Mobile SDK setup
- Views, Actions, Resources, Long Tasks, and Errors
- Core Web Vitals (LCP, FID, CLS)
- Session Replay (Privacy settings and recording)"

create_file "$DIR/002-Synthetics.md" "Synthetics" \
"- API Tests (HTTP, SSL, DNS, WebSocket)
- Browser Tests (Selenium-style recording)
- Private Locations (Testing internal endpoints)
- CI/CD Integration for Synthetics"

create_file "$DIR/003-Error-Tracking.md" "Error Tracking" \
"- Issue Grouping and Aggregation
- Source Maps support"

# ==========================================
# Part VI: Alerting & Incident Management
# ==========================================
DIR="006-Alerting-and-Incidents"
mkdir -p "$DIR"

create_file "$DIR/001-Monitors.md" "Monitors" \
"- **Monitor Types**: Metric, Log, APM, Integration, Process, Custom Check
- **Evaluation Logic**: Simple Alert, Multi Alert, Query Alert
- Thresholds, Recovery Thresholds, and Delays
- No Data / Missing Data logic"

create_file "$DIR/002-Advanced-Alerting.md" "Advanced Alerting" \
"- Anomaly Detection (Algorithmic)
- Outlier Detection
- Forecast Monitors
- Composite Monitors (Logic gates: A && B)
- Slo/SLI Alerts (Burn rates)"

create_file "$DIR/003-Notification-and-Response.md" "Notification & Incident Response" \
"- Variables and Markdown in Notifications
- Integration: Slack, PagerDuty, Jira, Webhooks
- Downtimes (Scheduled maintenance windows)
- Incident Management Tool (declaring incidents, post-mortems)"

# ==========================================
# Part VII: Visualization & Reporting
# ==========================================
DIR="007-Visualization-and-Reporting"
mkdir -p "$DIR"

create_file "$DIR/001-Dashboards.md" "Dashboards" \
"- **Timeboards** (Troubleshooting/Correlation) vs. **Screenboards** (Status/Storytelling)
- Widget Types: Timeseries, Query Value, Top List, Heatmap, Change, Table
- Template Variables (Dynamic dashboarding)
- Powerpacks (Reusable dashboard groups)"

create_file "$DIR/002-Notebooks.md" "Notebooks" \
"- Data storytelling with Notebooks
- Post-mortem analysis documents"

create_file "$DIR/003-Metrics-Advanced-Math.md" "Metrics Advanced Math" \
"- Formulas and Functions
- Aggregations (Avg, Sum, Max, Min)
- Rollups (Time and Space aggregation)"

# ==========================================
# Part VIII: Security Monitoring
# ==========================================
DIR="008-Security-Monitoring"
mkdir -p "$DIR"

create_file "$DIR/001-Cloud-Security-Management.md" "Cloud Security Management (CSM)" \
"- Misconfigurations (CSPM)
- Cloud Workload Security (CWS)
- Real-time threat detection"

create_file "$DIR/002-Application-Security.md" "Application Security (AppSec)" \
"- Application Security Management (ASM)
- WAF capabilities (In-app firewall)
- Vulnerability Management (Code-level CVE detection)"

# ==========================================
# Part IX: Database & Network Monitoring
# ==========================================
DIR="009-Database-and-Network-Monitoring"
mkdir -p "$DIR"

create_file "$DIR/001-Database-Monitoring.md" "Database Monitoring (DBM)" \
"- Query Metrics and Explain Plans
- Host vs. Database view
- Supported Engines (Postgres, MySQL, SQL Server)"

create_file "$DIR/002-Network-Performance-Monitoring.md" "Network Performance Monitoring (NPM)" \
"- Flow logs vs. eBPF-based NPM
- Network Map (Cross-AZ traffic, DNS resolution)
- Connection tracing"

# ==========================================
# Part X: Developer Experience & Automation
# ==========================================
DIR="010-Developer-Experience"
mkdir -p "$DIR"

create_file "$DIR/001-Datadog-API.md" "Datadog API" \
"- Authentication (API Keys vs. Application Keys)
- Rate Limits and Best Practices
- Querying Metrics and Events via API"

create_file "$DIR/002-Infrastructure-as-Code.md" "Infrastructure as Code (IaC)" \
"- **Terraform Provider**: Managing Monitors, Dashboards, and Synthetics as Code
- **Datadog CLI** (dog)
- Managing Dashboards via JSON"

create_file "$DIR/003-CI-CD-Visibility.md" "CI/CD Visibility" \
"- Pipeline Execution Monitoring (GitHub Actions, GitLab CI, Jenkins)
- Flaky Test Management
- Quality Gates"

# ==========================================
# Part XI: Cost Management & Governance
# ==========================================
DIR="011-Cost-Management"
mkdir -p "$DIR"

create_file "$DIR/001-Understanding-Billing.md" "Understanding Billing" \
"- Committed Use vs. On-Demand
- High Water Marks
- Estimating Log Indexing Costs"

create_file "$DIR/002-Governance-Tools.md" "Governance Tools" \
"- Tag Policies
- Role-Based Access Control (RBAC)
- Audit Trail
- Teams and Ownership"

# ==========================================
# Part XII: Certification & Advanced Scenarios
# ==========================================
DIR="012-Certification-and-Advanced"
mkdir -p "$DIR"

create_file "$DIR/001-Official-Certifications.md" "Official Certifications" \
"- Datadog Fundamentals
- Log Management Fundamentals
- APM & Distributed Tracing Fundamentals"

create_file "$DIR/002-Advanced-Use-Cases.md" "Advanced Use Cases" \
"- Monitoring Service Mesh (Istio/Linkerd)
- IoT Monitoring
- Multi-cloud Strategy with Datadog"

echo "Directory structure created successfully in folder: $ROOT"
```

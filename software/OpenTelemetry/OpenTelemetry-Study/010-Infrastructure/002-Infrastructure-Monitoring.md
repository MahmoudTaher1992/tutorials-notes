Here is a detailed breakdown of **Part X: Infrastructure & Kubernetes, Section B: Infrastructure Monitoring**.

In the context of OpenTelemetry (OTel), **Infrastructure Monitoring** refers to the ability of the OTel Collector to gather metrics not just from your custom application code (traces/spans), but from the underlying operating system, the container orchestrator (Kubernetes), and third-party services (databases, caches, load balancers).

Traditionally, you might use `node_exporter` for Linux metrics, `cAdvisor` for containers, and a specific exporter for Redis. OpenTelemetry aims to consolidate these into a single binary: **The OTel Collector.**

---

# 010-Infrastructure / 002-Infrastructure-Monitoring.md

## 1. The Host Metrics Receiver
The **Host Metrics Receiver** (`hostmetricsreceiver`) is a core component of the OpenTelemetry Collector Contrib distribution. It allows the Collector to read system-level usage data directly from the host operating system (Linux, Windows, macOS).

When you deploy the OTel Collector as an **Agent** (or DaemonSet in Kubernetes), it runs on every node. This receiver looks at the host's `/proc` and `/sys` filesystems (on Linux) to report on hardware health.

### How it works
The receiver is modular. You enable specific **scrapers** inside the configuration to choose which metrics you want.

### Key Scrapers:
1.  **CPU:** Reports usage per core (user, system, idle, wait, interrupt).
2.  **Memory:** Reports physical memory usage (used, free, cached, buffered) and Swap usage.
3.  **Disk / Filesystem:** Reports disk I/O (reads/writes per second) and filesystem usage (disk space available/used).
4.  **Network:** Reports network interface statistics (packets sent/received, errors, dropped packets).
5.  **Load:** Reports the system load average (1m, 5m, 15m).
6.  **Paging/Processes:** Reports the number of running/blocked processes and page faults.

### Configuration Example (`config.yaml`)
```yaml
receivers:
  hostmetrics:
    collection_interval: 10s
    scrapers:
      cpu:
      memory:
      load:
      filesystem:
        # Filter to only show physical devices
        include_devices:
          match_type: strict
          services: [/dev/sda1, /dev/vda1]
      network:

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"

service:
  pipelines:
    metrics:
      receivers: [hostmetrics]
      exporters: [prometheus]
```

**Why this matters:** It allows you to correlate a latency spike in your application trace (e.g., "SQL Query took 5s") with the underlying infrastructure (e.g., "The CPU on the DB Node was at 100%").

---

## 2. The Kubelet Stats Receiver
While the Host Metrics receiver looks at the *Node (VM/Bare Metal)*, the **Kubelet Stats Receiver** looks at the *Kubernetes layer*.

The Kubelet is the agent that runs on each Kubernetes node. It holds the "source of truth" regarding how much resource (CPU/RAM) every Pod and Container is consuming compared to its limits and requests.

### Key Capabilities:
*   **Pod Metrics:** CPU/Memory usage per pod.
*   **Container Metrics:** CPU/Memory usage per container within the pod.
*   **Volume Metrics:** Storage usage for Persistent Volumes attached to pods.
*   **Node Metrics:** Summarized metrics for the node itself.

### Authentication & Connection
Since the Collector needs to talk to the Kubelet API, it requires specific permissions.
1.  **Service Account:** The Collector's Pod must use a ServiceAccount with a ClusterRole allowing it to read nodes/stats.
2.  **TLS:** The connection is usually HTTPS, so the receiver acts as a client using the ServiceAccount token.

### Configuration Example
```yaml
receivers:
  kubeletstats:
    collection_interval: 20s
    auth_type: "serviceAccount"
    endpoint: "https://${env:K8S_NODE_NAME}:10250"
    insecure_skip_verify: true # Common in internal clusters
    metric_groups:
      - node
      - pod
      - container
```

**Why this matters:** This replaces the need for `cAdvisor` or `metrics-server` for observability data. It allows you to visualize if a specific container is hitting its memory limit and getting OOMKilled.

---

## 3. Receiver Scrapers (Third-Party Integration)
In the old world (e.g., Prometheus), if you wanted to monitor Redis, you deployed a separate binary called `redis_exporter`. In OTel, the Collector has **native receivers** that can connect to these services and pull metrics directly.

These are built into the **OTel Collector Contrib** distro.

### A. Redis Receiver
Connects to a Redis instance and runs the `INFO` command to gather stats.
*   **Metrics:** Connected clients, memory fragmentation ratio, keyspace hits/misses, evicted keys, commands processed per second.

### B. PostgreSQL Receiver
Connects to a Postgres database via a connection string.
*   **Metrics:** Active connections, commits vs. rollbacks, deadlocks, disk usage by table (if configured).

### C. Nginx / Apache Receiver
Usually connects to the `stub_status` page (Nginx) or `server-status` page (Apache).
*   **Metrics:** Active connections, requests per second, reading/writing states.

### Configuration Example (Redis)
```yaml
receivers:
  redis:
    endpoint: "redis-service:6379"
    collection_interval: 10s
    password: "${env:REDIS_PASSWORD}"
    
service:
  pipelines:
    metrics:
      receivers: [redis]
      exporters: [otlp] # Send to your backend
```

---

## Summary of Architecture
To implement Infrastructure Monitoring effectively, you typically use the **DaemonSet (Agent) Pattern** in Kubernetes:

1.  **Deployment:** You deploy the OTel Collector as a **DaemonSet**. This ensures exactly one Collector runs on every Node.
2.  **Host Metrics:** Because the Collector is on the node, it can mount `/proc` and scrape the host hardware.
3.  **Kubelet Stats:** Because it is on the node, it can talk to `localhost` (or the node IP) to hit the Kubelet API efficiently.
4.  **Local Scrapers:** The Agent can be configured to discover other containers running on the same node (like a Redis pod) and scrape them, though often specialized service monitoring is done via a Sidecar or a central Deployment depending on network topology.

### The "One Agent" Rule
The ultimate goal of this section is to teach you that you can remove `node_exporter`, `telegraf`, `filebeat`, and `promtail`. The **OpenTelemetry Collector** can handle:
1.  **Host Metrics** (replacing node_exporter)
2.  **Logs** (replacing filebeat/promtail)
3.  **App Traces** (unique to OTel)

...all in a single deployed binary.
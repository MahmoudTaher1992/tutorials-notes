Based on the Table of Contents you provided, **Part IX: Scaling & High Availability** addresses the limitations of a single Prometheus server. By default, Prometheus is a monolithic application—it is a single binary that does everything (scraping, storing, querying). Eventually, you will hit a limit on RAM, CPU, or Disk I/O.

Here is a detailed explanation of **001-Basic Scaling**, which covers the two fundamental strategies used before moving to complex, distributed solutions like Thanos or Cortex.

---

# 001-Basic Scaling

Basic scaling allows you to grow your monitoring infrastructure using standard Prometheus binaries without introducing external databases or complex distributed storage systems.

## 1. Federation (Hierarchical Scraping)

Federation allows a Prometheus server to scrape selected time series from another Prometheus server. This creates a hierarchy of monitoring servers.

### How it Works
1.  **Leaf Nodes:** You have multiple Prometheus instances (Leafs) collecting detailed metrics from specific environments (e.g., one per Data Center or one per Kubernetes Cluster). These usually have a short data retention period (e.g., 24 hours).
2.  **Global Node:** You have a central "Global" Prometheus server. Instead of scraping the raw targets (pods/servers), it scrapes the **Leaf Nodes**.

### The Mechanism: The `/federate` Endpoint
Standard Prometheus instances expose a special endpoint: `/federate`. The Global Prometheus scrapes this endpoint using specific query parameters (matchers) to pull only the data it needs.

**Example Configuration (Global Prometheus):**
```yaml
scrape_configs:
  - job_name: 'federate'
    scrape_interval: 15s
    honor_labels: true # Preserves the labels from the original source
    metrics_path: '/federate'
    params:
      'match[]':
        - '{__name__=~"^job:.*"}'   # Pull pre-aggregated recording rules
        - '{__name__=~"^node_.*"}'  # Pull specific node metrics
    static_configs:
      - targets:
        - 'prometheus-dc-us-east:9090'
        - 'prometheus-dc-eu-west:9090'
```

### When to use Federation
*   **Aggregated Global View:** You want a "single pane of glass" to see the overall health of multiple data centers, but you don't need every single granular metric (like garbage collection times of a specific pod in Europe).
*   **Network Security Zones:** The Global Prometheus might not have network access to the internal pods in a secure zone, but it can access the specific Leaf Prometheus server running inside that zone.

### The Limitation (The "Tree" Problem)
Federation is **not** a solution for backing up all your data. If you try to pull *every* metric from the Leafs to the Global, the Global server will crash. It is designed only for subsets of data or pre-aggregated metrics (using Recording Rules).

---

## 2. Functional Sharding (Splitting by Function)

When a single Prometheus server runs out of memory because there are too many metrics (high cardinality), you can split the workload across multiple isolated Prometheus servers. This is often called "Vertical Partitioning."

### How it Works
Instead of one giant Prometheus scraping everything, you deploy multiple servers, each responsible for a specific slice of your infrastructure.

**Examples of Splitting:**
1.  **By Service Type:**
    *   `Prometheus-A`: Scrapes only Database metrics (MySQL, Postgres, Redis).
    *   `Prometheus-B`: Scrapes only App metrics (Microservices, API Gateways).
    *   `Prometheus-C`: Scrapes only Node/Hardware metrics.
2.  **By Team:**
    *   `Prometheus-Frontend`: Scrapes React/Next.js/Nginx metrics.
    *   `Prometheus-Backend`: Scrapes Go/Java/Python backends.

### Configuration Approach
You essentially configure the `scrape_configs` differently for each server.

*   **Prometheus A Config:**
    ```yaml
    scrape_configs:
      - job_name: 'mysql-exporter'
        ...
    ```
*   **Prometheus B Config:**
    ```yaml
    scrape_configs:
      - job_name: 'backend-api'
        ...
    ```

### Visualization (The "Grafana Glue")
Since these Prometheus servers do not talk to each other, you cannot perform PromQL joins between them (e.g., you cannot divide *App requests* from Server B by *DB CPU* from Server A in a single query).

However, **Grafana** solves this for visualization:
1.  You add both Prometheus instances as separate **Data Sources** in Grafana.
2.  On a Dashboard, Panel A queries Data Source A, and Panel B queries Data Source B.
3.  You can view them side-by-side, effectively "stitching" the monitoring together visually.

---

## Summary of Basic Scaling Strategies

| Strategy | Primary Goal | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **Federation** | Hierarchical aggregation; Global view of multi-cluster setups. | Good for network isolation; Summarizes data well. | The Global node becomes a bottleneck; cannot replicate *all* data. |
| **Functional Sharding** | Reducing load on a single server by splitting the work. | Simple to implement; Isolates failures (if DB monitoring dies, App monitoring stays up). | Data silos; Hard to write queries that combine data from different shards. |

### Note on High Availability (HA)
While "Scaling" adds capacity, "High Availability" ensures reliability. In basic setups, HA is achieved by **Horizontal Duplication**:
*   You run two identical Prometheus servers (`Prom-A` and `Prom-B`).
*   They scrape the exact same targets.
*   If `Prom-A` crashes, Alertmanager (or Grafana) creates a failover to `Prom-B`.
*   *Note: This doubles the load on your monitored services, as they are being scraped twice.*

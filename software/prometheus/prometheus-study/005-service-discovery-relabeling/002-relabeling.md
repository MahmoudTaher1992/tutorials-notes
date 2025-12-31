Based on the comprehensive Table of Contents you provided, **Part V, Section B: Relabeling (The ETL of Prometheus)** is one of the most powerful but often misunderstood features of Prometheus.

You can think of Relabeling as the **ETL (Extract, Transform, Load)** pipeline for your monitoring data. It allows you to intercept data and modify it on the fly.

Here is a detailed explanation of `002-Relabeling.md`.

---

# 002-Relabeling: The ETL of Prometheus

## 1. The High-Level Concept
Prometheus does not just passively accept whatever data an endpoint gives it. Relabeling allows the Prometheus server to dynamically rewrite, drop, or filter metadata and metrics **before** they are saved to the database.

It is used for two main purposes:
1.  **Target Management:** Deciding *what* to scrape and how to name the target.
2.  **Metric Management:** Deciding *which metrics* to save and cleaning up messy labels.

## 2. The Two Phases of Relabeling
This is the most critical distinction to understand. Relabeling happens at two completely different stages in the scrape lifecycle.

### Phase 1: `relabel_configs` (Target Relabeling)
*   **When:** Happens **BEFORE** the scrape occurs.
*   **Input:** Metadata provided by Service Discovery (SD).
*   **Purpose:**
    *   Filter targets (e.g., "Don't scrape pods with `status=failed`").
    *   Format the target address (e.g., changing the port).
    *   Convert "Meta Labels" (from AWS, K8s, Consul) into persistent target labels.
*   **Transient Labels:** In this phase, you have access to labels starting with `__`. These are internal/temporary. If you don't rename them to something standard (without `__`), they are **discarded** before the scrape starts.

### Phase 2: `metric_relabel_configs` (Metric Relabeling)
*   **When:** Happens **AFTER** the scrape, but **BEFORE** saving to disk (Ingestion).
*   **Input:** The actual series (metrics) returned by the target.
*   **Purpose:**
    *   Drop specific heavy metrics (Cardinality control).
    *   Drop sensitive labels (privacy).
    *   Rename metrics coming from legacy systems.

---

## 3. The "Meta" Labels (`__`)
When Prometheus performs Service Discovery (SD), the SD mechanism (like Kubernetes or AWS EC2) provides a wealth of metadata that is not yet useful.

For example, Kubernetes SD provides:
*   `__meta_kubernetes_pod_name`
*   `__meta_kubernetes_namespace`
*   `__meta_kubernetes_pod_label_app`

**Crucial Rule:** Any label starting with `__` is **dropped** automatically after the `relabel_configs` phase is done. If you want to keep the Pod Name as a label on your metrics, you *must* use a relabel rule to copy `__meta_kubernetes_pod_name` to `pod_name`.

---

## 4. Relabeling Actions
In your configuration file (`prometheus.yml`), every relabel step has an `action`. Here are the most common ones:

### A. `replace` (The Default)
Matches a regex against source label(s) and writes the result to a target label.

*   **Scenario:** You have a label `instance="192.168.1.5:8080"` but you want a clean label `host="192.168.1.5"`.
*   **Mechanism:** It uses Regex Capture Groups.

```yaml
action: replace
source_labels: [instance]
regex: '(.*):.*'        # Capture everything before the colon
target_label: host      # Put it in a new label called 'host'
replacement: '$1'       # Use the first capture group
```

### B. `keep` and `drop`
This acts as a filter.
*   **`keep`:** If the regex matches, keep the target/metric. If it doesn't match, **discard it silently**.
*   **`drop`:** The inverse. If the regex matches, discard it.

*   **Scenario:** Only scrape targets that have a specific annotation in Kubernetes.
```yaml
action: keep
source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
regex: 'true'
```

### C. `labelmap`
This is used for bulk-copying. It maps a regex of label names to new label names.

*   **Scenario:** You want all Kubernetes labels (e.g., `app`, `env`, `tier`) attached to the pod to become Prometheus labels, without writing a rule for each one manually.
```yaml
action: labelmap
regex: __meta_kubernetes_pod_label_(.+)
# If K8s has '__meta_kubernetes_pod_label_app=backend',
# this creates a label 'app=backend'.
```

### D. `hashmod` (Sharding)
Used to distribute targets across multiple Prometheus servers (Horizontal Scaling/Sharding). It calculates a hash of the source labels and performs a modulo.
*   **Scenario:** "Prometheus A" scrapes targets where hash % 2 == 0, "Prometheus B" scrapes targets where hash % 2 == 1.

---

## 5. Practical Examples

### Example 1: The "Standard" Kubernetes Relabeling
Almost every Kubernetes setup has this block. It makes the internal `__address__` (IP:Port) reachable but sets the `instance` label to the Pod name (which is more human-readable).

```yaml
relabel_configs:
  # 1. Scrape the specific pod IP and Port
  - source_labels: [__meta_kubernetes_pod_ip, __meta_kubernetes_pod_container_port_number]
    action: replace
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
    target_label: __address__  # Tells Prometheus WHERE to send the HTTP request

  # 2. Rename the 'instance' label to be the Pod Name instead of IP:Port
  - source_labels: [__meta_kubernetes_pod_name]
    action: replace
    target_label: instance
```

### Example 2: Dropping Expensive Metrics (`metric_relabel_configs`)
Imagine a developer accidentally included a high-cardinality metric called `http_request_details_bucket` that is eating all your storage RAM. You can drop it at ingestion without changing the application code.

```yaml
scrape_configs:
  - job_name: 'my-app'
    metric_relabel_configs:
      - source_labels: [__name__] # The internal label representing the metric name
        regex: 'http_request_details_bucket'
        action: drop
```

## Summary for your Study Guide

1.  **Relabeling is a pipeline:** Rules are executed strictly in order (top to bottom).
2.  **`relabel_configs`**: Edits **Targets** (Before scraping). Used for SD and filtering targets.
3.  **`metric_relabel_configs`**: Edits **Series** (After scraping). Used for cardinality reduction and cleanup.
4.  **`__` labels**: Are metadata provided by the system. They disappear unless you `replace` or `labelmap` them into normal labels.
5.  **Debug carefully**: A wrong `drop` rule can result in an empty dashboard with no data. Use the Prometheus web UI "Service Discovery" page to see the result of your Target Relabeling rules.

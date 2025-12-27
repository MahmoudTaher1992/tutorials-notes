Based on the Table of Contents provided, here is a detailed breakdown of **Part VI, Section B: Alerting Rules**.

This section represents the logic layer of your monitoring stack. While Prometheus collects metrics, **Alerting Rules** are the mechanism that evaluates those metrics to decide if a human needs to be woken up or if an automated process needs to trigger.

---

# 006-Alerting-Rule-Management / 002-Alerting-Rules.md

## 1. What is an Alerting Rule?
In Prometheus, an alerting rule is a configuration that defines a condition based on a PromQL query. Prometheus evaluates these rules periodically (usually every 1 minute, defined by `evaluation_interval`).

If the condition is met, Prometheus does not send an email or Slack message directly. Instead, it changes the state of the alert to **"Firing"** and sends that state to the **Alertmanager**, which handles the notification logic.

## 2. Defining Alerts: The YAML Structure
Alerting rules are defined in YAML files loaded via the `rule_files` block in the main Prometheus configuration.

Here is the anatomy of a standard alert rule:

```yaml
groups:
- name: node_alerts
  rules:
  - alert: HighCPUUsage
    expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
    for: 5m
    labels:
      severity: warning
      team: devops
    annotations:
      summary: "High CPU usage on {{ $labels.instance }}"
      description: "CPU usage is at {{ $value }}% for more than 5 minutes."
```

### Key Fields Breakdown:

#### A. `alert` (The Name)
This is the unique identifier for the alert within the group. It usually describes the issue concisely (e.g., `InstanceDown`, `HighErrorRate`, `SSLCertificateExpiring`).

#### B. `expr` (The Expression)
This is the **PromQL query**. It is the logic engine of the alert.
*   The query usually filters for "bad" states.
*   It must return a **vector** (a list of results). If the query returns *nothing* (empty result), the alert is considered "Green" (OK). If it returns *anything*, the alert logic triggers.
*   **Example:** `up == 0` (Find instances that are down).

#### C. `for` (The Duration)
This is the debounce mechanism.
*   **Without `for`:** The moment the CPU hits 81%, the alert fires. This causes "flapping" (alerting on momentary spikes).
*   **With `for: 5m`:** The expression must be consistently true for 5 consecutive minutes before Prometheus considers it a real alert.

#### D. `labels` (Routing & Categorization)
These are key-value pairs attached to the alert. They are primarily used by **Alertmanager** for routing and grouping.
*   **Routing:** "If `severity=critical`, page the on-call engineer. If `severity=warning`, just send a Slack message."
*   **Deduplication:** "Group all alerts with `env=production` together."

#### E. `annotations` (Human Information)
While `labels` are for machines (routing), `annotations` are for humans. They contain the details the engineer needs to triage the issue. Common annotations include `summary`, `description`, `dashboard_url`, or `runbook_url`.

---

## 3. Templating in Alerts (Go Templates)
Static text in alerts is not very useful. You want to know *which* server is down and *what* the value is. Prometheus allows you to use **Go Templating** in the `annotations` (and label values).

### Common Variables:
*   **`{{ $labels.<labelname> }}`**: Accesses the labels of the time series that triggered the alert.
    *   *Example:* `{{ $labels.instance }}` prints "server-01".
*   **`{{ $value }}`**: The numerical value of the query evaluation.
    *   *Example:* If the CPU is at 95.5%, `{{ $value }}` prints "95.5".
    *   *Formatting:* You can use printf formatting: `{{ $value | printf "%.2f" }}` to round to 2 decimal places.

**Example in Action:**
```yaml
annotations:
  description: "Host {{ $labels.instance }} has {{ $value }}% free disk space left."
```
*Becomes:* "Host web-server-01 has 4.5% free disk space left."

---

## 4. The Alert Lifecycle
Understanding the state of an alert is crucial for debugging:

1.  **Inactive:** The `expr` returns no results. Everything is fine.
2.  **Pending:** The `expr` returns results (the threshold is breached), but the `for` duration has not passed yet. No notification is sent yet.
3.  **Firing:** The `expr` has been true for longer than the `for` duration. Prometheus sends the alert to Alertmanager.

---

## 5. Testing Alerts with `promtool`
One of the most powerful features of Prometheus is the ability to **Unit Test** your alerting rules. You should never write an alert and wait for production to break to see if it works.

You create a test file (e.g., `tests.yaml`) and run it with the CLI tool `promtool`.

### Structure of a Unit Test:
1.  **Interval:** How often the test simulates time passing (e.g., 1 minute).
2.  **Input Series:** You define mock data time series with specific values.
3.  **PromQL Expressions:** The rules file you are testing.
4.  **Alert Rule Tests:** You assert that at a specific time, an alert should be firing.

### Example Test Snippet:
```yaml
rule_files:
    - alerts.yaml

evaluation_interval: 1m

tests:
    - interval: 1m
      input_series:
          # Mocking a server that goes down
          - series: 'up{job="node", instance="server1"}'
            values: '1 1 0 0 0 0 0' # 1 is Up, 0 is Down
      alert_rule_test:
          - eval_time: 2m
            alertname: InstanceDown
            exp_alerts: [] # Should be empty (pending, not firing yet)
          - eval_time: 10m
            alertname: InstanceDown
            exp_alerts:
                - exp_labels:
                      severity: critical
                      instance: server1
                  exp_annotations:
                      summary: "Instance server1 is down"
```

Running `promtool test rules tests.yaml` validates your logic without needing a running server.

---

## Summary of Best Practices
1.  **Alert on Symptoms, not Causes:** Alert on "High Latency" (user pain), not "High Memory" (technical detail), unless the memory usage implies an imminent crash.
2.  **Use `for` wisely:** Always use a `for` duration (usually 1m to 5m) to prevent noisy, flapping alerts.
3.  **Enrich Annotations:** Always include a `runbook_url` in the annotations so the on-call engineer knows exactly how to fix the issue.
4.  **Test Rules:** Make `promtool` checks part of your CI/CD pipeline.

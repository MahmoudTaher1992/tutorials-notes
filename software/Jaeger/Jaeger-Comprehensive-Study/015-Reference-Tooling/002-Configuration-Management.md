Based on the Table of Contents provided, here is a detailed explanation of **Part XV, Section B: Configuration Management**.

This section focuses on **how to operationalize Jaeger**. Once you understand the architecture (Collector, Query, Agent) and have chosen your storage (Elasticsearch, Cassandra), you need to tell the binaries how to connect to each other and how to behave.

---

# 015-Reference-Tooling/002-Configuration-Management.md

This module explains the three distinct ways to configure Jaeger components: **CLI Flags**, **Environment Variables**, and **Configuration Files (YAML)**. It also explains the hierarchy of how these configurations are applied.

## 1. The Configuration Hierarchy (Viper)

Jaeger uses a Go library called **Viper** for configuration. This implies a specific precedence order. If you define a setting in multiple places, Jaeger will prioritize them in this order (highest priority first):

1.  **CLI Flags:** Arguments passed directly to the binary at runtime (e.g., `--es.server-urls=...`).
2.  **Environment Variables:** System variables set before the process starts (e.g., `ES_SERVER_URLS=...`).
3.  **Configuration Files:** YAML or JSON files loaded at startup.
4.  **Defaults:** Hardcoded values inside the Jaeger binary.

> **Key Concept:** Almost every CLI flag has a corresponding Environment Variable. The convention is usually converting the flag to uppercase and replacing dashes/dots with underscores.
> *   Flag: `--collector.queue-size`
> *   Env Var: `COLLECTOR_QUEUE_SIZE`

---

## 2. CLI Flags Reference

Command Line Interface (CLI) flags are the most "explicit" way to configure Jaeger. When you run a binary manually or check a running process list (`ps aux`), you can see exactly what settings were used.

### How to use them
When running a Jaeger binary (like `jaeger-collector` or `jaeger-all-in-one`), you append the flags:

```bash
./jaeger-all-in-one --memory.max-traces=10000 --log-level=debug
```

### Categorization of Flags
In the documentation, flags are usually grouped by the component or subsystem they control:

*   **Common Flags:**
    *   `--log-level`: Controls verbosity (`info`, `debug`, `error`).
    *   `--metrics-backend`: Where Jaeger sends its own internal metrics (usually `prometheus`).
*   **Storage Flags:**
    *   `--span-storage.type`: The most important flag. Tells Jaeger to use `elasticsearch`, `cassandra`, `kafka`, `memory`, or `grpc-plugin`.
*   **Elasticsearch Specifics (if type=elasticsearch):**
    *   `--es.server-urls`: Comma-separated list of ES nodes.
    *   `--es.index-prefix`: Naming convention for indices (default `jaeger-span`).
*   **Collector Specifics:**
    *   `--collector.queue-size`: How many spans to hold in memory before dropping.
    *   `--collector.num-workers`: How many go-routines process the queue.

> **Tip:** You can always run any Jaeger binary with `--help` to see the full list of available flags for that specific version.

---

## 3. Environment Variables vs. YAML Config

In modern containerized environments (Docker, Kubernetes), passing long strings of CLI flags is often cumbersome. Jaeger provides two alternatives.

### A. Environment Variables
This is the standard approach for "Cloud Native" applications (The 12-Factor App methodology). It allows you to inject secrets (like DB passwords) securely without writing them in the command line string.

**Example (Docker Compose):**
```yaml
services:
  jaeger-collector:
    image: jaegertracing/jaeger-collector
    environment:
      - SPAN_STORAGE_TYPE=elasticsearch
      - ES_SERVER_URLS=http://elasticsearch:9200
      - ES_USERNAME=elastic
      - ES_PASSWORD=changeme
```

### B. Configuration Files & YAML
While Jaeger v1 binaries are mostly flag/env-var driven, there are specific scenarios where files are required or preferred.

#### 1. Sampling Strategies File (`--sampling.strategies-file`)
This is a JSON file that defines complex sampling logic (e.g., "Sample `Service A` at 10%, but `Service B` at 50%"). You cannot do this easily via flags; you point the flag to a file path.

#### 2. Kubernetes & The Jaeger Operator
If you are running on Kubernetes, you rarely write flags or env vars manually. You write a **YAML Manifest** (Custom Resource Definition).

The Jaeger Operator reads your YAML and **transpiles** it into CLI arguments for the underlying pods.

**Example (Jaeger Operator YAML):**
```yaml
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: simple-prod
spec:
  strategy: production
  storage:
    type: elasticsearch
    options:
      es:
        server-urls: http://elasticsearch:9200
```
*Note: Under `options`, the YAML keys map directly to the CLI flags (minus the `--`).*

#### 3. Jaeger v2 (The Future)
It is important to note (as mentioned in Part XIII of your ToC) that **Jaeger v2** is replatforming onto the **OpenTelemetry Collector**.
*   **Old Way:** Custom Jaeger Flags/Env Vars.
*   **New Way (v2):** Standard OTel YAML configuration (Receivers, Processors, Exporters).

---

## 4. Practical Troubleshooting Scenarios

This section often includes "Gotchas" regarding configuration:

*   **Precedence Issues:** A user sets `ES_SERVER_URLS` in an environment variable, but the startup script also has `--es.server-urls` hardcoded. The Flag wins, and the Env Var is ignored.
*   **Port Conflicts:** Configuring the HTTP port (`--query.port`) effectively helps if you are running Jaeger alongside other services using port 16686.
*   **Memory Tuning:** Configuration is the primary place to tune performance. If Jaeger is crashing (OOM), you adjust `--collector.queue-size` or `--memory.max-traces` via config to limit memory footprint.

## Summary Table

| Method | Best Use Case | Precedence |
| :--- | :--- | :--- |
| **CLI Flags** | Local testing, explicit startup scripts, debugging. | **High** (Overrides everything) |
| **Env Vars** | Docker, Kubernetes (non-operator), Secrets management. | **Medium** |
| **Config Files** | Sampling strategies, Jaeger Operator (CRDs), Jaeger v2. | **Low** (varies by implementation) |

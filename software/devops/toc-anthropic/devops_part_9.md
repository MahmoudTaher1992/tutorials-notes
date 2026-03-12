# DevOps Engineering Study Guide - Part 9: Phase 1 — Logging, DevSecOps & GitOps

## 8.0 Logging

### 8.1 Log Pipeline Architecture
#### 8.1.1 Collection
- 8.1.1.1 Log shippers — Fluentd / Fluent Bit / Vector / Logstash — collect + forward
  - 8.1.1.1.1 Fluent Bit — C — low memory (<1MB) — K8s DaemonSet — preferred
  - 8.1.1.1.2 Fluentd — Ruby — rich plugins — heavier — aggregator role
  - 8.1.1.1.3 Vector — Rust — high throughput — unified logs/metrics — newer
- 8.1.1.2 Collection patterns — DaemonSet (node-level) vs. sidecar (per-pod)
  - 8.1.1.2.1 DaemonSet — single agent per node — /var/log/containers/ — efficient
  - 8.1.1.2.2 Sidecar — per-pod — custom parsing — shares log volume

#### 8.1.2 Parsing & Enrichment
- 8.1.2.1 Log parsing — regex / grok / JSON auto-parse — extract fields
  - 8.1.2.1.1 Grok patterns — named regex — pre-built for nginx/apache/syslog
  - 8.1.2.1.2 JSON parser — auto-keys — no custom regex — prefer structured logs
- 8.1.2.2 Log enrichment — add Kubernetes metadata — pod/namespace/node labels
  - 8.1.2.2.1 Fluent Bit kubernetes filter — attach pod labels to every log line
  - 8.1.2.2.2 Trace injection — add trace_id from OTel propagation — correlate

### 8.2 Log Storage & Querying
#### 8.2.1 Elasticsearch / OpenSearch
- 8.2.1.1 Inverted index — term → posting list — fast full-text search
  - 8.2.1.1.1 Shard — Lucene instance — horizontal partition — primary + replica
  - 8.2.1.1.2 Index lifecycle — hot → warm → cold → delete — ILM policy
  - 8.2.1.1.3 Rollover — new index when size/age exceeded — alias points to current
- 8.2.1.2 Query DSL — JSON — match / term / range / bool — complex queries
  - 8.2.1.2.1 KQL — Kibana Query Language — human-friendly — UI search bar

#### 8.2.2 Loki (Log Aggregation)
- 8.2.2.1 Loki — index only labels — store log lines compressed — cheap
  - 8.2.2.1.1 Labels — low-cardinality only — app / namespace / pod — not trace_id
  - 8.2.2.1.2 LogQL — filter + metric queries — pipe expressions — Prometheus-like
  - 8.2.2.1.3 Chunks — compressed log streams — stored in object storage — low cost
- 8.2.2.2 Loki architecture — distributor + ingester + querier + ruler
  - 8.2.2.2.1 Ingester WAL — crash recovery — flush to object storage every 2 min

---

## 9.0 DevSecOps

### 9.1 Secret Management
#### 9.1.1 HashiCorp Vault
- 9.1.1.1 Secret engines — KV / PKI / database / SSH / AWS / GCP — pluggable
  - 9.1.1.1.1 KV v2 — versioned — soft delete — check-and-set — metadata
  - 9.1.1.1.2 Dynamic secrets — database engine — short-lived credentials — auto-revoke
  - 9.1.1.1.3 PKI engine — issue short-lived certs — CA hierarchy — automate rotation
- 9.1.1.2 Auth methods — token / AppRole / K8s / AWS / OIDC / LDAP
  - 9.1.1.2.1 K8s auth — service account JWT — Vault validates with K8s API
  - 9.1.1.2.2 AppRole — role_id + secret_id — machine auth — CI/CD pipelines
- 9.1.1.3 Vault policies — HCL — path-based — capabilities — least privilege
  - 9.1.1.3.1 path "secret/data/myapp/*" { capabilities = ["read"] }
  - 9.1.1.3.2 Token TTL — short-lived — renewable — no long-lived tokens in apps
- 9.1.1.4 Vault HA — Raft integrated storage — 3/5 nodes — auto-unseal
  - 9.1.1.4.1 Shamir seal — key shares — M-of-N — manual unseal
  - 9.1.1.4.2 Auto-unseal — AWS KMS / GCP KMS / Azure Key Vault — no manual

### 9.2 SAST / DAST / SCA in Pipelines
#### 9.2.1 Static Analysis (SAST)
- 9.2.1.1 SAST — analyze source code — find vulnerabilities before runtime
  - 9.2.1.1.1 Semgrep — pattern-based — custom rules — fast — OSS
  - 9.2.1.1.2 CodeQL — data flow analysis — GitHub — deep semantic analysis
  - 9.2.1.1.3 Bandit (Python) / gosec (Go) / SpotBugs (Java) — language-specific
- 9.2.1.2 Pipeline integration — fail on HIGH+ — PR comment annotations — SARIF output

#### 9.2.2 Software Composition Analysis (SCA)
- 9.2.2.1 SCA — scan dependencies — find CVEs in libraries — SBOM generation
  - 9.2.2.1.1 Dependabot / Renovate — auto-PRs for vulnerable deps — merge gate
  - 9.2.2.1.2 Snyk / Grype — deeper analysis — license compliance — exploit maturity
- 9.2.2.2 Reachability analysis — is vulnerable code actually called? — reduce noise
  - 9.2.2.2.1 Snyk reachability — call graph — only alert if vulnerable path reachable

#### 9.2.3 Dynamic Analysis (DAST)
- 9.2.3.1 DAST — test running application — send malicious inputs — find runtime bugs
  - 9.2.3.1.1 OWASP ZAP — active scan — passive scan — API scan — CI integration
  - 9.2.3.1.2 Nuclei — template-based — fast — community templates — CVE checks

---

## 10.0 GitOps

### 10.1 GitOps Principles
#### 10.1.1 Core Principles
- 10.1.1.1 Git as single source of truth — all config in Git — no manual cluster changes
  - 10.1.1.1.1 Declarative desired state — YAML in repo — no imperative kubectl
  - 10.1.1.1.2 Audit trail — git log = change log — who + what + when
- 10.1.1.2 Pull-based delivery — agent watches Git — pulls changes — no push from CI
  - 10.1.1.2.1 No cluster credentials in CI — agent has access — CI just pushes to Git
  - 10.1.1.2.2 Reconciliation loop — drift detection — auto-correct — continuous
- 10.1.1.3 Observability — compare live state vs. desired — alert on divergence
  - 10.1.1.3.1 Sync status — Synced / OutOfSync / Unknown — dashboard visibility

### 10.2 Reconciliation & Drift
- 10.2.1.1 Reconciliation interval — poll Git or webhook — detect new commits
  - 10.2.1.1.1 Webhook trigger — Git push → notify agent — instant reconcile
  - 10.2.1.1.2 Force sync — manual trigger — re-apply even if no change
- 10.2.1.2 Drift remediation — agent detects live ≠ desired → apply desired
  - 10.2.1.2.1 self-heal flag — auto-revert manual kubectl changes — enforce Git truth
  - 10.2.1.2.2 Pruning — delete resources not in Git — enable explicitly — destructive

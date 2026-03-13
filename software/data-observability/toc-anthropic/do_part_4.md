# Data Observability Complete Study Guide - Part 4: Data Testing & Pipeline Observability

## 7.0 Data Testing

### 7.1 Testing Taxonomy
#### 7.1.1 Test Types
- 7.1.1.1 Schema tests — column exists / data type / not-null / unique / accepted values
  - 7.1.1.1.1 Not-null test — fail if any NULL in required column — completeness enforcement
  - 7.1.1.1.2 Unique test — no duplicate PK — idempotency check — dedup validation
  - 7.1.1.1.3 Accepted values — enum validation — status IN ('active','inactive') — domain check
- 7.1.1.2 Referential integrity tests — FK relationship — every child ID exists in parent table
  - 7.1.1.2.1 Relationships test (dbt) — child.FK in parent.PK — orphan detection
- 7.1.1.3 Statistical / distribution tests — numeric range / mean / percentile — anomaly tests
  - 7.1.1.3.1 Range check — value BETWEEN min AND max — price > 0 AND < 1M
  - 7.1.1.3.2 Z-score check — column value within N std devs of historical mean — outlier
- 7.1.1.4 Custom business logic tests — SQL assertions — domain invariants — bespoke rules
  - 7.1.1.4.1 SQL test — SELECT count(*) FROM orders WHERE ship_date < order_date > 0 → fail
  - 7.1.1.4.2 Python assertion — pandas DataFrame checks — complex multi-column logic
- 7.1.1.5 Reconciliation tests — cross-system — source_count = warehouse_count — data fidelity
  - 7.1.1.5.1 Row count reconciliation — extract count vs. load count — no silent data loss
  - 7.1.1.5.2 Checksum reconciliation — hash of key columns — detect silent value corruption

#### 7.1.2 Test Pyramid for Data
- 7.1.2.1 Unit tests (model level) — test single transformation in isolation — mocked inputs
  - 7.1.2.1.1 dbt unit tests — YAML-defined inputs + expected outputs — regression safety net
  - 7.1.2.1.2 Fast feedback — run on every PR — no dependency on full pipeline
- 7.1.2.2 Integration tests — test multi-step pipeline end-to-end — real data subset
  - 7.1.2.2.1 Staging environment — run pipeline on sample data — assert output quality
  - 7.1.2.2.2 Contract tests — consumer receives expected schema + values — interface test
- 7.1.2.3 Production monitors — continuous checks on live data — freshness + volume + distribution
  - 7.1.2.3.1 Always-on — run on schedule or trigger — production data health monitoring
  - 7.1.2.3.2 Alert on failure — page on-call — block downstream consumers — circuit breaker

### 7.2 Test Infrastructure
#### 7.2.1 Test Execution
- 7.2.1.1 In-warehouse testing — push SQL tests to warehouse — leverage compute — scalable
  - 7.2.1.1.1 Compile test to SQL — SELECT count(*) WHERE fail_condition > 0 — zero-copy
  - 7.2.1.1.2 Warehouse cost — every test = query — budget test runs — sample large tables
- 7.2.1.2 Test scheduling — post-pipeline trigger (event-driven) vs. cron — timing strategy
  - 7.2.1.2.1 Event-driven — test after pipeline completes — fresh data — no delay
  - 7.2.1.2.2 Cron — run every hour — catches freshness issues even if no pipeline ran
- 7.2.1.3 Test result storage — persist pass/fail history — trend analysis — quality over time
  - 7.2.1.3.1 Elementary meta-tables — dbt test results persisted — queryable history

---

## 8.0 Pipeline Observability

### 8.1 Pipeline Telemetry
#### 8.1.1 Metrics to Collect
- 8.1.1.1 Throughput — records processed per second — batch size / window — capacity planning
  - 8.1.1.1.1 Input throughput — records read from source — detect source slowdown
  - 8.1.1.1.2 Output throughput — records written to sink — detect bottleneck
- 8.1.1.2 Latency — time per record / per batch — P50 / P95 / P99 — tail latency matters
  - 8.1.1.2.1 Processing lag (streaming) — event time vs. processing time — Flink watermarks
  - 8.1.1.2.2 Task duration (batch) — elapsed time per DAG task — SLA compliance
- 8.1.1.3 Error metrics — failed records / retry count / DLQ depth — error rate per stage
  - 8.1.1.3.1 Parse error rate — malformed records — alert if > 0.1% — schema mismatch signal
  - 8.1.1.3.2 Retry rate — transient failures — high retry = underlying instability
- 8.1.1.4 Resource metrics — CPU / memory / network — executor utilization — cost control
  - 8.1.1.4.1 Spill-to-disk events — memory pressure — shuffle spill — tune executor memory

#### 8.1.2 Dead Letter Queues
- 8.1.2.1 DLQ — capture failed records — reprocess later — no data loss on pipeline error
  - 8.1.2.1.1 DLQ depth monitor — growing DLQ = persistent failure — alert + manual review
  - 8.1.2.1.2 DLQ record inspection — parse error message + original payload — root cause
  - 8.1.2.1.3 DLQ reprocessing — fix transform + replay — idempotent sink required

### 8.2 DAG-Level Observability
#### 8.2.1 DAG Health Metrics
- 8.2.1.1 Task success rate — pass rate per task over rolling window — reliability measure
  - 8.2.1.1.1 Flaky task detection — intermittent failures — retry masks problem — investigate
  - 8.2.1.1.2 Cascading failure — upstream task failure → downstream skipped — lineage-aware
- 8.2.1.2 DAG run duration — historical P50/P95 — SLA breach prediction — runtime trend
  - 8.2.1.2.1 Slow task detection — compare to baseline — > 2× typical duration → alert
  - 8.2.1.2.2 Critical path analysis — identify bottleneck task — optimize longest chain
- 8.2.1.3 Queue depth — tasks waiting to run — executor saturation — concurrency planning
  - 8.2.1.3.1 Executor slots — Airflow CeleryExecutor slots — starved tasks = capacity issue

# Data Observability Complete Study Guide - Part 11: OpenTelemetry & Airflow Observability

## 21.0 OpenTelemetry for Data Pipelines

### 21.1 OTel Concepts Applied to Data
#### 21.1.1 Signals
- 21.1.1.1 Metrics — counters / gauges / histograms — records_processed / pipeline_lag / error_rate
  - 21.1.1.1.1 Counter — monotonically increasing — records_ingested_total — cumulative
  - 21.1.1.1.2 Gauge — current value — queue_depth / consumer_lag — point-in-time
  - 21.1.1.1.3 Histogram — distribution — processing_duration_seconds — P50/P95/P99 via buckets
- 21.1.1.2 Traces — distributed trace across pipeline stages — span per task/step — latency decomposition
  - 21.1.1.2.1 Pipeline trace — ingestion → transform → load — end-to-end span tree
  - 21.1.1.2.2 Span attributes — dataset name / row count / partition / warehouse — context
  - 21.1.1.2.3 Span events — point in time within span — schema change detected / checkpoint written
- 21.1.1.3 Logs — structured log events — level / timestamp / trace_id — correlated to trace
  - 21.1.1.3.1 trace_id injection — correlate log to trace — find logs for slow span — powerful

#### 21.1.2 OTel Instrumentation
- 21.1.2.1 Auto-instrumentation — OTel agent — framework-level spans — no code changes
  - 21.1.2.1.1 Python OTel SDK — opentelemetry-api + sdk + exporter — manual span creation
  - 21.1.2.1.2 OTLP exporter — send to OpenTelemetry Collector — vendor-neutral — Jaeger/Tempo
- 21.1.2.2 OTel Collector — receive / process / export — pipeline of processors — central gateway
  - 21.1.2.2.1 Receivers — OTLP / Jaeger / Prometheus / Kafka — accept telemetry from any source
  - 21.1.2.2.2 Processors — batch / filter / attribute enrichment — reduce cardinality
  - 21.1.2.2.3 Exporters — Prometheus / Jaeger / Tempo / Datadog — route to backend
- 21.1.2.3 Data pipeline semantic conventions — WIP in OTel — dataset attributes on spans
  - 21.1.2.3.1 db.system + db.name — warehouse context — table name as span attribute
  - 21.1.2.3.2 Custom attributes — rows_read / rows_written / bytes_written — domain-specific

### 21.2 OpenLineage & OTEL Integration
#### 21.2.1 OpenLineage
- 21.2.1.1 OpenLineage spec — JSON events — RunEvent (START/COMPLETE/FAIL) — standard lineage
  - 21.2.1.1.1 InputDataset + OutputDataset facets — schema facet + stats facet — per run
  - 21.2.1.1.2 Job facet — pipeline name + job type — identifies transformation process
- 21.2.1.2 Marquez server — OpenLineage backend — REST API — lineage graph storage + query
  - 21.2.1.2.1 /api/v1/lineage — POST RunEvent — /api/v1/jobs — GET lineage — simple REST
- 21.2.1.3 OTel + OpenLineage — span attributes carry lineage facets — unified telemetry
  - 21.2.1.3.1 Lineage as span attribute — input_datasets / output_datasets — trace = process

---

## 22.0 Airflow Observability

### 22.1 Airflow Metrics
#### 22.1.1 StatsD & Prometheus
- 22.1.1.1 StatsD integration — Airflow emits metrics via StatsD — statsd_host config
  - 22.1.1.1.1 dag.dag_id.duration — DAG run duration per dag_id — latency tracking
  - 22.1.1.1.2 operator_successes_TaskName — operator success count — per-task success rate
  - 22.1.1.1.3 executor.open_slots / queued_slots — executor capacity — saturation monitor
- 22.1.1.2 Prometheus exporter — statsd_exporter sidecar — translate StatsD → Prometheus
  - 22.1.1.2.1 Grafana dashboard — pre-built Airflow dashboards — community-maintained
  - 22.1.1.2.2 Alert rules — Prometheus alertmanager — task failure rate > 10% → page

#### 22.1.2 Airflow Logs & Tracing
- 22.1.2.1 Task logs — per-task — stdout/stderr captured — stored in log backend
  - 22.1.2.1.1 Remote logging — S3 / GCS / Elasticsearch — scalable — query by task instance
  - 22.1.2.1.2 Structured logging — JSON format — include dag_id / task_id / run_id — parseable
- 22.1.2.2 OpenTelemetry in Airflow 2.7+ — native OTel tracing — span per task — exporter config
  - 22.1.2.2.1 otel_on = True — airflow.cfg — enable OTel integration — OTLP exporter
  - 22.1.2.2.2 Trace per DAG run — tasks as spans — visualize in Jaeger / Tempo — trace UI

### 22.2 Airflow Data Quality Integration
#### 22.2.1 Quality Gates in DAGs
- 22.2.1.1 SQLCheckOperator — run SQL assertion — non-zero result = fail — gate downstream tasks
  - 22.2.1.1.1 SQLValueCheckOperator — compare value to expected — exact match check
  - 22.2.1.1.2 SQLIntervalCheckOperator — compare metric to N-day window — anomaly gate
- 22.2.1.2 BranchPythonOperator — route on quality result — proceed vs. quarantine branch
  - 22.2.1.2.1 Quarantine pattern — quality fail → move to quarantine table → alert → human review
- 22.2.1.3 Sensors — wait for upstream data — FileSensor / S3KeySensor / ExternalTaskSensor
  - 22.2.1.3.1 ExternalTaskSensor — wait for upstream DAG task to succeed — dependency gate
  - 22.2.1.3.2 Sensor timeout — mode=reschedule — poke_interval — avoid blocking worker slots
- 22.2.1.4 DataHub Airflow plugin — emit OpenLineage events — auto lineage from Airflow DAGs
  - 22.2.1.4.1 inlet / outlet task annotation — mark dataset inputs/outputs — explicit lineage
  - 22.2.1.4.2 Auto-extraction — hooks intercept all operators — detect dataset references

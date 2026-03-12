# Azure Complete Study Guide - Part 14: Phase 2 — Synapse, Databricks, Stream Analytics

## 28.0 Azure Synapse Analytics

### 28.1 Synapse Core
→ See Ideal §10.1 Data Warehousing, §10.2 ETL/ELT

#### 28.1.1 Synapse-Unique Features
- **Unique: Unified workspace** — SQL + Spark + Pipelines + KQL + Power BI in one pane
  - 28.1.1.1 Synapse Studio — no separate portal — single IDE for all personas
  - 28.1.1.2 Co-authoring — Git-integrated notebooks — collaborative analytics
- **Unique: Dedicated SQL Pool pause/resume** — stop billing for compute — storage retained
  - 28.1.1.3 Automation — auto-pause on schedule — PowerShell/Logic App patterns
  - 28.1.1.4 Workload management — workload groups — cap concurrency per group
  - 28.1.1.5 Result set cache — TTL 168hrs — identical queries served from cache
- **Unique: Serverless SQL Pool** — query data lake without provisioning — pay per TB
  - 28.1.1.6 External tables — CREATE EXTERNAL TABLE — partition pruning via folder structure
  - 28.1.1.7 Delta Lake support — read Delta tables from ADLS Gen2 — time travel
  - 28.1.1.8 Wildcard path — OPENROWSET(BULK 'https://.../*.parquet') — multiple files
- **Unique: Synapse Link** — zero-ETL — Cosmos DB or SQL Server → Synapse analytical store
  - 28.1.1.9 Columnar format auto-sync — no write amplification to transactional store
  - 28.1.1.10 Cost model — analytical store storage + Synapse compute — no RU charge
- **Unique: Synapse Pipelines** — ADF-equivalent within workspace — 90+ connectors
  - 28.1.1.11 Mapping dataflows — code-free Spark ETL — visual canvas
  - 28.1.1.12 Triggers — schedule, tumbling window, event-based (Storage/Custom)
- **Unique: KQL pools (Azure Data Explorer)** — time-series, IoT, log analytics workloads
  - 28.1.1.13 Ingestion from Event Hub — streaming + batch — retention policies
- **Unique: Power BI integration** — publish Power BI dataset from Synapse workspace
  - 28.1.1.14 DirectLake mode — Power BI reads Delta/Parquet directly — no import

---

## 29.0 Azure Databricks

### 29.1 Databricks Core
→ See Ideal §10.3 Batch Processing, §10.5 Data Lake

#### 29.1.1 Azure Databricks-Unique Features
- **Unique: Unity Catalog integration with Entra ID** — groups → UC principals
  - 29.1.1.1 External locations — ADLS Gen2 credentials — storage credential + location
  - 29.1.1.2 Delta Sharing — open protocol — share data without moving it
  - 29.1.1.3 Lineage — column-level — dataset to dashboard — cross-workspace
- **Unique: Azure Databricks-specific compute**
  - 29.1.1.4 Azure-exclusive SKUs — Lsv3 NVMe — best Spark shuffle performance
  - 29.1.1.5 Azure confidential VMs — DCsv3 — secure Spark workloads
- **Unique: Photon engine** — vectorized C++ query engine — 2–20x faster SQL
  - 29.1.1.6 Columnar batch processing — SIMD — cache-friendly — replaces JVM Spark
  - 29.1.1.7 Delta Live Tables + Photon — near-real-time + cheap batch same engine
- **Unique: Databricks Asset Bundles (DABs)** — IaC for notebooks/jobs/pipelines
  - 29.1.1.8 databricks.yml — define resources — deploy via CLI
  - 29.1.1.9 CI/CD integration — GitHub Actions / Azure DevOps — bundle deploy
- **Unique: Databricks Apps** — host web apps co-located with data — Streamlit/Gradio
  - 29.1.1.10 Direct cluster access — app talks to SQL Warehouse or cluster — no copy
- **Unique: OIDC federation with Azure** — ADB service principal → Entra federated cred
  - 29.1.1.11 No secret rotation — short-lived tokens — storage + Key Vault access

---

## 30.0 Azure Stream Analytics & Event Routing

### 30.1 Stream Analytics Core
→ See Ideal §10.3 Stream Processing, §10.4 Azure Stream Analytics

#### 30.1.1 Stream Analytics-Unique Features
- **Unique: No-code editor** — visual pipeline — Event Hub → transform → output
  - 30.1.1.1 Tile-based designer — filter, aggregate, join, ML score — drag and drop
  - 30.1.1.2 Immediate deployment — test with live data — iterate without SAQL knowledge
- **Unique: JavaScript UDFs + UDAs** — custom logic in SAQL — stateful aggregation
  - 30.1.1.3 User-defined aggregate (UDA) — init, accumulate, deaccumulate, getResult
- **Unique: MLmodel scoring** — ONNX model inline — score stream records in real-time
  - 30.1.1.4 Export ML model → ONNX → embed in Stream Analytics job
- **Unique: Geofencing queries** — ST_WITHIN, ST_DISTANCE, ST_BUFFER — IoT tracking
  - 30.1.1.5 Reference data join — polygon definitions in Blob — update without restart
- **Unique: Job diagram view** — visualize parallelism — data flow per partition
  - 30.1.1.6 Watermark delays — monitor late arrival handling per node
- **Unique: PowerBI output** — push to real-time streaming dataset — live dashboards
  - 30.1.1.7 0-second latency — dataset refreshed on each batch — no manual refresh

---

## 31.0 Azure Data Factory

### 31.1 ADF Core
→ See Ideal §10.2 ETL/ELT Pipelines

#### 31.1.1 ADF-Unique Features
- **Unique: Managed virtual network + private endpoints** — all connectors go private
  - 31.1.1.1 Auto-resolve IR with managed VNet — private DNS auto-managed
  - 31.1.1.2 Private link for SHIR — route SHIR traffic through PrivateLink
- **Unique: Mapping Data Flows** — code-free Spark — Spark cluster behind scenes
  - 31.1.1.3 Debug mode — live cluster — row-level preview during development
  - 31.1.1.4 Flowlet — reusable sub-flow — embed in multiple data flows
- **Unique: SSIS integration runtime** — lift-and-shift SSIS packages — no code change
  - 31.1.1.5 SSIS catalog (SSISDB) on Azure SQL MI — identical to on-prem SSIS
  - 31.1.1.6 Enterprise SSIS IR — premium connectors — custom setup allowed
- **Unique: ADF Dataflow Bloom filter** — skip partition files if no match — pushdown
- **Unique: Global parameters** — workspace-wide constants — environment config
  - 31.1.1.7 Export/import — DEV → PROD — preserve pipeline references
- **Unique: Managed Airflow environment (Preview)** — Apache Airflow hosted in ADF
  - 31.1.1.8 Bring own DAGs — python requirements.txt — plugins + connections

# Data Observability Complete Study Guide - Part 7: dbt

## 14.0 dbt (data build tool)

### 14.1 dbt Core Architecture
#### 14.1.1 Project Structure
- 14.1.1.1 models/ — SQL SELECT files — dbt compiles to CREATE TABLE/VIEW — transformation layer
  - 14.1.1.1.1 Staging models — src_ / stg_ prefix — clean raw data — one-to-one source
  - 14.1.1.1.2 Intermediate models — int_ prefix — joins + enrichment — not exposed to BI
  - 14.1.1.1.3 Mart models — fct_ / dim_ — business-facing — fully documented — tested
- 14.1.1.2 sources.yml — declare upstream tables — freshness checks — test source data
  - 14.1.1.2.1 freshness: warn_after + error_after — dbt source freshness — staleness alert
  - 14.1.1.2.2 source tests — not_null / unique on source — catch upstream quality early
- 14.1.1.3 schema.yml — document models + columns + tests — co-located with models
  - 14.1.1.3.1 Column-level docs — description — tag — meta — searchable in catalog
  - 14.1.1.3.2 model-level config — materialization / tags / meta / contracts — declarative

#### 14.1.2 Materializations
- 14.1.2.1 View — default — recomputed each query — no storage — always fresh — cheap
- 14.1.2.2 Table — full refresh — snapshot of data — CREATE TABLE AS SELECT — heavy
  - 14.1.2.2.1 Use when — downstream query speed matters — complex transform — read-heavy
- 14.1.2.3 Incremental — append / upsert only new/changed rows — efficient for large tables
  - 14.1.2.3.1 unique_key — merge on this key — upsert behavior — idempotent
  - 14.1.2.3.2 is_incremental() macro — filter to new rows only — {{ this }} = existing table
  - 14.1.2.3.3 Full refresh flag — --full-refresh — override incremental — rebuild from scratch
- 14.1.2.4 Ephemeral — CTE inlined — no object in DB — reuse across models — no cost
  - 14.1.2.4.1 Avoid deep chains — nested CTEs grow — hard to debug — intermediate tables better

### 14.2 dbt Tests
#### 14.2.1 Built-in Generic Tests
- 14.2.1.1 not_null — fail if any NULL — applied per column — completeness
- 14.2.1.2 unique — fail if duplicates — applied per column — PK validation
- 14.2.1.3 accepted_values — fail if value not in list — enum validation — domain check
- 14.2.1.4 relationships — FK check — column references parent model — referential integrity
  - 14.2.1.4.1 to: ref('dim_users') — field: user_id — child.user_id in parent.id
- 14.2.1.5 Custom generic tests — reusable — define in tests/generic/ — parametrized macros
  - 14.2.1.5.1 not_empty — assert row count > 0 — empty table = pipeline failure signal
  - 14.2.1.5.2 expect_column_values_to_be_between — range check — generic + configurable

#### 14.2.2 dbt Unit Tests
- 14.2.2.1 dbt unit tests (1.8+) — YAML-defined — mock inputs → expected outputs — fast
  - 14.2.2.1.1 given: input_rows — when: model runs — then: expected_output_rows — assertion
  - 14.2.2.1.2 Run without DB data — isolated — CI-safe — no warehouse cost for logic test
- 14.2.2.2 Singular tests — SQL files in tests/ — returns rows = failure — ad hoc checks
  - 14.2.2.2.1 SELECT * FROM {{ ref('orders') }} WHERE amount < 0 — negative order = bug

### 14.3 dbt Artifacts & State
#### 14.3.1 Artifacts
- 14.3.1.1 manifest.json — full project graph — node metadata — tests — exposure — lineage
  - 14.3.1.1.1 Unique node ID — model.project.model_name — cross-reference in lineage tools
  - 14.3.1.1.2 Parsed by DataHub / Elementary / Monte Carlo — ingest dbt lineage — catalog
- 14.3.1.2 run_results.json — execution outcomes — status / timing / rows_affected per node
  - 14.3.1.2.1 Test failures captured — test node result = fail + message — observable
  - 14.3.1.2.2 Elementary ingests run_results — persists to meta-tables — queryable history
- 14.3.1.3 catalog.json — column-level metadata — types — fetched from warehouse — docs
  - 14.3.1.3.1 dbt docs generate — creates catalog + manifest — serve with dbt docs serve

#### 14.3.2 dbt State & Slim CI
- 14.3.2.1 State-based selection — run only modified models — dbt run --select state:modified+
  - 14.3.2.1.1 Defer to prod — use prod manifest as baseline — compare on PR — fast CI
  - 14.3.2.1.2 dbt build --select state:modified+ —defer —state prod/ — test changed + deps
- 14.3.2.2 dbt Exposures — declare BI dashboards + ML models consuming dbt — downstream lineage
  - 14.3.2.2.1 Exposure in schema.yml — name + type + maturity + owner + depends_on
  - 14.3.2.2.2 Impact analysis — change to fct_orders — which exposures are downstream — notify

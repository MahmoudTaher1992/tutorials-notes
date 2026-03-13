# Data Observability Complete Study Guide - Part 8: Great Expectations & Soda

## 15.0 Great Expectations

### 15.1 Core Concepts
#### 15.1.1 Expectations
- 15.1.1.1 Expectation — declarative assertion about data — "column X should be not null"
  - 15.1.1.1.1 Atomic expectation — single column / table property — composable — versioned
  - 15.1.1.1.2 Expectation suite — named collection of expectations — applied to one asset
  - 15.1.1.1.3 Auto-generated suite — profile data — generate expectations from statistics — baseline
- 15.1.1.2 Expectation types — column-level / table-level / multi-column / custom
  - 15.1.1.2.1 expect_column_values_to_not_be_null — null check — essential baseline
  - 15.1.1.2.2 expect_column_values_to_be_between — range check — min_value + max_value
  - 15.1.1.2.3 expect_column_values_to_match_regex — pattern validation — email / UUID / date
  - 15.1.1.2.4 expect_table_row_count_to_be_between — volume check — min + max row count
  - 15.1.1.2.5 expect_column_pair_values_a_to_be_greater_than_b — cross-column — ship ≥ order
  - 15.1.1.2.6 Custom expectations — inherit from ColumnMapExpectation — arbitrary logic

#### 15.1.2 Data Context & Assets
- 15.1.2.1 Data context — GX project root — config / expectations / checkpoints — .great_expectations/
  - 15.1.2.1.1 Datasource — connection to data — SQL / Spark / Pandas / file-based — pluggable
  - 15.1.2.1.2 Data asset — logical table or file — referenced by name — versioned expectations
- 15.1.2.2 Batch request — specify subset of asset — partition by date — run on specific slice
  - 15.1.2.2.1 Batch definition — partition column + value — run checks on today's partition only
  - 15.1.2.2.2 Whole table batch — default — validate entire table — use for smaller datasets

### 15.2 Checkpoints & Data Docs
#### 15.2.1 Checkpoints
- 15.2.1.1 Checkpoint — execution unit — run suite against batch — produce validation result
  - 15.2.1.1.1 YAML config — checkpoint name + suite name + batch — declarative execution
  - 15.2.1.1.2 Actions — post-validation — update Data Docs / send Slack alert / store result
  - 15.2.1.1.3 SlackNotificationAction — message on failure — #data-quality channel — alert
- 15.2.1.2 Running checkpoints — CLI (great_expectations checkpoint run) or Python API
  - 15.2.1.2.1 Airflow operator — GreatExpectationsOperator — gate pipeline on checkpoint pass
  - 15.2.1.2.2 Result: ValidationResult — statistics — success_percent — failed expectations list

#### 15.2.2 Data Docs
- 15.2.2.1 Data Docs — auto-generated HTML — expectations + validation results — browsable
  - 15.2.2.1.1 Expectation suite page — all expectations in suite — business-readable format
  - 15.2.2.1.2 Validation result page — run outcome — per-expectation pass/fail + observed values
- 15.2.2.2 Hosting Data Docs — S3 static site / local / Confluence-embed — team visibility
  - 15.2.2.2.1 update_data_docs action — rebuild after each run — always current — publish to S3

---

## 16.0 Soda

### 16.1 SodaCL (Soda Checks Language)
#### 16.1.1 Check Syntax
- 16.1.1.1 checks for dataset_name — YAML block — list of checks — per-dataset file
  - 16.1.1.1.1 row_count check — row_count > 0 — basic volume guard — zero-row detection
  - 16.1.1.1.2 missing_count — null count for column — missing_count(col) = 0 — strict null
  - 16.1.1.1.3 duplicate_count — dedup check — duplicate_count(col) = 0 — uniqueness
  - 16.1.1.1.4 invalid_count — values not matching format — invalid_count(email) = 0
  - 16.1.1.1.5 avg / min / max / sum — aggregate bounds — avg(price) between 10 and 500
- 16.1.1.2 Threshold levels — fail / warn — separate thresholds — graduated severity
  - 16.1.1.2.1 warn: when > 5 / fail: when > 100 — warn early — fail on serious violation
  - 16.1.1.2.2 No threshold (informational) — collect metric — surface in Soda Cloud — observe

#### 16.1.2 Advanced SodaCL
- 16.1.2.1 Schema check — schema change detection — added / removed / changed columns
  - 16.1.2.1.1 schema: warn: when schema changes — detect any column change — broad coverage
  - 16.1.2.1.2 columns: required/forbidden — specific column presence enforcement
- 16.1.2.2 Freshness check — freshness(updated_at) < 6h — time since last row update
  - 16.1.2.2.1 Warn on 4h / fail on 8h — graduated freshness thresholds — SLA alignment
- 16.1.2.3 Reference check — cross-dataset FK validation — id in other_dataset(col)
  - 16.1.2.3.1 must_not_exist — values not allowed to be in reference set — exclusion check
- 16.1.2.4 User-defined metrics — custom SQL metric — feed into threshold checks
  - 16.1.2.4.1 failed_rows — SQL filter — retrieve failing rows — include in report

### 16.2 Soda Cloud & Integration
#### 16.2.1 Soda Cloud
- 16.2.1.1 Centralized results — scan history — trend charts — health dashboards — SaaS
  - 16.2.1.1.1 Dataset health score — pass rate over time — drill to check level — root cause
  - 16.2.1.1.2 Anomaly detection — Soda Cloud ML — auto-detect metric anomalies — no threshold
- 16.2.1.2 Integration — Airflow / dbt / Spark / Snowflake / BigQuery / Redshift — connectors
  - 16.2.1.2.1 soda scan — CLI command — run checks — exit code 1 on fail — CI/CD gate

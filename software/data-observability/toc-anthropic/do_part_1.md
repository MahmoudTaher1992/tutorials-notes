# Data Observability Complete Study Guide - Part 1: Fundamentals & Data Quality

## 1.0 Data Observability Fundamentals

### 1.1 Definition & Scope
#### 1.1.1 What Is Data Observability
- 1.1.1.1 Ability to understand, diagnose, and manage data health across the full lifecycle
  - 1.1.1.1.1 Five pillars — freshness / distribution / volume / schema / lineage — Barr Moses
  - 1.1.1.1.2 Data downtime — periods when data is missing, erroneous, or unreliable — cost
  - 1.1.1.1.3 Shift-left — detect issues close to source — cheaper to fix — proactive vs reactive
- 1.1.1.2 Observability vs. monitoring — monitoring = known unknowns — observability = unknown unknowns
  - 1.1.1.2.1 Monitoring — predefined thresholds — alerts on known failure modes
  - 1.1.1.2.2 Observability — rich telemetry — investigate novel failures — ask new questions
  - 1.1.1.2.3 Data observability extends software observability (logs/metrics/traces) to data assets

#### 1.1.2 Data Observability vs. Data Quality
- 1.1.2.1 Data quality — properties of the data itself — dimensions: completeness/accuracy/etc.
- 1.1.2.2 Data observability — broader — includes pipeline health, lineage, schema drift, freshness
  - 1.1.2.2.1 DQ is a subset — observability provides operational context around quality signals
  - 1.1.2.2.2 Observability answers "why" — DQ answers "what" — both needed for reliability

### 1.2 Pillars of Data Observability
#### 1.2.1 The Five Pillars
- 1.2.1.1 Freshness — when was data last updated — staleness detection — SLA compliance
  - 1.2.1.1.1 Measured by — last updated timestamp — expected update interval — lag = violation
- 1.2.1.2 Distribution — are values within expected statistical range — null rates / value histograms
  - 1.2.1.2.1 Sudden shift in distribution — upstream change or bug — model drift trigger
- 1.2.1.3 Volume — expected number of rows / events per time window — drop or spike detection
  - 1.2.1.3.1 Row count anomaly — ingestion failure / duplicate explosion — leading indicator
- 1.2.1.4 Schema — structure and types of fields — unexpected additions / removals / type changes
  - 1.2.1.4.1 Breaking schema change — downstream query fails — lineage needed to scope impact
- 1.2.1.5 Lineage — where data comes from — where it goes — dependency graph — blast radius
  - 1.2.1.5.1 Column-level lineage — fine-grained — track individual field transformations

### 1.3 Organizational Context
#### 1.3.1 Data Reliability Engineering
- 1.3.1.1 DRE role — analogous to SRE — owns data reliability — SLOs for datasets
  - 1.3.1.1.1 Error budgets for data — tolerated downtime per quarter — prioritize fixes
  - 1.3.1.1.2 Toil reduction — automate repetitive data quality checks — focus on engineering
- 1.3.1.2 Data mesh context — federated ownership — each domain owns its data quality
  - 1.3.1.2.1 Data product thinking — treat datasets as products — SLAs to consumers
  - 1.3.1.2.2 Federated governance — central platform — domain-specific quality rules

---

## 2.0 Data Quality

### 2.1 Quality Dimensions
#### 2.1.1 Core Dimensions
- 2.1.1.1 Completeness — are all expected values present — null/missing rate per column
  - 2.1.1.1.1 Null rate threshold — column X must be < 5% null — alert on violation
  - 2.1.1.1.2 Referential completeness — FK exists in parent table — no orphan records
- 2.1.1.2 Accuracy — values reflect real-world truth — harder to automate — cross-source validation
  - 2.1.1.2.1 Cross-system reconciliation — compare DB vs. API vs. warehouse counts — diff check
  - 2.1.1.2.2 Ground-truth comparison — known reference values — regression-style check
- 2.1.1.3 Consistency — same entity has same value across systems — deduplication signal
  - 2.1.1.3.1 Cross-table consistency — user.email = orders.email for same user_id
  - 2.1.1.3.2 Temporal consistency — value doesn't change unexpectedly — monotone checks
- 2.1.1.4 Uniqueness — no unexpected duplicates — PK violations — idempotency failures
  - 2.1.1.4.1 Duplicate detection — GROUP BY PK — count > 1 — dedup pipeline needed
  - 2.1.1.4.2 Idempotency — rerunning pipeline = same result — no duplicate rows inserted
- 2.1.1.5 Timeliness — data available when needed — SLA window — freshness + latency
- 2.1.1.6 Validity — values conform to defined rules — regex / range / enum / referential
  - 2.1.1.6.1 Domain validation — email regex / date format / positive price — schema-level
  - 2.1.1.6.2 Business rule validation — discount ≤ 100% / ship_date ≥ order_date — semantic

#### 2.1.2 Quality Scoring
- 2.1.2.1 Composite quality score — weighted average of dimension scores — 0–100 scale
  - 2.1.2.1.1 Weight by business impact — completeness > accuracy for most OLAP use cases
  - 2.1.2.1.2 Per-table scorecard — trend over time — regression alerting — QA dashboard
- 2.1.2.2 Data Quality Index (DQI) — aggregate organization-level — C-suite metric
  - 2.1.2.2.1 Drill down — DQI → domain → table → column — hierarchical decomposition

### 2.2 Quality Rules & Expectations
#### 2.2.1 Rule Types
- 2.2.1.1 Schema rules — data type / not-null / primary key / foreign key — structural
- 2.2.1.2 Statistical rules — mean ± Nσ / percentile bounds / min-max range — distributional
  - 2.2.1.2.1 Dynamic thresholds — ML-learned bounds — adapt to seasonality — better than static
  - 2.2.1.2.2 Static thresholds — explicit min/max — simple — brittle with seasonal data
- 2.2.1.3 Custom business rules — domain-specific SQL or Python — arbitrary predicates
  - 2.2.1.3.1 SQL assertion — SELECT count(*) WHERE condition > 0 → fail — powerful + flexible
- 2.2.1.4 Referential rules — FK integrity — join coverage — orphan rate

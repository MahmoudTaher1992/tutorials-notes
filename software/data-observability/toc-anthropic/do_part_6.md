# Data Observability Complete Study Guide - Part 6: Incidents, Contracts & Anomaly Detection

## 11.0 Incident Management & SLAs

### 11.1 Data SLOs & SLIs
#### 11.1.1 Defining SLOs for Data
- 11.1.1.1 SLI (Service Level Indicator) — measurable signal — freshness lag / row count / DQI
  - 11.1.1.1.1 Freshness SLI — % of measurement windows where lag ≤ threshold — rolling 30 days
  - 11.1.1.1.2 Quality SLI — % of pipeline runs where quality checks pass — rolling window
  - 11.1.1.1.3 Availability SLI — % of time dataset queryable without error — uptime analog
- 11.1.1.2 SLO (Service Level Objective) — target for SLI — 99% freshness compliance per month
  - 11.1.1.2.1 Error budget — 1 − SLO — 1% = 7.2 hours/month allowed downtime — burn rate
  - 11.1.1.2.2 Error budget burn rate — 1h window × 14.4 = burn alert — fast exhaustion
- 11.1.1.3 SLA (Service Level Agreement) — external commitment — breach → escalation / penalty
  - 11.1.1.3.1 Consumer SLA — contractual — downstream team counts on delivery by 8 AM daily
  - 11.1.1.3.2 Consequence — SLA breach = P1 incident — executive notification — postmortem

### 11.2 Incident Response
#### 11.2.1 Incident Lifecycle
- 11.2.1.1 Detection — automated alert or consumer report — MTTD (Mean Time to Detect)
  - 11.2.1.1.1 MTTD goal — < 15 minutes for P1 — continuous monitors + fast alert routing
  - 11.2.1.1.2 Consumer-reported — often first signal — invest in proactive detection to reduce
- 11.2.1.2 Triage — identify scope + severity — check lineage for root cause — assign owner
  - 11.2.1.2.1 Lineage-assisted triage — traverse upstream — find first failed node — root cause
  - 11.2.1.2.2 Blast radius assessment — downstream consumer count — revenue impact estimate
- 11.2.1.3 Mitigation — stop downstream consumption — communicate status — quarantine bad data
  - 11.2.1.3.1 Circuit breaker — pause dependent pipelines — prevent cascading bad data
  - 11.2.1.3.2 Rollback — restore last known good data version — table time-travel / snapshot
- 11.2.1.4 Resolution + postmortem — fix root cause — RCA document — action items
  - 11.2.1.4.1 MTTR goal — P1 < 2 hours — P2 < 8 hours — measured + tracked over time
  - 11.2.1.4.2 Blameless postmortem — 5 Whys — contributing factors — systemic improvements

### 11.3 On-Call for Data
#### 11.3.1 Data On-Call Practices
- 11.3.1.1 Rotation — rotating data engineer on-call — defined escalation path — runbooks
  - 11.3.1.1.1 Runbook per alert — step-by-step diagnosis — autonomous resolution — faster MTTR
  - 11.3.1.1.2 Runbook link in alert body — auto-attached — responder has context immediately
- 11.3.1.2 Alert fatigue management — too many alerts → ignored → missed incidents
  - 11.3.1.2.1 Alert review cadence — weekly audit — suppress noisy monitors — tune thresholds
  - 11.3.1.2.2 Alert ownership — each alert has owner — ownerless alerts → disable or assign

---

## 12.0 Data Contracts

### 12.1 Contract Specification
#### 12.1.1 Contract Components
- 12.1.1.1 Schema contract — field names / types / required fields / constraints — structural
  - 12.1.1.1.1 Declared in YAML — version-controlled — reviewed on change — source of truth
  - 12.1.1.1.2 Semantic versioning — breaking change = major version bump — consumers notified
- 12.1.1.2 Quality contract — acceptable null rates / value ranges / freshness SLA — quality
  - 12.1.1.2.1 Producer commits — "orders table will have < 1% null on order_id"
  - 12.1.1.2.2 Consumer relies on — SLA-backed guarantee — no surprise breakage
- 12.1.1.3 Delivery contract — update frequency / retention period / partitioning strategy
  - 12.1.1.3.1 Frequency — hourly / daily — consumer depends on scheduling cadence
  - 12.1.1.3.2 Retention — 90 days hot / 2 years cold — consumer plans queries accordingly

#### 12.1.2 Contract Enforcement
- 12.1.2.1 Pre-production validation — contract checked in CI — schema tests + quality gates
  - 12.1.2.1.1 dbt contract enforcement — contract: true — fail build if schema diverges
  - 12.1.2.1.2 Great Expectations checkpoint — run in CI — block deploy on quality failure
- 12.1.2.2 Runtime enforcement — validate at ingestion — reject non-conforming records
  - 12.1.2.2.1 Schema registry enforcement — Kafka producer fails if schema incompatible
  - 12.1.2.2.2 Data contract as code — Soda / custom Python — gate pipeline on contract pass

---

## 13.0 Statistical Anomaly Detection

### 13.1 Univariate Methods
#### 13.1.1 Statistical Tests
- 13.1.1.1 Z-score — (value − mean) / std — |z| > 3 = anomaly — assumes normal distribution
  - 13.1.1.1.1 Rolling Z-score — mean/std computed over sliding window — adapts to trend
  - 13.1.1.1.2 Modified Z-score — median absolute deviation — robust to outliers — skewed data
- 13.1.1.2 IQR method — outlier if value < Q1 − 1.5×IQR or > Q3 + 1.5×IQR — non-parametric
  - 13.1.1.2.1 Tukey fences — robust — no normality assumption — good for skewed metrics
- 13.1.1.3 Prophet time-series — additive model — trend + seasonality + holiday — residual check
  - 13.1.1.3.1 Uncertainty interval — yhat_lower / yhat_upper — value outside = anomaly
  - 13.1.1.3.2 Weekly / yearly seasonality — auto-detected — handles Mon/Fri vs. weekend patterns

### 13.2 Multivariate & ML Methods
#### 13.2.1 ML-Based Detection
- 13.2.1.1 Isolation Forest — tree-based — isolate anomalies in fewer splits — fast — scalable
  - 13.2.1.1.1 contamination parameter — expected anomaly fraction — 0.01–0.05 typical
  - 13.2.1.1.2 Multi-metric input — [row_count, null_rate, mean_value] — holistic detection
- 13.2.1.2 Autoencoder — learn compressed representation — high reconstruction error = anomaly
  - 13.2.1.2.1 Threshold on reconstruction error — train on normal — score new data
- 13.2.1.3 DBSCAN — density-based clustering — noise points = anomalies — no k needed
  - 13.2.1.3.1 eps + min_samples tuning — critical — domain-specific — validate on labeled data

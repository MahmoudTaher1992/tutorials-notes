# Software Company Roles Study Guide - Part 4: Infrastructure, Platform & Data Roles

## 4.0 Infrastructure & Platform Roles

### 4.1 DevOps Engineer
#### 4.1.1 Core Responsibilities
- 4.1.1.1 Bridges development and operations — reduce friction from code to production
  - 4.1.1.1.1 CI/CD ownership — pipelines, build systems, deployment automation
  - 4.1.1.1.2 Environment management — dev/staging/prod parity — infrastructure config
- 4.1.1.2 Infrastructure automation — IaC — reproducible environments — no snowflakes
  - 4.1.1.2.1 Provision — create infra via code — Terraform / Pulumi / CloudFormation
  - 4.1.1.2.2 Configuration — enforce desired state — Ansible / Chef / Puppet
- 4.1.1.3 Observability — metrics + logs + traces — alert on meaningful signals
  - 4.1.1.3.1 On-call rotation — first responder for infra issues — escalation path
  - 4.1.1.3.2 Runbook authoring — step-by-step remediation — reduce MTTR
- 4.1.1.4 Developer experience — fast pipelines + self-service tooling + clear docs
  - 4.1.1.4.1 Build time reduction — cache layers + parallelism — developer productivity

#### 4.1.2 DevOps Career Levels
- 4.1.2.1 Junior DevOps — executes defined tasks — maintains existing pipelines
- 4.1.2.2 DevOps Engineer — owns CI/CD, containerization, basic cloud infra
- 4.1.2.3 Senior DevOps — designs systems, mentors, sets infra standards
- 4.1.2.4 Staff / Lead DevOps — cross-team platform strategy — org-wide tooling
- 4.1.2.5 DevOps Manager — manages DevOps team — hiring + roadmap + culture

---

### 4.2 Site Reliability Engineer (SRE)
#### 4.2.1 SRE vs. DevOps Distinction
- 4.2.1.1 SRE — Google-originated — software engineering applied to operations problems
  - 4.2.1.1.1 SRE implements DevOps philosophy — with prescriptive practices + metrics
  - 4.2.1.1.2 Key difference — SRE has explicit reliability targets (SLOs) + error budgets
- 4.2.1.2 Toil limit — max 50% operational work — rest is engineering automation
  - 4.2.1.2.1 Toil — manual, repetitive, no enduring value — must be eliminated
  - 4.2.1.2.2 Automate toil away — scripts → self-healing — escalate if >50% toil

#### 4.2.2 SRE Core Responsibilities
- 4.2.2.1 Define + own SLIs / SLOs / error budgets — reliability contract with product
  - 4.2.2.1.1 SLI negotiation — agree with PM + EM — what "reliable enough" means
  - 4.2.2.1.2 Error budget policy — freeze features vs. invest in reliability — enforced
- 4.2.2.2 Production readiness reviews (PRR) — gate before launch — checklist
  - 4.2.2.2.1 PRR covers — monitoring, alerting, runbooks, capacity, rollback plan
  - 4.2.2.2.2 SRE approval — sign-off that service meets reliability bar before GA
- 4.2.2.3 Incident commander role — lead response — coordinate — not just fix
  - 4.2.2.3.1 Blameless postmortem — systems thinking — action items tracked
- 4.2.2.4 Capacity planning — predict growth — provision ahead of demand
  - 4.2.2.4.1 Load testing — establish baseline — model growth — set provisioning targets

---

### 4.3 Platform Engineer
#### 4.3.1 Platform Engineer Core Responsibilities
- 4.3.1.1 Build Internal Developer Platform (IDP) — golden paths — paved roads
  - 4.3.1.1.1 Golden path — opinionated recommended way — reduces decision fatigue
  - 4.3.1.1.2 Self-service — developers provision environments without ops ticket
  - 4.3.1.1.3 Backstage / Port / Cortex — developer portal — service catalog + docs
- 4.3.1.2 Abstract complexity — expose simple interfaces — hide infra details from devs
  - 4.3.1.2.1 Platform as a Product — roadmap + SLOs + user research (devs as users)
  - 4.3.1.2.2 Developer satisfaction — track adoption + DORA metrics + surveys
- 4.3.1.3 Standardization — common observability, security, deploy pipelines — org-wide
  - 4.3.1.3.1 Opinionated defaults — secure by default — right patterns built in
  - 4.3.1.3.2 Escape hatches — allow deviation with justification — not rigid

---

### 4.4 Cloud / Infrastructure Engineer
#### 4.4.1 Cloud Engineer Responsibilities
- 4.4.1.1 Design + operate cloud infrastructure — networking + compute + storage + IAM
  - 4.4.1.1.1 Landing zone design — account structure + VPC + baseline security controls
  - 4.4.1.1.2 Cost optimization — reserved instances + rightsizing + spot strategy
- 4.4.1.2 Multi-cloud strategy — evaluate tradeoffs — avoid vendor lock-in where needed
  - 4.4.1.2.1 Cloud-agnostic abstractions — Terraform modules — portable patterns
- 4.4.1.3 Cloud security — IAM policies + SCPs + Config rules + GuardDuty + Security Hub

---

## 5.0 Data Roles

### 5.1 Data Engineer
#### 5.1.1 Core Responsibilities
- 5.1.1.1 Build + maintain data pipelines — ingest → transform → serve — reliable data
  - 5.1.1.1.1 Batch pipelines — scheduled ETL/ELT — warehouse loads — daily/hourly
  - 5.1.1.1.2 Streaming pipelines — real-time ingestion — Kafka → Spark/Flink → warehouse
- 5.1.1.2 Data modeling — dimensional model / data vault / one big table — tradeoffs
  - 5.1.1.2.1 Dimensional model — facts + dimensions — Kimball — BI-friendly
  - 5.1.1.2.2 Data Vault — hub + link + satellite — audit trail — enterprise DW
- 5.1.1.3 Data quality — SLAs on freshness + completeness + accuracy — monitoring
  - 5.1.1.3.1 dbt tests — not_null + unique + referential integrity + custom rules
  - 5.1.1.3.2 Data contracts — upstream agrees schema won't break consumers — formal

#### 5.1.2 Data Engineer Collaboration
- 5.1.2.1 Works with Data Analysts — provides clean reliable datasets — serves needs
- 5.1.2.2 Works with ML Engineers — provides features — manages feature store
- 5.1.2.3 Works with Backend Engineers — event schemas — Kafka topics — API contracts

---

### 5.2 Data Scientist
#### 5.2.1 Core Responsibilities
- 5.2.1.1 Experiment design — hypothesis → A/B test → statistical analysis → decision
  - 5.2.1.1.1 Power analysis — minimum detectable effect + sample size + duration
  - 5.2.1.1.2 Novelty effect — early spike — run test long enough — stabilize metric
- 5.2.1.2 Exploratory analysis — find patterns — generate hypotheses — inform product
- 5.2.1.3 Predictive models — build + validate + hand off to ML Engineer for prod
  - 5.2.1.3.1 Model evaluation — precision/recall/AUC — business metric translation

---

### 5.3 ML Engineer
#### 5.3.1 Core Responsibilities
- 5.3.1.1 Production ML — take Data Scientist model → reliable production service
  - 5.3.1.1.1 Training pipelines — reproducible — versioned data + code + artifacts
  - 5.3.1.1.2 Serving infrastructure — latency SLOs — model versioning — rollback
- 5.3.1.2 MLOps — monitor model performance — detect drift — retrain triggers
  - 5.3.1.2.1 Feature store — consistent train/serve features — no training-serving skew
  - 5.3.1.2.2 Shadow mode — run new model alongside old — compare outputs — safe rollout

---

### 5.4 Data Analyst & Analytics Engineer
#### 5.4.1 Data Analyst Responsibilities
- 5.4.1.1 Answer business questions — SQL + BI tools — self-service analysis
  - 5.4.1.1.1 Dashboard ownership — stakeholder-facing — refresh cadence + alerting
  - 5.4.1.1.2 Ad-hoc analysis — executive requests — turnaround time matters

#### 5.4.2 Analytics Engineer Responsibilities
- 5.4.2.1 Bridge between Data Engineer and Analyst — transform data in warehouse
  - 5.4.2.1.1 dbt models — SQL transforms — version controlled — tested — documented
  - 5.4.2.1.2 Semantic layer — define metrics once — consistent org-wide definitions

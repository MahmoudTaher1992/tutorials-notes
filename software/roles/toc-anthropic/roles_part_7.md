# Software Company Roles Study Guide - Part 7: Role Interactions & Collaboration

## 12.0 Role Interactions

### 12.1 Feature Delivery — End-to-End Collaboration
#### 12.1.1 Discovery Phase
- 12.1.1.1 PM leads discovery — frames problem — brings data + customer evidence
  - 12.1.1.1.1 PM + UX Designer — user research sessions — observe real user pain
  - 12.1.1.1.2 PM + Engineering — early feasibility check — avoid designing impossible
  - 12.1.1.1.3 PM + Data Analyst — quantify opportunity — size the problem with metrics
- 12.1.1.2 UX Designer runs design sprint — ideation + prototyping + user testing
  - 12.1.1.2.1 PM participates — provides business context — not design decisions
  - 12.1.1.2.2 Engineers consulted — technical constraints — design within feasibility
- 12.1.1.3 Output — defined problem + validated solution concept — ready for refinement

#### 12.1.2 Refinement & Planning
- 12.1.2.1 3 Amigos — PM + Dev + QA — review each story — shared understanding
  - 12.1.2.1.1 PM clarifies — acceptance criteria — business rules — edge cases
  - 12.1.2.1.2 Dev raises — technical concerns — alternative approaches — estimates
  - 12.1.2.1.3 QA identifies — test scenarios — edge cases — testability requirements
- 12.1.2.2 Sprint planning — team commits to stories — capacity-based — PM available
  - 12.1.2.2.1 Scope negotiation — PM adjusts scope — engineers protect quality
  - 12.1.2.2.2 Definition of Ready gate — story must be clear before sprint starts

#### 12.1.3 Build Phase
- 12.1.3.1 Backend Engineer → Frontend Engineer — API contract first — parallel work
  - 12.1.3.1.1 API design doc — schema + endpoints + error codes — agree before code
  - 12.1.3.1.2 Mock server — frontend unblocked — uses mocked API while backend builds
- 12.1.3.2 Backend Engineer → DevOps / Platform — deployment needs — environment config
  - 12.1.3.2.1 Infrastructure requirements — new DB / queue / storage — ticket early
  - 12.1.3.2.2 Feature flags — DevOps provides flag service — devs wrap feature in flag
- 12.1.3.3 Frontend Engineer ↔ UI Designer — design QA — match spec — iterate
  - 12.1.3.3.1 Design review — designer checks implementation — feedback on deviations
  - 12.1.3.3.2 Acceptable deviations — engineer flags infeasible — designer adapts

#### 12.1.4 Test & Release Phase
- 12.1.4.1 QA Engineer — tests in staging — verifies acceptance criteria — reports bugs
  - 12.1.4.1.1 Bug triage — QA + PM + Dev — severity assessment — fix or defer
  - 12.1.4.1.2 Release sign-off — QA confirms critical scenarios pass — green light
- 12.1.4.2 DevOps / SRE — production readiness — monitoring + alerting + rollback plan
  - 12.1.4.2.1 Launch checklist — runbook + metrics dashboard + alert threshold set
  - 12.1.4.2.2 Feature flag rollout — 1% → 10% → 100% — SRE monitors error budget
- 12.1.4.3 PM — monitors post-launch metrics — validates success criteria met
  - 12.1.4.3.1 Launch review — 1 week after — metrics vs. targets — iterate or move on

---

### 12.2 Ownership & Accountability Boundaries
#### 12.2.1 What Each Role Owns
- 12.2.1.1 PM owns — what to build + why — business metrics + user outcomes
  - 12.2.1.1.1 Does NOT own — how to build — technical decisions — team health
- 12.2.1.2 EM owns — team health + delivery + people — how the team operates
  - 12.2.1.2.1 Does NOT own — what to build — roadmap — product decisions
- 12.2.1.3 Tech Lead / Staff Eng owns — technical architecture — code quality standards
  - 12.2.1.3.1 Does NOT own — people management — career growth of teammates
- 12.2.1.4 UX Designer owns — user experience quality — interaction + visual design
  - 12.2.1.4.1 Does NOT own — product strategy — what features get built
- 12.2.1.5 QA Engineer owns — quality signal — test coverage — release confidence
  - 12.2.1.5.1 Does NOT own — quality itself — whole team owns quality
- 12.2.1.6 DevOps / SRE owns — reliability + deployment + observability infrastructure
  - 12.2.1.6.1 Does NOT own — application code quality — shared with dev team

#### 12.2.2 Common Friction Points & Resolution
- 12.2.2.1 PM vs. EM — scope vs. quality tension — negotiation needed — document
  - 12.2.2.1.1 Scope creep — PM adds to sprint — EM protects capacity — escalate
  - 12.2.2.1.2 Tech debt accumulation — EM advocates — PM allocates 20% capacity
- 12.2.2.2 Dev vs. QA — QA as blocker perception — embed QA early — shift left
  - 12.2.2.2.1 Bug ownership — developer wrote it — developer fixes it — QA verifies
- 12.2.2.3 Dev vs. DevOps — "works on my machine" — shared ownership of prod
  - 12.2.2.3.1 DevOps done right — devs have prod access — deploy themselves — no handoff

---

### 12.3 On-Call & Incident Roles
#### 12.3.1 On-Call Structure
- 12.3.1.1 Primary on-call — first responder — acknowledges alert — begins triage
  - 12.3.1.1.1 Rotation — weekly — all engineers participate — shared burden
  - 12.3.1.1.2 On-call readiness — runbooks current + dashboards accessible + laptop ready
- 12.3.1.2 Secondary on-call — escalation — if primary unavailable or needs help
  - 12.3.1.2.1 Escalation ladder — primary → secondary → EM → VP — defined SLAs
- 12.3.1.3 Incident commander — SEV1/2 — coordinates response — usually SRE or senior
  - 12.3.1.3.1 IC responsibilities — status updates every 15 min — no fixing — coordinating
  - 12.3.1.3.2 Communications lead — customer-facing updates — status page — separate from IC
- 12.3.1.4 Subject matter experts — called in by IC — DB expert / network / security
  - 12.3.1.4.1 Avoid too many cooks — IC controls who is in war room — clarity

#### 12.3.2 Post-Incident Roles
- 12.3.2.1 Postmortem owner — typically IC or lead engineer — writes timeline + analysis
  - 12.3.2.1.1 Blameless review — systems + processes failed — not individuals
  - 12.3.2.1.2 Action items — PM + EM prioritize — tracked in backlog — not forgotten
- 12.3.2.2 PM role in incidents — communicate to business stakeholders — set expectations
  - 12.3.2.2.1 Customer impact assessment — how many affected — revenue impact — SLA
- 12.3.2.3 EM role in incidents — support team — remove blockers — handle escalations
  - 12.3.2.3.1 After incident — check team wellbeing — late-night incidents take toll

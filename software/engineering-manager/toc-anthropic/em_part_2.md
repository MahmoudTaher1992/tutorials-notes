# Engineering Manager Complete Study Guide (Ideal / Angel Method)
## Part 2: Ideal Engineering Manager — Execution & Technical Leadership

---

### 4. Execution & Process Management

#### 4.1 Development Methodologies
- 4.1.1 Scrum — sprints, ceremonies, roles (PO, Scrum Master, Dev Team)
- 4.1.2 Kanban — flow-based, WIP limits, continuous delivery
- 4.1.3 Shape Up (Basecamp) — 6-week cycles, betting table, no backlogs
- 4.1.4 Scrumban — hybrid, pull-based sprint planning
- 4.1.5 Avoiding methodology dogma — adapt to team, not team to methodology
- 4.1.6 Ceremony effectiveness — stand-ups (async-first), retrospectives, planning sessions

#### 4.2 Project Planning & Delivery
- 4.2.1 Decomposition — epics → stories → tasks, vertical slices over horizontal
- 4.2.2 Estimation techniques — story points, t-shirt sizing, three-point (#-Wideband Delphi)
- 4.2.3 Scope management — scope creep detection, change control, "good, fast, cheap"
- 4.2.4 Milestone planning — critical path, buffer strategy, external dependency mapping
- 4.2.5 Risk management — risk register, likelihood × impact, mitigation vs contingency
- 4.2.6 Cross-team dependency management — liaison roles, shared roadmaps, SLAs

#### 4.3 Tracking & Reporting
- 4.3.1 Team metrics — velocity, cycle time, lead time, deployment frequency (DORA)
- 4.3.2 Quality metrics — defect escape rate, MTTR, change failure rate
- 4.3.3 Avoiding vanity metrics — raw velocity, story points as goals, commit counts
- 4.3.4 Status reporting to leadership — ROYGBIV/RAG status, exception-based reporting
- 4.3.5 Dashboards & tooling — Jira, Linear, Shortcut, Notion; what to track where
- 4.3.6 Communicating bad news — early, factual, with mitigation plan

#### 4.4 Release & Delivery Management
- 4.4.1 CI/CD strategy — deployment frequency as a health metric, trunk-based development
- 4.4.2 Release trains — scheduled vs on-demand releases, coordination with stakeholders
- 4.4.3 Feature flags — decouple deploy from release, gradual rollouts, kill switches
- 4.4.4 Go/No-Go decisions — launch criteria, rollback readiness, stakeholder sign-off
- 4.4.5 On-call & operational readiness — runbooks, ownership, escalation paths
- 4.4.6 Launch retrospectives — what could be smoother, continuous delivery improvement

---

### 5. Technical Leadership & Oversight

#### 5.1 Architectural Decision-Making
- 5.1.1 EM's role — facilitate and influence, not dictate (unless also Tech Lead)
- 5.1.2 RFC process — Request for Comments, structured proposal, async review
- 5.1.3 ADRs (Architecture Decision Records) — lightweight, persistent, searchable decisions
- 5.1.4 Technical steering committee — cross-team alignment, consistency at scale
- 5.1.5 Build vs Buy framework — cost, risk, differentiation, maintenance burden
- 5.1.6 Vendor evaluation — POC criteria, security review, contract negotiation involvement

#### 5.2 Technical Debt Management
- 5.2.1 Classifying debt — intentional (shortcuts) vs unintentional (ignorance) vs bit rot
- 5.2.2 Quantifying debt — developer pain points, velocity impact, incident correlation
- 5.2.3 Debt prioritization — severity × frequency × blast radius scoring
- 5.2.4 Paydown strategy — 20% time, dedicated sprints, boy scout rule
- 5.2.5 Communicating debt to stakeholders — business impact framing, not technical jargon
- 5.2.6 Preventing accumulation — tech debt budgets, architectural review gates

#### 5.3 Fostering Technical Excellence
- 5.3.1 Code review culture — PR standards, turnaround SLA, learning vs gatekeeping
- 5.3.2 Engineering standards — linters, formatters, test coverage gates, security checks
- 5.3.3 Testing strategy — test pyramid (unit → integration → e2e), quality ownership
- 5.3.4 Documentation culture — READMEs, runbooks, decision logs, API docs
- 5.3.5 Knowledge sharing — tech talks, brown bags, pair programming, internal blog
- 5.3.6 Security-first mindset — DevSecOps, threat modeling, security champions program

#### 5.4 Technical Roadmap
- 5.4.1 Aligning tech roadmap with product roadmap — shared planning sessions
- 5.4.2 Platform investments — infrastructure as enablement, reducing cognitive load
- 5.4.3 Technology radar — adopt, trial, assess, hold framework (ThoughtWorks model)
- 5.4.4 Legacy modernization — strangler fig pattern, incremental migration strategy
- 5.4.5 Capacity allocation — feature work vs tech debt vs operational vs innovation
- 5.4.6 Communicating the technical roadmap — visuals, executive summaries, quarterly reviews

#### 5.5 System Reliability & Observability
- 5.5.1 SLOs, SLIs, SLAs — defining and owning reliability targets
- 5.5.2 Error budgets — allowing risk vs protecting reliability
- 5.5.3 On-call design — rotation fairness, escalation paths, alerting quality
- 5.5.4 Incident management — P0/P1/P2 classification, war room facilitation
- 5.5.5 Post-incident review (PIR/RCA) — blameless, systemic causes, action items
- 5.5.6 Runbook culture — every alert must have a runbook, operational documentation

---

### 6. Stakeholder Management & Influence

#### 6.1 Working with Product Management
- 6.1.1 Shared planning cadence — quarterly roadmap, sprint planning partnership
- 6.1.2 Healthy tension — EM defends technical quality, PM defends user value
- 6.1.3 Discovery participation — involving engineers early in problem definition
- 6.1.4 Prioritization negotiation — RICE, ICE, MoSCoW frameworks
- 6.1.5 Translating business requirements — breaking ambiguity into technical clarity
- 6.1.6 Saying no effectively — "not now, here's the cost, here's the alternative"

#### 6.2 Cross-Functional Collaboration
- 6.2.1 Design collaboration — design system adoption, design review participation
- 6.2.2 Data/analytics partnership — instrumentation ownership, self-serve analytics
- 6.2.3 Sales/marketing engineering — customer escalations, feature request triage
- 6.2.4 Customer support escalations — shared triage process, feedback loops
- 6.2.5 Security & compliance — SOC 2, GDPR, audit participation, pen test response
- 6.2.6 Finance partnership — cloud cost management, budget justification, ROI framing

#### 6.3 Executive Communication
- 6.3.1 Executive summary writing — one-pager format, bottom-line-up-front (BLUF)
- 6.3.2 Translating technical risk to business risk — framing for non-technical audience
- 6.3.3 Managing up — proactive updates, no surprises, making your manager successful
- 6.3.4 Influencing without authority — data, relationships, credibility, timing
- 6.3.5 Presenting to leadership — visual clarity, "so what" framing, handling questions
- 6.3.6 Organizational politics navigation — building allies, understanding power dynamics

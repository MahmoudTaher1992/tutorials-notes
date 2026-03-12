# Software Company Roles Study Guide - Part 5: Security, QA, Design & Leadership Roles

## 6.0 Security Roles

### 6.1 Application Security Engineer (AppSec)
#### 6.1.1 Core Responsibilities
- 6.1.1.1 Secure SDLC — embed security in development process — shift left
  - 6.1.1.1.1 Threat modeling — design phase — identify attack surfaces before code
  - 6.1.1.1.2 Security requirements — define acceptance criteria with security controls
  - 6.1.1.1.3 Secure code review — manual review of sensitive code — auth + crypto + input
- 6.1.1.2 SAST / DAST / SCA tooling — integrate into CI/CD — triage findings with teams
  - 6.1.1.2.1 Reduce false positives — tune rules — lose credibility if noisy
  - 6.1.1.2.2 Developer enablement — security champions program — train engineers
- 6.1.1.3 Penetration testing — scheduled + bug bounty — validate defenses
  - 6.1.1.3.1 Internal red team — simulate attacker — find before real attacker does
  - 6.1.1.3.2 Bug bounty — external researchers — HackerOne / Bugcrowd — coordinated disclosure
- 6.1.1.4 Vulnerability management — triage + SLA + track remediation to closure
  - 6.1.1.4.1 Critical — 24h SLA — High — 7 days — Medium — 30 days — severity-based

### 6.2 Security Operations (SecOps)
#### 6.2.1 Core Responsibilities
- 6.2.1.1 Monitor for threats — SIEM — detect anomalous behavior — 24/7
  - 6.2.1.1.1 Alert triage — distinguish true positive from noise — playbook-driven
  - 6.2.1.1.2 Threat intelligence — IOCs / TTPs — MITRE ATT&CK framework — hunt
- 6.2.1.2 Incident response — contain + eradicate + recover + lessons learned
  - 6.2.1.2.1 IR playbooks — per threat type — ransomware / credential leak / data breach
  - 6.2.1.2.2 Forensics — preserve evidence — chain of custody — legal considerations

---

## 7.0 Quality & Testing Roles

### 7.1 QA Engineer
#### 7.1.1 Core Responsibilities
- 7.1.1.1 Ensure product quality — test planning + execution + bug tracking
  - 7.1.1.1.1 Test plan — scope + objectives + approach + entry/exit criteria
  - 7.1.1.1.2 Test cases — positive + negative + edge cases — traceability to requirements
- 7.1.1.2 Manual testing — exploratory + regression + user acceptance testing
  - 7.1.1.2.1 Exploratory testing — unscripted — find unexpected issues — creativity
  - 7.1.1.2.2 Regression suite — protect against regressions — critical path coverage
- 7.1.1.3 Bug lifecycle management — report + reproduce + prioritize + verify fix
  - 7.1.1.3.1 Bug report quality — steps to reproduce + expected vs. actual + environment
  - 7.1.1.3.2 Severity vs. priority — severity = impact — priority = when to fix
- 7.1.1.4 Quality advocacy — raise quality concerns in sprint planning — before code
  - 7.1.1.4.1 Shift-left testing — QA in design + planning — not just at end of sprint

#### 7.1.2 QA Collaboration Model
- 7.1.2.1 Embedded QA — QA in squad — same sprint — continuous feedback
  - 7.1.2.1.1 3 amigos — PM + Dev + QA — review story before implementation
- 7.1.2.2 Centralized QA — separate QA team — supports multiple squads — less context

---

### 7.2 SDET (Software Dev Engineer in Test)
#### 7.2.1 Core Responsibilities
- 7.2.1.1 Build test automation frameworks — not just write tests — enable scale
  - 7.2.1.1.1 Framework design — page object model / screenplay / fluent APIs
  - 7.2.1.1.2 Maintainability — tests fail when product changes — not framework bugs
- 7.2.1.2 CI/CD integration — tests run in pipeline — fast feedback — block on failure
  - 7.2.1.2.1 Test parallelization — sharding — reduce total suite time
  - 7.2.1.2.2 Flaky test management — quarantine + track + fix — trust the suite
- 7.2.1.3 Performance + load testing — scripts in k6/Gatling — establish baselines
- 7.2.1.4 Contract testing — Pact — consumer-driven — prevent API breakage

---

## 8.0 Design Roles

### 8.1 UX Designer
#### 8.1.1 Core Responsibilities
- 8.1.1.1 User research — interviews + surveys + usability tests — discover real needs
  - 8.1.1.1.1 User interviews — 5 users reveal 85% of usability issues — Nielsen
  - 8.1.1.1.2 Jobs to be Done — what job is user hiring product for — underlying motivation
- 8.1.1.2 Information architecture — structure + navigation — findability + learnability
  - 8.1.1.2.1 Card sorting — users organize content — reveals mental models
  - 8.1.1.2.2 Sitemap + user flows — document structure before wireframes
- 8.1.1.3 Wireframing + prototyping — low fidelity to high fidelity — test before build
  - 8.1.1.3.1 Low-fidelity wireframe — sketches / Balsamiq — fast — cheap to change
  - 8.1.1.3.2 High-fidelity prototype — Figma — interactive — usability test with users
- 8.1.1.4 Usability testing — validate designs — identify friction — iterate
  - 8.1.1.4.1 Think-aloud protocol — user narrates actions — reveals mental model gaps

### 8.2 UI Designer
#### 8.2.1 Core Responsibilities
- 8.2.1.1 Visual design — color, typography, spacing, iconography — brand alignment
  - 8.2.1.1.1 Design system ownership — component library — token-based — consistent UI
  - 8.2.1.1.2 Accessibility — color contrast ratios — WCAG 2.1 AA — inclusive design
- 8.2.1.2 Design handoff — annotated specs — Figma dev mode — measure + inspect

### 8.3 Product Designer
#### 8.3.1 Core Responsibilities
- 8.3.1.1 End-to-end design ownership — research → IA → UX → UI — in one role
  - 8.3.1.1.1 Common in startups — one designer covers full spectrum — generalist
  - 8.3.1.1.2 Embeds in product squad — participates in discovery + sprint — full context
- 8.3.1.2 Collaborates with PM — translates user needs into designed solutions
  - 8.3.1.2.1 Design critique — regular team feedback session — iterative improvement
  - 8.3.1.2.2 Design debt — track technical debt equivalent — advocate for revisits

---

## 9.0 Leadership & Management Roles

### 9.1 Engineering Manager (EM)
#### 9.1.1 Core Responsibilities
- 9.1.1.1 People management — hiring + growth + performance + retention
  - 9.1.1.1.1 1:1s — weekly — relationship + feedback + growth — not status updates
  - 9.1.1.1.2 Performance reviews — calibration + leveling + promotion decisions
  - 9.1.1.1.3 Psychological safety — create environment where team speaks up + takes risk
- 9.1.1.2 Team delivery — project tracking + unblocking + stakeholder management
  - 9.1.1.2.1 EM ≠ tech lead — EM manages people — TL drives technical decisions
  - 9.1.1.2.2 Delegate technical decisions — trust senior ICs — don't be bottleneck
- 9.1.1.3 Hiring — calibrating bar + interviewing + selling role to candidates
  - 9.1.1.3.1 Structured interviews — same questions per role — reduce bias — calibrate
  - 9.1.1.3.2 Candidate experience — fast process + respectful — reflects company culture
- 9.1.1.4 Culture — model values — address behavior mismatches — shape team norms
  - 9.1.1.4.1 Blameless culture — mistakes = learning — not punishment — safety to ship

#### 9.1.2 EM Career Levels
- 9.1.2.1 EM — manages 1 team (5–10 ICs) — first management role
- 9.1.2.2 Senior EM — manages larger team or 2 teams — coaches junior EMs
- 9.1.2.3 Director of Engineering — manages EMs — org-level strategy + hiring

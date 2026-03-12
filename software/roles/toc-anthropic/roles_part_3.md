# Software Company Roles Study Guide - Part 3: Engineering Roles

## 3.0 Engineering Roles

### 3.1 Software Engineer (IC Track)
#### 3.1.1 Core Responsibilities by Level
- 3.1.1.1 L1 / Junior Engineer — guided execution — task-level ownership
  - 3.1.1.1.1 Executes well-defined tasks — asks for help proactively — learns fast
  - 3.1.1.1.2 Output — working code — passes review — meets acceptance criteria
  - 3.1.1.1.3 Growth focus — deepen language + domain — understand codebase
- 3.1.1.2 L2 / Mid-level Engineer — independent execution — story-level ownership
  - 3.1.1.2.1 Breaks down tasks — identifies edge cases — minimal supervision needed
  - 3.1.1.2.2 Code review participation — gives useful feedback — raises quality
  - 3.1.1.2.3 Begins mentoring juniors — pairs effectively — documents decisions
- 3.1.1.3 L3 / Senior Engineer — leads features — technical design — team scope
  - 3.1.1.3.1 Designs solutions — considers maintainability + scalability + tradeoffs
  - 3.1.1.3.2 Drives technical decisions — RFCs — represents team in cross-team discussions
  - 3.1.1.3.3 Multiplies team — unblocks others — improves processes — raises bar
- 3.1.1.4 Staff Engineer — multi-team scope — org-wide technical leadership
  - 3.1.1.4.1 Identifies systemic problems — solves before they impact multiple teams
  - 3.1.1.4.2 Shapes technical strategy — architecture decisions — long-term bets
  - 3.1.1.4.3 No direct reports — influence through writing + pairing + standards
- 3.1.1.5 Principal Engineer — company-wide scope — sets technical direction
  - 3.1.1.5.1 Works with CTO/VPE — translates business goals to tech strategy
  - 3.1.1.5.2 External representation — conferences / papers / OSS / hiring magnet
- 3.1.1.6 Distinguished / Fellow — industry-wide impact — rare — top 0.1%

#### 3.1.2 Universal Engineer Responsibilities
- 3.1.2.1 Code quality — readable + tested + documented — leaves codebase better
  - 3.1.2.1.1 Definition of Done — tests pass + reviewed + deployed + monitored
- 3.1.2.2 On-call participation — operational responsibility — "you build it, you run it"
  - 3.1.2.2.1 Respond to alerts — triage + mitigate + escalate — within SLA
  - 3.1.2.2.2 Post-incident — contribute to postmortem — drive follow-up items
- 3.1.2.3 Estimation — provide honest estimates — communicate uncertainty
  - 3.1.2.3.1 T-shirt sizing — XS/S/M/L/XL — relative not absolute — team calibration
  - 3.1.2.3.2 Story points — abstract complexity — velocity trend over time

---

### 3.2 Frontend Engineer
#### 3.2.1 Responsibilities
- 3.2.1.1 Owns client-side application — browser / native web — user-facing layer
  - 3.2.1.1.1 Implements UI designs — pixel-accurate — responsive — accessible
  - 3.2.1.1.2 State management — client state vs. server state — performance
- 3.2.1.2 Collaborates with UX/UI designers — translates design into code
  - 3.2.1.2.1 Design handoff — Figma review — flag infeasible designs early
  - 3.2.1.2.2 Accessibility — WCAG AA compliance — screen readers — keyboard nav
- 3.2.1.3 Performance ownership — Core Web Vitals — LCP / CLS / INP targets
  - 3.2.1.3.1 Bundle size — code splitting — lazy loading — reduces initial load
  - 3.2.1.3.2 Perceived performance — skeleton screens + optimistic UI — UX quality

---

### 3.3 Backend Engineer
#### 3.3.1 Responsibilities
- 3.3.1.1 Owns server-side logic — APIs, data models, business rules, integrations
  - 3.3.1.1.1 API design — contracts with frontend + external consumers — stability
  - 3.3.1.1.2 Data ownership — schema design — migrations — query performance
- 3.3.1.2 Reliability ownership — error handling + retry + idempotency + observability
  - 3.3.1.2.1 Graceful degradation — handle dependency failures — fallback behavior
  - 3.3.1.2.2 Instrumentation — log + trace + metric every service boundary
- 3.3.1.3 Security responsibilities — input validation + auth + secrets handling
  - 3.3.1.3.1 Never trust client input — validate + sanitize at service boundary
  - 3.3.1.3.2 Principle of least privilege — service accounts — minimal DB permissions

---

### 3.4 Full-Stack Engineer
#### 3.4.1 Responsibilities
- 3.4.1.1 Owns feature end-to-end — UI → API → DB — reduces handoff latency
  - 3.4.1.1.1 Common in startups / small teams — one person ships complete features
  - 3.4.1.1.2 Trade-off — breadth over depth — may lack specialization at scale
- 3.4.1.2 Context switching — frontend one day, backend next — requires discipline
  - 3.4.1.2.1 T-shaped skills — strong in one area — functional in others

---

### 3.5 Mobile Engineer
#### 3.5.1 Responsibilities
- 3.5.1.1 Owns native / cross-platform mobile app — iOS / Android / React Native / Flutter
  - 3.5.1.1.1 App store release — binary size + review process + versioning
  - 3.5.1.1.2 Device fragmentation — test across OS versions + screen sizes
- 3.5.1.2 Offline-first design — local storage + sync — handle network loss gracefully
- 3.5.1.3 Performance on constrained hardware — battery + memory + CPU — optimize

---

### 3.6 Embedded / Firmware Engineer
#### 3.6.1 Responsibilities
- 3.6.1.1 Programs hardware — microcontrollers — real-time constraints — C/C++/Rust
  - 3.6.1.1.1 RTOS — scheduling + interrupts + memory — deterministic behavior required
  - 3.6.1.1.2 Hardware-software interface — register maps — peripheral drivers — HAL
- 3.6.1.2 Over-the-air (OTA) updates — safe rollback — update integrity — critical
  - 3.6.1.2.1 Bricked device risk — staged rollout + health check before commit

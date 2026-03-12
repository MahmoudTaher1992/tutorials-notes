# Software Company Roles Study Guide - Part 1: Company Structure & Team Topologies

## 1.0 Company Structure

### 1.1 Engineering Org Models
#### 1.1.1 Flat Organization
- 1.1.1.1 Minimal hierarchy — few management layers — direct IC-to-leadership access
  - 1.1.1.1.1 Works best — < 50 engineers — high trust — senior-heavy teams
  - 1.1.1.1.2 Breaks down — coordination cost rises — unclear ownership at scale
- 1.1.1.2 Autonomous teams — full ownership — product + infra + on-call per team
  - 1.1.1.2.1 "You build it, you run it" — Werner Vogels principle — accountability
  - 1.1.1.2.2 Risk — duplicated effort — inconsistent standards — platform drift

#### 1.1.2 Spotify Model (Tribes, Squads, Chapters, Guilds)
- 1.1.2.1 Squad — autonomous cross-functional team — PM + engineers + designer
  - 1.1.2.1.1 Squad mission — long-lived — owns a product area — not a project
  - 1.1.2.1.2 Squad size — 6–12 people — cognitive load limit — two-pizza rule
- 1.1.2.2 Tribe — collection of squads — shared mission — < 150 people (Dunbar)
  - 1.1.2.2.1 Tribe lead — coordination — not micromanagement — remove blockers
- 1.1.2.3 Chapter — same discipline across squads — Backend Chapter, QA Chapter
  - 1.1.2.3.1 Chapter lead — line manager — career growth + standards — not delivery
  - 1.1.2.3.2 Dual reporting — squad lead (what to build) + chapter lead (how to grow)
- 1.1.2.4 Guild — community of interest — cross-tribe — informal — opt-in
  - 1.1.2.4.1 Examples — Security Guild, Frontend Guild — share practices + patterns

#### 1.1.3 Functional Organization
- 1.1.3.1 Teams grouped by discipline — Frontend team, Backend team, QA team
  - 1.1.3.1.1 Deep specialization — high expertise — slower cross-functional delivery
  - 1.1.3.1.2 Handoff-heavy — features require coordination across multiple teams
- 1.1.3.2 Project-based assignment — engineers pulled from functions into projects
  - 1.1.3.2.1 Matrix org — functional manager + project manager — dual authority

### 1.2 Team Topologies
#### 1.2.1 Four Fundamental Team Types (Skelton & Pais)
- 1.2.1.1 Stream-aligned team — delivers value to end user — primary team type
  - 1.2.1.1.1 Owns full flow — design → build → test → deploy → operate
  - 1.2.1.1.2 Minimizes dependencies — reduces waiting — fast flow of change
  - 1.2.1.1.3 Cognitive load limit — platform team removes complexity from stream teams
- 1.2.1.2 Platform team — internal product — reduces cognitive load for stream teams
  - 1.2.1.2.1 Self-service APIs — CI/CD platform, observability, developer portal
  - 1.2.1.2.2 Platform is a product — has users (developers) — roadmap + SLOs
  - 1.2.1.2.3 Anti-pattern — gatekeeping platform — creates bottleneck not enabler
- 1.2.1.3 Enabling team — temporary — upskills stream teams — then steps back
  - 1.2.1.3.1 Embeds in stream team — pair programming — knowledge transfer — leaves
  - 1.2.1.3.2 Does not do work for stream team — teaches — avoids dependency
- 1.2.1.4 Complicated subsystem team — specialist knowledge — math / ML / compiler
  - 1.2.1.4.1 Justified when complexity too high for stream team — not default split

#### 1.2.2 Team Interaction Modes
- 1.2.2.1 Collaboration — work closely together — temporary — high bandwidth needed
  - 1.2.2.1.1 Used during discovery — two teams exploring new domain together
- 1.2.2.2 X-as-a-Service — low interaction — consume API / platform — minimal sync
  - 1.2.2.2.1 Platform team delivers toolchain — stream teams self-serve — async
- 1.2.2.3 Facilitating — enabling team helps stream team — finite engagement
  - 1.2.2.3.1 Success criteria — stream team no longer needs help — goal = independence

### 1.3 RACI & Decision-Making
#### 1.3.1 RACI Framework
- 1.3.1.1 Responsible — does the work — one or more people — executes
- 1.3.1.2 Accountable — owns the outcome — one person only — signs off
  - 1.3.1.2.1 Single accountable — avoids diffusion of responsibility
- 1.3.1.3 Consulted — input requested — two-way communication — before decision
- 1.3.1.4 Informed — notified of outcome — one-way — after decision
  - 1.3.1.4.1 Over-informing — too many Informed — notification fatigue — curate

#### 1.3.2 Decision-Making Frameworks
- 1.3.2.1 RFC (Request for Comments) — written proposal — async feedback — documented
  - 1.3.2.1.1 RFC template — problem + proposed solution + alternatives + tradeoffs
  - 1.3.2.1.2 Comment period — typically 1–2 weeks — stakeholders review async
  - 1.3.2.1.3 RFC acceptance — author synthesizes feedback — decision recorded
- 1.3.2.2 ADR (Architecture Decision Record) — capture why — not just what
  - 1.3.2.2.1 Status — proposed / accepted / deprecated / superseded
  - 1.3.2.2.2 Context — forces at play — why this decision was needed now
  - 1.3.2.2.3 Consequences — positive + negative — tradeoffs acknowledged
- 1.3.2.3 DACI — Driver / Approver / Contributor / Informed — variant of RACI
  - 1.3.2.3.1 Driver — owns the process — moves it forward — not always the expert
  - 1.3.2.3.2 Approver — single decision-maker — breaks ties — accountable

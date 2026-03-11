# Engineering Manager Complete Study Guide (Ideal / Angel Method)
## Part 4: Implementations — EM by Context & Stage

> **Ideal mappings** reference sections from Parts 1-3.
> Only features **unique** to each context are expanded here.

---

### Phase 2.1: Startup EM (Series A–B, ~10–50 engineers)

#### Ideal Mappings
- People development → Ideal §3
- Execution → Ideal §4
- Culture building → Ideal §7

#### **Unique: Startup EM Context**

##### ST.1 Scope & Survival Mode
- ST.1.1 Wearing multiple hats — EM + Tech Lead + Recruiter + IC simultaneously
- ST.1.2 Speed over process — ruthless prioritization, acceptable technical debt
- ST.1.3 Founder relationship — direct access, alignment on mission, no bureaucracy
- ST.1.4 Early engineering culture — what you build now becomes "how we do things"
- ST.1.5 No playbook — creating process from scratch, high tolerance for ambiguity
- ST.1.6 Product-market fit phase — teams must pivot quickly, low attachment to code

##### ST.2 Hiring at Startup
- ST.2.1 Generalist hiring — T-shaped engineers who can do multiple things
- ST.2.2 Employer branding from zero — equity narrative, mission story
- ST.2.3 Informal interviews — culture fit weighted heavily, small team impact
- ST.2.4 Equity conversations — vesting schedules, cliff, strike price explanation
- ST.2.5 Early employees become leads — fast track to management/leadership

##### ST.3 Infrastructure & Process
- ST.3.1 Build only what's needed now — no premature platform investment
- ST.3.2 Minimal viable process — lightweight agile, no ceremony overhead
- ST.3.3 Incident response informality — everyone all-hands, no formal rotations yet
- ST.3.4 Technical debt acceptance — strategic shortcuts with written justification

---

### Phase 2.2: Scale-Up EM (Series C–D, ~50–300 engineers)

#### Ideal Mappings
- Team structure → Ideal §2.4
- Technical leadership → Ideal §5
- Stakeholder management → Ideal §6

#### **Unique: Scale-Up EM Context**

##### SU.1 Growing Pains
- SU.1.1 Specialization emerging — generalists become specialists, roles diverge
- SU.1.2 Communication overhead — explicit channels, decision-making frameworks needed
- SU.1.3 Process debt — informal processes break at scale, need formalization
- SU.1.4 Founding team dynamics — original members must evolve or step aside
- SU.1.5 Cross-team coordination — dependencies multiply, platform teams emerge
- SU.1.6 Hiring volume — structured interview loops, consistent bar across teams

##### SU.2 Team Topology Decisions
- SU.2.1 Feature teams vs component teams — choosing based on product complexity
- SU.2.2 Platform team creation — internal developer experience as product
- SU.2.3 Embedded vs centralized specialists — data, security, QA placement
- SU.2.4 Engineering levels standardization — consistent career ladder company-wide

##### SU.3 Technical Scaling
- SU.3.1 Monolith-to-services migration — EM facilitation, ownership model
- SU.3.2 Reliability investment — SLOs, on-call, incident process formalization
- SU.3.3 Developer productivity metrics — DORA, SPACE framework adoption
- SU.3.4 Architecture review board — cross-team consistency, avoiding fragmentation

---

### Phase 2.3: Enterprise EM (500+ engineers, public or late-stage)

#### Ideal Mappings
- Manager of Managers → Ideal §10
- OKRs & goal setting → Ideal §9.2
- Budget management → Ideal §9.1

#### **Unique: Enterprise EM Context**

##### EN.1 Organizational Complexity
- EN.1.1 Matrix org navigation — functional vs product reporting structures
- EN.1.2 Long decision cycles — RFC, ARB, security review, legal review chains
- EN.1.3 Political capital — earned through track record, relationships, alliances
- EN.1.4 Headcount bureaucracy — req approval process, backfill vs new hire distinction
- EN.1.5 Change management at scale — internal comms, town halls, cascade strategy
- EN.1.6 Compliance overhead — SOC 2, ISO 27001, HIPAA, GDPR team impact

##### EN.2 Multi-Team Portfolio Management
- EN.2.1 Program management — coordinating multiple teams toward shared milestone
- EN.2.2 Strategic planning cycles — annual planning, H1/H2 roadmap, quarterly reviews
- EN.2.3 Resource allocation across teams — trade-offs, prioritization at portfolio level
- EN.2.4 Metrics aggregation — team-level vs org-level DORA, quality, productivity

---

### Phase 2.4: Remote / Distributed Team EM

#### Ideal Mappings
- 1:1s → Ideal §3.1
- Team health → Ideal §3.6
- Culture → Ideal §7.1

#### **Unique: Remote EM Context**

##### RM.1 Async-First Operations
- RM.1.1 Async decision-making — RFC-style proposals, Loom videos, written decisions
- RM.1.2 Documentation culture — everything written, findable, updated
- RM.1.3 Timezone-aware scheduling — core overlap hours, rotation for off-hours meetings
- RM.1.4 Communication over-indexing — more explicit, more frequent than in-person
- RM.1.5 Written communication quality — Pyramid Principle, concise Slack culture

##### RM.2 Remote Culture & Connection
- RM.2.1 Virtual team rituals — remote coffee chats, Donut pairings, watercooler channels
- RM.2.2 In-person offsites — quarterly/biannual, relationship building investment
- RM.2.3 Camera norms — guidelines not mandates, flexibility, mental health awareness
- RM.2.4 Recognition in remote — public Slack shoutouts, async appreciation
- RM.2.5 Onboarding remotely — structured buddy program, extra check-in density

##### RM.3 Tools & Tooling
- RM.3.1 Source of truth — one wiki (Notion/Confluence), not split across tools
- RM.3.2 Meeting hygiene — agenda required, record for async, notes in 24h
- RM.3.3 Status visibility — async standups (Geekbot, Range), project boards
- RM.3.4 Virtual whiteboarding — Miro, FigJam for collaborative design sessions

---

### Phase 2.5: EM Anti-Patterns & Failure Modes

#### AP.1 People Anti-Patterns
- AP.1.1 Brilliant jerk tolerance — protecting culture vs retaining high performer
- AP.1.2 Proximity bias — favoring in-office team members over remote
- AP.1.3 Favoritism — unequal opportunity distribution, homophily bias
- AP.1.4 Avoiding hard conversations — conflict avoidance creating festering problems
- AP.1.5 Hero culture — single person rescuing every incident, no team resilience
- AP.1.6 Promotion as reward for IC work — Peter Principle trap, manager vs contributor

#### AP.2 Execution Anti-Patterns
- AP.2.1 Estimation as commitment — treating t-shirt sizes as contracts
- AP.2.2 Velocity as the goal — optimizing story points over business outcomes
- AP.2.3 Death march — known impossible deadline, no pushback, team burned out
- AP.2.4 Scope creep acceptance — inability to say no to new requirements mid-sprint
- AP.2.5 Meeting culture — all decisions in meetings, no async, calendar packed
- AP.2.6 Roadmap theater — detailed roadmap that never reflects reality

#### AP.3 Technical Anti-Patterns
- AP.3.1 Not staying technical enough — losing credibility, poor architectural decisions
- AP.3.2 Over-engineering governance — process that slows down without adding safety
- AP.3.3 Rewarding heroism — celebrating firefighting over prevention
- AP.3.4 Technical debt silence — not surfacing debt to leadership until crisis
- AP.3.5 Ignoring on-call burden — unsustainable rotations, no toil reduction investment

#### AP.4 Strategy Anti-Patterns
- AP.4.1 Bottom-up only — no connection to business objectives
- AP.4.2 Top-down only — disempowered team, no ownership or intrinsic motivation
- AP.4.3 Initiative overload — too many priorities = no real priorities
- AP.4.4 Short-termism — constant feature push, no platform/reliability investment
- AP.4.5 Over-indexing on process — methodology becomes more important than outcomes

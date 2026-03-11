# Product Manager Complete Study Guide (Ideal / Angel Method)
## Part 5: Implementations — PM by Context, Anti-Patterns & Toolkit

> **Ideal mappings** reference sections from Parts 1-4.
> Only features **unique** to each context are expanded here.

---

### Phase 2.1: B2B / Enterprise PM

#### Ideal Mappings
- User research → Ideal §3
- Stakeholder management → Ideal §11
- Business case → Ideal §13.3

#### **Unique: B2B PM Context**

##### B2B.1 Buyer vs User Distinction
- B2B.1.1 Economic buyer — who pays (VP, CFO), driven by ROI, TCO, risk
- B2B.1.2 Technical buyer — who evaluates (IT, security), driven by compliance, integration
- B2B.1.3 End user — who uses daily, driven by ease, efficiency, delight
- B2B.1.4 Champion — internal advocate, PM's most important relationship
- B2B.1.5 Multi-stakeholder research — interview all buyer types separately

##### B2B.2 Enterprise-Specific Product Concerns
- B2B.2.1 SSO/SAML — required for enterprise deals, zero exceptions
- B2B.2.2 Audit logs & admin controls — compliance, IT oversight requirements
- B2B.2.3 Role-based access control (RBAC) — fine-grained permissions for enterprise
- B2B.2.4 Data residency — GDPR, contractual requirements for data location
- B2B.2.5 SLA commitments — uptime guarantees, support tiers, enterprise contracts
- B2B.2.6 Custom integrations — enterprise wants Salesforce, Workday, SAP connectors

##### B2B.3 Sales-Assisted PM Work
- B2B.3.1 Deal-driven features — balancing strategic customers vs roadmap integrity
- B2B.3.2 Customer advisory boards (CABs) — structured customer input forums
- B2B.3.3 RFP responses — PM as technical and functional owner
- B2B.3.4 Professional services — PM scope vs PS scope boundary
- B2B.3.5 Contract negotiation support — pricing, packaging, feature commitment risk

---

### Phase 2.2: B2C / Consumer PM

#### Ideal Mappings
- Growth → Ideal §10
- Experimentation → Ideal §9.3
- Retention → Ideal §10.2

#### **Unique: B2C PM Context**

##### B2C.1 Mass Scale Considerations
- B2C.1.1 Onboarding for zero-context users — no sales rep, no training, just the product
- B2C.1.2 Mobile-first UX — thumb-reach, offline states, notification permissions
- B2C.1.3 Performance as a product feature — load time, jank, battery drain
- B2C.1.4 Accessibility at scale — billions of users means many with disabilities
- B2C.1.5 Localization at scale — 50+ countries, cultural adaptation is a product function

##### B2C.2 Consumer Psychology
- B2C.2.1 Behavioral economics — loss aversion, anchoring, social proof, scarcity
- B2C.2.2 Habit formation — Hooked Model (Nir Eyal), habit stack design
- B2C.2.3 Notification strategy — value-first, permission-based, frequency capping
- B2C.2.4 Viral mechanics — inherent virality vs incentivized referral
- B2C.2.5 Dark patterns awareness — ethical obligation to avoid manipulative UX

##### B2C.3 Consumer Metrics
- B2C.3.1 DAU/MAU stickiness — core health signal for consumer apps
- B2C.3.2 D1/D7/D30 retention — cohort retention curves
- B2C.3.3 Session length & frequency — engagement depth signals
- B2C.3.4 App Store ratings — NPS proxy, keyword signal, review response

---

### Phase 2.3: Growth PM

#### Ideal Mappings
- Growth frameworks → Ideal §10.1
- Experimentation → Ideal §9.3
- Funnel metrics → Ideal §9.4

#### **Unique: Growth PM Context**

##### GP.1 Growth Specialization
- GP.1.1 Growth team structure — cross-functional squad, rapid experimentation mandate
- GP.1.2 Experiment velocity — volume of experiments as a health metric
- GP.1.3 North Star alignment — growth work must move the North Star, not vanity metrics
- GP.1.4 Acquisition channels — SEO, paid, viral, content, partnerships — owned vs rented
- GP.1.5 Activation optimization — reduce steps to aha moment, progressive disclosure
- GP.1.6 Referral loop design — double-sided incentives, share mechanics, virality coefficient

##### GP.2 PLG-Specific Skills
- GP.2.1 Free-to-paid conversion funnel — identify upgrade triggers
- GP.2.2 Product Qualified Leads (PQL) — usage-based signal for sales handoff
- GP.2.3 Expansion revenue — seat expansion, usage expansion, feature upsell
- GP.2.4 Self-serve onboarding design — zero touch, in-product education, progressive reveal

---

### Phase 2.4: Technical PM

#### Ideal Mappings
- Working with engineering → Ideal §7.1
- Platform products → Ideal §14.1
- Technical debt → shared concern

#### **Unique: Technical PM Context**

##### TP.1 Technical Depth
- TP.1.1 API design ownership — endpoint design, versioning strategy, breaking change policy
- TP.1.2 Data pipeline products — schema design, latency SLAs, data quality guarantees
- TP.1.3 Infrastructure cost awareness — cloud spend attribution, FinOps partnership
- TP.1.4 Developer experience (DX) — documentation, SDKs, error messages as product
- TP.1.5 Migration management — deprecation policy, backward compatibility windows
- TP.1.6 Architecture review participation — informed voice in technical decisions

---

### Phase 2.5: PM Anti-Patterns

#### AP.1 Discovery Anti-Patterns
- AP.1.1 Solution before problem — pitching features without validated pain
- AP.1.2 Customer is always right — taking requests at face value, not underlying need
- AP.1.3 Research theater — user research performed but findings never inform decisions
- AP.1.4 Confirmation bias — only interviewing users who agree with your hypothesis
- AP.1.5 Single source of truth — relying only on analytics or only on qualitative research

#### AP.2 Strategy Anti-Patterns
- AP.2.1 Roadmap as feature factory — shipping features without outcome measurement
- AP.2.2 Stakeholder-driven roadmap — loudest voice wins, not data + strategy
- AP.2.3 Death by a thousand features — breadth over depth, no coherent strategy
- AP.2.4 Copying competitors — reactive strategy without own vision
- AP.2.5 Vanity North Star — metric that can be gamed (sign-ups vs activated users)

#### AP.3 Execution Anti-Patterns
- AP.3.1 Waterfall PRD — 30-page spec before any discovery, thrown over the wall
- AP.3.2 Metric without owners — define success metric but no one tracks it post-launch
- AP.3.3 Launch and forget — shipping without monitoring adoption or impact
- AP.3.4 Over-specification — dictating the "how" to engineering, losing creativity
- AP.3.5 Endless discovery — analysis paralysis, never committing to building

#### AP.4 Stakeholder Anti-Patterns
- AP.4.1 HiPPO problem — highest paid person's opinion overrides data
- AP.4.2 Surprise roadmap changes — re-prioritization without communication
- AP.4.3 Saying yes to everything — inability to push back, no trade-off conversations
- AP.4.4 Over-promising to sales — committing to features for deals without feasibility check

---

### Phase 2.6: PM Toolkit Reference

##### Tools by Category
- **Roadmapping** — Productboard, Aha!, Linear, Notion
- **Project tracking** — Jira, Linear, Shortcut, Asana, GitHub Projects
- **Analytics** — Amplitude, Mixpanel, Heap, PostHog, Google Analytics
- **Experimentation** — LaunchDarkly, Optimizely, Split.io, in-house platforms
- **User research** — Dovetail, Maze, UserTesting, Lookback, Hotjar, FullStory
- **Design collaboration** — Figma, FigJam, Miro, Mural
- **Customer feedback** — Intercom, Productboard, Canny, Pendo
- **Survey tools** — Typeform, SurveyMonkey, Delighted (NPS)
- **Documentation** — Notion, Confluence, Coda
- **Communication** — Slack, Loom, Linear update newsletters

##### Frameworks Quick Reference
- **Discovery** — Opportunity Solution Tree, JTBD, Mom Test, Continuous Discovery
- **Strategy** — Value Proposition Canvas, Business Model Canvas, Porter's 5 Forces
- **Prioritization** — RICE, ICE, Kano, MoSCoW, Cost of Delay, WSJF
- **Metrics** — AARRR, HEART, North Star, OKRs, DORA (for platform PMs)
- **Growth** — Growth loops, PLG flywheel, Hooked Model, AARRR funnel
- **Communication** — Pyramid Principle, BLUF, Amazon 6-pager, Story Arc
- **Stakeholders** — Power/Interest Grid, RACI, Disagree & Commit

# CAP Theorem in 60 Seconds: Why Your Database Can't Have It All

**Category**: Backend / Databases
**Difficulty**: Intermediate
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/databases/nosql/general.md` — Part I.B, The CAP Theorem

---

## Introduction
Every distributed database decision you make at scale is secretly a trade-off between consistency and availability — most developers do not know this until a network split exposes it in production. The CAP Theorem explains this constraint in three words and a triangle.

---

## Body

### Key Points to Cover
1. The three guarantees — Consistency (all nodes return the same data), Availability (every request gets a response), Partition Tolerance (the system survives network failures between nodes)
2. The hard rule — Partition Tolerance is non-negotiable in any real distributed system (networks do fail), so you are always choosing between C and A
3. CP systems — banks, payment processors; when a partition occurs the system returns an error rather than risk returning stale data (data correctness over uptime)
4. AP systems — social media feeds, DNS, shopping carts; when a partition occurs the system stays available and serves possibly stale data (uptime over strict correctness)
5. The practical takeaway — there is no "best" database, only the right database for your consistency vs. availability requirements

### Suggested Code Examples / Demos
- A simple visual: triangle with C, A, P at the corners; highlight the CP and AP axes
- Real-world database examples mapped to each side: MongoDB (tunable), Cassandra (AP), etcd (CP)
- No code needed — this is a conceptual Short; a clean animated diagram is ideal

### Common Pitfalls / Misconceptions
- "CAP means I have to sacrifice one of three things" — you always have P, so the real trade-off is just C vs. A
- "My database is ACID so it handles this" — ACID is about transaction guarantees on a single node; CAP is about distributed systems behaviour
- "I can tune this away" — you can tune the degree of consistency (e.g., eventual vs. strong) but not eliminate the trade-off

---

## Conclusion / Footer
Three letters, one triangle, and one rule: in a distributed system during a network partition you choose consistency or availability — not both. Next time you pick a database, ask yourself: what is more damaging to your users, stale data or downtime?

---

## Notes for Production
- Thumbnail idea: a triangle labeled C / A / P with a "pick two" callout
- Follow-up video idea: ACID vs. BASE properties
- Reference: Eric Brewer's original CAP theorem paper
- Related video to mention: NoSQL database types overview

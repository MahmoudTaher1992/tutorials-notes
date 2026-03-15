# Why You Should Never Use `SELECT *` in Production Code

**Category**: Backend / Databases
**Difficulty**: Beginner
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/databases/nosql/general.md` — Part III.B, Query Optimization; general SQL query best practices across notes

---

## Introduction
`SELECT *` is perfectly fine in a query console, but it is a subtle performance and security hazard in application code. It fetches columns you do not need, silently breaks when the schema changes, and can leak sensitive fields into your application layer without anyone noticing.

---

## Body

### Key Points to Cover
1. The over-fetching problem — `SELECT *` fetches every column in the table, including large text fields, blobs, and JSON columns your code never reads; this wastes database I/O, network bandwidth, and application memory on every single request
2. The silent security leak — a new `password_hash` or `internal_notes` column gets added to the `users` table; every existing `SELECT *` query now returns it; if it reaches an API response, it is a data exposure incident
3. The schema change fragility problem — if a column is renamed or reordered, code that relies on positional column access (common in some ORMs and raw query result mapping) silently breaks or maps data to the wrong field
4. Index coverage is wasted — the database cannot use a covering index to answer the query without touching the actual row data if you request all columns; explicit columns enable much faster index-only scans
5. The fix — always name your columns: `SELECT id, title, published_at FROM articles`

### Suggested Code Examples / Demos
- Before: `SELECT * FROM users` returned to an API — show the response accidentally including `password_hash`
- After: `SELECT id, email, display_name, created_at FROM users` — only what the endpoint actually needs
- Show the query plan difference (`EXPLAIN`) between `SELECT *` and a column-explicit query to visualise the index scan benefit

### Common Pitfalls / Misconceptions
- "I use an ORM so this does not apply" — many ORM default query methods generate `SELECT *` unless you explicitly select fields
- "It is fine for internal tools" — internal tools become external tools; build the habit from the start
- "Naming columns is too verbose" — it is a one-time cost that pays dividends in security, performance, and debuggability forever

---

## Conclusion / Footer
`SELECT *` is a convenience that becomes a liability in production. Name your columns explicitly, every time. Viewer challenge: search your codebase for `SELECT *` — pick the first result and replace it with an explicit column list right now.

---

## Notes for Production
- Thumbnail idea: `SELECT *` with a red warning badge, explicit column list with a green shield
- Related video to mention: database indexing explained, SQL query optimisation basics
- Note: this applies equally to SQL and to NoSQL projection operators like MongoDB's `find({})` with no projection

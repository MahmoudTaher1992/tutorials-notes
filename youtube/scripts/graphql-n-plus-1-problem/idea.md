# GraphQL N+1 Problem: Why Your API Is Making 100 Database Calls for 1 Query

**Category**: Backend / GraphQL
**Difficulty**: Intermediate
**Estimated Duration**: 60-90 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/api/graphql/others/00400-apollo-server/00700-resolvers.txt` — resolver chain and performance

---

## Introduction
GraphQL's nested resolver chain is elegant on paper but a performance disaster by default — every nested field triggers its own database query, silently turning one client request into dozens of round trips without a single warning in your logs.

---

## Body

### Key Points to Cover
1. How the resolver chain works — GraphQL resolves the root field first, then recursively resolves each field on the returned objects
2. The N+1 scenario — fetch 10 books: 1 query. Each book then triggers its own author resolver: 10 more queries. Total: 11 queries for what felt like one request
3. Why this is invisible — no single resolver looks wrong; the problem only emerges at runtime under real data volumes
4. The solution concept — DataLoader (batching): instead of firing one DB call per author, collect all author IDs across the batch and fire a single `WHERE id IN (...)` query
5. Name-drop the fix clearly: Facebook's DataLoader library, built-in batching in Apollo Server

### Suggested Code Examples / Demos
- Annotated resolver map showing `Book.author` resolver calling `db.findAuthor(parent.authorId)` — highlight the per-item call
- Console log showing 11 SQL queries firing for 10 books
- One-line contrast: DataLoader batches those 10 calls into a single `SELECT * FROM authors WHERE id IN (1,2,3...)`

### Common Pitfalls / Misconceptions
- "GraphQL is slow" — GraphQL is not inherently slow; unoptimised resolvers are
- Thinking the problem only appears with large datasets — N+1 is visible with as few as 5-10 records in development
- Assuming an ORM handles this automatically — most ORMs do not batch across resolver boundaries

---

## Conclusion / Footer
GraphQL does not cause N+1 — naive resolvers do. The fix is batching with DataLoader. Viewer challenge: open your GraphQL server logs and count how many DB queries fire for a single list query. The number might surprise you.

---

## Notes for Production
- Thumbnail idea: "1 request = 101 DB calls" in large red text
- Related video to mention: GraphQL schema design, Apollo Server context
- Reference: DataLoader GitHub repository by Facebook

# GraphQL's Hidden Performance Killer

**Tone:** Serious / Educational
**Duration:** ~30 seconds

| Sentence | Type |
|----------|------|
| One GraphQL query can silently trigger hundreds of database calls. | Hook |
| This is the N+1 problem — GraphQL's most invisible performance trap. | Title Reveal |
| GraphQL resolves each field separately using its own resolver function. | Introduction |
| Fetch 10 books in one query, then each book resolves its own author. | Body – Point 1 |
| Ten books means eleven database calls for one single client request. | Body – Point 2 |
| DataLoader fixes this by batching all author calls into one SQL query. | Body – Point 3 |
| The problem is not GraphQL — it is unoptimised resolvers. DataLoader solves it. | Conclusion |
| Open your GraphQL server logs and count DB queries per request — check now. | CTA |

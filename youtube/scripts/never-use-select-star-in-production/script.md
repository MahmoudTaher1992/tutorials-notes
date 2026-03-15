# Stop Using SELECT * in Production

**Tone:** Serious / Educational
**Duration:** ~30 seconds

| Sentence | Type |
|----------|------|
| `SELECT *` exposes every new column you add — including sensitive ones. | Hook |
| Here is why `SELECT *` is a silent security and performance risk. | Title Reveal |
| `SELECT *` fetches every column, including ones your code never uses. | Introduction |
| It wastes I/O, network bandwidth, and memory on every single request. | Body – Point 1 |
| Add a `password_hash` column and it silently appears in your API response. | Body – Point 2 |
| Named columns also allow the database to use faster index-only scans. | Body – Point 3 |
| Always name your columns: `SELECT id, email, created_at FROM users`. | Conclusion |
| Search your codebase for `SELECT *` and replace the first result right now. | CTA |

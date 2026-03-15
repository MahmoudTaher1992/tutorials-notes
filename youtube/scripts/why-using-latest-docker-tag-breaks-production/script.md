# Stop Using `:latest` in Production

**Tone:** Serious / Educational
**Duration:** ~30 seconds

| Sentence | Type |
|----------|------|
| Using `:latest` in production is a hidden deployment timebomb. | Hook |
| Here is why the latest Docker tag will break your deployments. | Title Reveal |
| `:latest` is not a version — it is just a default tag name. | Introduction |
| Two engineers pull `:latest` at different times and get different images. | Body – Point 1 |
| When a new image is pushed, the old `:latest` is overwritten forever. | Body – Point 2 |
| You cannot reliably roll back to the previous version using `:latest`. | Body – Point 3 |
| Tag every build with its git SHA or semantic version instead. | Conclusion |
| Open your docker-compose.yml and swap every `:latest` for a pinned tag. | CTA |

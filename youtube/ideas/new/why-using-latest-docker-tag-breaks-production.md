# Why Using the `latest` Docker Tag Will Break Your Production Deployment

**Category**: DevOps
**Difficulty**: Beginner / Intermediate
**Estimated Duration**: 60-90 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/docker/general.md` — Part VI, Image Tagging Best Practices

---

## Introduction
The `:latest` tag feels safe and convenient, but it is not a version — it is just a moving pointer that silently changes every time a new image is pushed. This video reveals why relying on `:latest` is a hidden deployment timebomb and how one-line semantic versioning fixes it permanently.

---

## Body

### Key Points to Cover
1. What `:latest` actually means — it is the tag applied by default when no tag is specified; it is not guaranteed to be the most recent image you expect
2. The production breakage scenario — two engineers on the same team pull `:latest` at different times and get different image versions, causing a "works on my machine" incident in prod
3. Why `:latest` destroys rollback — you cannot reliably roll back to "the previous latest" because that image may have been overwritten
4. The fix: semantic versioning tags (e.g., `myapp:1.4.2`, `myapp:1.4.2-alpine`) tied to a git tag or CI pipeline step
5. Bonus: show the Docker Hub UI or `docker images` output to make the problem visual

### Suggested Code Examples / Demos
- Show a `docker pull myapp:latest` side-by-side on two machines (or two points in time) getting different image IDs via `docker inspect`
- Show a `docker-compose.yml` with `:latest` vs. a pinned version and explain the difference
- One-liner CI example: `docker build -t myapp:$GIT_SHA .`

### Common Pitfalls / Misconceptions
- "`:latest` is always the newest image" — false; it is just a default tag name, nothing enforces recency
- "Only junior devs make this mistake" — production Dockerfiles from large teams often still use `:latest`
- Confusing image tag with image digest — mention `@sha256:...` for true pinning if needed

---

## Conclusion / Footer
The fix is one word: stop using `:latest` in production Dockerfiles and compose files. Tag every build with its git commit SHA or semantic version and your deployments become deterministic and rollback-safe. Challenge for the viewer: open your current `docker-compose.yml` right now — are any services using `:latest`?

---

## Notes for Production
- Thumbnail idea: `:latest` tag with a red warning icon vs. `:1.4.2` with a green checkmark
- Related video to mention: Docker multi-stage builds for image size
- Reference: Docker official docs on image tagging best practices

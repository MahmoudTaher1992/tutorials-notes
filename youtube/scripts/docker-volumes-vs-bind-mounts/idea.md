# Docker Volumes vs. Bind Mounts: Stop Using the Wrong One

**Category**: DevOps / Docker
**Difficulty**: Beginner / Intermediate
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/docker/general.md` — Part IV.A, Managing Data in Docker: Volumes and Bind Mounts

---

## Introduction
Volumes and bind mounts both persist data outside a container's lifecycle, but they are optimised for completely different jobs. Using the wrong one leads to data loss in production, broken hot-reload in development, and permission headaches that are hard to diagnose.

---

## Body

### Key Points to Cover
1. Bind mounts — map a specific directory from your host machine directly into the container; the container sees your actual files in real time; perfect for development hot-reload
2. Volumes — Docker-managed storage that lives in Docker's own area of the filesystem; fully portable, not tied to a specific host path; the right choice for production database data and any persistent state that must survive container and host changes
3. The key difference — bind mounts depend on the host's directory structure (breaks on other machines); volumes are self-contained and portable
4. Permission gotcha with bind mounts — files created inside the container may be owned by `root` on the host, causing headaches when the developer tries to edit them
5. Decision rule in one sentence: development workflow = bind mount for live code reload; production data = volume for portability and safety

### Suggested Code Examples / Demos
- `docker run -v $(pwd)/src:/app/src` — bind mount for dev hot-reload
- `docker run -v myapp-data:/var/lib/postgresql/data` — named volume for a Postgres database
- `docker volume ls` and `docker volume inspect` to show volumes are managed by Docker, not the host path
- `docker-compose.yml` snippet showing both used together in a typical dev setup

### Common Pitfalls / Misconceptions
- Using a bind mount for production database data — if the container is moved to a different host, the bind mount path may not exist or may have different permissions
- Using a volume for development source code — Docker volumes are not designed for live file sync; changes from the host may not reflect instantly depending on the platform
- Thinking `docker volume rm` is safe — it permanently deletes all data in the volume with no confirmation

---

## Conclusion / Footer
Bind mounts are for development speed. Volumes are for production data safety. Never swap them. Check your production `docker-compose.yml` right now — if your database is using a bind mount, that is a data portability risk waiting to happen.

---

## Notes for Production
- Thumbnail idea: two icons — a folder with a "dev" label (bind mount) vs. a Docker whale with a database cylinder (volume)
- Related video to mention: Docker networking, Docker Compose for local development
- Note: on Docker Desktop for Mac/Windows, bind mount file sync can be slower than on Linux — worth mentioning for dev experience context

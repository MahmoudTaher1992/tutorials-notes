# Docker Complete Study Guide (Ideal / Angel Method)
## Part 1: Ideal Container Platform — Foundation & Core

---

### 1. Container Fundamentals

#### 1.1 Theoretical Basis
- 1.1.1 Linux namespaces — process (PID), network (net), mount (mnt), UTS, IPC, user isolation
- 1.1.2 cgroups v1 & v2 — CPU/memory/PID resource limiting and accounting
- 1.1.3 Union filesystems — OverlayFS layered image storage, copy-on-write semantics
- 1.1.4 chroot & pivot_root — filesystem root isolation mechanism
- 1.1.5 Linux capabilities — fine-grained privilege model, replacing setuid binaries
- 1.1.6 Seccomp profiles — syscall filtering, default Docker profile
- 1.1.7 Container vs VM — shared kernel vs hypervisor, tradeoffs (startup, overhead, isolation)
- 1.1.8 OCI standards — runtime spec (runc), image spec, distribution spec

#### 1.2 Container Lifecycle
- 1.2.1 States — created, running, paused, stopped, dead, restarting
- 1.2.2 Start, stop, pause, kill — SIGTERM vs SIGKILL, drain period
- 1.2.3 PID 1 problem — zombie reaping, signal forwarding, tini/dumb-init
- 1.2.4 Graceful shutdown — SIGTERM handler, pre-stop hooks, STOPSIGNAL instruction
- 1.2.5 Restart policies — no, on-failure[:max], always, unless-stopped
- 1.2.6 Exit codes — 0 success, 1 generic error, 125 Docker error, 137 OOM kill (128+9)

---

### 2. Image System

#### 2.1 Image Architecture
- 2.1.1 Layers — immutable, content-addressable SHA256, shared across images
- 2.1.2 Manifest — image config + ordered layer references + platform metadata
- 2.1.3 Image ID vs Digest — local hash vs registry content-addressable digest
- 2.1.4 Tags — mutable pointers, `:latest` anti-pattern, semantic versioning conventions
- 2.1.5 Multi-arch manifest lists — platform-specific images under a single tag
- 2.1.6 OCI image spec — standardized format across runtimes (containerd, CRI-O, Docker)

#### 2.2 Image Building
- 2.2.1 Build context — files sent to daemon, `.dockerignore` best practices
- 2.2.2 Layer caching — invalidation rules, cache-busting strategies (ARG, --no-cache)
- 2.2.3 Multi-stage builds — named stages `AS builder`, copy only artifacts
- 2.2.4 Base image selection — scratch, distroless, alpine, slim, full debian
- 2.2.5 Build arguments (ARG) — build-time vars, not persisted to runtime env
- 2.2.6 BuildKit — parallel stages, secret mounts, SSH mounts, cache mounts

---

### 3. Dockerfile Mastery

#### 3.1 Instructions Reference
- 3.1.1 FROM — base selection, multi-stage `AS <name>`, `FROM scratch`
- 3.1.2 RUN — shell vs exec form, `&&` chaining, heredoc `RUN <<EOF`
- 3.1.3 COPY vs ADD — prefer COPY; ADD only for auto-extract tarballs or URLs
- 3.1.4 CMD vs ENTRYPOINT — default command vs fixed executable, combined pattern
- 3.1.5 ENV — runtime environment variables, persisted in every child layer
- 3.1.6 ARG — build-time only variable, not available at runtime
- 3.1.7 EXPOSE — metadata only, does not publish; use `-p` to publish
- 3.1.8 WORKDIR — set working dir, creates if missing, prefer over `RUN cd`
- 3.1.9 USER — drop root privileges, pair with addgroup/adduser in RUN
- 3.1.10 VOLUME — declare mount points, avoid in production Dockerfiles (use -v at runtime)
- 3.1.11 HEALTHCHECK — cmd, interval, timeout, retries, start-period
- 3.1.12 LABEL — OCI annotations, `org.opencontainers.image.*` standard keys
- 3.1.13 STOPSIGNAL — override default SIGTERM per-container
- 3.1.14 ONBUILD — trigger instructions for downstream child images
- 3.1.15 SHELL — override default `/bin/sh -c` for RUN instructions

#### 3.2 Dockerfile Best Practices
- 3.2.1 Layer ordering — least-to-most-frequently-changed (deps before src)
- 3.2.2 Package manager cleanup — `rm -rf /var/lib/apt/lists/*` in same RUN layer
- 3.2.3 Non-root user — pin UID/GID (e.g., 1001), not name-only
- 3.2.4 Minimal final image — COPY --from=builder, omit build tools from runtime
- 3.2.5 .dockerignore — exclude `.git`, `node_modules`, tests, `.env`, secrets
- 3.2.6 Pin base image versions — use digest (`@sha256:…`) not `:latest`
- 3.2.7 Secret handling — BuildKit `--mount=type=secret`, never ENV or ARG
- 3.2.8 COPY --chown — set ownership atomically at copy time

#### 3.3 Optimization Techniques
- 3.3.1 Minimize layer count — chain RUN with `&&`, heredoc for readability
- 3.3.2 Cache mount (BuildKit) — `--mount=type=cache,target=/root/.npm`
- 3.3.3 Parallel build stages — independent stages resolve concurrently
- 3.3.4 Scratch base — statically compiled Go/Rust binaries, zero OS overhead
- 3.3.5 Distroless base — no shell/pkg manager, minimal CVE surface
- 3.3.6 Image size analysis — `dive` tool, `docker history --no-trunc`

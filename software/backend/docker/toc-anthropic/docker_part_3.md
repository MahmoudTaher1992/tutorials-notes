# Docker Complete Study Guide (Ideal / Angel Method)
## Part 3: Ideal Container Platform — Operations, CI/CD & Advanced Patterns

---

### 7. Resource Management

#### 7.1 CPU & Memory Controls
- 7.1.1 Memory hard limit — `--memory`, OOM killer triggers, container exits with 137
- 7.1.2 Memory soft limit — `--memory-reservation`, hint for scheduling
- 7.1.3 Swap limit — `--memory-swap` (memory + swap total), `-1` for unlimited
- 7.1.4 CPU quota — `--cpus 1.5` (1.5 cores max), `--cpu-period` + `--cpu-quota`
- 7.1.5 CPU shares — `--cpu-shares` relative weight (default 1024), affects contention
- 7.1.6 CPU pinning — `--cpuset-cpus 0,1` bind to specific cores
- 7.1.7 PID limit — `--pids-limit 100` prevents fork bomb DoS
- 7.1.8 I/O limits — `--blkio-weight`, `--device-read-bps`, `--device-write-bps`
- 7.1.9 cgroup v2 — unified hierarchy, PSI (pressure stall info) metrics

---

### 8. Observability

#### 8.1 Logging
- 8.1.1 Log drivers — json-file (default), syslog, journald, fluentd, awslogs, gelf, splunk, none
- 8.1.2 Log rotation — `--log-opt max-size=10m --log-opt max-file=3`
- 8.1.3 Structured logging — JSON output, key-value pairs, log level fields
- 8.1.4 Log aggregation — ELK/OpenSearch, Loki+Grafana, CloudWatch, Datadog
- 8.1.5 Streaming — `docker logs -f --since 1h --tail 100`
- 8.1.6 Daemon logs — `/var/log/docker.log` or journald (`journalctl -u docker`)

#### 8.2 Metrics
- 8.2.1 Built-in stats — `docker stats` — CPU%, mem, net I/O, block I/O, PIDs
- 8.2.2 cAdvisor — per-container Prometheus metrics exporter (CPU, mem, net, disk)
- 8.2.3 Prometheus integration — `/metrics` endpoint, scrape config
- 8.2.4 Grafana dashboards — container dashboards, alerting rules
- 8.2.5 Docker daemon metrics — `--metrics-addr 127.0.0.1:9323 --experimental`

#### 8.3 Health Checking
- 8.3.1 HEALTHCHECK instruction — `CMD`, `interval`, `timeout`, `retries`, `start-period`
- 8.3.2 Health states — starting → healthy / unhealthy
- 8.3.3 Orchestrator integration — Swarm replaces unhealthy tasks, K8s liveness/readiness
- 8.3.4 External probing — uptime monitors, synthetic transactions, blackbox_exporter

---

### 9. Registry & Distribution

#### 9.1 Registry Concepts
- 9.1.1 Registry hierarchy — registry / repository / tag / digest
- 9.1.2 OCI Distribution Spec — standard `/v2/` API, pull, push, catalog
- 9.1.3 Authentication — token auth (Bearer), service account credentials, `docker login`
- 9.1.4 Pull-through cache — proxy/mirror registry for airgapped environments
- 9.1.5 Image promotion workflow — immutable dev digest → tag staging → tag prod
- 9.1.6 Retention policies — auto-prune untagged manifests, lifecycle rules

#### 9.2 Registry Options
- 9.2.1 Docker Hub — public/private repos, rate limits (100/6h anon, 200/6h free)
- 9.2.2 AWS ECR — IAM-based auth, lifecycle policies, cross-region replication, scanning
- 9.2.3 GCP Artifact Registry — multi-format (Docker, npm, Maven), VPC-SC
- 9.2.4 Azure ACR — geo-replication, ACR Tasks, managed identities
- 9.2.5 GitHub Container Registry (ghcr.io) — GitHub Actions integration, package permissions
- 9.2.6 Self-hosted Harbor — RBAC, vulnerability scanning, replication, Helm chart registry

---

### 10. CI/CD Integration

#### 10.1 Build Strategies
- 10.1.1 Docker-in-Docker (DinD) — privileged sidecar, socket mounting risks
- 10.1.2 Kaniko — rootless in-cluster builds, no daemon required
- 10.1.3 Buildah — OCI-compliant, rootless, scriptable without daemon
- 10.1.4 GitHub Actions — `docker/build-push-action`, QEMU for multi-arch
- 10.1.5 Registry cache — `--cache-from` / `--cache-to` in CI
- 10.1.6 Tagging strategy — commit SHA (immutable), branch (mutable), semver, latest

#### 10.2 Deployment Patterns
- 10.2.1 Blue-green — two identical envs, atomic traffic switch, instant rollback
- 10.2.2 Canary — incremental traffic shift (5% → 25% → 100%), metrics gate
- 10.2.3 Rolling update — replace containers one-by-one, zero-downtime
- 10.2.4 Immutable infrastructure — never mutate running containers, replace entirely
- 10.2.5 GitOps — declarative state in Git, reconciliation loop (ArgoCD, Flux)
- 10.2.6 Health gate — deployment blocked until health checks pass

---

### 11. Advanced Patterns

#### 11.1 Multi-Platform Builds
- 11.1.1 QEMU emulation — `binfmt_misc`, cross-arch builds (slow but simple)
- 11.1.2 Cross-compilation — native toolchain targeting different arch (fast)
- 11.1.3 `docker buildx` — multi-platform builder, `--platform linux/amd64,linux/arm64`
- 11.1.4 Manifest lists — push multiple platform images under single tag

#### 11.2 Development Workflow
- 11.2.1 Bind mount source — live reload without rebuild (dev only)
- 11.2.2 Dev containers (VS Code) — full dev environment in container, `.devcontainer/`
- 11.2.3 `docker exec` — interactive debugging, `--user root` override
- 11.2.4 `docker cp` — copy files in/out without bind mount
- 11.2.5 `nsenter` — enter namespaces without shell in container
- 11.2.6 Debug sidecar — inject busybox/debug image into pod/container namespace

#### 11.3 Anti-Patterns
- 11.3.1 Running as root — escalation risk, fail PodSecurityStandards
- 11.3.2 `:latest` tag in production — unpredictable drift, debugging nightmare
- 11.3.3 Secrets in ENV/ARG — visible via `docker inspect`, `docker history`
- 11.3.4 Fat images with dev tools — bloat + attack surface increase
- 11.3.5 Entrypoint as shell script without `exec` — PID 1 doesn't receive signals
- 11.3.6 Single Dockerfile for all environments — use build targets or ARG
- 11.3.7 No resource limits — OOM kills, noisy neighbor, cluster instability
- 11.3.8 `--privileged` unnecessarily — grants full host kernel access
- 11.3.9 Hardcoded config in image — couples image to environment, use env/configmap
- 11.3.10 Missing `.dockerignore` — large context sent to daemon, secrets leaked

---

### 12. Debugging & Production Readiness

#### 12.1 Debugging Commands
- 12.1.1 `docker inspect` — full JSON config, state, networking, mounts
- 12.1.2 `docker diff` — filesystem changes since container start
- 12.1.3 `docker logs` — stdout/stderr, with `--since`, `--until`, `--tail`
- 12.1.4 `docker events` — real-time daemon event stream
- 12.1.5 `docker top` — running processes inside container
- 12.1.6 `docker stats` — live resource usage

#### 12.2 Common Issues
- 12.2.1 Permission denied — UID/GID mismatch on bind mount, fix with `--user` or chown
- 12.2.2 Immediate exit — foreground process missing, bad CMD, app crash on start
- 12.2.3 Cannot reach service — wrong network, port not published, firewall
- 12.2.4 OOM kill — memory limit too low, exit 137, check `docker inspect .HostConfig.Memory`
- 12.2.5 Pull rate limit — Docker Hub 429, use mirror or authenticated pull
- 12.2.6 Disk pressure — `docker system prune -a`, log rotation missing
- 12.2.7 Layer cache miss unexpectedly — COPY ordering, context files changed

#### 12.3 Production Readiness Checklist
- 12.3.1 Non-root USER with pinned UID
- 12.3.2 Memory + CPU limits set
- 12.3.3 HEALTHCHECK defined with appropriate timing
- 12.3.4 `--read-only` with tmpfs for writable paths
- 12.3.5 Secrets via secrets manager, not baked in image
- 12.3.6 Base image pinned to digest, scanned for CVEs
- 12.3.7 Log driver with rotation configured
- 12.3.8 Restart policy set (`unless-stopped` or `on-failure`)
- 12.3.9 Graceful shutdown handled (SIGTERM → exec form ENTRYPOINT)
- 12.3.10 `.dockerignore` excludes sensitive files and build artifacts

# DevOps Engineering Study Guide - Part 2: Phase 1 — CI/CD Pipelines

## 2.0 CI/CD Pipelines

### 2.1 Pipeline Architecture & Stages
#### 2.1.1 Pipeline Anatomy
- 2.1.1.1 Trigger — push, PR, schedule, manual, webhook — entry point
  - 2.1.1.1.1 Push trigger — branch filter — regex — only relevant paths
  - 2.1.1.1.2 Path filter — run only if src/ changed — skip docs-only commits
- 2.1.1.2 Stage — logical grouping of jobs — sequential or parallel
  - 2.1.1.2.1 Fan-out — parallel jobs — reduce total wall time
  - 2.1.1.2.2 Fan-in — join after parallel — aggregate results — block on all
- 2.1.1.3 Job — unit of execution — runs in isolated environment (runner/agent)
  - 2.1.1.3.1 Job isolation — clean workspace — Docker container or VM per job
  - 2.1.1.3.2 Service containers — DB/cache alongside job — integration tests
- 2.1.1.4 Step / Task — single command or action — within a job
  - 2.1.1.4.1 Reusable actions — abstraction — composite or Docker actions
- 2.1.1.5 Workspace / Artifact passing — share data between jobs
  - 2.1.1.5.1 Upload artifact — zip + store — download in later job
  - 2.1.1.5.2 Cache — dependency cache — restore before build — save after

#### 2.1.2 Pipeline Patterns
- 2.1.2.1 Pipeline as code — YAML in repo — version-controlled — peer-reviewed
  - 2.1.2.1.1 DRY pipelines — reusable workflow templates — shared library
  - 2.1.2.1.2 Matrix builds — test multiple OS/runtime combos — single job def
- 2.1.2.2 Monorepo pipelines — affected-only builds — change detection
  - 2.1.2.2.1 nx affected / Turborepo — dependency graph — build what changed
  - 2.1.2.2.2 Path-based triggers — job per service — independent deploy
- 2.1.2.3 Environment gates — promote artifacts through dev → staging → prod
  - 2.1.2.3.1 Artifact immutability — same artifact deployed to all envs — tag once

### 2.2 Build Systems & Artifact Production
#### 2.2.1 Build Caching
- 2.2.1.1 Layer caching — Docker BuildKit — content-addressed — reuse unchanged
  - 2.2.1.1.1 Cache mount — RUN --mount=type=cache — persist across builds
  - 2.2.1.1.2 Remote cache — push cache to registry — share across CI runners
- 2.2.1.2 Dependency caching — node_modules / .m2 / pip cache — restore by lockfile hash
  - 2.2.1.2.1 Cache key — hash(lockfile) — invalidate on dependency change only
  - 2.2.1.2.2 Fallback key — partial restore + install delta — faster than clean install

#### 2.2.2 Artifact Versioning
- 2.2.2.1 Semantic versioning — MAJOR.MINOR.PATCH — machine-readable
  - 2.2.2.1.1 Pre-release — 1.2.0-alpha.1 — distinguish from stable
  - 2.2.2.1.2 Build metadata — 1.2.0+20240301 — informational — not for ordering
- 2.2.2.2 Git-based versioning — gitversion / semantic-release — auto-bump from commits
  - 2.2.2.2.1 Conventional commits → automatic CHANGELOG + version bump
  - 2.2.2.2.2 git describe — tag + commit count + hash — unique per build

### 2.3 Testing in Pipelines
#### 2.3.1 Test Pyramid
- 2.3.1.1 Unit tests — isolated — fast — < 1ms per test — no I/O
  - 2.3.1.1.1 Mock/stub external deps — test logic only — deterministic
  - 2.3.1.1.2 Code coverage — line/branch/mutation — minimum threshold gate
- 2.3.1.2 Integration tests — real dependencies — DB + queue — Docker Compose
  - 2.3.1.2.1 Testcontainers — spin up real DB in test — no mock divergence
  - 2.3.1.2.2 Contract tests — Pact — consumer-driven — prevent API breakage
- 2.3.1.3 End-to-end tests — full stack — browser or API — slowest — least stable
  - 2.3.1.3.1 Smoke suite — critical paths only — run on every deploy — fast gate
  - 2.3.1.3.2 Full regression — nightly — not blocking PRs — separate pipeline

#### 2.3.2 Performance Testing in CI
- 2.3.2.1 Load testing — k6 / Locust / Gatling — baseline regression
  - 2.3.2.1.1 Performance budget — p95 < 200ms threshold — fail pipeline if exceeded
  - 2.3.2.1.2 Trend analysis — compare to prior run — detect gradual degradation

### 2.4 Deployment Strategies
#### 2.4.1 Blue/Green Deployment
- 2.4.1.1 Two identical environments — route traffic to green — blue idle standby
  - 2.4.1.1.1 DNS / LB switch — instant cutover — < 1 second transition
  - 2.4.1.1.2 Rollback — switch LB back to blue — sub-second — no rebuild
- 2.4.1.2 Database compatibility — both versions must handle same schema
  - 2.4.1.2.1 Expand-contract migration — add nullable column first — backward compat

#### 2.4.2 Canary Deployment
- 2.4.2.1 Traffic splitting — 1% → 10% → 50% → 100% — gradual rollout
  - 2.4.2.1.1 Weighted routing — LB rule / service mesh — percentage-based
  - 2.4.2.1.2 User segmentation — header/cookie-based — target beta users
- 2.4.2.2 Automated canary analysis — error rate + latency vs. baseline
  - 2.4.2.2.1 Rollback trigger — error rate > threshold — auto revert — no human
  - 2.4.2.2.2 Observation window — 10-30 minutes at each % — time-gated

#### 2.4.3 Rolling Deployment
- 2.4.3.1 Replace pods/instances in batches — maxSurge + maxUnavailable
  - 2.4.3.1.1 maxUnavailable: 0 — never reduce capacity — slower but safer
  - 2.4.3.1.2 maxSurge: 1 — one extra pod at a time — resource headroom needed
- 2.4.3.2 Readiness gate — new pod ready before old removed — no traffic loss
  - 2.4.3.2.1 readinessProbe — HTTP 200 — must pass before traffic routed

#### 2.4.4 Feature Flags
- 2.4.4.1 Runtime toggle — decouple deploy from release — dark launch
  - 2.4.4.1.1 LaunchDarkly / Unleash / Flagsmith — flag evaluation — SDK
  - 2.4.4.1.2 Percentage rollout — gradual enable — cohort by user ID hash
  - 2.4.4.1.3 Kill switch — instant disable — no deploy needed — production safety

### 2.5 Pipeline Security & Supply Chain
#### 2.5.1 Secrets in CI/CD
- 2.5.1.1 Secrets storage — CI secrets store / Vault — never in repo
  - 2.5.1.1.1 Masked secrets — CI log redaction — prevent leak via echo
  - 2.5.1.1.2 Short-lived credentials — OIDC federation — no static secret
  - 2.5.1.1.3 OIDC in CI — GitHub Actions → AWS/GCP/Azure — keyless auth
- 2.5.1.2 Least privilege runner — minimal IAM permissions — scoped per pipeline

#### 2.5.2 SLSA & Supply Chain
- 2.5.2.1 SLSA framework — levels 1-4 — provenance + integrity — build hardening
  - 2.5.2.1.1 SLSA Level 1 — provenance generated — scripted build
  - 2.5.2.1.2 SLSA Level 2 — hosted build service — signed provenance
  - 2.5.2.1.3 SLSA Level 3 — hardened build — no secret access — isolated
- 2.5.2.2 SBOM — Software Bill of Materials — list all dependencies + versions
  - 2.5.2.2.1 SPDX / CycloneDX formats — attach to release — vulnerability tracking
- 2.5.2.3 Artifact signing — Cosign / Notary — sign image after build — verify at deploy
  - 2.5.2.3.1 Keyless signing — Sigstore / Fulcio — OIDC identity as signing key
  - 2.5.2.3.2 Rekor transparency log — append-only — tamper-evident — public audit

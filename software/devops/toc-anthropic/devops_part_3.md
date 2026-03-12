# DevOps Engineering Study Guide - Part 3: Phase 1 — Containerization

## 3.0 Containerization

### 3.1 Container Internals
#### 3.1.1 Linux Namespaces
- 3.1.1.1 Namespaces — kernel isolation primitive — 8 types
  - 3.1.1.1.1 PID namespace — isolated PID 1 — process tree isolation
  - 3.1.1.1.2 NET namespace — separate network stack — veth pair bridges container
  - 3.1.1.1.3 MNT namespace — isolated filesystem view — bind mounts
  - 3.1.1.1.4 UTS namespace — separate hostname — independent identity
  - 3.1.1.1.5 IPC namespace — isolated SysV IPC + POSIX MQ — shared mem isolation
  - 3.1.1.1.6 USER namespace — UID/GID remapping — rootless containers
  - 3.1.1.1.7 Cgroup namespace — isolate cgroup view — hides host hierarchy
  - 3.1.1.1.8 Time namespace — independent clock offsets — container snapshot restore

#### 3.1.2 Control Groups (cgroups)
- 3.1.2.1 cgroups v1 — per-subsystem hierarchy — fragmented — legacy
  - 3.1.2.1.1 CPU subsystem — cpu.shares — relative weight — CFS scheduler
  - 3.1.2.1.2 Memory subsystem — memory.limit_in_bytes — OOM kill on exceed
  - 3.1.2.1.3 blkio subsystem — block I/O throttle — weight + limits
- 3.1.2.2 cgroups v2 — unified hierarchy — single tree — all controllers
  - 3.1.2.2.1 cpu.max — absolute CPU quota — 100000 200000 = 50% of one core
  - 3.1.2.2.2 memory.max — hard limit — memory.high — soft limit + reclaim
  - 3.1.2.2.3 Pressure stall info (PSI) — cpu/mem/io pressure — monitoring hooks

#### 3.1.3 Union Filesystems & Layers
- 3.1.3.1 OverlayFS — default Linux — lowerdir + upperdir + workdir + merged
  - 3.1.3.1.1 Layer sharing — multiple containers share read-only layers — disk efficient
  - 3.1.3.1.2 Copy-on-write — first write copies file to upperdir — original intact
  - 3.1.3.1.3 Whiteout files — .wh.filename — mark deletion in upper layer
- 3.1.3.2 Layer caching — content-addressed — unchanged layer = same hash = reuse
  - 3.1.3.2.1 Cache invalidation — any change invalidates all subsequent layers
  - 3.1.3.2.2 Layer ordering — rarely changing layers first — maximize cache hits

### 3.2 Image Building & Optimization
#### 3.2.1 Dockerfile Best Practices
- 3.2.1.1 Multi-stage builds — build stage → runtime stage — discard build deps
  - 3.2.1.1.1 Builder stage — full SDK — compile — large image OK
  - 3.2.1.1.2 Runtime stage — distroless / alpine — copy binary only — minimal
  - 3.2.1.1.3 COPY --from=builder — selective copy — not entire filesystem
- 3.2.1.2 Layer optimization — group related RUN commands — reduce layer count
  - 3.2.1.2.1 apt-get install — single RUN — apt-get clean && rm -rf /var/lib/apt
  - 3.2.1.2.2 COPY requirements.txt before COPY . — cache pip install layer
- 3.2.1.3 Base image selection — distroless > alpine > debian-slim > debian
  - 3.2.1.3.1 Distroless — no shell — no package manager — minimal attack surface
  - 3.2.1.3.2 Alpine — musl libc — 5MB — may cause compatibility issues
  - 3.2.1.3.3 Scratch — empty — static binaries only — Go / Rust ideal

#### 3.2.2 BuildKit Features
- 3.2.2.1 BuildKit — parallel stage execution — improved caching — secrets handling
  - 3.2.2.1.1 --mount=type=secret — inject secret at build — not in layer
  - 3.2.2.1.2 --mount=type=cache — persist cache dirs — npm/pip across builds
  - 3.2.2.1.3 --mount=type=ssh — forward SSH agent — private git repos
- 3.2.2.2 Build attestations — SBOM + provenance — attached to image manifest
  - 3.2.2.2.1 docker buildx build --sbom=true --provenance=true — inline attestation

#### 3.2.3 Image Size & Security
- 3.2.3.1 .dockerignore — exclude .git / node_modules / test files — reduce context
  - 3.2.3.1.1 Large context — slows build — network transfer to daemon
- 3.2.3.2 Non-root user — USER directive — drop privileges — least privilege
  - 3.2.3.2.1 UID 65534 (nobody) — safest default — no home directory
  - 3.2.3.2.2 Rootless runtime — user namespace — no setuid binaries needed

### 3.3 Container Runtime
#### 3.3.1 Runtime Architecture (OCI)
- 3.3.1.1 OCI Runtime Spec — standard — runc implements — container lifecycle
  - 3.3.1.1.1 runc — reference implementation — create/start/kill/delete
  - 3.3.1.1.2 crun — C implementation — faster start — lower memory — Red Hat
  - 3.3.1.1.3 gVisor (runsc) — userspace kernel — syscall interception — isolation
  - 3.3.1.1.4 Kata Containers — micro-VM — hardware isolation — strongest security
- 3.3.1.2 OCI Image Spec — manifest + config + layers — content-addressable
  - 3.3.1.2.1 Image manifest — JSON — references config + layer blobs
  - 3.3.1.2.2 Image index — multi-arch — maps platform to manifest

#### 3.3.2 High-Level Runtimes
- 3.3.2.1 containerd — daemon — pulls images, manages snapshots, calls runc
  - 3.3.2.1.1 containerd snapshotter — overlay / native / zfs — pluggable
  - 3.3.2.1.2 CRI plugin — implements Kubernetes CRI — k8s uses containerd
- 3.3.2.2 CRI-O — lightweight — K8s-only — no Docker dependency
  - 3.3.2.2.1 OpenShift default — pinned versions — security hardened

### 3.4 Container Security
#### 3.4.1 Capabilities
- 3.4.1.1 Linux capabilities — fine-grained root powers — drop all, add needed
  - 3.4.1.1.1 CAP_NET_BIND_SERVICE — bind ports < 1024 — vs. run as root
  - 3.4.1.1.2 Default dropped — CAP_SYS_ADMIN — prevents host escape vectors
  - 3.4.1.1.3 securityContext.capabilities.drop: ["ALL"] — K8s pod spec pattern

#### 3.4.2 Seccomp & AppArmor
- 3.4.2.1 Seccomp — filter syscalls — block ptrace/mount — Docker default profile
  - 3.4.2.1.1 Custom seccomp JSON — allowlist syscalls — minimal surface
  - 3.4.2.1.2 Audit mode — log blocked calls — build profile iteratively
- 3.4.2.2 AppArmor — MAC policy — restrict file/network access per container
  - 3.4.2.2.1 docker-default profile — blocks raw sockets + /proc writes

#### 3.4.3 Image Vulnerability Management
- 3.4.3.1 Scan on push — Trivy / Grype / Snyk — block critical CVEs
  - 3.4.3.1.1 CVSS threshold — block CRITICAL — warn HIGH — ignore LOW
  - 3.4.3.1.2 Fixed-version check — ignore unfixed — actionable only
- 3.4.3.2 Base image update — rebuild on upstream patch — automated PR
  - 3.4.3.2.1 Renovate Bot — open PR on base image tag change — merge gate

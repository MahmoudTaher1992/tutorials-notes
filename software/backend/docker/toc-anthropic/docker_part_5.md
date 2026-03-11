# Docker Complete Study Guide (Ideal / Angel Method)
## Part 5: Implementation — Docker Swarm, BuildKit & Alternative Runtimes

> **Ideal mappings** reference sections from Parts 1-3.
> Only features **unique** to each implementation are expanded here.

---

### Phase 2.2: Docker Swarm

#### Ideal Mappings (not repeated)
- Overlay networking → Ideal §4.1.4, §4.4.4
- Health checks → Ideal §8.3
- Rolling updates → Ideal §10.2.3
- Registry authentication → Ideal §9.1.3
- Secrets management → Ideal §6.3.6

---

#### **Unique: Swarm Mode**

##### SW.1 Cluster Architecture
- SW.1.1 Manager nodes — Raft consensus log, leader election, quorum = `floor(N/2)+1`
- SW.1.2 Worker nodes — task execution only, no cluster state, pull work from managers
- SW.1.3 Manager as worker — `--availability drain` removes from scheduling
- SW.1.4 Join tokens — separate manager/worker tokens, `docker swarm join-token rotate`
- SW.1.5 Node labels — `docker node update --label-add` for placement targeting
- SW.1.6 Auto-TLS — mTLS between all nodes, 90-day cert rotation, custom CA support
- SW.1.7 Raft snapshots — periodic state snapshots, `--snapshot-interval`, recovery

##### SW.2 Services & Tasks
- SW.2.1 Services — desired state declarations (vs imperative containers)
- SW.2.2 Replicated mode — N replica tasks spread across nodes
- SW.2.3 Global mode — exactly one task per node (node agents, monitoring)
- SW.2.4 Tasks — atomic scheduled units, immutable, replaced on failure
- SW.2.5 VIP load balancing — virtual IP for service, IPVS round-robin
- SW.2.6 DNSRR mode — DNS round-robin instead of VIP, client-side balancing
- SW.2.7 Rollback — `docker service rollback`, auto-rollback on failure threshold

##### SW.3 Stacks (Compose in Swarm)
- SW.3.1 `docker stack deploy -c compose.yml <name>` — deploy Compose file to Swarm
- SW.3.2 `deploy` key — `replicas`, `update_config`, `rollback_config`, `resources`, `placement`
- SW.3.3 `update_config` — `parallelism`, `delay`, `failure_action` (pause/continue/rollback), `order`
- SW.3.4 `rollback_config` — same options, applies during rollback
- SW.3.5 `placement.constraints` — `node.role==worker`, `node.labels.gpu==true`
- SW.3.6 `placement.preferences` — spread strategy (`spread: node.labels.zone`)

##### SW.4 Secrets & Configs in Swarm
- SW.4.1 Encrypted secrets — stored in Raft, AES-256-GCM at rest, tmpfs in container
- SW.4.2 Secret rotation — create new → `docker service update --secret-add` → remove old
- SW.4.3 Configs — non-sensitive file distribution, stored in Raft, immutable after create
- SW.4.4 Secret/config ownership — `uid`, `gid`, `mode` on mount

##### SW.5 Swarm Networking
- SW.5.1 Ingress overlay network — built-in, handles published port routing mesh
- SW.5.2 Routing mesh (IPVS) — any node receives traffic for any service replica
- SW.5.3 Host mode ports — `mode: host` bypasses routing mesh, binds to specific node
- SW.5.4 Custom overlay networks — per-stack, encrypted option, attachable flag

---

### Phase 2.3: BuildKit & Buildx

#### **Unique: BuildKit Features**
- BK.1 Parallel stage execution — DAG-based build graph, independent stages run concurrently
- BK.2 Cache mounts — `--mount=type=cache,target=/root/.cache/pip` persists across builds
- BK.3 Secret mounts — `--mount=type=secret,id=npmrc` never written to layer
- BK.4 SSH mounts — `--mount=type=ssh` for private Git repos during build
- BK.5 Inline cache — `--cache-to=type=inline` embeds metadata in image
- BK.6 Registry cache — `--cache-to=type=registry,ref=<image>` shared CI cache
- BK.7 Bake — `docker buildx bake` HCL/JSON matrix for multi-target builds
- BK.8 Provenance attestations — SLSA L1/L2/L3, `--provenance=true`, `--sbom=true`
- BK.9 Dockerfile heredoc — `RUN <<EOF` multi-line without extra layers

#### **Unique: Buildx**
- BX.1 Builder instances — `docker buildx create`, multiple backends
- BX.2 Backends — `docker` (default), `docker-container` (full BuildKit), `kubernetes`
- BX.3 Multi-platform builds — `--platform linux/amd64,linux/arm64,linux/arm/v7`
- BX.4 Remote builders — cloud build workers (Depot, Namespace)
- BX.5 `--push` — build and push in one step
- BX.6 `--load` — load single-platform result into local daemon

---

### Phase 2.4: Podman (Alternative Runtime)

#### Ideal Mappings
- Docker-compatible CLI — Ideal §1-12 (most commands work as-is)
- Image building — Ideal §2.2, §3 (Buildah backend)
- Networking — Ideal §4 (Netavark/CNI)

#### **Unique: Podman Features**
- PM.1 Daemonless — no central daemon, fork+exec directly to runc/crun
- PM.2 Rootless by default — user namespaces, UID mapping, no root required
- PM.3 Pods — group containers sharing namespaces (net, IPC), Kubernetes-inspired
- PM.4 Quadlets — systemd `.container` / `.pod` unit files, `podman generate systemd`
- PM.5 Podman Compose — Compose Spec compatible, daemonless
- PM.6 `podman generate kube` — export running pod to Kubernetes YAML
- PM.7 `podman play kube` — run Kubernetes YAML locally without K8s
- PM.8 Socket activation — drop-in `docker.sock` replacement (`podman.socket`)
- PM.9 Netavark + aardvark-dns — Rust-based network stack replacing CNI plugins
- PM.10 `podman machine` — lightweight VM for macOS/Windows (like Docker Desktop)

---

### Phase 2.5: containerd & Low-Level Tools

#### **Unique: containerd**
- CT.1 Industry standard CRI — Kubernetes default runtime via CRI plugin
- CT.2 `ctr` CLI — low-level containerd client (not user-friendly, debugging only)
- CT.3 `nerdctl` — Docker-compatible CLI for containerd
- CT.4 Snapshotter — overlayfs, devmapper, zfs, native (macOS)
- CT.5 Content store — content-addressable blobs, shared across namespaces
- CT.6 Namespaces — isolation between Docker, Kubernetes, standalone usage

#### **Unique: Skopeo**
- SK.1 Registry operations without daemon — copy, inspect, delete, sync
- SK.2 Cross-registry image copy — ECR → GCR without pulling locally
- SK.3 Image inspection without pull — `skopeo inspect docker://image`
- SK.4 Multi-arch manifest operations — sync entire manifest lists

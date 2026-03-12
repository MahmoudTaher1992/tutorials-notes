# DevOps Engineering Study Guide - Part 12: Phase 2 — Docker & Kubernetes/Helm

## 16.0 Docker

### 16.1 Docker Engine
→ See Ideal §3.1 Container Internals, §3.2 Image Building, §3.3 Container Runtime

#### 16.1.1 Docker Engine-Unique Features
- **Unique: Docker Desktop** — Mac/Windows VM — LinuxKit — dev-local K8s
  - 16.1.1.1 Dev tunnel — expose local service — docker dev environments — share
- **Unique: Docker BuildKit** — parallel builds — cache mounts — secrets at build
  - 16.1.1.2 docker buildx build — multi-platform — --platform linux/amd64,arm64
  - 16.1.1.3 Build cache export — --cache-to=type=registry — share cache across CI
  - 16.1.1.4 Bake — docker buildx bake — HCL/JSON — multi-target parallel builds
- **Unique: Docker Compose** — multi-container local dev — service dependencies
  - 16.1.1.5 depends_on + healthcheck — wait for DB ready — not just container start
  - 16.1.1.6 Compose profiles — selectively start services — dev vs. test subsets
  - 16.1.1.7 Compose watch — file sync + rebuild on change — dev inner loop
  - 16.1.1.8 Override files — compose.override.yml — local dev overrides — not committed
- **Unique: Docker Scout** — vulnerability + SBOM + policy — integrated in Docker Hub
  - 16.1.1.9 Policy evaluation — block non-compliant images — CI gate
- **Unique: Docker contexts** — manage multiple Docker endpoints — remote daemons
  - 16.1.1.10 docker context use — switch between local/remote/K8s — multi-env

---

## 17.0 Kubernetes / Helm

### 17.1 Kubernetes-Specific
→ See Ideal §4.0–4.6 Kubernetes Architecture, Workloads, Networking, Storage, Scaling, Security

#### 17.1.1 kubectl-Unique Features
- **Unique: kubectl plugins (krew)** — extend kubectl — community plugins
  - 17.1.1.1 kubectl ctx / ns — context/namespace switcher — kubectx / kubens
  - 17.1.1.2 kubectl stern — multi-pod log tailing — regex pod filter — color output
  - 17.1.1.3 kubectl neat — strip managed fields — clean YAML output — readability
- **Unique: Server-side apply** — kubectl apply --server-side — field manager — conflict detection
  - 17.1.1.4 Field ownership — multiple managers — merge without overwrite
  - 17.1.1.5 Dry-run server-side — validate against admission — not just schema

#### 17.1.2 Kubernetes Operators
- **Unique: Operator pattern** — CRD + controller — manage stateful apps natively
  - 17.1.2.1 CustomResourceDefinition — extend API — domain-specific resources
  - 17.1.2.2 Operator SDK — Go / Ansible / Helm — scaffold operator — reconcile loop
  - 17.1.2.3 Operator Lifecycle Manager (OLM) — install/upgrade operators — K8s-native catalog
- **Unique: K8s Events** — state changes — informational — watch for troubleshooting
  - 17.1.2.4 kubectl events — sorted — reason + message + count — first/last time

### 17.2 Helm
→ See Ideal §5.0 IaC Concepts

#### 17.2.1 Helm Architecture
- 17.2.1.1 Chart — package — templates/ + values.yaml + Chart.yaml + helpers
  - 17.2.1.1.1 _helpers.tpl — named templates — {{ include "name" . }} — DRY
  - 17.2.1.1.2 NOTES.txt — post-install message — usage instructions — kubectl commands
- 17.2.1.2 Release — installed chart instance — named — tracked in K8s Secrets
  - 17.2.1.2.1 Release history — helm history — rollback to revision — helm rollback N
  - 17.2.1.2.2 Atomic — rollback on failure — helm install --atomic — fail safe

#### 17.2.2 Helm Templating
- **Unique: Go templates** — {{ range }} / {{ if }} / {{ with }} — powerful but complex
  - 17.2.2.1 Values override chain — chart defaults → values.yaml → -f override → --set
  - 17.2.2.2 Schema validation — values.schema.json — validate user values — type check
  - 17.2.2.3 Lookup function — query existing K8s resources in templates — conditional
- **Unique: Helm hooks** — pre-install / post-install / pre-upgrade / post-delete
  - 17.2.2.4 Database migration job — pre-upgrade hook — run before new pods start
  - 17.2.2.5 hook-delete-policy — before-hook-creation — clean before re-run
- **Unique: Library charts** — no templates rendered — shared helpers only — include only
  - 17.2.2.6 Chart dependency — requirements.yaml / Chart.yaml deps — helm dep update
- **Unique: OCI registry for Helm** — helm push chart oci://registry — versioned
  - 17.2.2.7 helm pull oci:// — pull chart from OCI registry — no Chart Museum needed

#### 17.2.3 Helm Security
- 17.2.3.1 Helm Secrets plugin — SOPS encryption — values encrypted in Git
  - 17.2.3.1.1 helm secrets dec — decrypt on fly — pass to helm install — no plaintext
- 17.2.3.2 Chart provenance — helm package --sign — verify with helm verify
  - 17.2.3.2.1 GPG signed charts — keyring verify — supply chain trust

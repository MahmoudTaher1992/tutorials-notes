# Docker Complete Study Guide (Ideal / Angel Method)
## Part 4: Implementation — Docker Compose

> **Ideal mappings** reference sections from Parts 1-3.
> Only features **unique** to Docker Compose are expanded here.

---

### Phase 2.1: Docker Compose

#### Ideal Mappings (not repeated)
- Container lifecycle → Ideal §1.2
- Image building → Ideal §2.2, §3
- Networking (bridge/overlay) → Ideal §4
- Volumes → Ideal §5
- Resource limits → Ideal §7.1
- Health checks → Ideal §8.3
- Registry distribution → Ideal §9

---

#### **Unique: Compose Service Definitions**

##### DC.1 Service Configuration
- DC.1.1 `image` vs `build` — pull existing or build from Dockerfile
- DC.1.2 `build` block — `context`, `dockerfile`, `args`, `target`, `cache_from`
- DC.1.3 `depends_on` with conditions — `service_healthy`, `service_completed_successfully`
- DC.1.4 `profiles` — selective service activation (`--profile dev`, `--profile tools`)
- DC.1.5 `deploy.replicas` — multiple containers per service (Swarm-extended behavior)
- DC.1.6 `restart` — no / on-failure[:N] / always / unless-stopped

##### DC.2 Networking in Compose
- DC.2.1 Auto-created default network — `<project>_default`, service name = DNS hostname
- DC.2.2 Custom named networks — explicit driver, subnet, external declaration
- DC.2.3 External networks — attach Compose services to pre-existing network
- DC.2.4 Network aliases — `aliases:` list, multiple DNS names per service
- DC.2.5 `ipv4_address` / `ipv6_address` — static IP assignment within network

##### DC.3 Volumes in Compose
- DC.3.1 Top-level named volumes — declared once, referenced by multiple services
- DC.3.2 External volumes — `external: true`, Compose will not create or destroy
- DC.3.3 Volume driver options — NFS, tmpfs, cloud storage inline in `driver_opts`
- DC.3.4 Service-level anonymous volumes — scoped to service lifecycle

##### DC.4 Configuration & Secrets
- DC.4.1 `environment` — inline key=value or list form
- DC.4.2 `env_file` — `.env`, `.env.local`, `.env.production` file loading
- DC.4.3 Variable substitution — `${VAR}`, `${VAR:-default}`, `${VAR:?error message}`
- DC.4.4 `configs` — non-sensitive file distribution, mounted read-only
- DC.4.5 `secrets` — file-based (dev) or external/Swarm-managed, tmpfs mount
- DC.4.6 `extends` — inherit and override service definitions from another file

##### DC.5 Compose CLI Commands
- DC.5.1 `docker compose up [-d]` — create and start all services
- DC.5.2 `docker compose down [--volumes --rmi all]` — stop and clean up
- DC.5.3 `docker compose ps` — list service containers and status
- DC.5.4 `docker compose logs [-f --no-log-prefix]` — aggregate logs
- DC.5.5 `docker compose exec <svc> <cmd>` — run command in running container
- DC.5.6 `docker compose run --rm <svc> <cmd>` — one-off command container
- DC.5.7 `docker compose build [--no-cache --push]` — build service images
- DC.5.8 `docker compose pull` — pull all service images
- DC.5.9 `docker compose watch` — file-sync and auto-rebuild on changes (v2.22+)
- DC.5.10 `docker compose --profile <name>` — activate optional service profiles
- DC.5.11 `docker compose convert` — view fully-resolved merged config
- DC.5.12 `-f compose.yml -f compose.override.yml` — multi-file merging

##### DC.6 File Merging & Override Strategy
- DC.6.1 `compose.override.yml` — auto-merged with base compose.yml
- DC.6.2 Merge semantics — mappings merged (deep), sequences appended
- DC.6.3 Environment-specific overrides — `compose.prod.yml`, `compose.dev.yml`
- DC.6.4 `COMPOSE_FILE` env var — set default file list without `-f` flags

##### DC.7 Development Workflow
- DC.7.1 Bind mount source code — `volumes: [./src:/app/src]` for live reload
- DC.7.2 `watch` directive — path-based sync, `action: sync|rebuild|sync+restart`
- DC.7.3 Service mocking — stub services (wiremock, localstack) for local dev
- DC.7.4 Deterministic ports — fixed host ports per service for scripts/tooling
- DC.7.5 Init containers — `depends_on: service_completed_successfully` pattern
- DC.7.6 Health-gated startup — `depends_on: service_healthy` wait until ready

##### DC.8 Production Considerations
- DC.8.1 Single-host suitability — good for simple stacks, not HA or multi-host
- DC.8.2 Resource limits — `deploy.resources.limits.memory` / `.cpus`
- DC.8.3 `deploy` key — only respected in Swarm mode, silently ignored in plain Compose
- DC.8.4 Log rotation — `logging.options.max-size: "10m"`, `max-file: "3"`
- DC.8.5 Named volumes for data — never rely on anonymous volumes for persistence
- DC.8.6 Project isolation — `COMPOSE_PROJECT_NAME` or `-p` to run multiple stacks

##### DC.9 Compose Spec (Standard)
- DC.9.1 Compose Specification — vendor-neutral, maintained by compose-spec org
- DC.9.2 Compatibility — Docker Compose v2, Podman Compose, Nerdctl Compose
- DC.9.3 `x-` extensions — custom top-level keys with YAML anchors for DRY configs
- DC.9.4 YAML anchors & aliases — `&anchor`, `*alias`, `<<: *merge` for reuse

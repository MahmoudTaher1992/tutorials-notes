# Docker Complete Study Guide (Ideal / Angel Method)
## Part 2: Ideal Container Platform — Networking & Storage

---

### 4. Networking

#### 4.1 Network Drivers
- 4.1.1 bridge — default NAT, per-host isolation, user-defined bridges enable DNS
- 4.1.2 host — share host network namespace, no isolation, best performance
- 4.1.3 none — fully isolated, no network interface except loopback
- 4.1.4 overlay — multi-host VXLAN networking for Swarm/Kubernetes
- 4.1.5 macvlan — assign MAC address, appear as physical device on LAN
- 4.1.6 ipvlan — layer-3 routing, no ARP flooding, better for large networks
- 4.1.7 User-defined bridge — recommended default, enables container DNS by name

#### 4.2 Container DNS & Service Discovery
- 4.2.1 Embedded DNS server — 127.0.0.11, resolves container names on same network
- 4.2.2 Network-scoped aliases — `--network-alias`, multiple names per container
- 4.2.3 Custom DNS servers — `--dns`, `--dns-search`, `--dns-opt`
- 4.2.4 /etc/hosts overrides — `--add-host` for static entries
- 4.2.5 Service discovery patterns — sidecar proxy, external DNS (CoreDNS)
- 4.2.6 Deprecated `--link` — replaced by user-defined networks

#### 4.3 Port Mapping & Exposure
- 4.3.1 Port publishing (`-p`) — `[host_ip:]host_port:container_port[/proto]`
- 4.3.2 Bind address security — `127.0.0.1:8080:8080` vs `0.0.0.0:8080:8080`
- 4.3.3 Port ranges — bulk publishing `8000-8010:8000-8010`
- 4.3.4 Random host port — `-p 80` assigns ephemeral host port
- 4.3.5 IPv6 support — `::1` binding, dual-stack configuration

#### 4.4 Network Security
- 4.4.1 Network isolation — only containers on same network communicate
- 4.4.2 ICC (Inter-container communication) — disable on default bridge for defense-in-depth
- 4.4.3 iptables management — Docker inserts DOCKER-USER chain, pre/post hook point
- 4.4.4 Encrypted overlay — TLS with AES-256-GCM, key rotation in Swarm

---

### 5. Storage & Volumes

#### 5.1 Storage Types
- 5.1.1 Volumes — managed by Docker daemon, persist beyond container removal
- 5.1.2 Bind mounts — host path mounted into container, dev workflow, file sync
- 5.1.3 tmpfs mounts — in-memory ephemeral storage, sensitive data (tokens, certs)
- 5.1.4 Named pipes (`npipe`) — Windows IPC driver

#### 5.2 Volume Management
- 5.2.1 Named volumes — explicit name, reusable, inspectable
- 5.2.2 Anonymous volumes — random name, scoped to container, auto-pruned
- 5.2.3 Volume drivers — local, NFS, cloud storage plugins (AWS EFS, Azure File)
- 5.2.4 Volume lifecycle — survives `docker rm`, requires explicit `docker volume rm`
- 5.2.5 Volume backup/restore — `docker run --volumes-from` + tar pattern
- 5.2.6 Volume pruning — `docker volume prune`, dangling vs in-use volumes

#### 5.3 Data Patterns
- 5.3.1 Init container pattern — pre-populate volume before app starts
- 5.3.2 Sidecar pattern — shared volume between main + sidecar containers
- 5.3.3 Secrets as tmpfs — mount sensitive data in-memory only
- 5.3.4 Read-only containers — `--read-only` + tmpfs for writable paths (`/tmp`, `/run`)
- 5.3.5 Config injection — volume-mounted config files vs env vars tradeoffs

---

### 6. Security

#### 6.1 Container Security Model
- 6.1.1 Privilege escalation — `--privileged` grants full host access, use sparingly
- 6.1.2 Linux capabilities — `--cap-drop ALL --cap-add NET_BIND_SERVICE` pattern
- 6.1.3 Seccomp profiles — default blocks 44+ syscalls, custom profiles, `unconfined` risk
- 6.1.4 AppArmor — default `docker-default` profile, custom profiles
- 6.1.5 SELinux — label-based MAC, `--security-opt label=type:svirt_sandbox_file_t`
- 6.1.6 Rootless Docker — user namespace remapping, no root daemon
- 6.1.7 No-new-privileges — `--security-opt=no-new-privileges` blocks setuid escalation

#### 6.2 Image Security
- 6.2.1 Image scanning — Trivy, Grype, Snyk, Docker Scout — CVE detection
- 6.2.2 Content trust (DCT) — Notary v1 image signing
- 6.2.3 Cosign (Sigstore) — keyless OIDC signing, supply chain verification
- 6.2.4 SBOM generation — `docker sbom`, Syft, CycloneDX/SPDX formats
- 6.2.5 Secret leakage prevention — `docker history` inspection, multi-stage scrub
- 6.2.6 SLSA provenance — build attestations, level 1-4 supply chain security
- 6.2.7 Dependency pinning — lock files, reproducible builds

#### 6.3 Runtime Security
- 6.3.1 Read-only filesystem — `--read-only` prevents in-container tampering
- 6.3.2 Resource limits as security — PID limit (`--pids-limit`) prevents fork bombs
- 6.3.3 Runtime threat detection — Falco, Sysdig — syscall anomaly detection
- 6.3.4 Audit logging — Docker daemon events, API access logging
- 6.3.5 CIS Docker Benchmark — `docker-bench-security` compliance scanner
- 6.3.6 Secrets management — Vault, AWS SSM, Docker secrets — never bake into image

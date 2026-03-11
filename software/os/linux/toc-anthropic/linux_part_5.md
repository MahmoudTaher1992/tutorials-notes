# Linux Complete Study Guide (Ideal / Angel Method)
## Part 5: Implementations — Distributions, Containers & Anti-Patterns

> **Ideal mappings** reference sections from Parts 1-4.
> Only features **unique** to each distribution/context are expanded here.

---

### Phase 2.1: Debian / Ubuntu

#### Ideal Mappings
- Package management → Ideal §11.1
- systemd → Ideal §11.2
- AppArmor → Ideal §9.3 (AppArmor)

#### **Unique: Debian/Ubuntu**

##### DEB.1 APT Package System
- DEB.1.1 `apt update` — refresh package index from repos
- DEB.1.2 `apt upgrade` vs `apt full-upgrade` — safe upgrade vs allows removals
- DEB.1.3 `apt install/remove/purge/autoremove` — install and clean packages
- DEB.1.4 `apt-cache search/show` — find and inspect packages
- DEB.1.5 `/etc/apt/sources.list.d/` — PPA and third-party repo drop-ins
- DEB.1.6 `dpkg -i`, `dpkg -l`, `dpkg -S` — low-level .deb operations
- DEB.1.7 `apt-mark hold` — pin package at current version, prevent upgrades
- DEB.1.8 Unattended upgrades — `/etc/apt/apt.conf.d/50unattended-upgrades`

##### DEB.2 Ubuntu-Specific
- DEB.2.1 LTS vs interim releases — 24.04 LTS (5yr support) vs 24.10 (9mo)
- DEB.2.2 `do-release-upgrade` — official upgrade path between releases
- DEB.2.3 Snap daemon (snapd) — Ubuntu's universal package system
- DEB.2.4 `netplan` — YAML network configuration (`/etc/netplan/*.yaml`)
- DEB.2.5 UFW — `ufw allow 22/tcp`, `ufw enable`, `ufw status verbose`
- DEB.2.6 cloud-init — cloud instance bootstrap, `/etc/cloud/cloud.cfg`

---

### Phase 2.2: RHEL / CentOS / Fedora / AlmaLinux / Rocky

#### Ideal Mappings
- SELinux → Ideal §9.3 (SELinux)
- systemd → Ideal §11.2
- firewalld → Ideal §8.4

#### **Unique: RHEL Ecosystem**

##### RH.1 DNF/YUM Package System
- RH.1.1 `dnf install/remove/update/upgrade` — main package operations
- RH.1.2 `dnf search`, `dnf info`, `dnf provides /bin/vim` — package discovery
- RH.1.3 `dnf module` — AppStream modularity, multiple software versions
- RH.1.4 `/etc/yum.repos.d/` — repo files, `enabled=1`, `gpgcheck=1`
- RH.1.5 `rpm -ivh`, `rpm -qa`, `rpm -qf /usr/bin/bash` — RPM queries
- RH.1.6 `dnf history undo` — rollback transactions
- RH.1.7 `subscription-manager` — RHEL entitlement management

##### RH.2 RHEL-Specific Tools
- RH.2.1 `sosreport` — collect diagnostic information bundle for support
- RH.2.2 `insights-client` — Red Hat Insights telemetry and recommendations
- RH.2.3 `cockpit` — web-based system administration dashboard
- RH.2.4 `nmcli` / `nmtui` — NetworkManager CLI/TUI for network config
- RH.2.5 `chrony` — NTP time synchronization (replaced `ntpd` on RHEL 7+)
- RH.2.6 RHEL alternatives — AlmaLinux, Rocky Linux (1:1 binary compatible)

---

### Phase 2.3: Arch Linux

#### Ideal Mappings
- Package management → Ideal §11.1
- Boot process → Ideal §2

#### **Unique: Arch Linux**

##### ARC.1 Pacman Package Manager
- ARC.1.1 `pacman -Syu` — sync repos and upgrade all packages (rolling release)
- ARC.1.2 `pacman -S`, `-R`, `-Rs` — install, remove, remove with deps
- ARC.1.3 `pacman -Ss`, `-Si`, `-Ql` — search, info, list package files
- ARC.1.4 `pacman -Qe` — list explicitly installed packages
- ARC.1.5 AUR (Arch User Repository) — community packages, `makepkg -si`
- ARC.1.6 AUR helpers — `yay`, `paru` — automate AUR package building

##### ARC.2 Arch-Specific Philosophy
- ARC.2.1 Rolling release — always latest, no version upgrade process
- ARC.2.2 KISS philosophy — minimal default, user builds their own system
- ARC.2.3 Arch Wiki — de facto reference for all Linux topics, not just Arch
- ARC.2.4 systemd-boot — Arch default EFI bootloader
- ARC.2.5 `reflector` — select fastest pacman mirrors automatically

---

### Phase 2.4: Alpine Linux

#### Ideal Mappings
- Package management → Ideal §11.1
- Security (minimal surface) → Ideal §9.6

#### **Unique: Alpine Linux**

##### ALP.1 apk Package Manager
- ALP.1.1 `apk add/del/update/upgrade` — fast, minimal package manager
- ALP.1.2 `apk search`, `apk info` — package discovery
- ALP.1.3 `apk add --virtual .build-deps` — temporary build dep groups
- ALP.1.4 `/etc/apk/repositories` — repo configuration

##### ALP.2 Alpine Architecture
- ALP.2.1 musl libc — lightweight C library (vs glibc), important for compatibility
- ALP.2.2 BusyBox — single binary providing many UNIX utilities
- ALP.2.3 OpenRC — default init system (not systemd)
- ALP.2.4 Container popularity — tiny base image (~5MB), Docker `FROM alpine:3`
- ALP.2.5 glibc compatibility layer — `gcompat` package for glibc-linked binaries
- ALP.2.6 musl vs glibc pitfalls — DNS resolution, locale, thread stack differences

---

### Phase 2.5: Linux in Containers & Cloud

#### Ideal Mappings
- Namespaces → Ideal §3.1 (process isolation)
- cgroups → Ideal §12.4
- Network namespaces → Ideal §8.1.3

#### **Unique: Container Linux Context**

##### CT.1 Namespaces (Container Isolation Primitives)
- CT.1.1 PID namespace — container PID 1, isolated process tree
- CT.1.2 Network namespace — isolated network stack, veth pairs
- CT.1.3 Mount namespace — isolated filesystem view, pivot_root
- CT.1.4 UTS namespace — isolated hostname and domain name
- CT.1.5 IPC namespace — isolated System V IPC, POSIX message queues
- CT.1.6 User namespace — UID/GID mapping, rootless containers

##### CT.2 Cloud-Specific Linux Skills
- CT.2.1 cloud-init — instance metadata, user-data scripts, network config
- CT.2.2 Instance metadata service — `http://169.254.169.254/` — AWS/GCP/Azure
- CT.2.3 User data scripts — bootstrap automation on first boot
- CT.2.4 SystemD in containers — `systemd` as PID 1 in containers (privileged)
- CT.2.5 `cloud-config` format — YAML-based cloud-init declarative config

---

### 13. Anti-Patterns & Common Mistakes

#### 13.1 Permission Anti-Patterns
- 13.1.1 `chmod 777` — grants everyone full access, never the right answer
- 13.1.2 Running services as root — one vulnerability = full system compromise
- 13.1.3 World-writable directories — `/tmp` sticky bit exists for a reason
- 13.1.4 Storing secrets in environment variables without restriction — visible in `/proc`
- 13.1.5 Disabling SELinux/AppArmor — removing protection instead of writing policy

#### 13.2 System Administration Anti-Patterns
- 13.2.1 Editing files in production without backup — always `cp file file.bak` first
- 13.2.2 `rm -rf /` — the most famous destructive command
- 13.2.3 Ignoring `df -h` — disk full causes mysterious application failures
- 13.2.4 Not testing cron jobs — jobs that "work manually" fail in cron environment
- 13.2.5 Disabling swap on memory-constrained systems — OOM killer becomes trigger-happy
- 13.2.6 Unattended kernel upgrades without reboot — running old kernel, new libraries

#### 13.3 Shell Scripting Anti-Patterns
- 13.3.1 Missing `set -euo pipefail` — silent failures propagate, errors hidden
- 13.3.2 Unquoted variables — `rm -rf $DIR` with space in DIR deletes wrong paths
- 13.3.3 Parsing `ls` output — filenames with spaces/newlines break parsing
- 13.3.4 Using `cat file | grep` instead of `grep pattern file` — unnecessary process
- 13.3.5 Hardcoded paths — scripts break on different distros (`/usr/bin` vs `/usr/local/bin`)

#### 13.4 Networking Anti-Patterns
- 13.4.1 Disabling the firewall "temporarily" — it becomes permanent
- 13.4.2 Binding services to `0.0.0.0` unnecessarily — expose only on needed interface
- 13.4.3 SSH password auth on public internet — brute-forced in minutes
- 13.4.4 Ignoring `sshd_config` defaults — root login enabled, all auth methods on
- 13.4.5 Not setting `ulimit` — file descriptor exhaustion under load

---

### 14. Essential Commands Quick Reference

#### 14.1 File & Directory
- `ls -lahF` — long list with hidden, human sizes, type indicator
- `find / -name "*.conf" -not -path "*/proc/*"` — search excluding /proc
- `rsync -avz --progress src/ dest/` — efficient copy with progress
- `tar -czvf archive.tgz dir/` — create compressed archive
- `tar -xzvf archive.tgz` — extract compressed archive

#### 14.2 Process & System
- `ps aux --sort=-%mem | head -20` — top 20 processes by memory
- `lsof -p PID` — files open by process
- `fuser -v /path/to/mount` — what's using a mounted path
- `dmesg -T | tail -50` — recent kernel messages with timestamps
- `journalctl -xe` — recent journal with explanations

#### 14.3 Network
- `ss -tulnp` — all listening sockets with process names
- `ip route get 8.8.8.8` — which interface/route to reach a destination
- `nmap -sV -p 1-65535 host` — full port scan with version detection
- `curl -I https://example.com` — HTTP headers only

#### 14.4 Emergency Recovery
- `fsck /dev/sda1` — check filesystem (must be unmounted)
- `grub-install /dev/sda && update-grub` — reinstall bootloader
- `passwd root` — reset root password from rescue shell
- `journalctl --boot=-1` — logs from previous boot (diagnose crash)

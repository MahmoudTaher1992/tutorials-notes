# Linux Complete Study Guide (Ideal / Angel Method)
## Part 3: Ideal Linux System — Networking & Security

---

### 8. Networking

#### 8.1 Network Stack
- 8.1.1 TCP/IP model layers — link, internet, transport, application — Linux kernel implements bottom 3
- 8.1.2 Socket API — `socket()`, `bind()`, `listen()`, `accept()`, `connect()`, `send()`, `recv()`
- 8.1.3 Network namespaces — isolated network stack per namespace (basis for containers)
- 8.1.4 `netstat` / `ss` — show sockets, listen ports, connections (`ss -tulnp`)
- 8.1.5 `/proc/net/` — kernel networking state (tcp, udp, unix, arp, dev)
- 8.1.6 `ethtool` — query and configure NIC hardware features

#### 8.2 Network Configuration

##### ip command (iproute2 — modern)
- 8.2.1 `ip addr` — show/manage IP addresses
- 8.2.2 `ip link` — manage network interfaces (up/down, MTU, MAC)
- 8.2.3 `ip route` — show/manage routing table
- 8.2.4 `ip neigh` — ARP/NDP neighbor table
- 8.2.5 `ip netns` — manage network namespaces

##### Legacy (deprecated but common)
- 8.2.6 `ifconfig` — interface configuration (net-tools, superseded by `ip`)
- 8.2.7 `route` — routing table (superseded by `ip route`)

#### 8.3 DNS & Name Resolution
- 8.3.1 `/etc/resolv.conf` — nameserver configuration
- 8.3.2 `/etc/hosts` — static hostname-to-IP mappings
- 8.3.3 `/etc/nsswitch.conf` — name service switch order (files, dns, mDNS)
- 8.3.4 `dig` — DNS lookup tool, `dig @8.8.8.8 example.com A`
- 8.3.5 `nslookup` — interactive DNS queries (legacy, use dig)
- 8.3.6 `resolvectl` — systemd-resolved status and query tool
- 8.3.7 mDNS / Avahi — local network discovery, `.local` domain resolution

#### 8.4 Firewall (iptables / nftables)

##### iptables
- 8.4.1 Tables — filter, nat, mangle, raw, security
- 8.4.2 Chains — INPUT, OUTPUT, FORWARD (built-in); custom chains
- 8.4.3 Rules — match criteria + target (ACCEPT, DROP, REJECT, LOG, MASQUERADE)
- 8.4.4 `iptables -L -n -v` — list rules with packet/byte counters
- 8.4.5 `iptables-save` / `iptables-restore` — persist and restore rules

##### nftables (modern replacement)
- 8.4.6 Single tool replaces iptables/ip6tables/arptables/ebtables
- 8.4.7 `nft list ruleset` — view all rules
- 8.4.8 `nft` scripting — atomic rule replacement, better performance

##### firewalld / ufw
- 8.4.9 firewalld — zone-based, dynamic, used on RHEL/Fedora
- 8.4.10 ufw (Uncomplicated Firewall) — simple front-end, Ubuntu default
- 8.4.11 `firewall-cmd --list-all` — show active zone rules

#### 8.5 Network Diagnostics
- 8.5.1 `ping` / `ping6` — ICMP echo test, basic reachability
- 8.5.2 `traceroute` / `tracepath` — hop-by-hop path to destination
- 8.5.3 `mtr` — combined ping + traceroute, live updating
- 8.5.4 `tcpdump` — packet capture, `tcpdump -i eth0 port 443 -w capture.pcap`
- 8.5.5 `wireshark` / `tshark` — packet analysis (GUI and CLI)
- 8.5.6 `nc` (netcat) — TCP/UDP Swiss army knife, port testing, data transfer
- 8.5.7 `curl` / `wget` — HTTP client tools, `curl -v`, `--resolve` overrides

#### 8.6 Network Performance
- 8.6.1 `iperf3` — bandwidth measurement between two hosts
- 8.6.2 `nethogs` — bandwidth per process in real time
- 8.6.3 `iftop` — bandwidth per connection
- 8.6.4 TCP tuning — `tcp_rmem`, `tcp_wmem`, `tcp_congestion_control` (BBR vs CUBIC)
- 8.6.5 `sysctl net.*` — kernel network parameter tuning
- 8.6.6 Jumbo frames — MTU 9000, reduces CPU overhead for large transfers

---

### 9. Security

#### 9.1 Users, Groups & Authentication
- 9.1.1 `/etc/passwd` — user accounts (username:x:UID:GID:comment:home:shell)
- 9.1.2 `/etc/shadow` — hashed passwords, aging policy (root-readable only)
- 9.1.3 `/etc/group` — group definitions, membership
- 9.1.4 `useradd`, `usermod`, `userdel` — user management
- 9.1.5 `passwd` — change user password
- 9.1.6 `sudo` — run commands as another user, `/etc/sudoers` (use `visudo`)
- 9.1.7 `su` — switch user, `-l` for login shell
- 9.1.8 PAM (Pluggable Authentication Modules) — flexible auth framework

#### 9.2 SSH
- 9.2.1 SSH protocol — encrypted shell access, public key auth, port 22
- 9.2.2 `ssh-keygen` — generate key pair (Ed25519 preferred over RSA)
- 9.2.3 `ssh-copy-id` — install public key to remote `~/.ssh/authorized_keys`
- 9.2.4 `~/.ssh/config` — per-host aliases, port, identity file, ProxyJump
- 9.2.5 `sshd_config` — server hardening: `PermitRootLogin no`, `PasswordAuthentication no`
- 9.2.6 SSH tunneling — `-L` local forward, `-R` remote forward, `-D` SOCKS proxy
- 9.2.7 `ssh-agent` — private key cache, `ssh-add`
- 9.2.8 `ProxyJump` / bastion hosts — `ssh -J bastion user@target`

#### 9.3 Mandatory Access Control

##### SELinux
- 9.3.1 SELinux modes — enforcing, permissive, disabled (`getenforce` / `setenforce`)
- 9.3.2 Labels — type enforcement context `user:role:type:level` on every object
- 9.3.3 Policies — targeted (RHEL default), strict, MLS
- 9.3.4 `ausearch` / `audit2allow` — diagnose and generate policy from denials
- 9.3.5 `restorecon` — reset file security context to policy default
- 9.3.6 Booleans — `getsebool -a`, `setsebool` — toggle policy options

##### AppArmor
- 9.3.7 Profile-based — per-application capability restriction
- 9.3.8 Modes — enforce vs complain (audit only)
- 9.3.9 `aa-status`, `aa-genprof`, `aa-logprof` — profile management
- 9.3.10 Used by default on Ubuntu, Debian, SUSE

#### 9.4 Auditing & Intrusion Detection
- 9.4.1 `auditd` — kernel audit framework, log syscalls, file access, user changes
- 9.4.2 `auditctl` — add/remove audit rules at runtime
- 9.4.3 `aureport` — summary reports from audit log
- 9.4.4 `fail2ban` — parse logs, ban IPs after repeated failures
- 9.4.5 `rkhunter` / `chkrootkit` — rootkit detection scanners
- 9.4.6 AIDE (Advanced Intrusion Detection Environment) — file integrity monitoring

#### 9.5 Cryptography Tools
- 9.5.1 `gpg` — encrypt, decrypt, sign files; key management
- 9.5.2 `openssl` — TLS/SSL operations, certificate management, hash functions
- 9.5.3 `certbot` — Let's Encrypt certificate automation
- 9.5.4 `cryptsetup` / LUKS — full disk encryption, `cryptsetup luksOpen`
- 9.5.5 `age` — modern simple file encryption tool
- 9.5.6 `/dev/random` vs `/dev/urandom` — blocking vs non-blocking entropy sources

#### 9.6 System Hardening
- 9.6.1 CIS Benchmarks — industry-standard hardening checklists per distro
- 9.6.2 `sysctl` hardening — `kernel.dmesg_restrict`, `net.ipv4.conf.all.rp_filter`, etc.
- 9.6.3 Remove unnecessary packages — reduce attack surface
- 9.6.4 `unattended-upgrades` / `dnf-automatic` — automatic security patching
- 9.6.5 Disable unused services — `systemctl disable --now <service>`
- 9.6.6 `lynis` — security audit and hardening scanner

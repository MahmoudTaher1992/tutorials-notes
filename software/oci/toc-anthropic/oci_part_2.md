# OCI Complete Study Guide - Part 2: Phase 1 — Networking

## 2.0 Networking

### 2.1 Virtual Cloud Network (VCN) Architecture
#### 2.1.1 VCN Fundamentals
- 2.1.1.1 VCN — software-defined network — regional — CIDR /16 to /30
  - 2.1.1.1.1 IPv4 + IPv6 dual-stack — /56 prefix delegated per VCN
  - 2.1.1.1.2 VCN CIDR expansion — add secondary CIDRs — live — no downtime
- 2.1.1.2 Internet Gateway (IGW) — one per VCN — attach/detach — stateful
  - 2.1.1.2.1 Public subnet required — route 0.0.0.0/0 → IGW — instance needs public IP
- 2.1.1.3 NAT Gateway — managed SNAT — no NAT VM — regional — HA built-in
  - 2.1.1.3.1 Block public ingress — outbound only — private subnet internet access
  - 2.1.1.3.2 Bandwidth — scales automatically — no instance type sizing
- 2.1.1.4 Service Gateway (SGW) — private path to OCI services — no internet
  - 2.1.1.4.1 All OCI Services in Oracle Services Network — one route rule covers all
  - 2.1.1.4.2 Object Storage, Autonomous DB, Analytics — no NAT needed
- 2.1.1.5 Local Peering Gateway (LPG) — VCN-to-VCN — same region — no transitive routing
  - 2.1.1.5.1 LPG pair — one per side — CIDR must not overlap — requester/acceptor
- 2.1.1.6 Dynamic Routing Gateway (DRG) — hub — connect VCNs + on-prem + other regions
  - 2.1.1.6.1 DRG v2 — transit routing — spoke VCNs route through hub — centralized firewall
  - 2.1.1.6.2 VCN attachment — import/export route distribution — granular policy

#### 2.1.2 DRG Transit Routing
- 2.1.2.1 Hub-and-spoke topology — DRG hub — spoke VCNs — on-prem — single choke point
  - 2.1.2.1.1 Route distribution — DRG export policy — control which routes propagate
  - 2.1.2.1.2 Firewall insertion — NVA in hub VCN — all east-west traffic inspected
- 2.1.2.2 Remote VCN peering — DRG-to-DRG — cross-region — OCI backbone
  - 2.1.2.2.1 RPC — Remote Peering Connection — latency based on region distance

### 2.2 Subnets, Route Tables, Security Lists
#### 2.2.1 Subnet Types
- 2.2.1.1 Regional subnet — spans all ADs in region — simpler design
  - 2.2.1.1.1 AD-specific subnet — legacy — single AD only — use regional for new designs
- 2.2.1.2 Public subnet — instances can receive public IPs — IGW route required
  - 2.2.1.2.1 Public IP assignment — ephemeral (released on stop) vs. reserved (persistent)
- 2.2.1.3 Private subnet — no public IP — NAT/SGW for outbound — no internet inbound

#### 2.2.2 Route Tables
- 2.2.2.1 Route rule — destination CIDR → target — longest prefix match
  - 2.2.2.1.1 Target types — IGW, NAT GW, Service GW, DRG, LPG, Private IP, NLB
  - 2.2.2.1.2 0.0.0.0/0 → NAT GW — private subnet default route — internet egress
- 2.2.2.2 Per-subnet route table — one RT per subnet — no implicit routes
  - 2.2.2.2.1 Multiple subnets — share RT or separate — security boundary

#### 2.2.3 Security Lists
- 2.2.3.1 Stateful rules — track connection state — allow return traffic automatically
  - 2.2.3.1.1 Ingress + Egress rules — CIDR + protocol + port — separate rule sets
  - 2.2.3.1.2 Stateless rules — inspect each packet — must have matching return rule
- 2.2.3.2 Default security list — allows SSH inbound + all outbound — modify immediately
  - 2.2.3.2.1 Multiple security lists per subnet — union of all rules applies

### 2.3 Network Security Groups (NSG)
#### 2.3.1 NSG Architecture
- 2.3.1.1 NSG — applied to VNIC — not subnet — finer granularity than SL
  - 2.3.1.1.1 NSG as rule source/destination — allow between NSG members — no CIDR needed
  - 2.3.1.1.2 Combine with security list — both evaluated — more restrictive wins (union)
- 2.3.1.2 Max 5 NSGs per VNIC — per-VNIC limit — plan NSG design carefully
  - 2.3.1.2.1 NSG for DB tier — allow only app tier NSG — zero-trust micro-segmentation

### 2.4 Load Balancing
#### 2.4.1 Load Balancer (HTTP/HTTPS — Layer 7)
- 2.4.1.1 Flexible LB — bandwidth 10 Mbps to 8 Gbps — regional — HA by default
  - 2.4.1.1.1 Listener — protocol (HTTP/HTTPS/TCP) + port — frontend entry point
  - 2.4.1.1.2 Backend set — health-checked backends — multiple policies
  - 2.4.1.1.3 Routing policy — URI/header-based rules — path routing to different sets
- 2.4.1.2 SSL termination — load balancer decrypts — backend receives plain HTTP
  - 2.4.1.2.1 Certificate bundle — OCI Certificates service — auto-rotation
  - 2.4.1.2.2 SSL passthrough — LB forwards encrypted — end-to-end TLS
- 2.4.1.3 Session persistence — cookie-based — LB-generated or application cookie
  - 2.4.1.3.1 LB cookie — insert Set-Cookie header — hashed backend routing
- 2.4.1.4 Health checks — HTTP/TCP — interval + timeout + threshold
  - 2.4.1.4.1 Return code — 200 expected — custom path — /health endpoint
  - 2.4.1.4.2 Drain — connection draining — graceful deregistration — configurable timeout

#### 2.4.2 Network Load Balancer (TCP/UDP — Layer 4)
- 2.4.2.1 NLB — ultra-low latency — preserve source IP — no SSL termination
  - 2.4.2.1.1 Bandwidth unrestricted — no capacity unit limit — scales automatically
  - 2.4.2.1.2 UDP support — DNS servers, gaming, streaming — NLB only (not LB)
- 2.4.2.2 Health checks — TCP/HTTP — NLB routes away from unhealthy backends
  - 2.4.2.2.1 Preserve source IP — backend sees client IP — firewall rules needed

### 2.5 FastConnect & VPN
#### 2.5.1 FastConnect (Private Peering)
- 2.5.1.1 FastConnect — dedicated circuit — colocation + provider models
  - 2.5.1.1.1 Colocation — direct cross-connect in OCI FastConnect location
  - 2.5.1.1.2 Provider model — carrier provides last-mile — many partners
  - 2.5.1.1.3 Bandwidth — 1/10 Gbps — multiple circuits — LAG bonding
- 2.5.1.2 Private Peering — on-prem ↔ OCI VCN — RFC1918 — BGP
  - 2.5.1.2.1 BGP ASN — OCI uses 31898 — customer uses private ASN
  - 2.5.1.2.2 Route filtering — prefix lists — limit advertised prefixes
- 2.5.1.3 Public Peering — on-prem → OCI public endpoints — over FastConnect
  - 2.5.1.3.1 Use case — on-prem to OCI Object Storage — no internet path

#### 2.5.2 Site-to-Site VPN
- 2.5.2.1 IPSec VPN — managed — two tunnels per connection — HA by default
  - 2.5.2.1.1 IKEv1 + IKEv2 — policy-based or BGP route-based
  - 2.5.2.1.2 Redundant tunnels — different OCI headend IPs — active/active or active/standby

### 2.6 DNS & Traffic Management
#### 2.6.1 OCI DNS
- 2.6.1.1 Public DNS zones — authoritative — global anycast — 100% SLA
  - 2.6.1.1.1 Record types — A/AAAA/CNAME/MX/TXT/NS/SOA/CAA
  - 2.6.1.1.2 DNSSEC — sign zones — chain of trust — protect against spoofing
- 2.6.1.2 Private DNS zones — VCN-scoped — custom resolver — split-horizon
  - 2.6.1.2.1 Resolver endpoint — listening/forwarding — on-prem DNS integration
  - 2.6.1.2.2 Conditional forwarding — forward specific domain to on-prem DNS

#### 2.6.2 Traffic Management Steering Policies
- 2.6.2.1 Geolocation steering — route based on client IP location
  - 2.6.2.1.1 Country/continent — map to answer pool — CDN-like DNS
- 2.6.2.2 Failover policy — health-check driven — primary → secondary
  - 2.6.2.2.1 HTTP health check — OCI global probers — 10 locations

### 2.7 WAF & Network Firewall
#### 2.7.1 Web Application Firewall (WAF)
- 2.7.1.1 OCI WAF — OWASP rules — bot management — rate limiting
  - 2.7.1.1.1 Protection rules — 100+ managed rules — CVE-based updates
  - 2.7.1.1.2 Challenge actions — CAPTCHA — JS challenge — bot detection
- 2.7.1.2 Network Firewall — Palo Alto VM-Series — stateful — IDS/IPS
  - 2.7.1.2.1 Policy — security rules + decryption rules + NAT rules
  - 2.7.1.2.2 Threat intelligence — OCI-managed feed — auto-updated signatures

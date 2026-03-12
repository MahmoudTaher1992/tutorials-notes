# GCP Complete Study Guide - Part 2: Networking & Connectivity (Phase 1 — Ideal)

## 2.0 Networking & Connectivity

### 2.1 VPC Architecture (Global VPC)
#### 2.1.1 Global VPC Fundamentals
- 2.1.1.1 Global VPC — single VPC spans all regions — unique to GCP
  - 2.1.1.1.1 Subnets are regional — VMs in different regions share one VPC
  - 2.1.1.1.2 No VPC peering needed for same-project multi-region traffic
- 2.1.1.2 VPC modes — auto mode vs. custom mode
  - 2.1.1.2.1 Auto mode — creates subnets in all regions — /20 per region
  - 2.1.1.2.2 Custom mode — explicit subnet creation — production recommended
- 2.1.1.3 Shared VPC — host project VPC shared to service projects
  - 2.1.1.3.1 Host project — owns VPC — grants compute.subnetworkUser role
  - 2.1.1.3.2 Service projects — use shared subnets — resources deployed there
  - 2.1.1.3.3 XPN (Cross-Project Networking) — centralized network governance

#### 2.1.2 VPC Peering
- 2.1.2.1 VPC peering — connect two VPCs — same or different project/org
  - 2.1.2.1.1 Non-transitive — must peer directly — no hub-spoke transitivity
  - 2.1.2.1.2 Exchange custom routes opt-in — import/export route tables
  - 2.1.2.1.3 No overlapping CIDRs — peering fails if address ranges conflict
- 2.1.2.2 Private Service Connect (PSC) — expose service via endpoint
  - 2.1.2.2.1 Producer — attach service to PSC forwarding rule + service attachment
  - 2.1.2.2.2 Consumer — create endpoint — gets private IP — DNS auto-created

### 2.2 Subnetting & IP Addressing
#### 2.2.1 Subnet Design
- 2.2.1.1 Regional subnets — primary CIDR + secondary CIDR ranges
  - 2.2.1.1.1 Primary range — VMs — 4 reserved IPs (network, gateway, +2, broadcast)
  - 2.2.1.1.2 Secondary ranges — Pods + Services in GKE — alias IP ranges
- 2.2.1.2 Subnet expansion — enlarge primary CIDR non-destructively
  - 2.2.1.2.1 Must be superset — only prefix length decrease allowed
  - 2.2.1.2.2 No VM restart — live expansion — takes effect immediately
- 2.2.1.3 Private Google Access — VMs without public IP access Google APIs
  - 2.2.1.3.1 restricted.googleapis.com — VIP 199.36.153.4/30 — no internet
  - 2.2.1.3.2 DNS override — route *.googleapis.com to restricted VIP

#### 2.2.2 IPv6 in GCP VPC
- 2.2.2.1 Dual-stack subnets — /64 IPv6 per subnet — internal or external
  - 2.2.2.1.1 ULA (Unique Local Address) — internal only — fd00::/8 range
  - 2.2.2.1.2 External IPv6 — globally routable — assigned from Google's pool

### 2.3 Routing & Traffic Engineering
#### 2.3.1 Routes & Forwarding
- 2.3.1.1 System-generated routes — default internet gateway + subnet local
  - 2.3.1.1.1 Default route priority 1000 — override with lower value = higher priority
- 2.3.1.2 Custom static routes — specific next-hops — VM, VLAN, VPN tunnel, ILB
  - 2.3.1.2.1 Tag-based routes — apply route only to VMs with matching network tag
- 2.3.1.3 Dynamic routes — BGP via Cloud Router — Cloud VPN / Interconnect
  - 2.3.1.3.1 Cloud Router — regional — BGP session per VPN/Interconnect interface
  - 2.3.1.3.2 Global dynamic routing mode — propagate routes to all regions in VPC

#### 2.3.2 Network Connectivity Center (NCC)
- 2.3.2.1 Hub-and-spoke model — Google backbone as transit
  - 2.3.2.1.1 Spoke types — VPN tunnels, VLAN attachments, Router Appliance VMs
  - 2.3.2.1.2 Data transfer — spoke-to-spoke via Google backbone — metered
- 2.3.2.2 VPC spokes — connect VPCs to hub — transitive routing solved
  - 2.3.2.2.1 Preset topology — star or mesh — configurable

### 2.4 Cloud DNS
#### 2.4.1 Cloud DNS Architecture
- 2.4.1.1 Managed zones — public or private — authoritative DNS
  - 2.4.1.1.1 SOA TTL — 21600s default — NS propagation time
  - 2.4.1.1.2 DNSSEC — RSASHA256 — KSK + ZSK — DS record to registrar
- 2.4.1.2 Private zones — VPC-scoped — override public DNS per VPC
  - 2.4.1.2.1 Forwarding zones — forward queries to on-prem DNS servers
  - 2.4.1.2.2 Peering zones — delegate resolution to another VPC's DNS
- 2.4.1.3 Cloud DNS policies — response policy zones — split-horizon DNS
  - 2.4.1.3.1 Inbound server policy — allow on-prem to resolve GCP private zones
  - 2.4.1.3.2 Outbound forwarders — VMs query on-prem — 35.199.192.0/19 source

### 2.5 Load Balancing
#### 2.5.1 Global External Application Load Balancer (ALB)
- 2.5.1.1 Layer 7 — Anycast — HTTP/HTTPS/HTTP2/gRPC — global single VIP
  - 2.5.1.1.1 URL map — host + path rules → backend service/bucket
  - 2.5.1.1.2 Advanced traffic management — traffic split, mirroring, fault injection
- 2.5.1.2 Backend types — instance group, NEG (zonal/internet/serverless/PSC)
  - 2.5.1.2.1 Serverless NEG — route ALB to Cloud Run/Functions/App Engine
  - 2.5.1.2.2 Internet NEG — proxy to external HTTPS endpoint — third-party backends
- 2.5.1.3 SSL policies — TLS 1.0–1.3 — profile (Compatible/Modern/Restricted/Custom)
  - 2.5.1.3.1 Certificate Manager — managed certs — wildcard — bulk provisioning

#### 2.5.2 Regional Load Balancers
- 2.5.2.1 Regional External ALB — single region — L7 — proxy-based
- 2.5.2.2 Internal ALB (Cross-region) — L7 — RFC 1918 — internal services
  - 2.5.2.2.1 Access from on-prem — via VPN/Interconnect — private internal LB
- 2.5.2.3 External Network LB (pass-through) — L3/L4 — preserves source IP
  - 2.5.2.3.1 Target pool or backend service — legacy vs. modern config
  - 2.5.2.3.2 Maglev — Google's consistent hashing — stateless connection distribution
- 2.5.2.4 Internal Passthrough NLB — L4 — ILB — same region — symmetric hashing

#### 2.5.3 Traffic Director (xDS-based service mesh)
- 2.5.3.1 Cloud-managed control plane — Envoy sidecar — xDS API
  - 2.5.3.1.1 Service-level traffic policies — retries, timeouts, circuit breaker
  - 2.5.3.1.2 gRPC-native — proxyless gRPC — no Envoy sidecar needed

### 2.6 Cloud VPN & Cloud Interconnect
#### 2.6.1 Cloud VPN
- 2.6.1.1 HA VPN — 2 interfaces — 4 tunnels — 99.99% SLA
  - 2.6.1.1.1 IKEv2 — AES-256/SHA-256 — 3Gbps per tunnel
  - 2.6.1.1.2 ECMP via Cloud Router — BGP load balance across tunnels
- 2.6.1.2 Classic VPN — single interface — 99.9% SLA — legacy

#### 2.6.2 Cloud Interconnect
- 2.6.2.1 Dedicated Interconnect — 10/100Gbps physical cross-connect — colocation
  - 2.6.2.1.1 MACSEC — L2 encryption — optional — dedicated only
  - 2.6.2.1.2 VLAN attachments — 802.1Q — up to 8 per interconnect
- 2.6.2.2 Partner Interconnect — 50Mbps–50Gbps — via service provider
  - 2.6.2.2.1 Layer 2 vs. Layer 3 — partner manages BGP (L3) or customer does (L2)
- 2.6.2.3 Cross-Cloud Interconnect — dedicated to AWS/Azure — 10/100Gbps

### 2.7 Network Security
#### 2.7.1 Firewall Rules (VPC)
- 2.7.1.1 Stateful — implied allow for established connections
  - 2.7.1.1.1 Priority 0–65534 — lower = higher priority — 65535 implied deny all
  - 2.7.1.1.2 Target — all instances, service account, or network tag
- 2.7.1.2 Firewall Policy — hierarchical — org/folder/VPC — override per-VPC rules
  - 2.7.1.2.1 Goto_next — fall through to lower-priority policy
  - 2.7.1.2.2 Layer 7 inspection — FQDN + geolocation in firewall rules (NGFW)
- 2.7.1.3 Firewall Insights — shadowed rules, overly permissive, allow vs. deny hit counts

#### 2.7.2 Cloud Armor
- 2.7.2.1 DDoS protection + WAF — attached to ALB backend services
  - 2.7.2.1.1 Adaptive Protection — ML — detect and mitigate L7 DDoS automatically
  - 2.7.2.1.2 Preconfigured WAF rules — OWASP CRS — SQLi, XSS, LFI, RCE
- 2.7.2.2 Security policies — allow/deny/rate-based-ban/redirect/throttle
  - 2.7.2.2.1 Custom rules language — CEL expressions — request attributes
  - 2.7.2.2.2 Bot management — reCAPTCHA Enterprise integration — challenge action
- 2.7.2.3 Named IP list — Fastly, Cloudflare, Tor exit nodes — maintained by Google

### 2.8 CDN & Edge
#### 2.8.1 Cloud CDN
- 2.8.1.1 Edge caching — 90+ PoPs — GCS/ALB backend — Cache-Control headers
  - 2.8.1.1.1 Cache modes — CACHE_ALL_STATIC, USE_ORIGIN_HEADERS, FORCE_CACHE_ALL
  - 2.8.1.1.2 Signed URLs / Signed Cookies — time-limited access to CDN content
- 2.8.1.2 Cache invalidation — URL prefix or specific URLs — near-instant
  - 2.8.1.2.1 Bypass cache — x-goog-bypass-cache: true header on origin

#### 2.8.2 Media CDN
- 2.8.2.1 Built on YouTube infrastructure — streaming-optimized — 1M+ Tbps capacity
  - 2.8.2.1.1 EdgeCacheService + EdgeCacheOrigin — separate resource model
  - 2.8.2.1.2 HTTP Range request coalescing — avoid origin stampede on cache miss

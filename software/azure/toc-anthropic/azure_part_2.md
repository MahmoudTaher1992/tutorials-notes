# Azure Complete Study Guide - Part 2: Networking & Connectivity (Phase 1 — Ideal)

## 2.0 Networking & Connectivity

### 2.1 Virtual Network (VNet) Architecture
#### 2.1.1 VNet Fundamentals
- 2.1.1.1 Software-defined network — VXLAN encapsulation — per-subscription isolation
  - 2.1.1.1.1 Address space — one or more CIDR blocks — IPv4 + IPv6 dual-stack
  - 2.1.1.1.2 VNet scope — single region — extend via peering or Global VNet Peering
- 2.1.1.2 VNet peering — direct backbone routing — low latency — no gateway
  - 2.1.1.2.1 Regional peering — same region — ingress/egress free
  - 2.1.1.2.2 Global VNet peering — cross-region — bandwidth charges apply
  - 2.1.1.2.3 No transitivity — hub-spoke requires UDR or Azure Firewall/NVA
- 2.1.1.3 VNet-to-VNet — over VPN Gateway — encrypted — cross-subscription

#### 2.1.2 Service Endpoints vs. Private Endpoints
- 2.1.2.1 Service Endpoints — extend VNet identity to PaaS — traffic on backbone
  - 2.1.2.1.1 Still uses public IP of service — no private IP on PaaS resource
  - 2.1.2.1.2 VNet firewall rule on service — allow specific VNet/subnet
- 2.1.2.2 Private Endpoints — NIC with private IP in VNet — true private access
  - 2.1.2.2.1 Private DNS Zone integration — automatic DNS override
  - 2.1.2.2.2 Disable public endpoint — force all traffic through private endpoint

### 2.2 Subnetting & Address Spaces
#### 2.2.1 Subnet Design
- 2.2.1.1 Azure reserved IPs — first 4 + last 1 — /24 = 251 usable
  - 2.2.1.1.1 .0 network, .1 gateway, .2/.3 DNS, .255 broadcast
- 2.2.1.2 Subnet delegation — dedicate subnet to a service — ACI, App Service, MySQL
  - 2.2.1.2.1 Only one delegation per subnet — exclusive use by delegated service
- 2.2.1.3 Application Gateway subnet — /24 minimum recommended — no other resources
- 2.2.1.4 Gateway subnet — required name "GatewaySubnet" — VPN/ExpressRoute GW
  - 2.2.1.4.1 Minimum /29 — /27 recommended for coexistence scenarios

#### 2.2.2 IPv6 in VNet
- 2.2.2.1 Dual-stack — /48 or /64 subnet — public + private IPv6
  - 2.2.2.1.1 IPv6 load balancer rules — separate frontend + backend pool rules
  - 2.2.2.1.2 No NAT64 — dual-stack VMs required for IPv6 communication

### 2.3 Routing & Traffic Engineering
#### 2.3.1 Effective Routes & UDR
- 2.3.1.1 System routes — default VNet local, 0.0.0.0/0 to internet
  - 2.3.1.1.1 Optional default routes — VPN/ExpressRoute propagated routes
- 2.3.1.2 User Defined Routes (UDR) — override system routes
  - 2.3.1.2.1 Next hop types — VirtualAppliance, VirtualNetworkGateway, Internet, None
  - 2.3.1.2.2 Force-tunneling — 0.0.0.0/0 → NVA — route all outbound via firewall
- 2.3.1.3 BGP route propagation — disable per subnet — prevent GW route override

#### 2.3.2 Azure Virtual WAN
- 2.3.2.1 Managed hub-spoke — hub VNets — automated routing — SD-WAN integration
  - 2.3.2.1.1 Standard vs. Basic Hub — Basic=VPN only, Standard=full routing
  - 2.3.2.1.2 Any-to-any routing — transit between spokes without UDR
- 2.3.2.2 Virtual Hub routing — route tables — labels — association + propagation
  - 2.3.2.2.1 Custom route tables — isolate workloads — security spoke separation

### 2.4 DNS
#### 2.4.1 Azure DNS Public Zones
- 2.4.1.1 Authoritative DNS — globally distributed Anycast — 100% SLA
  - 2.4.1.1.1 Alias records — point to Azure resources — auto IP update
  - 2.4.1.1.2 Supported types — A, AAAA, CNAME, MX, NS, PTR, SOA, SRV, TXT, CAA

#### 2.4.2 Azure Private DNS Zones
- 2.4.2.1 Name resolution within VNets — no custom DNS server needed
  - 2.4.2.1.1 Autoregistration — VMs auto-register A records on NIC assignment
  - 2.4.2.1.2 Link VNet to zone — registration vs. resolution link
- 2.4.2.2 Private resolver — inbound/outbound endpoints — hybrid DNS forwarding
  - 2.4.2.2.1 Forwarding ruleset — forward on-prem domains to on-prem DNS
  - 2.4.2.2.2 No custom DNS VMs needed — fully managed — zone redundant

### 2.5 Load Balancing
#### 2.5.1 Azure Load Balancer (Layer 4)
- 2.5.1.1 Standard SKU — zone-redundant — 99.99% SLA — always required
  - 2.5.1.1.1 Flow symmetry — 5-tuple hash — src/dst IP+port, protocol
  - 2.5.1.1.2 HA Ports — all ports/protocols — NVA behind LB — single rule
- 2.5.1.2 Health probes — HTTP/HTTPS/TCP — interval 5s, unhealthy threshold 2
  - 2.5.1.2.1 Probe-down behavior — all instances unhealthy → allow all traffic
- 2.5.1.3 Inbound NAT rules — port-forwarding to specific backend VM
  - 2.5.1.3.1 NAT rule v2 — VMSS backend pool — auto-assign ports per instance

#### 2.5.2 Azure Application Gateway (Layer 7)
- 2.5.2.1 HTTP/HTTPS/WebSocket/HTTP2 — SSL offload — WAF integration
  - 2.5.2.1.1 URL path-based routing — /images/* → image pool, /api/* → api pool
  - 2.5.2.1.2 Multi-site hosting — host header routing — multiple domains on one GW
- 2.5.2.2 Autoscaling v2 — min/max instances — 0 minimum supported
  - 2.5.2.2.1 Zone-redundant — V2 SKU — deploy across all AZs
- 2.5.2.3 Rewrite rules — request/response headers, URLs — regex capture groups
- 2.5.2.4 Connection draining — graceful backend removal — timeout configurable

#### 2.5.3 Azure Front Door (Global Layer 7)
- 2.5.3.1 Anycast PoPs — 118+ globally — Split TCP — TLS termination at edge
  - 2.5.3.1.1 AFD Standard vs. Premium — Premium adds WAF + Private Link origin
  - 2.5.3.1.2 Origin groups — load balancing + health probe — weighted routing
- 2.5.3.2 Rules engine — match conditions + actions — header manipulation, redirect
  - 2.5.3.2.1 Cache rules — TTL override — bypass per path — purge API
- 2.5.3.3 Azure CDN integration — static content caching — compression

#### 2.5.4 Azure Traffic Manager (DNS-based)
- 2.5.4.1 Routing methods — Priority, Weighted, Performance, Geographic, Subnet, Multivalue
  - 2.5.4.1.1 Nested profiles — combine methods — geographic + performance
  - 2.5.4.1.2 Real User Measurements (RUM) — JS snippet — improve latency routing

### 2.6 VPN Gateway & ExpressRoute
#### 2.6.1 Azure VPN Gateway
- 2.6.1.1 Site-to-site VPN — IKEv2/IKEv1 — BGP supported — active-active
  - 2.6.1.1.1 SKU tiers — Basic → VpnGw5AZ — throughput 100Mbps → 10Gbps
  - 2.6.1.1.2 Active-active — two public IPs — four tunnels — BGP ECMP
- 2.6.1.2 Point-to-site VPN — individual client — OpenVPN, IKEv2, SSTP
  - 2.6.1.2.1 Azure AD authentication — Entra ID — no certificates needed
  - 2.6.1.2.2 RADIUS + NPS — MFA integration for P2S connections

#### 2.6.2 Azure ExpressRoute
- 2.6.2.1 Private peering — on-prem to Azure VNets — L3 BGP — no internet
  - 2.6.2.1.1 Circuit SKUs — Local/Standard/Premium — regional vs. global reach
  - 2.6.2.1.2 Bandwidth 50Mbps–100Gbps — port speed at meet-me location
- 2.6.2.2 Microsoft peering — Azure PaaS + M365 — public BGP prefix advertisement
  - 2.6.2.2.1 Route filter — select BGP communities — restrict to needed services
- 2.6.2.3 ExpressRoute Global Reach — on-prem to on-prem via Azure backbone
- 2.6.2.4 ExpressRoute FastPath — bypass GW datapath — ultra-low latency
  - 2.6.2.4.1 Supported SKUs — Ultra Performance / ErGw3AZ only
  - 2.6.2.4.2 Private endpoint support — FastPath + Private Link — full bypass

### 2.7 Network Security
#### 2.7.1 Network Security Groups (NSGs)
- 2.7.1.1 Stateful — 5-tuple rules — priority 100–4096 — lower = higher priority
  - 2.7.1.1.1 Service tags — AzureLoadBalancer, Internet, VirtualNetwork — dynamic IPs
  - 2.7.1.1.2 Application Security Groups (ASGs) — group VMs by role — no IP management
- 2.7.1.2 NSG flow logs v2 — traffic analytics — Log Analytics workspace
  - 2.7.1.2.1 Traffic Analytics — geo-map, port distribution, top talkers

#### 2.7.2 Azure Firewall
- 2.7.2.1 Stateful managed firewall — L3-L7 — FQDN filtering — IDPS
  - 2.7.2.1.1 Standard vs. Premium — Premium adds TLS inspection + IDPS signatures
  - 2.7.2.1.2 IDPS — 58,000+ signatures — alert or deny mode
- 2.7.2.2 Firewall Policy — hierarchical — parent + child — DevOps-friendly
  - 2.7.2.2.1 Rule collection groups → rule collections → rules — priority ordering
  - 2.7.2.2.2 DNS proxy — resolve FQDN rules — clients point to firewall for DNS
- 2.7.2.3 Forced tunneling — dedicated management subnet — no UDR interference

### 2.8 CDN & Edge Delivery
#### 2.8.1 Azure CDN
- 2.8.1.1 Microsoft CDN (Classic) — standard features — static content
- 2.8.1.2 Edgio/Verizon CDN (legacy) — advanced rules — sunset migration to AFD
- 2.8.1.3 Azure Front Door as CDN replacement — unified platform recommendation
  - 2.8.1.3.1 Rules engine — cache TTL, redirect, URL rewrite — per route
  - 2.8.1.3.2 Origin Shield — centralized caching — reduce origin load

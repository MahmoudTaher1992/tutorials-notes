# AWS Complete Study Guide - Part 2: Networking & Connectivity (Phase 1 — Ideal)

## 2.0 Networking & Connectivity

### 2.1 Virtual Network Architecture
#### 2.1.1 Network Segmentation Model
- 2.1.1.1 Overlay network — virtual switch (vSwitch) encapsulating physical fabric
  - 2.1.1.1.1 VXLAN encapsulation — 24-bit VNI, 16M isolated segments
  - 2.1.1.1.2 Geneve encapsulation — extensible TLV metadata for advanced routing
- 2.1.1.2 Network namespace isolation — per-VM kernel namespace, separate routing table
  - 2.1.1.2.1 veth pair — kernel virtual Ethernet — connects namespace to bridge

#### 2.1.2 VPC Architecture
- 2.1.2.1 VPC boundary — hard isolation — no default inter-VPC routing
  - 2.1.2.1.1 VPC CIDR range — /16 to /28 — IPv4 and/or IPv6 dual-stack
  - 2.1.2.1.2 Secondary CIDRs — add up to 5 additional IPv4 ranges post-creation
- 2.1.2.2 Internet Gateway (IGW) — horizontally scaled, no bandwidth cap
  - 2.1.2.2.1 Implicit router — VPC route table 0.0.0.0/0 → IGW
- 2.1.2.3 Egress-Only IGW — IPv6 outbound only — stateful, blocks inbound

### 2.2 Subnetting & CIDR
#### 2.2.1 Subnet Design Patterns
- 2.2.1.1 Public subnet — route table has 0.0.0.0/0 → IGW
  - 2.2.1.1.1 Auto-assign public IPv4 — NAT not required — direct internet path
- 2.2.1.2 Private subnet — route table has 0.0.0.0/0 → NAT Gateway
  - 2.2.1.2.1 NAT Gateway — managed, AZ-scoped — $0.045/hr + $0.045/GB
  - 2.2.1.2.2 NAT instance — self-managed EC2, source/dest check disabled
- 2.2.1.3 Isolated subnet — no route to internet — DB/secrets tier

#### 2.2.2 AWS Reserved IPs per Subnet
- 2.2.2.1 First 4 + last 1 IPs reserved — /24 gives 251 usable addresses
  - 2.2.2.1.1 .0 network, .1 VPC router, .2 DNS, .3 future, .255 broadcast

#### 2.2.3 IPv6 in VPC
- 2.2.3.1 AWS-assigned /56 per VPC, /64 per subnet — globally routable
  - 2.2.3.1.1 No NAT for IPv6 — all addresses publicly routable
  - 2.2.3.1.2 Dual-stack vs. IPv6-only subnets — EC2 Instance Connect Endpoint required

### 2.3 Routing & Traffic Engineering
#### 2.3.1 Route Tables
- 2.3.1.1 Implicit local route — VPC CIDR always wins (most specific)
  - 2.3.1.1.1 Longest prefix match — /32 beats /24 beats /16
- 2.3.1.2 Route propagation — VGW propagates BGP routes automatically
- 2.3.1.3 Gateway Route Tables — applied to IGW/VGW for ingress routing (GWLB)

#### 2.3.2 Transit Gateway
- 2.3.2.1 Regional hub — connect VPCs, VPNs, Direct Connect — up to 5000 attachments
  - 2.3.2.1.1 TGW Route Tables — multiple per TGW — segment traffic domains
  - 2.3.2.1.2 Blackhole routes — drop traffic to specific CIDRs
- 2.3.2.2 TGW Peering — cross-region, static routes, no route propagation
  - 2.3.2.2.1 Bandwidth — 50Gbps per VPC attachment aggregate

#### 2.3.3 VPC Peering
- 2.3.3.1 Direct encrypted link — no transitive routing
  - 2.3.3.1.1 No edge-to-edge routing — cannot use VGW/NAT/IGW of peer
  - 2.3.3.1.2 Cross-account, cross-region peering — requester/accepter model

### 2.4 DNS Resolution
#### 2.4.1 Route 53 Resolver
- 2.4.1.1 VPC DNS Server — 169.254.169.253 / VPC+2 address
  - 2.4.1.1.1 enableDnsSupport — required for DNS in VPC
  - 2.4.1.1.2 enableDnsHostnames — assigns public/private DNS names to instances
- 2.4.1.2 Resolver Endpoints — inbound/outbound for hybrid DNS
  - 2.4.1.2.1 Inbound endpoint — on-prem DNS queries AWS private hosted zones
  - 2.4.1.2.2 Outbound endpoint — Route 53 forwards to on-prem DNS servers
  - 2.4.1.2.3 Resolver Rules — forward rules, system rules, recursive resolver

#### 2.4.2 Route 53 Record Types & Routing Policies
- 2.4.2.1 A / AAAA / CNAME / MX / TXT / SRV / NS / SOA
- 2.4.2.2 Alias records — point to AWS resources, free queries, apex support
  - 2.4.2.2.1 Alias targets — ALB, NLB, CloudFront, S3, API GW, Elastic IPs
- 2.4.2.3 Routing policies
  - 2.4.2.3.1 Simple — single resource, no health check
  - 2.4.2.3.2 Weighted — A/B traffic split, 0 weight = disabled
  - 2.4.2.3.3 Latency-based — route to lowest-latency AWS region
  - 2.4.2.3.4 Geolocation — country/continent granularity, default required
  - 2.4.2.3.5 Geoproximity — bias offset ±99, Traffic Flow required
  - 2.4.2.3.6 Failover — primary/secondary with health checks
  - 2.4.2.3.7 Multivalue — up to 8 healthy IPs, client-side LB

### 2.5 Load Balancing
#### 2.5.1 Application Load Balancer (ALB)
- 2.5.1.1 Layer 7 — HTTP/HTTPS/HTTP2/WebSocket/gRPC routing
  - 2.5.1.1.1 Content-based routing — host, path, header, query string, source IP
  - 2.5.1.1.2 Lambda targets — invoke Lambda directly as ALB target
- 2.5.1.2 Listener rules — up to 100 rules per listener — priority-ordered
  - 2.5.1.2.1 Authenticate action — OIDC / Cognito integration
  - 2.5.1.2.2 Redirect action — HTTP → HTTPS forced redirect at LB layer
- 2.5.1.3 Sticky sessions — duration-based or application-based cookies
  - 2.5.1.3.1 AWSALB cookie — LB-generated, 1s–7d TTL
  - 2.5.1.3.2 AWSALBAPP cookie — application-controlled stickiness

#### 2.5.2 Network Load Balancer (NLB)
- 2.5.2.1 Layer 4 — TCP/UDP/TLS — ultra-low latency (<100μs)
  - 2.5.2.1.1 Static IP per AZ — Elastic IP assignment for IP whitelisting
  - 2.5.2.1.2 Preserve source IP — no SNAT for EC2 targets (direct client IP)
- 2.5.2.2 PrivateLink — expose services via NLB without VPC peering

#### 2.5.3 Gateway Load Balancer (GWLB)
- 2.5.3.1 Layer 3 — IP — transparent inline bump-in-the-wire for appliances
  - 2.5.3.1.1 GENEVE encapsulation — port 6081 — metadata in TLV headers
  - 2.5.3.1.2 GWLB Endpoint — route table intercept before IGW

### 2.6 VPN & Private Connectivity
#### 2.6.1 Site-to-Site VPN
- 2.6.1.1 Two IPSec tunnels per connection — AZ redundancy
  - 2.6.1.1.1 IKEv2 — preferred — dead peer detection, rekey intervals
  - 2.6.1.1.2 BGP routing — dynamic route exchange over VPN tunnel
  - 2.6.1.1.3 Bandwidth cap — 1.25Gbps per tunnel (ECMP for higher throughput)
- 2.6.1.2 Accelerated VPN — Global Accelerator anycast — reduced latency

#### 2.6.2 AWS Direct Connect (DX)
- 2.6.2.1 Dedicated connection — 1/10/100Gbps — physical cross-connect at DX location
  - 2.6.2.1.1 Hosted connection — partner-provisioned, 50Mbps–10Gbps
  - 2.6.2.1.2 Virtual Interfaces (VIFs) — Private VIF, Public VIF, Transit VIF
- 2.6.2.2 Direct Connect Gateway — connect DX to multiple VPCs / TGW
  - 2.6.2.2.1 BGP AS path — private ASN 64512–65534 for Private VIF
  - 2.6.2.2.2 MACsec — Layer 2 encryption — 802.1AE on dedicated connections

### 2.7 Network Security Controls
#### 2.7.1 Security Groups (SGs)
- 2.7.1.1 Stateful — return traffic automatically allowed
  - 2.7.1.1.1 Default allow-all egress — best practice: restrict outbound
  - 2.7.1.1.2 Reference SG in rules — dynamic membership — no IP management
- 2.7.1.2 Limits — 5 SGs per ENI, 60 inbound + 60 outbound rules per SG

#### 2.7.2 Network ACLs (NACLs)
- 2.7.2.1 Stateless — must allow both inbound and outbound for a flow
  - 2.7.2.1.1 Rule evaluation order — lowest number first — first match wins
  - 2.7.2.1.2 Ephemeral ports — 1024–65535 — required for stateless response

#### 2.7.3 VPC Flow Logs
- 2.7.3.1 Capture metadata — src/dst IP, port, protocol, bytes, action, reason
  - 2.7.3.1.1 Destinations — CloudWatch Logs, S3, Kinesis Data Firehose
  - 2.7.3.1.2 Custom format — select specific fields, Parquet for Athena query

### 2.8 CDN & Edge Delivery
#### 2.8.1 CloudFront Architecture
- 2.8.1.1 Edge locations — 450+ globally — cache static & dynamic content
  - 2.8.1.1.1 Regional Edge Caches (RECs) — 13 — secondary cache tier, larger TTL
  - 2.8.1.1.2 Cache key — URL + selected headers/cookies/query strings
- 2.8.1.2 Origin types — S3, ALB, NLB, API GW, HTTP custom origin
  - 2.8.1.2.1 Origin Shield — centralized caching layer — reduce origin load 80%+
  - 2.8.1.2.2 Origin failover — primary + secondary with 5xx failover trigger
- 2.8.1.3 CloudFront Functions vs. Lambda@Edge
  - 2.8.1.3.1 CF Functions — <1ms, viewer request/response, JS only, 10KB limit
  - 2.8.1.3.2 Lambda@Edge — 5s/30s limits, origin req/resp, full Node/Python

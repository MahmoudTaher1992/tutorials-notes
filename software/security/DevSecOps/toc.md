# DevSecOps: Comprehensive Study Table of Contents

## Part I: Foundations, Culture & Prerequisites

### A. Introduction to DevSecOps
- **DevOps vs. DevSecOps**: The cultural shift
- The "Shift Left" Philosophy
- Breaking Silos: Development, Security, and Operations
- **The CIA Triad**: Confidentiality, Integrity, Availability
- **Defense in Depth**: Layered security strategies
- **Zero Trust Architecture**: Never trust, always verify
- **Least Privilege Principle**: Minimizing access rights

### B. Operating Systems & Editors
- **Linux Fundamentals**: File systems, permissions (`chmod`, `chown`), processes
- **Text Editors**: Vim / Nano / Emacs (Editing config files on servers)
- **Virtualization Basics**: Hypervisors and VMs

### C. Programming & Scripting Skills
- **Scripting for Automation**:
  - **Bash**: Shell scripting, cron jobs, piping, grep/sed/awk
  - **PowerShell**: Windows administration and automation
- **Programming Languages** (Choose one high-level + one systems level):
  - **Python**: Scripting, automation tools, data analysis
  - **Ruby**: Legacy Puppet/Chef, scripting
  - **Go (Golang)**: Cloud-native tools, high performance
  - **Rust**: Memory safety, secure systems programming
  - **JavaScript / Node.js**: Understanding modern web apps
- **Reading Code**: Ability to review code for vulnerabilities

## Part II: Networking & Infrastructure Security

### A. Networking Basics
- **OSI Model**: Layers 1-7 Deep Dive
- **Core Protocols**: TCP/IP, UDP, ICMP, ARP
- **DNS**: Records, Zone Transfers, DNS Security (DNSSEC)
- **HTTP/HTTPS**: Methods, Headers, Status Codes, State
- **TLS/SSL**: Handshakes, Certificates, Forward Secrecy

### B. Network Defense & Segmentation
- **Firewalls**: Stateful vs. Stateless, WAF (Web Application Firewall)
- **Network Segmentation**: DMZ, Subnetting, Security Groups
- **VLANs**: Virtual LANs and trunking
- **ACLs** (Access Control Lists): Inbound/Outbound rules
- **Secure Network Zoning**: Isolating critical assets
- **DDoS Mitigation Strategies**: Rate limiting, blackholing, scrubbing

### C. Network Scanning & Reconnaissance
- **Nmap Basics**: Port scanning, service version detection, OS fingerprinting
- **Wireshark**: Packet capture and traffic analysis
- **Netcat / Socat**: Networking utility Swiss-army knives

## Part III: Cryptography & Identity Management

### A. Cryptography Fundamentals
- **Symmetric Encryption**: AES, ChaCha20
- **Asymmetric Encryption**: RSA, ECC (Elliptic Curve)
- **Hashing Algorithms**: SHA-256, MD5 (legacy), Collisions
- **Salting & Hashing Passwords**: bcrypt, Argon2, PBKDF2
- **PKI (Public Key Infrastructure)**:
  - Certificate Authorities (CA)
  - Certificate Lifecycle Management
  - PKI Design and Failover

### B. Identity and Access Management (IAM)
- **Authentication (AuthN) vs. Authorization (AuthZ)**
- **IAM Core Concepts**: Users, Groups, Roles, Policies
- **Role-Based Access Control (RBAC)**
- **Multi-Factor Authentication (MFA/2FA)**
- **Large Scale Identity Strategy**: SSO (Single Sign-On), Federation (SAML, OIDC)
- **Key Management Services (KMS)**: Managing secrets and rotation

## Part IV: Application Security (AppSec)

### A. Web Application Security
- **OWASP Top 10**: Deep dive into the most critical risks
  - Injection (SQL, NoSQL, OS Command)
  - Broken Access Control
  - Cryptographic Failures
  - Insecure Design
  - Security Misconfiguration
- **Vulnerability Prevention**:
  - **SQL Injection Prevention**: Prepared Statements, ORMs
  - **XSS Prevention**: Content Security Policy (CSP), Output Encoding
  - **Input Validation Patterns**: Whitelisting vs. Blacklisting

### B. Secure Coding & Design
- **Secure API Design**: REST, GraphQL, Rate Limiting, Token Management
- **Security Headers**: HSTS, X-Frame-Options, X-Content-Type-Options
- **Dependency Risk Management**:
  - Supply Chain Security
  - SCA (Software Composition Analysis)
  - Managing CVEs in libraries

### C. AppSec Tools
- **Burp Suite**: Proxy setup, Repeater, Intruder (Web assessment)
- **SAST (Static Application Security Testing)**: Code scanning (e.g., SonarQube)
- **DAST (Dynamic Application Security Testing)**: Runtime scanning (e.g., OWASP ZAP)

## Part V: Cloud & Container Security

### A. Container Security (Docker & Kubernetes)
- **Docker Security**:
  - Image Scanning (Trivy, Clair)
  - Dockerfile Best Practices (User privileges, multi-stage builds)
  - Trusted Registries
- **Kubernetes (K8s) Security**:
  - RBAC in K8s
  - Network Policies (Pod-to-Pod communication)
  - Secrets Management
  - Admission Controllers

### B. Cloud Security Posture
- **Cloud Providers**: AWS / Azure / GCP Security Models
- **Shared Responsibility Model**
- **CSPM**: Cloud Security Posture Management tools
- **Multi-Region Security Planning**: Replication and compliance data residency
- **Infrastructure as Code (IaC) Security**: Scanning Terraform/CloudFormation (e.g., Checkov)

## Part VI: Threat Modeling & Architecture

### A. Threat Modeling Methodologies
- **STRIDE**: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege
- **PASTA**: Process for Attack Simulation and Threat Analysis
- **Attack Surface Mapping**: Identifying entry points
- **Threat Modeling Workflows**: Integrating into the design phase

### B. Secure Architecture
- **Fail Securely**: Error handling without info leaks
- **Separation of Duties**
- **Audit & Compliance Mapping**: Ensuring architecture meets regs

## Part VII: CI/CD & Pipeline Security

### A. Build Pipeline Hardening
- **Securing the CI/CD Toolchain**: Jenkins, GitHub Actions, GitLab CI
- **Automated Security Gates**: Breaking builds on vulnerability detection
- **Secret Management in Pipelines**: HashiCorp Vault, GitHub Secrets (avoiding hardcoded keys)
- **SBOMs (Software Bill of Materials)**: Generating and verifying artifacts
- **Artifact Signing**: Sigstore, Cosign

### B. Automated Testing & Remediation
- **Vulnerability Scanning Tools**: Nessus, OpenVAS, Qualys
- **Automated Patching**: Strategies for OS and Dependencies

## Part VIII: Operations, Monitoring & Response

### A. Monitoring & Logging
- **Log Analysis**: Centralized logging (ELK Stack, Splunk)
- **SIEM (Security Information and Event Management)**:
  - Alert Types and Tuning
  - Correlation Rules
- **IDS / IPS**: Intrusion Detection vs. Prevention Systems

### B. Incident Response (IR)
- **IR Lifecycle**: Preparation, Identification, Containment, Eradication, Recovery, Lessons Learned
- **Forensics**:
  - Memory and Disk Forensics
  - Chain of Custody
- **Root Cause Analysis (RCA)**: The "5 Whys"
- **Enterprise Operations Response Strategy**: Escalation matrices and War Rooms

### C. Security Orchestration (SOAR)
- **SOAR Concepts**: Automation and Response
- **EDR Strategy**: Endpoint Detection and Response agents (CrowdStrike, SentinelOne)

## Part IX: Governance, Risk, and Compliance (GRC)

### A. Frameworks and Standards
- **NIST Cybersecurity Framework (CSF)**: Identify, Protect, Detect, Respond, Recover
- **ISO 27001**: Information Security Management
- **SOC 2**: Service Organization Control (Trust Service Criteria)
- **GDPR / HIPAA / PCI-DSS**: Regulatory compliance overview

### B. Risk Management
- **Risk Quantification**: Qualitative vs. Quantitative analysis
- **Audit Trails**: Ensuring non-repudiation in logs
- **Supply Chain Security**: Managing 3rd party vendor risk
Here is the bash script to generate the Cyber Security study notes hierarchy.

You can save this as a file (e.g., `setup_cyber_study.sh`), give it execution permissions (`chmod +x setup_cyber_study.sh`), and run it.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Cyber-Security-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"

echo "Creating directory structure for Cyber Security Study..."

# ==============================================================================
# Part I: Foundational IT & Systems Knowledge
# ==============================================================================
DIR_001="$ROOT_DIR/001-Foundational-IT-Systems-Knowledge"
mkdir -p "$DIR_001"

# A. Core IT Fundamentals
cat > "$DIR_001/001-Core-IT-Fundamentals.md" <<EOF
# Core IT Fundamentals

- **Computer Hardware Components**: CPU, RAM, Storage (HDD/SSD), Motherboard, NIC.
- **Connection Types**: Ethernet, Fiber Optic, USB, Thunderbolt; understand their function and security implications.
- **Operating Systems Concepts**: Kernel vs. User space, Processes, Threads, Memory Management.
- **Basics of Virtualization**:
    - Core Concepts: Hypervisor (Type 1 vs. Type 2), VM, Host OS, Guest OS.
    - Common Technologies: VMware (Workstation, ESXi), VirtualBox, Proxmox, Hyper-V.
- **Troubleshooting Methodologies**: The universal problem-solving approach (Identify, Theorize, Test, Establish Plan, Verify, Document).
EOF

# B. Operating Systems Proficiency
cat > "$DIR_001/002-Operating-Systems-Proficiency.md" <<EOF
# Operating Systems Proficiency

- **Common Operating Systems**: Windows, Linux, MacOS.
    - **Installation & Configuration**: Setting up a secure baseline installation.
    - **Navigating the System**: Mastery of both GUI and Command-Line Interface (CLI).
        - Windows: Command Prompt & PowerShell.
        - Linux: Bash/Zsh (e.g., ls, cd, grep, find, chmod, chown).
    - **File Systems & Permissions**: NTFS (Windows) vs. ext4 (Linux); understanding ACLs, user/group ownership.
    - **Software & Package Management**: apt, yum, dnf (Linux), Chocolatey/Winget (Windows), Homebrew (MacOS).
    - **System Processes & Services**: Viewing, managing, and securing running services.
EOF


# ==============================================================================
# Part II: Networking Essentials
# ==============================================================================
DIR_002="$ROOT_DIR/002-Networking-Essentials"
mkdir -p "$DIR_002"

# A. Core Concepts & Models
cat > "$DIR_002/001-Core-Concepts-Models.md" <<EOF
# Core Concepts & Models

- **The OSI & TCP/IP Models**: Understanding layers and data encapsulation.
- **IP Addressing**:
    - Public vs. Private IP Addresses (RFC 1918).
    - IPv4 vs. IPv6.
    - Subnetting: CIDR notation, subnet masks, calculating network ranges.
    - Key Terminology: localhost/loopback, default gateway.
- **Network Topologies**: Star, Ring, Mesh, Bus, Hybrid.
- **Network Hardware & Concepts**: Router, Switch, Firewall, Access Point.
- **Network Segments**: LAN, WAN, WLAN, MAN, DMZ, VLAN.
EOF

# B. Key Protocols & Services
cat > "$DIR_002/002-Key-Protocols-Services.md" <<EOF
# Key Protocols & Services

- **Core Services & Functions**:
    - **DHCP**: Dynamic Host Configuration Protocol.
    - **DNS**: Domain Name System (A, AAAA, CNAME, MX, TXT records; DNS Poisoning).
    - **NTP**: Network Time Protocol.
    - **ARP**: Address Resolution Protocol (ARP Poisoning).
- **Common Protocols, their Ports & Security**:
    - **Web**: HTTP (80) vs. HTTPS (443).
    - **Remote Access**: SSH (22), RDP (3389), Telnet (23 - insecure).
    - **File Transfer**: FTP (20, 21), SFTP (22), SMB (445).
    - **Email**: SMTP (25, 587), POP3 (110), IMAP (143).
- **Authentication Protocols**: Kerberos, RADIUS, LDAP, SSO.
EOF

# C. Essential Networking Tools
cat > "$DIR_002/003-Essential-Networking-Tools.md" <<EOF
# Essential Networking Tools

- **Diagnostic Tools**: ping, ipconfig/ifconfig, netstat, tracert/traceroute, route.
- **DNS Enumeration**: nslookup, dig, host.
- **Packet Analysis**:
    - **Packet Sniffers**: Wireshark, tcpdump.
    - **Packet Crafting**: hping, scapy.
- **Port Scanners & Network Mapping**: nmap.
EOF


# ==============================================================================
# Part III: Core Security Principles & Concepts
# ==============================================================================
DIR_003="$ROOT_DIR/003-Core-Security-Principles-Concepts"
mkdir -p "$DIR_003"

# A. The Security Mindset
cat > "$DIR_003/001-The-Security-Mindset.md" <<EOF
# The Security Mindset

- **The CIA Triad**: Confidentiality, Integrity, Availability.
- **Authentication vs. Authorization**: Who you are vs. what you are allowed to do.
- **Defense in Depth**: Layered security approach.
- **Zero Trust Architecture**: "Never trust, always verify."
- **Risk Management**: Defining Risk, Threat, Vulnerability.
- **The Human Element**: Social Engineering, Insider Threats.
EOF

# B. Cryptography Fundamentals
cat > "$DIR_003/002-Cryptography-Fundamentals.md" <<EOF
# Cryptography Fundamentals

- **Core Concepts**: Hashing, Salting, Obfuscation, Encryption.
- **Symmetric vs. Asymmetric Encryption**: Shared secrets vs. public/private key pairs.
- **Public Key Infrastructure (PKI)**: Certificates, Certificate Authorities (CAs).
- **Secure Communication**: SSL/TLS Handshake, Key Exchange.
EOF

# C. Threat Modeling & Intelligence
cat > "$DIR_003/003-Threat-Modeling-Intelligence.md" <<EOF
# Threat Modeling & Intelligence

- **Cyber Kill Chain**: The 7 stages of an attack.
- **MITRE ATT&CK Framework**: A global knowledge base of adversary tactics and techniques.
- **The Diamond Model of Intrusion Analysis**.
- **Threat Intelligence**:
    - OSINT (Open-Source Intelligence).
    - Indicators of Compromise (IoCs).
- **Threat Classification**: APT, Zero-Day, Known vs. Unknown Threats.
EOF

# D. The Teams & Roles
cat > "$DIR_003/004-The-Teams-Roles.md" <<EOF
# The Teams & Roles

- **Blue Team**: Defense, hardening, monitoring.
- **Red Team**: Offensive, simulating attacks, penetration testing.
- **Purple Team**: Collaboration between Blue and Red teams.
- **Compliance & Auditors**: Ensuring adherence to standards and regulations.
EOF


# ==============================================================================
# Part IV: Offensive Security (The Red Team Perspective)
# ==============================================================================
DIR_004="$ROOT_DIR/004-Offensive-Security"
mkdir -p "$DIR_004"

# A. The Pentesting Lifecycle
cat > "$DIR_004/001-The-Pentesting-Lifecycle.md" <<EOF
# The Pentesting Lifecycle

- Rules of Engagement & Scoping.
- **Reconnaissance**: Passive (OSINT) and Active (Scanning).
- **Scanning & Enumeration**: Using tools like nmap to find open ports, services, and vulnerabilities.
- **Gaining Access (Exploitation)**: Exploiting vulnerabilities to get a foothold.
- **Maintaining Access**: Persistence techniques.
- **Privilege Escalation**: Moving from a low-privilege user to an admin/root user.
- **Covering Tracks**: Removing logs and evidence of presence.
EOF

# B. Common Attack Vectors & Vulnerabilities
cat > "$DIR_004/002-Common-Attack-Vectors-Vulnerabilities.md" <<EOF
# Common Attack Vectors & Vulnerabilities

- **Social Engineering**: Phishing, Vishing, Smishing, Whaling, Tailgating, Dumpster Diving.
- **Web-Based Attacks (OWASP Top 10)**: SQL Injection, Cross-Site Scripting (XSS), CSRF, Directory Traversal.
- **Network Attacks**: DoS vs. DDoS, Man-in-the-Middle (MITM), Spoofing, Evil Twin, Deauthentication Attack.
- **Application & System Attacks**: Buffer Overflow, Memory Leak, Pass the Hash.
- **Malware**:
    - **Types**: Virus, Worm, Trojan, Ransomware, Spyware, Adware, Rootkit.
    - **Analysis**: Understanding how malware works (static and dynamic analysis).
EOF

# C. Essential Hacking Tools & Frameworks
cat > "$DIR_004/003-Essential-Hacking-Tools-Frameworks.md" <<EOF
# Essential Hacking Tools & Frameworks

- **Distributions**: Kali Linux, ParrotOS.
- **Exploitation Frameworks**: Metasploit.
- **Web Proxies**: Burp Suite, OWASP ZAP.
- **Living Off The Land**: LOLBAS, GTFOBINS, WADCOMS (using legitimate tools for malicious purposes).
EOF


# ==============================================================================
# Part V: Defensive Security (The Blue Team Perspective)
# ==============================================================================
DIR_005="$ROOT_DIR/005-Defensive-Security"
mkdir -p "$DIR_005"

# A. System & Network Hardening
cat > "$DIR_005/001-System-Network-Hardening.md" <<EOF
# System & Network Hardening

- **Operating System Hardening**: Removing unnecessary services, applying security policies (GPO), configuring firewalls.
- **Patch Management**: The process of applying updates to fix vulnerabilities.
- **Access Control**:
    - Principle of Least Privilege.
    - Network Access Control (NAC): MAC-based, 802.1x.
    - Access Control Lists (ACLs).
- **Secure Protocols**: Prioritizing SFTP over FTP, HTTPS over HTTP, DNSSEC, LDAPS.
- **Endpoint Security**: EDR, Antivirus/Antimalware, HIPS.
EOF

# B. Detection & Monitoring
cat > "$DIR_005/002-Detection-Monitoring.md" <<EOF
# Detection & Monitoring

- **Log Analysis**: Event Logs, syslog, NetFlow, Firewall Logs, Packet Captures.
- **Intrusion Detection/Prevention Systems**: IDS (detects) vs. IPS (prevents); NIDS/NIPS vs. HIDS/HIPS.
- **Security Information & Event Management (SIEM)**: Aggregating and correlating logs.
- **Security Orchestration, Automation, & Response (SOAR)**.
- **Deception Technology**: Honeypots.
EOF

# C. Incident Response (IR)
cat > "$DIR_005/003-Incident-Response.md" <<EOF
# Incident Response (IR)

- **The IR Process**:
    1.  **Preparation**: Being ready before an incident.
    2.  **Identification**: Detecting a security event.
    3.  **Containment**: Isolating affected systems.
    4.  **Eradication**: Removing the threat.
    5.  **Recovery**: Restoring systems to normal operation.
    6.  **Lessons Learned**: Post-incident analysis.
- **Metrics**: False Positive, False Negative, True Positive, True Negative.
EOF

# D. Digital Forensics Basics
cat > "$DIR_005/004-Digital-Forensics-Basics.md" <<EOF
# Digital Forensics Basics

- **Principles**: Chain of Custody, Data Integrity.
- **Tools**: Autopsy, FTK Imager, memdump, dd, Wireshark.
- **Analysis**: Examining disk images, memory dumps, and network captures for evidence.
EOF


# ==============================================================================
# Part VI: Governance, Risk & Compliance (GRC)
# ==============================================================================
DIR_006="$ROOT_DIR/006-Governance-Risk-Compliance"
mkdir -p "$DIR_006"

# A. Security Frameworks & Standards
cat > "$DIR_006/001-Security-Frameworks-Standards.md" <<EOF
# Security Frameworks & Standards

- **NIST Cybersecurity Framework (CSF)**.
- **NIST Risk Management Framework (RMF)**.
- **ISO 27001/27002**: Information Security Management.
- **CIS Controls & Benchmarks**: Prescriptive guides for hardening systems.
EOF

# B. Communication & Reporting
cat > "$DIR_006/002-Communication-Reporting.md" <<EOF
# Communication & Reporting

- Understanding the audience: Stakeholders, Management, HR, Legal.
- Creating effective reports and runbooks.
- Backup and resiliency planning.
EOF


# ==============================================================================
# Part VII: Specialized & Advanced Domains
# ==============================================================================
DIR_007="$ROOT_DIR/007-Specialized-Advanced-Domains"
mkdir -p "$DIR_007"

# A. Cloud Security
cat > "$DIR_007/001-Cloud-Security.md" <<EOF
# Cloud Security

- **Cloud Models**: IaaS, PaaS, SaaS.
- **Deployment Models**: Private, Public, Hybrid.
- **Major Providers**: AWS, Azure, GCP (understanding their core security models).
- **Cloud vs. On-Premises**: Shared Responsibility Model.
- **Infrastructure as Code (IaC)**: Securing Terraform, CloudFormation.
- **Serverless & Container Security**: Docker, Kubernetes.
EOF

# B. Programming & Scripting for Security
cat > "$DIR_007/002-Programming-Scripting-for-Security.md" <<EOF
# Programming & Scripting for Security

- **Python**: Automation, tool development, data analysis.
- **Bash/PowerShell**: System administration, automation, "living off the land."
- **Go / C++**: Performance-critical tools, reverse engineering, exploit development.
- **JavaScript**: Understanding web exploits and browser security.
EOF

# C. Advanced Topics
cat > "$DIR_007/003-Advanced-Topics.md" <<EOF
# Advanced Topics

- **Reverse Engineering**: Decompiling and analyzing software.
- **Vulnerability Management**: Scanning, identifying, and prioritizing vulnerabilities.
- **Threat Hunting**: Proactively searching for threats instead of waiting for alerts.
EOF


# ==============================================================================
# Part VIII: Career Development & Continuous Learning
# ==============================================================================
DIR_008="$ROOT_DIR/008-Career-Development-Continuous-Learning"
mkdir -p "$DIR_008"

# A. Hands-On Practice
cat > "$DIR_008/001-Hands-On-Practice.md" <<EOF
# Hands-On Practice

- **Capture The Flag (CTF) Platforms**:
    - picoCTF (Beginner-friendly).
    - TryHackMe (Guided learning).
    - HackTheBox, VulnHub (Challenge-based).
- **Online Analysis Tools**: VirusTotal, any.run, Joe Sandbox, urlscan.io.
EOF

# B. Certifications Path
cat > "$DIR_008/002-Certifications-Path.md" <<EOF
# Certifications Path

- **Beginner Certifications**: CompTIA A+, Network+, Security+.
- **Intermediate/Specialist**: CCNA, CompTIA Linux+, CEH, GSEC, OSCP.
- **Advanced/Managerial**: CISSP, CISA, CISM.
EOF

# C. Staying Current
cat > "$DIR_008/003-Staying-Current.md" <<EOF
# Staying Current

- Following security news sites, blogs, and researchers.
- Attending conferences (e.g., DEF CON, Black Hat).
- Continuously practicing and exploring new technologies.
EOF

echo "Done! Structure created in directory: $ROOT_DIR"
```

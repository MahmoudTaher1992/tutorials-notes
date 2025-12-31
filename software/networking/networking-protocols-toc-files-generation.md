Here is the bash script to generate the folder and file structure based on your Table of Contents.

### Instructions:
1.  Save the code below into a file named `setup_study_guide.sh`.
2.  Open your terminal.
3.  Make the script executable: `chmod +x setup_study_guide.sh`
4.  Run the script: `./setup_study_guide.sh`

```bash
#!/bin/bash

# Root Directory Name
ROOT_DIR="Networking-Protocols-Study-Guide"

# Create Root Directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

# ==========================================
# PART I: Foundational Concepts & The OSI Model
# ==========================================
PART_DIR="001-Foundational-Concepts-and-The-OSI-Model"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Introduction-to-Networking-Protocols.md"
# Introduction to Networking Protocols

- The Role of Protocols in Network Communication
- Standardization Bodies (IETF, IEEE)
- Circuit-Switching vs. Packet-Switching
- Connection-Oriented vs. Connectionless Protocols
EOF

# Section B
cat <<EOF > "$PART_DIR/002-The-OSI-Model-A-Layered-Framework.md"
# The OSI Model: A Layered Framework

- Purpose and Benefits of a Layered Architecture.
- The 7 Layers of the OSI Model.
  - **Layer 7: Application Layer**: User-facing services (HTTP, FTP, SMTP).
  - **Layer 6: Presentation Layer**: Data translation, encryption, and compression.
  - **Layer 5: Session Layer**: Manages sessions between applications.
  - **Layer 4: Transport Layer**: End-to-end communication and data flow control (TCP, UDP).
  - **Layer 3: Network Layer**: Logical addressing and routing (IP).
  - **Layer 2: Data Link Layer**: Node-to-node data transfer and error correction.
  - **Layer 1: Physical Layer**: The physical connection between devices.
- Data Encapsulation and Decapsulation Process.
- TCP/IP Model vs. OSI Model
EOF

# ==========================================
# PART II: Core Internet Protocols
# ==========================================
PART_DIR="002-Core-Internet-Protocols"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Domain-Name-System-DNS.md"
# Domain Name System (DNS)

- The "Phonebook of the Internet": Purpose and Function.
- DNS Hierarchy: Root, TLD, and Authoritative Servers.
- The 8 Steps of a DNS Lookup.
- DNS Caching: Local and Remote
- DNS Record Types (A, AAAA, CNAME, MX, TXT)
- Recursive vs. Authoritative DNS Servers.
- DNS Security (DNSSEC)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Hypertext-Transfer-Protocol-HTTP.md"
# Hypertext Transfer Protocol (HTTP)

- Foundation of the World Wide Web.
- Client-Server Model and Request-Response Cycle.
- HTTP Methods (GET, POST, PUT, DELETE, etc.).
- HTTP Status Codes (1xx, 2xx, 3xx, 4xx, 5xx)
- HTTP Headers: Metadata for Requests and Responses.
- Stateless Nature of HTTP and the Role of Cookies.
- Evolution: HTTP/1.1, HTTP/2, and HTTP/3.
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Secure-Communication-Protocols.md"
# Secure Communication Protocols

- **HTTPS (HTTP Secure)**: HTTP with SSL/TLS Encryption.
- **SSL (Secure Sockets Layer) & TLS (Transport Layer Security)**
  - Purpose: Encryption, Authentication, and Integrity.
  - The TLS Handshake Process
  - SSL vs. TLS: History and Deprecation of SSL.
  - Digital Certificates and Certificate Authorities (CAs).
- **SSH (Secure Shell)**
  - Secure Remote Administration.
  - Client-Server Model and Port 22.
  - Encryption Techniques: Symmetrical, Asymmetrical, and Hashing.
  - Authentication Methods: Password vs. Public Key Authentication.
  - SSH Tunneling and Port Forwarding
EOF

# ==========================================
# PART III: File Transfer Protocols
# ==========================================
PART_DIR="003-File-Transfer-Protocols"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-File-Transfer-Protocol-FTP.md"
# File Transfer Protocol (FTP)

- Core Concepts and Purpose
- Active vs. Passive FTP
- FTP Commands (GET, PUT, LS, etc.)
- Inherent Insecurity: Plain Text Data Transfer.
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Secure-File-Transfer-Protocol-SFTP.md"
# Secure File Transfer Protocol (SFTP)

- FTP over an SSH Tunnel.
- Key Differences from FTP: Security and Single Channel Operation.
- Authentication using SSH Keys.
- Use Cases and Compliance (HIPAA, GDPR).
- FTPS (FTP over SSL/TLS) as another secure alternative
EOF

# ==========================================
# PART IV: Email Protocols
# ==========================================
PART_DIR="004-Email-Protocols"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Core-Email-Protocols-The-Trifecta.md"
# Core Email Protocols: The Trifecta

- **SMTP (Simple Mail Transfer Protocol)**
  - The Protocol for *Sending* Email.
  - Client-to-Server and Server-to-Server Communication.
  - SMTP Commands and Relay Process.
- **POP3 (Post Office Protocol 3)**
  - The Protocol for *Receiving* Email.
  - How POP3 Works: Download and Delete from Server.
  - Limitations in a Multi-Device World
- **IMAP (Internet Message Access Protocol)**
  - An Alternative for *Receiving* and Managing Email.
  - Server-Side Storage and Synchronization Across Devices.
  - IMAP vs. POP3: A Detailed Comparison.
- **POP3S and IMAPS**: Secure versions using SSL/TLS
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Email-Authentication-Protocols.md"
# Email Authentication Protocols

- **SPF (Sender Policy Framework)**
  - Purpose: Preventing Sender Address Forgery.
  - How SPF Works: Authorized Mail Servers in DNS.
  - SPF Record Syntax and Limitations.
- **DKIM (DomainKeys Identified Mail)**
  - Digital Signatures for Email Authentication.
  - Public/Private Key Cryptography in Email.
  - DKIM Record in DNS and Email Header Signature.
- **DMARC (Domain-based Message Authentication, Reporting, and Conformance)**
  - Building on SPF and DKIM.
  - DMARC Policies (none, quarantine, reject).
  - DMARC Reporting for Domain Owners.
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Email-Security-Practices.md"
# Email Security Practices

- **White / Grey Listing**
  - **Whitelisting**: A list of approved senders that are allowed to bypass spam filters.
  - **Greylisting**: A technique to temporarily reject email from an unknown sender. Legitimate servers will try again, while many spam servers will not.
- Spam Filtering Techniques
- Understanding Email Headers for Troubleshooting
EOF

# ==========================================
# PART V: Network Security Concepts in Practice
# ==========================================
PART_DIR="005-Network-Security-Concepts-in-Practice"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Access-Control.md"
# Access Control

- Whitelisting vs. Blacklisting
- Network Segmentation
- Firewalls and Access Control Lists (ACLs)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Monitoring-and-Analysis.md"
# Monitoring and Analysis

- Packet Sniffing (e.g., Wireshark)
- Intrusion Detection Systems (IDS) and Intrusion Prevention Systems (IPS)
- Log Analysis
EOF

# ==========================================
# APPENDICES
# ==========================================
PART_DIR="006-Appendices"
mkdir -p "$PART_DIR"

cat <<EOF > "$PART_DIR/001-Glossary-of-Networking-Terms.md"
# Glossary of Networking Terms
EOF

cat <<EOF > "$PART_DIR/002-Common-Port-Numbers.md"
# Common Port Numbers and Their Associated Protocols
EOF

cat <<EOF > "$PART_DIR/003-References-and-Further-Reading.md"
# References and Further Reading
EOF

echo "Structure created successfully inside folder: $ROOT_DIR"
```

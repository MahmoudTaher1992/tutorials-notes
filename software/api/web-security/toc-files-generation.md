Here is the bash script to generate the folder structure and Markdown files for your Web Security study guide.

Copy the code below, save it as a file (e.g., `create_web_security_structure.sh`), give it execution permissions (`chmod +x create_web_security_structure.sh`), and run it.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Web-Security-Study"

# Create the root directory and enter it
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $ROOT_DIR..."

# ==============================================================================
# PART I: Core Concepts & Foundational Principles
# ==============================================================================
PART_DIR="001-Core-Concepts-Foundational-Principles"
mkdir -p "$PART_DIR"

# A. Introduction to Web Security
cat <<EOF > "$PART_DIR/001-Introduction-to-Web-Security.md"
# Introduction to Web Security

* The Security Mindset: Thinking Like an Attacker
* The CIA Triad: Confidentiality, Integrity, and Availability
* Key Terminology: Threat, Vulnerability, Risk, Exploit, and Asset
* The Threat Landscape: Actors, Motivations, and Common Targets
EOF

# B. Core Web & Browser Security Models
cat <<EOF > "$PART_DIR/002-Core-Web-Browser-Security-Models.md"
# Core Web & Browser Security Models

* The HTTP Protocol: Inherent Insecurity of Plaintext
* The Same-Origin Policy (SOP): The Cornerstone of Web Security
* The Trust Model of the Web: DNS, IP Addresses, and Certificates
EOF

# C. Fundamental Security Principles
cat <<EOF > "$PART_DIR/003-Fundamental-Security-Principles.md"
# Fundamental Security Principles

* Defense in Depth: A Layered Security Approach
* Principle of Least Privilege
* Secure Defaults & Failing Securely
* Never Trust User Input
* Attack Surface Reduction
EOF

# ==============================================================================
# PART II: Cryptography & Secure Communication
# ==============================================================================
PART_DIR="002-Cryptography-Secure-Communication"
mkdir -p "$PART_DIR"

# A. Cryptography Essentials
cat <<EOF > "$PART_DIR/001-Cryptography-Essentials.md"
# Cryptography Essentials

* Symmetric vs. Asymmetric Encryption
* Public Key Infrastructure (PKI)
* Digital Signatures & Certificates
EOF

# B. Hashing Algorithms for Integrity and Passwords
cat <<EOF > "$PART_DIR/002-Hashing-Algorithms.md"
# Hashing Algorithms for Integrity and Passwords

* Purpose of Hashing: One-Way Functions and Integrity Checks
* Legacy/Insecure Algorithms (and why they're bad)
    * MD5: Vulnerable to collisions
    * SHA-1: Deprecated for most security purposes
* Modern Hashing Algorithms
    * SHA-2 Family: SHA-256, SHA-512
    * SHA-3
* Password Hashing (Key Stretching & Salting)
    * The need for computationally intensive algorithms
    * bcrypt: Strong, widely used
    * scrypt: Memory-hard, designed to resist custom hardware attacks
    * Argon2: The modern standard (winner of the Password Hashing Competition)
EOF

# C. Transport Layer Security (HTTPS)
cat <<EOF > "$PART_DIR/003-Transport-Layer-Security-HTTPS.md"
# Transport Layer Security (HTTPS)

* SSL/TLS Protocol: The "S" in HTTPS
    * Goals: Encryption, Authentication, and Integrity
    * The TLS Handshake Explained
    * Certificate Authorities (CAs) and the Chain of Trust
    * Common Misconfigurations and Vulnerabilities (e.g., weak cipher suites)
* Implementing HTTPS on a Server
    * Obtaining Certificates (e.g., Let's Encrypt)
    * Server Configuration Best Practices
EOF

# ==============================================================================
# PART III: Common Web Vulnerabilities (The OWASP Top 10 Risks)
# ==============================================================================
PART_DIR="003-Common-Web-Vulnerabilities-OWASP"
mkdir -p "$PART_DIR"

# A. A01: Broken Access Control
cat <<EOF > "$PART_DIR/001-A01-Broken-Access-Control.md"
# A01: Broken Access Control

* Insecure Direct Object References (IDOR)
* Path Traversal / Directory Traversal
* Privilege Escalation
EOF

# B. A02: Cryptographic Failures
cat <<EOF > "$PART_DIR/002-A02-Cryptographic-Failures.md"
# A02: Cryptographic Failures

* Sensitive Data Exposure in Transit and at Rest
* Use of Weak or Deprecated Cryptography
EOF

# C. A03: Injection
cat <<EOF > "$PART_DIR/003-A03-Injection.md"
# A03: Injection

* SQL Injection (SQLi)
* Cross-Site Scripting (XSS): Stored, Reflected, and DOM-based
* OS Command Injection
* LDAP Injection
EOF

# D. A04: Insecure Design
cat <<EOF > "$PART_DIR/004-A04-Insecure-Design.md"
# A04: Insecure Design

* Lack of Threat Modeling
* Insecure Business Logic Flaws
EOF

# E. A05: Security Misconfiguration
cat <<EOF > "$PART_DIR/005-A05-Security-Misconfiguration.md"
# A05: Security Misconfiguration

* Default Credentials, Verbose Error Messages, Unnecessary Features Enabled
* Improperly Configured Cloud Services
EOF

# F. A06: Vulnerable and Outdated Components
cat <<EOF > "$PART_DIR/006-A06-Vulnerable-Outdated-Components.md"
# A06: Vulnerable and Outdated Components

* Using Libraries/Frameworks with Known Vulnerabilities
* Dependency Management and Scanning
EOF

# G. A07: Identification and Authentication Failures
cat <<EOF > "$PART_DIR/007-A07-Identification-Authentication-Failures.md"
# A07: Identification and Authentication Failures

* Weak Password Policies, Credential Stuffing, Brute-Force Attacks
* Session Management Flaws (e.g., Session Fixation)
EOF

# H. A08: Software and Data Integrity Failures
cat <<EOF > "$PART_DIR/008-A08-Software-Data-Integrity-Failures.md"
# A08: Software and Data Integrity Failures

* Insecure Deserialization
* Software Update Vulnerabilities (lack of signature validation)
EOF

# I. A09: Security Logging and Monitoring Failures
cat <<EOF > "$PART_DIR/009-A09-Security-Logging-Monitoring-Failures.md"
# A09: Security Logging and Monitoring Failures

* Insufficient Logging to Detect and Respond to Attacks
EOF

# J. A10: Server-Side Request Forgery (SSRF)
cat <<EOF > "$PART_DIR/010-A10-Server-Side-Request-Forgery-SSRF.md"
# A10: Server-Side Request Forgery (SSRF)

* Forcing the Server to Make Malicious Requests on an Attacker's Behalf
EOF

# ==============================================================================
# PART IV: Defensive Mechanisms & Hardening
# ==============================================================================
PART_DIR="004-Defensive-Mechanisms-Hardening"
mkdir -p "$PART_DIR"

# A. Input Validation & Output Encoding
cat <<EOF > "$PART_DIR/001-Input-Validation-Output-Encoding.md"
# Input Validation & Output Encoding

* Validation: Whitelisting vs. Blacklisting
* Sanitization and Parameterized Queries (for preventing Injection)
* Output Encoding: Context-Aware Encoding for HTML, JavaScript, CSS to prevent XSS
EOF

# B. Browser-Based Defenses (Security Headers)
cat <<EOF > "$PART_DIR/002-Browser-Based-Defenses.md"
# Browser-Based Defenses (Security Headers)

* Content Security Policy (CSP)
    * Purpose: Mitigating XSS and data injection attacks
    * Directives (script-src, style-src, img-src, report-uri)
* HTTP Strict Transport Security (HSTS)
* X-Frame-Options / frame-ancestors (Clickjacking prevention)
* X-Content-Type-Options
EOF

# C. Cross-Origin Policies
cat <<EOF > "$PART_DIR/003-Cross-Origin-Policies.md"
# Cross-Origin Policies

* CORS (Cross-Origin Resource Sharing)
    * Understanding the Same-Origin Policy problem it solves
    * Simple vs. Preflighted Requests (OPTIONS method)
    * Key Headers (Access-Control-Allow-Origin) and common misconfigurations
EOF

# D. Session Management & Authentication Security
cat <<EOF > "$PART_DIR/004-Session-Management-Authentication.md"
# Session Management & Authentication Security

* Secure Cookie Attributes (HttpOnly, Secure, SameSite=Strict/Lax)
* Token-Based Authentication (JWTs) and their security considerations
* Implementing Multi-Factor Authentication (MFA/2FA)
* Protection against Cross-Site Request Forgery (CSRF) using Anti-CSRF Tokens
EOF

# ==============================================================================
# PART V: Server and Infrastructure Security
# ==============================================================================
PART_DIR="005-Server-Infrastructure-Security"
mkdir -p "$PART_DIR"

# A. Server Hardening
cat <<EOF > "$PART_DIR/001-Server-Hardening.md"
# Server Hardening

* Operating System Patch Management
* Firewall Configuration (Network & Host-based)
* Disabling Unnecessary Services and Ports
* File Permissions and User Privileges
EOF

# B. Web Server & Application Server Configuration
cat <<EOF > "$PART_DIR/002-WebServer-AppServer-Configuration.md"
# Web Server & Application Server Configuration

* Disabling Directory Listing and Sensitive Banners
* Configuring TLS/SSL Securely
* Using a Web Application Firewall (WAF)
EOF

# C. Secret Management
cat <<EOF > "$PART_DIR/003-Secret-Management.md"
# Secret Management

* Why not to hard-code credentials or API keys
* Solutions: Environment Variables, Encrypted Vaults (HashiCorp Vault, AWS Secrets Manager)
EOF

# D. Logging, Monitoring, and Alerting
cat <<EOF > "$PART_DIR/004-Logging-Monitoring-Alerting.md"
# Logging, Monitoring, and Alerting

* Centralized and Tamper-Proof Logging
* Intrusion Detection/Prevention Systems (IDS/IPS)
* Setting up alerts for suspicious activity
EOF

# ==============================================================================
# PART VI: API Security Best Practices
# ==============================================================================
PART_DIR="006-API-Security-Best-Practices"
mkdir -p "$PART_DIR"

# A. The OWASP API Security Top 10
cat <<EOF > "$PART_DIR/001-OWASP-API-Security-Top-10.md"
# The OWASP API Security Top 10

* Broken Object Level Authorization (BOLA)
* Broken User Authentication
* Excessive Data Exposure
* Lack of Resources & Rate Limiting
* Broken Function Level Authorization
EOF

# B. Authentication and Authorization for APIs
cat <<EOF > "$PART_DIR/002-Authentication-Authorization-APIs.md"
# Authentication and Authorization for APIs

* API Keys: Usage and limitations
* OAuth 2.0 & OpenID Connect (OIDC) as the standard for delegated authorization
EOF

# C. API-Specific Protections
cat <<EOF > "$PART_DIR/003-API-Specific-Protections.md"
# API-Specific Protections

* Robust Input Validation for all parameters, headers, and body payloads
* Rate Limiting and Throttling to prevent abuse and DoS
* Proper HTTP Method and Status Code Usage for security clarity
* API Gateway Security Features (e.g., authentication, rate limiting, logging)
EOF

# ==============================================================================
# PART VII: The Secure Software Development Lifecycle (SSDLC)
# ==============================================================================
PART_DIR="007-Secure-Software-Development-Lifecycle"
mkdir -p "$PART_DIR"

# A. Integrating Security into Development
cat <<EOF > "$PART_DIR/001-Integrating-Security-into-Development.md"
# Integrating Security into Development

* Threat Modeling (STRIDE, DREAD)
* Secure Coding Standards and Code Reviews
EOF

# B. Security Testing
cat <<EOF > "$PART_DIR/002-Security-Testing.md"
# Security Testing

* Static Application Security Testing (SAST) - "White-box"
* Dynamic Application Security Testing (DAST) - "Black-box"
* Interactive Application Security Testing (IAST)
* Penetration Testing & Bug Bounty Programs
EOF

# C. Dependency & Supply Chain Security
cat <<EOF > "$PART_DIR/003-Dependency-Supply-Chain-Security.md"
# Dependency & Supply Chain Security

* Software Composition Analysis (SCA)
* Scanning dependencies for known vulnerabilities (e.g., npm audit, Snyk)
EOF

# D. Incident Response
cat <<EOF > "$PART_DIR/004-Incident-Response.md"
# Incident Response

* Developing an Incident Response Plan
* Forensics and Post-Mortem Analysis
EOF

echo "Done! Web Security study guide structure created in '$ROOT_DIR'."
```

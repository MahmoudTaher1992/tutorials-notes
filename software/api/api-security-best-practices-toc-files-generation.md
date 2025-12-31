Here is the bash script. I have structured it to create the directory `API-Security-Study` and populate it with the hierarchy and content from your Table of Contents.

To use this:
1. Copy the code below.
2. Save it as a file (e.g., `create_api_study.sh`).
3. Make it executable: `chmod +x create_api_study.sh`.
4. Run it: `./create_api_study.sh`.

```bash
#!/bin/bash

# Root directory for the study guide
ROOT_DIR="API-Security-Study"

# Create root directory
mkdir -p "$ROOT_DIR"
echo "Creating study guide structure in: $ROOT_DIR"

# Function to create file with content
create_file() {
    local dir="$1"
    local filename="$2"
    local title="$3"
    local content="$4"

    mkdir -p "$dir"
    echo "# $title" > "$dir/$filename"
    echo "" >> "$dir/$filename"
    echo "$content" >> "$dir/$filename"
}

# ==============================================================================
# PART I: Foundations & The Threat Landscape
# ==============================================================================
DIR="$ROOT_DIR/001-Part-I-Foundations-and-Threat-Landscape"

# Section A
CONTENT=$(cat << 'EOF'
- What Defines an API? (REST, GraphQL, gRPC, WebSockets)
- Why API Security is Different from Traditional Web Security
- The Business Impact of Insecure APIs
- Core Security Principles Applied to APIs
  - Confidentiality, Integrity, Availability (The CIA Triad)
  - Defense in Depth
  - Principle of Least Privilege
  - Zero Trust Architecture
EOF
)
create_file "$DIR" "001-Introduction-to-API-Security.md" "Introduction to API Security" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- **OWASP API Security Top 10 (Deep Dive)**
  1.  **API1:2023** - Broken Object Level Authorization (BOLA)
  2.  **API2:2023** - Broken Authentication
  3.  **API3:2023** - Broken Object Property Level Authorization
  4.  **API4:2023** - Unrestricted Resource Consumption
  5.  **API5:2023** - Broken Function Level Authorization (BFLA)
  6.  **API6:2023** - Unrestricted Access to Sensitive Business Flows
  7.  **API7:2023** - Server Side Request Forgery (SSRF)
  8.  **API8:2023** - Security Misconfiguration
  9.  **API9:2023** - Improper Inventory Management
  10. **API10:2023** - Unsafe Consumption of APIs
- Common Attack Vectors: Credential Stuffing, Man-in-the-Middle (MitM), Injection Attacks, Denial of Service (DoS).
EOF
)
create_file "$DIR" "002-The-Modern-Threat-Landscape.md" "The Modern Threat Landscape" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- The Role of API Gateways
- Designing Secure API Contracts (OpenAPI/Swagger Specification)
- Versioning Strategies and Security Implications (`/v1/`, `/v2/`)
EOF
)
create_file "$DIR" "003-API-Design-for-Security.md" "API Design for Security" "$CONTENT"


# ==============================================================================
# PART II: Identity, Authentication & Access Control (AuthN & AuthZ)
# ==============================================================================
DIR="$ROOT_DIR/002-Part-II-Identity-Authentication-and-Access-Control"

# Section A
CONTENT=$(cat << 'EOF'
- **Weak Patterns to Avoid**
  - Basic Authentication (and why it's insecure)
  - API Keys in URL Query Parameters
- **Token-Based Authentication**
  - **JSON Web Tokens (JWTs):**
    - Structure: Header, Payload, Signature
    - Signing Algorithms: Symmetric (HS256) vs. Asymmetric (RS256)
    - Common Vulnerabilities: `alg:none`, Weak Secrets, Leaked Keys
    - Best Practices: Short-lived tokens (TTL), Refresh tokens (RTTL), Payload security (no PII), `jti` claim for revocation.
  - Opaque Tokens (Reference Tokens) vs. JWTs
- **Other Authentication Mechanisms**
  - API Keys: Secure Usage Patterns (in Headers, server-side validation)
  - Mutual TLS (mTLS) for service-to-service authentication
EOF
)
create_file "$DIR" "001-Authentication-AuthN.md" "Authentication (AuthN): Verifying Identity" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- The Critical Distinction Between Authentication and Authorization
- **Broken Object Level Authorization (BOLA/IDOR)**
  - Why `users/12345/orders` is dangerous
  - Mitigation: Using UUIDs, Ownership Checks in Business Logic
- **Broken Function Level Authorization (BFLA)**
  - Protecting Admin Endpoints (`/api/admin/deleteUser`)
  - Mitigation: Role-based checks on every sensitive endpoint.
- **Authorization Models & Patterns**
  - Role-Based Access Control (RBAC)
  - Attribute-Based Access Control (ABAC)
  - Policy-as-Code (e.g., Open Policy Agent - OPA)
EOF
)
create_file "$DIR" "002-Authorization-AuthZ.md" "Authorization (AuthZ): Verifying Permissions" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- Core Concepts: Roles (Resource Owner, Client, Authorization Server, Resource Server)
- **OAuth 2.0 Grant Types (Flows)**
  - Authorization Code Grant with PKCE (for SPAs and Mobile)
  - Client Credentials Grant (for service-to-service)
  - Legacy Flows to Avoid (Implicit Grant)
- **Security Best Practices**
  - Strict `redirect_uri` validation
  - The `state` parameter to prevent CSRF
  - Scope Validation and the Principle of Least Privilege
  - OIDC for Authentication Layer on top of OAuth 2.0
EOF
)
create_file "$DIR" "003-OAuth2-and-OIDC.md" "OAuth 2.0 & OpenID Connect (OIDC)" "$CONTENT"


# ==============================================================================
# PART III: Data Protection & Cryptography
# ==============================================================================
DIR="$ROOT_DIR/003-Part-III-Data-Protection-and-Cryptography"

# Section A
CONTENT=$(cat << 'EOF'
- **Transport Layer Security (TLS)**
  - Enforcing HTTPS Everywhere
  - Configuring Strong Cipher Suites & TLS Versions (1.2, 1.3)
  - HTTP Strict Transport Security (HSTS) Header to prevent SSL Stripping
- Certificate Management and Pinning
EOF
)
create_file "$DIR" "001-Data-in-Transit-Security.md" "Data in Transit Security" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- Encrypting Sensitive Data in Databases and File Storage
- Hashing vs. Encryption: When and How to Use Them
- Secure Password Storage: Hashing with `bcrypt`, `scrypt`, or `Argon2` (including salting and peppering).
EOF
)
create_file "$DIR" "002-Data-at-Rest-Security.md" "Data at Rest Security" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- Preventing Excessive Data Exposure in API Responses
- Implementing Field-level Security (e.g., using GraphQL patterns securely)
- Data Loss Prevention (DLP) Strategies
EOF
)
create_file "$DIR" "003-Data-Exposure-and-Filtering.md" "Data Exposure and Filtering" "$CONTENT"


# ==============================================================================
# PART IV: Secure Input/Output Handling & Logic
# ==============================================================================
DIR="$ROOT_DIR/004-Part-IV-Secure-Input-Output-Handling-and-Logic"

# Section A
CONTENT=$(cat << 'EOF'
- The "Never Trust User Input" Principle
- **Defense Against Injection Attacks**
  - SQL & NoSQL Injection
  - Command Injection
  - Cross-Site Scripting (XSS) from APIs serving content to frontends
  - XML External Entity (XXE) Attacks (disabling entity parsing)
- Schema Validation using OpenAPI/Swagger
- Validating Content-Types (e.g., rejecting `text/xml` if only `application/json` is expected)
EOF
)
create_file "$DIR" "001-Input-Validation-and-Sanitization.md" "Input Validation and Sanitization" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- Preventing Denial of Service (DoS) and Brute-Force Attacks
- Strategies: By IP, User ID, API Key
- Algorithms: Token Bucket, Leaky Bucket, Fixed/Sliding Window
- Limiting Request Size, Pagination Defaults, and Query Complexity (GraphQL)
EOF
)
create_file "$DIR" "002-Rate-Limiting-Throttling.md" "Rate Limiting, Throttling & Resource Management" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- **Security Headers for API Responses**
  - `Content-Security-Policy: default-src 'none'`
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: deny`
- Fingerprinting Prevention: Removing `X-Powered-By`, `Server`, and other verbose headers.
- Enforcing `Content-Type` headers to prevent content sniffing.
- Using proper HTTP Status Codes for clarity and security.
EOF
)
create_file "$DIR" "003-Secure-Output-Handling.md" "Secure Output Handling & HTTP Headers" "$CONTENT"

# Section D
CONTENT=$(cat << 'EOF'
- Mass Assignment/Binding Attacks
- Preventing Race Conditions in financial or inventory-based APIs
- Securing Multi-step Business Flows (e.g., password reset, checkout)
EOF
)
create_file "$DIR" "004-Business-Logic-Vulnerabilities.md" "Business Logic Vulnerabilities" "$CONTENT"


# ==============================================================================
# PART V: Monitoring, Logging & Incident Response
# ==============================================================================
DIR="$ROOT_DIR/005-Part-V-Monitoring-Logging-and-Incident-Response"

# Section A
CONTENT=$(cat << 'EOF'
- The Logging Goldilocks Zone: Log enough for forensics, but not too much.
- **What NOT to Log**: Passwords, Tokens, API Keys, PII, Credit Card Numbers.
- Data Masking and Sanitization in Logs.
- Centralized Logging for Correlation (ELK Stack, Splunk, Datadog).
EOF
)
create_file "$DIR" "001-Secure-Logging.md" "Secure Logging" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- Monitoring for Security Events:
  - Spikes in 4xx/5xx errors
  - Authentication failures
  - Anomalous data access patterns
- Web Application Firewalls (WAFs) and API Security Gateways
- Runtime Application Self-Protection (RASP)
- Intrusion Detection/Prevention Systems (IDS/IPS)
EOF
)
create_file "$DIR" "002-Monitoring-Alerting-Threat-Detection.md" "Monitoring, Alerting & Threat Detection" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- Developing an API Incident Response Plan
- Correlation IDs for Tracing Requests Across Services
- Post-mortem Analysis and Root Cause Analysis (RCA)
EOF
)
create_file "$DIR" "003-Incident-Response-and-Forensics.md" "Incident Response & Forensics" "$CONTENT"


# ==============================================================================
# PART VI: Secure Development Lifecycle (SDLC) & CI/CD
# ==============================================================================
DIR="$ROOT_DIR/006-Part-VI-Secure-Development-Lifecycle-SDLC"

# Section A
CONTENT=$(cat << 'EOF'
- Security by Design and Threat Modeling (STRIDE)
- Secure Coding Standards and Checklists
- Secure Code Reviews (Manual and Automated)
EOF
)
create_file "$DIR" "001-Shifting-Security-Left.md" "Shifting Security Left" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- **SAST (Static Application Security Testing)**: Scanning source code for vulnerabilities.
- **DAST (Dynamic Application Security Testing)**: Testing running applications for flaws.
- **SCA (Software Composition Analysis)**: Checking dependencies for known vulnerabilities (`npm audit`, Snyk, Dependabot).
- **IaC (Infrastructure as Code) Scanning**: Securing Terraform/CloudFormation templates.
EOF
)
create_file "$DIR" "002-Automated-Security-Tooling.md" "Automated Security Tooling" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- Integrating security scans as blocking steps in the pipeline.
- Secrets Management in CI/CD (Vault, GitHub Actions Secrets).
- Container Security: Image scanning and runtime security.
- Designing a Secure Rollback Plan.
EOF
)
create_file "$DIR" "003-Secure-CICD-Pipeline.md" "Secure CI/CD Pipeline" "$CONTENT"


# ==============================================================================
# PART VII: Advanced & Specialized API Architectures
# ==============================================================================
DIR="$ROOT_DIR/007-Part-VII-Advanced-and-Specialized-API-Architectures"

# Section A
CONTENT=$(cat << 'EOF'
- Introspection Queries (and why to disable them in production)
- Preventing Denial of Service via Query Depth/Complexity Limiting
- Authorization at the Field Level (Resolvers)
- Batching Attacks
EOF
)
create_file "$DIR" "001-GraphQL-Security.md" "GraphQL Security" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- Origin Validation
- Cross-Site WebSocket Hijacking (CSWSH)
- Authentication and Session Management over WebSockets
EOF
)
create_file "$DIR" "002-WebSocket-Real-time-Security.md" "WebSocket & Real-time API Security" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- Securing Service-to-Service Communication (mTLS, Service Mesh like Istio)
- IAM Roles and Permissions in Serverless (e.g., AWS Lambda)
- The "Eventual Perimeter" and Zero Trust Networking
EOF
)
create_file "$DIR" "003-Microservices-Serverless-Security.md" "Microservices & Serverless Security" "$CONTENT"

# Section D
CONTENT=$(cat << 'EOF'
- Certificate and Public Key Pinning
- Device Attestation and Fingerprinting
- Preventing Reverse Engineering and Tampering
EOF
)
create_file "$DIR" "004-Mobile-API-Security.md" "Mobile API Security" "$CONTENT"


# ==============================================================================
# PART VIII: Compliance & Governance
# ==============================================================================
DIR="$ROOT_DIR/008-Part-VIII-Compliance-and-Governance"

# Section A
CONTENT=$(cat << 'EOF'
- How API Security relates to GDPR, CCPA, HIPAA, PCI-DSS.
- Data Residency and Sovereignty.
EOF
)
create_file "$DIR" "001-Regulatory-and-Compliance-Frameworks.md" "Regulatory and Compliance Frameworks" "$CONTENT"

# Section B
CONTENT=$(cat << 'EOF'
- Discovering and Cataloging All APIs (including shadow and zombie APIs).
- Ownership and Lifecycle Management.
EOF
)
create_file "$DIR" "002-API-Inventory-and-Asset-Management.md" "API Inventory and Asset Management" "$CONTENT"

# Section C
CONTENT=$(cat << 'EOF'
- Scoping and Performing API Penetration Tests.
- Running a responsible disclosure or bug bounty program.
EOF
)
create_file "$DIR" "003-Penetration-Testing-and-Bug-Bounties.md" "Penetration Testing & Bug Bounties" "$CONTENT"


echo "Done! Hierarchy created in $ROOT_DIR"
```

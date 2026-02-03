
#!/bin/bash

# Define Root Directory Name
ROOT_DIR="OAuth-Study-Guide"

# Create Root Directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $ROOT_DIR..."

# --- Part 1: Foundations ---
DIR="001-Foundations"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Introduction-to-Authorization.md"
# 1. Introduction to Authorization

- Authentication vs Authorization
- The Problem OAuth Solves
- History of OAuth (OAuth 1.0 to OAuth 2.1)
- Real-World Analogies
EOF

cat <<EOF > "$DIR/002-OAuth-2.0-Overview.md"
# 2. OAuth 2.0 Overview

- What is OAuth 2.0?
- OAuth 2.0 vs OAuth 1.0
- OAuth 2.0 vs API Keys vs Basic Auth
- Core Principles & Design Goals
- Specification Documents (RFC 6749, RFC 6750)
EOF

cat <<EOF > "$DIR/003-OAuth-2.0-Terminology.md"
# 3. OAuth 2.0 Terminology

- Resource Owner
- Client
- Authorization Server
- Resource Server
- Protected Resource
- Redirect URI / Callback URL
- Scope
- Grant
- Token
EOF

# --- Part 2: Core Components ---
DIR="002-Core-Components"
mkdir -p "$DIR"

cat <<EOF > "$DIR/004-Roles-in-OAuth-2.0.md"
# 4. Roles in OAuth 2.0

- Resource Owner (End-User)
- Client Application
- Authorization Server
- Resource Server
- Role Interactions & Trust Relationships
EOF

cat <<EOF > "$DIR/005-Client-Types.md"
# 5. Client Types

- Confidential Clients
- Public Clients
- Credentialed Clients *(OAuth 2.1)*
- First-Party vs Third-Party Clients
- Client Profiles (Web App, Browser-Based App, Native App)
EOF

cat <<EOF > "$DIR/006-Client-Registration.md"
# 6. Client Registration

- Static Registration
- Dynamic Client Registration (RFC 7591)
- Dynamic Client Management (RFC 7592)
- Registration Metadata
- Client ID & Client Secret
- Redirect URI Registration
EOF

cat <<EOF > "$DIR/007-Tokens.md"
# 7. Tokens

- Access Tokens
- Refresh Tokens
- Token Types (Bearer, PoP, DPoP)
- Token Formats (Opaque vs Structured)
- Token Lifetime & Expiration
- Token Metadata
EOF

cat <<EOF > "$DIR/008-Scopes.md"
# 8. Scopes

- What are Scopes?
- Scope Design Patterns
- Scope Naming Conventions
- Requesting Scopes
- Scope Consent
- Downscoping
EOF

# --- Part 3: Grant Types ---
DIR="003-Grant-Types"
mkdir -p "$DIR"

cat <<EOF > "$DIR/009-Authorization-Code-Grant.md"
# 9. Authorization Code Grant

- Flow Diagram & Steps
- Authorization Request Parameters
- Authorization Response
- Token Request
- Token Response
- When to Use
- Security Considerations
EOF

cat <<EOF > "$DIR/010-Authorization-Code-Grant-with-PKCE.md"
# 10. Authorization Code Grant with PKCE

- The Problem with Public Clients
- PKCE Overview (RFC 7636)
- Code Verifier Generation
- Code Challenge Methods (plain, S256)
- Flow Diagram with PKCE
- Implementation Steps
- Why PKCE is Mandatory in OAuth 2.1
EOF

cat <<EOF > "$DIR/011-Implicit-Grant.md"
# 11. Implicit Grant (Deprecated)

- Flow Diagram & Steps
- Historical Use Cases
- Security Vulnerabilities
- Why It's Removed in OAuth 2.1
- Migration Path
EOF

cat <<EOF > "$DIR/012-Resource-Owner-Password-Credentials-Grant.md"
# 12. Resource Owner Password Credentials Grant (Deprecated)

- Flow Diagram & Steps
- Limited Use Cases
- Security Risks
- Why It's Removed in OAuth 2.1
- Alternatives
EOF

cat <<EOF > "$DIR/013-Client-Credentials-Grant.md"
# 13. Client Credentials Grant

- Flow Diagram & Steps
- Machine-to-Machine Authorization
- Service Accounts
- When to Use
- Security Considerations
EOF

cat <<EOF > "$DIR/014-Refresh-Token-Grant.md"
# 14. Refresh Token Grant

- Flow Diagram & Steps
- Refresh Token Rotation
- Refresh Token Expiration Strategies
- Binding Refresh Tokens to Clients
- Revocation Considerations
EOF

cat <<EOF > "$DIR/015-Device-Authorization-Grant.md"
# 15. Device Authorization Grant (RFC 8628)

- Use Cases (Smart TVs, CLI Tools, IoT)
- Flow Diagram & Steps
- Device Code & User Code
- Polling Mechanism
- User Experience Considerations
EOF

cat <<EOF > "$DIR/016-Token-Exchange-Grant.md"
# 16. Token Exchange Grant (RFC 8693)

- Use Cases (Delegation, Impersonation)
- Subject Token & Actor Token
- Token Types
- Flow Diagram & Steps
- Delegation vs Impersonation
EOF

cat <<EOF > "$DIR/017-JWT-Bearer-Assertion-Grant.md"
# 17. JWT Bearer Assertion Grant (RFC 7523)

- Use Cases
- JWT Assertion Structure
- Flow Diagram & Steps
- Service Account Authentication
EOF

cat <<EOF > "$DIR/018-SAML-2.0-Bearer-Assertion-Grant.md"
# 18. SAML 2.0 Bearer Assertion Grant (RFC 7522)

- Use Cases
- SAML Assertion Requirements
- Integration with Enterprise IdPs
EOF

# --- Part 4: Endpoints ---
DIR="004-Endpoints"
mkdir -p "$DIR"

cat <<EOF > "$DIR/019-Authorization-Endpoint.md"
# 19. Authorization Endpoint

- Purpose & Behavior
- Request Parameters
- Response Modes (query, fragment, form_post)
- Error Responses
- User Interaction & Consent
EOF

cat <<EOF > "$DIR/020-Token-Endpoint.md"
# 20. Token Endpoint

- Purpose & Behavior
- Request Parameters by Grant Type
- Client Authentication at Token Endpoint
- Token Response Structure
- Error Responses
EOF

cat <<EOF > "$DIR/021-Redirect-URI-Callback-Endpoint.md"
# 21. Redirect URI / Callback Endpoint

- Purpose
- Validation Rules
- Exact Match vs Pattern Matching
- Localhost Considerations
- Security Implications
EOF

cat <<EOF > "$DIR/022-Revocation-Endpoint.md"
# 22. Revocation Endpoint (RFC 7009)

- Purpose & Behavior
- Revoking Access Tokens
- Revoking Refresh Tokens
- Revocation Propagation
- Error Handling
EOF

cat <<EOF > "$DIR/023-Introspection-Endpoint.md"
# 23. Introspection Endpoint (RFC 7662)

- Purpose & Behavior
- Request Structure
- Response Structure
- Active vs Inactive Tokens
- Performance Considerations
- When to Use Introspection vs Local Validation
EOF

cat <<EOF > "$DIR/024-Device-Authorization-Endpoint.md"
# 24. Device Authorization Endpoint

- Purpose & Behavior
- Request & Response Structure
- User Code Display
EOF

cat <<EOF > "$DIR/025-Pushed-Authorization-Request-Endpoint.md"
# 25. Pushed Authorization Request Endpoint (RFC 9126)

- Purpose & Benefits
- Request Structure
- Request URI
- Integration with Authorization Endpoint
EOF

# --- Part 5: Client Authentication ---
DIR="005-Client-Authentication"
mkdir -p "$DIR"

cat <<EOF > "$DIR/026-Client-Authentication-Methods.md"
# 26. Client Authentication Methods

- none (Public Clients)
- client_secret_basic
- client_secret_post
- client_secret_jwt (RFC 7523)
- private_key_jwt (RFC 7523)
- tls_client_auth (RFC 8705)
- self_signed_tls_client_auth (RFC 8705)
EOF

cat <<EOF > "$DIR/027-Choosing-Authentication-Methods.md"
# 27. Choosing Authentication Methods

- Security Comparison
- Implementation Complexity
- Platform Considerations
- Best Practices
EOF

# --- Part 6: Token Types & Formats ---
DIR="006-Token-Types-Formats"
mkdir -p "$DIR"

cat <<EOF > "$DIR/028-Bearer-Tokens.md"
# 28. Bearer Tokens (RFC 6750)

- What are Bearer Tokens?
- Transmitting Bearer Tokens
- Authorization Header
- Form-Encoded Body Parameter *(Discouraged)*
- URI Query Parameter *(Discouraged)*
- Security Considerations
EOF

cat <<EOF > "$DIR/029-JWT-Access-Tokens.md"
# 29. JWT Access Tokens (RFC 9068)

- Structure & Claims
- Standard Claims (iss, sub, aud, exp, iat, jti, client_id, scope)
- Signing Algorithms
- Validation Steps
- Pros & Cons vs Opaque Tokens
EOF

cat <<EOF > "$DIR/030-Opaque-Tokens.md"
# 30. Opaque Tokens

- Structure & Generation
- Token Storage
- Introspection Requirements
- Pros & Cons vs JWT
EOF

cat <<EOF > "$DIR/031-Proof-of-Possession-Tokens.md"
# 31. Proof-of-Possession Tokens

- The Problem with Bearer Tokens
- DPoP (Demonstrating Proof of Possession) - RFC 9449
- mTLS-Bound Tokens (RFC 8705)
- Token Binding *(Deprecated)*
EOF

# --- Part 7: Security ---
DIR="007-Security"
mkdir -p "$DIR"

cat <<EOF > "$DIR/032-OAuth-2.0-Threat-Model.md"
# 32. OAuth 2.0 Threat Model (RFC 6819)

- Threat Categories
- Client Threats
- Authorization Server Threats
- Token Threats
- Endpoint Threats
EOF

cat <<EOF > "$DIR/033-Common-Vulnerabilities.md"
# 33. Common Vulnerabilities

- Authorization Code Interception
- CSRF Attacks
- Open Redirector Attacks
- Token Leakage via Referrer Header
- Token Leakage in Browser History
- Mix-Up Attacks
- Clickjacking
- Code Injection Attacks
- Access Token Injection
EOF

cat <<EOF > "$DIR/034-Security-Mitigations.md"
# 34. Security Mitigations

- State Parameter for CSRF Protection
- PKCE for Code Interception
- Exact Redirect URI Matching
- TLS Everywhere
- Short-Lived Access Tokens
- Refresh Token Rotation
- Token Binding / Sender-Constraining
- iss Parameter for Mix-Up Prevention
EOF

cat <<EOF > "$DIR/035-OAuth-2.0-Security-Best-Current-Practice.md"
# 35. OAuth 2.0 Security Best Current Practice (RFC 9700)

- Recommendations Summary
- Mandatory PKCE
- Redirect URI Restrictions
- Refresh Token Protection
- Access Token Protection
- Authorization Server Recommendations
EOF

cat <<EOF > "$DIR/036-Browser-Based-Application-Security.md"
# 36. Browser-Based Application Security (RFC 8252 + BCP)

- SPA-Specific Threats
- Token Storage in Browser
- Backend-for-Frontend (BFF) Pattern
- Same-Site Cookies
- Cross-Origin Considerations
EOF

cat <<EOF > "$DIR/037-Native-Application-Security.md"
# 37. Native Application Security (RFC 8252)

- Platform-Specific Considerations
- Custom URI Schemes
- Claimed HTTPS Schemes (Universal Links, App Links)
- PKCE Requirement
- System Browser vs Embedded WebView
- Loopback Interface Redirect
EOF

# --- Part 8: OAuth 2.1 ---
DIR="008-OAuth-2.1"
mkdir -p "$DIR"

cat <<EOF > "$DIR/038-OAuth-2.1-Overview.md"
# 38. OAuth 2.1 Overview

- What's New in OAuth 2.1
- Consolidation of Security BCPs
- Removed Features
EOF

cat <<EOF > "$DIR/039-OAuth-2.1-Changes-from-OAuth-2.0.md"
# 39. OAuth 2.1 Changes from OAuth 2.0

- PKCE Required for All Clients
- Implicit Grant Removed
- Password Grant Removed
- Bearer Token in URI Query Removed
- Refresh Token Rotation Recommended
- Exact Redirect URI Matching Required
- Security BCP Integration
EOF

cat <<EOF > "$DIR/040-Migrating-from-OAuth-2.0-to-OAuth-2.1.md"
# 40. Migrating from OAuth 2.0 to OAuth 2.1

- Assessment Checklist
- Migration Steps
- Backward Compatibility Considerations
EOF

# --- Part 9: Advanced Topics ---
DIR="009-Advanced-Topics"
mkdir -p "$DIR"

cat <<EOF > "$DIR/041-Resource-Indicators.md"
# 41. Resource Indicators (RFC 8707)

- Purpose & Use Cases
- Resource Parameter
- Audience Restriction
- Multi-Resource Requests
EOF

cat <<EOF > "$DIR/042-Rich-Authorization-Requests.md"
# 42. Rich Authorization Requests (RFC 9396)

- Beyond Simple Scopes
- Authorization Details Structure
- Type-Specific Fields
- Use Cases (Payments, Data Sharing)
EOF

cat <<EOF > "$DIR/043-Pushed-Authorization-Requests.md"
# 43. Pushed Authorization Requests (PAR) - RFC 9126

- Purpose & Benefits
- Request Object Security
- Integration Flow
- Confidentiality & Integrity
EOF

cat <<EOF > "$DIR/044-JWT-Secured-Authorization-Request.md"
# 44. JWT-Secured Authorization Request (JAR) - RFC 9101

- Request Object
- Signed & Encrypted Requests
- Passing by Value vs by Reference
- Security Benefits
EOF

cat <<EOF > "$DIR/045-Mutual-TLS.md"
# 45. Mutual TLS (mTLS) - RFC 8705

- Client Certificate Authentication
- Certificate-Bound Access Tokens
- PKI Considerations
- Implementation Complexity
EOF

cat <<EOF > "$DIR/046-DPoP.md"
# 46. DPoP (Demonstrating Proof of Possession) - RFC 9449

- DPoP Proof JWT Structure
- Binding Tokens to Key Pairs
- Flow Diagram
- Browser & Native App Considerations
- DPoP Nonce
EOF

cat <<EOF > "$DIR/047-Token-Introspection-Management.md"
# 47. Token Introspection & Management

- Centralized vs Distributed Validation
- Token Caching Strategies
- Real-Time Revocation Checking
EOF

cat <<EOF > "$DIR/048-Step-Up-Authentication.md"
# 48. Step-Up Authentication

- ACR Values
- Insufficient User Authentication Response
- Re-Authentication Flows
- max_age Parameter
EOF

cat <<EOF > "$DIR/049-Financial-Grade-API.md"
# 49. Financial-Grade API (FAPI)

- FAPI 1.0 Baseline & Advanced
- FAPI 2.0 Security Profile
- Use Cases (Banking, Open Finance)
- Requirements Summary
EOF

cat <<EOF > "$DIR/050-Global-Token-Revocation.md"
# 50. Global Token Revocation

- Revocation Challenges
- Event-Based Revocation
- Shared Signals Framework (SSF)
- CAEP (Continuous Access Evaluation Protocol)
EOF

# --- Part 10: Implementation Patterns ---
DIR="010-Implementation-Patterns"
mkdir -p "$DIR"

cat <<EOF > "$DIR/051-Web-Application-Integration.md"
# 51. Web Application Integration

- Server-Side Flow
- Session Management
- Token Storage
- Logout Handling
EOF

cat <<EOF > "$DIR/052-SPA-Integration.md"
# 52. Single Page Application (SPA) Integration

- Authorization Code + PKCE
- Token Storage Options (Memory, Session Storage)
- Silent Refresh Strategies
- BFF Pattern Implementation
EOF

cat <<EOF > "$DIR/053-Mobile-Application-Integration.md"
# 53. Mobile Application Integration

- iOS Implementation (ASWebAuthenticationSession)
- Android Implementation (Custom Tabs)
- Secure Token Storage (Keychain, Keystore)
- Biometric Protection
- Deep Linking
EOF

cat <<EOF > "$DIR/054-CLI-Desktop-App-Integration.md"
# 54. CLI & Desktop Application Integration

- Loopback Redirect
- Device Authorization Flow
- Manual Code Copy
- Token Caching
EOF

cat <<EOF > "$DIR/055-Microservices-API-Gateway-Integration.md"
# 55. Microservices & API Gateway Integration

- Gateway Token Validation
- Token Exchange Between Services
- Service-to-Service Authorization
- Propagating User Context
EOF

cat <<EOF > "$DIR/056-Machine-to-Machine-Integration.md"
# 56. Machine-to-Machine Integration

- Client Credentials Flow
- Service Account Management
- Secret Rotation
- Workload Identity
EOF

# --- Part 11: Authorization Server Implementation ---
DIR="011-Authorization-Server-Implementation"
mkdir -p "$DIR"

cat <<EOF > "$DIR/057-Authorization-Server-Architecture.md"
# 57. Authorization Server Architecture

- Core Components
- Storage Requirements
- Scalability Considerations
- High Availability
EOF

cat <<EOF > "$DIR/058-Implementing-Core-Endpoints.md"
# 58. Implementing Core Endpoints

- Authorization Endpoint Logic
- Token Endpoint Logic
- Consent Management
- Error Handling
EOF

cat <<EOF > "$DIR/059-Token-Generation-Management.md"
# 59. Token Generation & Management

- Token Format Selection
- Signing Keys Management
- Token Storage & Indexing
- Revocation Implementation
EOF

cat <<EOF > "$DIR/060-Client-Management.md"
# 60. Client Management

- Registration Workflows
- Secret Management & Rotation
- Client Policy Enforcement
EOF

cat <<EOF > "$DIR/061-Consent-User-Experience.md"
# 61. Consent & User Experience

- Consent Screen Design
- Scope Descriptions
- Consent Persistence
- Consent Revocation
EOF

cat <<EOF > "$DIR/062-Popular-Authorization-Servers.md"
# 62. Popular Authorization Servers

- Keycloak
- IdentityServer / Duende
- Auth0
- Okta
- AWS Cognito
- Azure AD / Microsoft Entra ID
- Hydra (Ory)
- Spring Authorization Server
- Authlib
EOF

# --- Part 12: Resource Server Implementation ---
DIR="012-Resource-Server-Implementation"
mkdir -p "$DIR"

cat <<EOF > "$DIR/063-Resource-Server-Architecture.md"
# 63. Resource Server Architecture

- Token Validation Strategies
- Middleware / Filter Design
- Caching Considerations
EOF

cat <<EOF > "$DIR/064-Token-Validation.md"
# 64. Token Validation

- JWT Local Validation
- Introspection-Based Validation
- Hybrid Approaches
- Clock Skew Handling
- Key Rotation Handling
EOF

cat <<EOF > "$DIR/065-Scope-Permission-Enforcement.md"
# 65. Scope & Permission Enforcement

- Scope-Based Access Control
- Fine-Grained Authorization
- Policy Decision Points
- Attribute-Based Access Control (ABAC)
EOF

cat <<EOF > "$DIR/066-Error-Responses.md"
# 66. Error Responses (RFC 6750)

- invalid_token
- insufficient_scope
- invalid_request
- WWW-Authenticate Header
EOF

# --- Part 13: Testing & Debugging ---
DIR="013-Testing-Debugging"
mkdir -p "$DIR"

cat <<EOF > "$DIR/067-Testing-OAuth-Implementations.md"
# 67. Testing OAuth Implementations

- Unit Testing Strategies
- Integration Testing
- Mocking Authorization Servers
- Conformance Testing
EOF

cat <<EOF > "$DIR/068-Debugging-Troubleshooting.md"
# 68. Debugging & Troubleshooting

- Common Errors & Solutions
- Token Inspection Tools
- Network Traffic Analysis
- Logging Best Practices
EOF

cat <<EOF > "$DIR/069-Security-Testing.md"
# 69. Security Testing

- Penetration Testing Checklist
- Automated Security Scanning
- Vulnerability Assessment
EOF

# --- Part 14: Operations & Monitoring ---
DIR="014-Operations-Monitoring"
mkdir -p "$DIR"

cat <<EOF > "$DIR/070-Token-Lifecycle-Management.md"
# 70. Token Lifecycle Management

- Issuance Monitoring
- Usage Analytics
- Revocation Tracking
- Expiration Management
EOF

cat <<EOF > "$DIR/071-Key-Management.md"
# 71. Key Management

- Signing Key Generation
- Key Rotation Strategies
- Key Storage (HSM, Cloud KMS)
- JWKS Endpoint Management
EOF

cat <<EOF > "$DIR/072-Monitoring-Alerting.md"
# 72. Monitoring & Alerting

- Metrics to Track
- Anomaly Detection
- Rate Limiting
- Abuse Prevention
EOF

cat <<EOF > "$DIR/073-Audit-Compliance.md"
# 73. Audit & Compliance

- Audit Logging Requirements
- Compliance Frameworks (SOC 2, GDPR, PCI-DSS)
- Data Retention Policies
EOF

# --- Part 15: Related Specifications & Ecosystem ---
DIR="015-Related-Specifications-Ecosystem"
mkdir -p "$DIR"

cat <<EOF > "$DIR/074-OAuth-Extensions-Related-RFCs.md"
# 74. OAuth Extensions & Related RFCs

- RFC Index & Summary
- Experimental vs Standards Track
- Draft Specifications to Watch
EOF

cat <<EOF > "$DIR/075-OpenID-Connect-Relationship.md"
# 75. OpenID Connect Relationship

- OIDC as OAuth Extension
- When to Use OAuth vs OIDC
- ID Tokens vs Access Tokens
EOF

cat <<EOF > "$DIR/076-UMA.md"
# 76. UMA (User-Managed Access)
EOF

echo "Done! OAuth Study Guide structure created successfully in $(pwd)."


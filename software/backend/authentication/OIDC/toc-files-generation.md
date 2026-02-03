
#!/bin/bash

# Root Directory Name
ROOT_DIR="OIDC-Developer-Study-Guide"

# Create Root Directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# ==========================================
# PART 1: Foundations
# ==========================================
DIR_NAME="001-Foundations"
mkdir -p "$DIR_NAME"

# 1. Introduction
cat <<EOF > "$DIR_NAME/001-Introduction-to-Identity-and-Authentication.md"
# Introduction to Identity & Authentication

- Authentication vs Authorization
- History of Web Authentication
- The Problem OIDC Solves
EOF

# 2. OAuth 2.0 Primer
cat <<EOF > "$DIR_NAME/002-OAuth-2-Primer.md"
# OAuth 2.0 Primer

- OAuth 2.0 Overview
- Roles: Resource Owner, Client, Authorization Server, Resource Server
- OAuth 2.0 Grant Types Overview
- Access Tokens & Refresh Tokens
- Scopes in OAuth 2.0
- Limitations of OAuth 2.0 for Authentication
EOF

# 3. OIDC Overview
cat <<EOF > "$DIR_NAME/003-OIDC-Overview.md"
# OIDC Overview

- What is OpenID Connect?
- OIDC vs OAuth 2.0 vs SAML
- OIDC Architecture
- Key Terminology
EOF

# ==========================================
# PART 2: Core OIDC Concepts
# ==========================================
DIR_NAME="002-Core-OIDC-Concepts"
mkdir -p "$DIR_NAME"

# 4. Roles & Components
cat <<EOF > "$DIR_NAME/001-OIDC-Roles-and-Components.md"
# OIDC Roles & Components

- End-User (Resource Owner)
- Relying Party (RP) / Client
- OpenID Provider (OP) / Identity Provider (IdP)
- UserInfo Endpoint
EOF

# 5. Tokens in OIDC
cat <<EOF > "$DIR_NAME/002-Tokens-in-OIDC.md"
# Tokens in OIDC

- ID Token (the core OIDC addition)
- Access Token
- Refresh Token
- Token Lifetimes & Expiration
EOF

# 6. ID Token Deep Dive
cat <<EOF > "$DIR_NAME/003-ID-Token-Deep-Dive.md"
# The ID Token Deep Dive

- JWT Structure (Header, Payload, Signature)
- Standard Claims (iss, sub, aud, exp, iat, nonce, etc.)
- Optional Claims (auth_time, acr, amr, azp)
- Custom Claims
- ID Token Validation Steps
EOF

# 7. Scopes & Claims
cat <<EOF > "$DIR_NAME/004-Scopes-and-Claims.md"
# Scopes & Claims

- OIDC Standard Scopes (openid, profile, email, address, phone)
- Requesting Specific Claims
- Claims Parameter
- Scope to Claims Mapping
EOF

# ==========================================
# PART 3: Authentication Flows
# ==========================================
DIR_NAME="003-Authentication-Flows"
mkdir -p "$DIR_NAME"

# 8. Authorization Code Flow
cat <<EOF > "$DIR_NAME/001-Authorization-Code-Flow.md"
# Authorization Code Flow

- Flow Diagram & Steps
- When to Use
- Security Considerations
- Implementation Walkthrough
EOF

# 9. Authorization Code Flow with PKCE
cat <<EOF > "$DIR_NAME/002-Authorization-Code-Flow-with-PKCE.md"
# Authorization Code Flow with PKCE

- The Problem with Public Clients
- PKCE Explained (code_verifier, code_challenge)
- Challenge Methods (plain, S256)
- Implementation Steps
- Why PKCE is Now Recommended for All Clients
EOF

# 10. Implicit Flow
cat <<EOF > "$DIR_NAME/003-Implicit-Flow-Legacy.md"
# Implicit Flow (Legacy)

- Flow Diagram & Steps
- Security Risks
- Why It's Deprecated
- Migration Path to Authorization Code + PKCE
EOF

# 11. Hybrid Flow
cat <<EOF > "$DIR_NAME/004-Hybrid-Flow.md"
# Hybrid Flow

- Flow Diagram & Steps
- Response Type Combinations
- Use Cases
- Trade-offs
EOF

# 12. Client Credentials & Other Flows
cat <<EOF > "$DIR_NAME/005-Client-Credentials-and-Other-Flows.md"
# Client Credentials & Other Flows

- Machine-to-Machine Authentication
- Resource Owner Password Credentials (Legacy)
- Device Authorization Flow
EOF

# ==========================================
# PART 4: Endpoints & Discovery
# ==========================================
DIR_NAME="004-Endpoints-and-Discovery"
mkdir -p "$DIR_NAME"

# 13. OIDC Endpoints
cat <<EOF > "$DIR_NAME/001-OIDC-Endpoints.md"
# OIDC Endpoints

- Authorization Endpoint
- Token Endpoint
- UserInfo Endpoint
- Revocation Endpoint
- Introspection Endpoint
- End Session Endpoint
EOF

# 14. Discovery & Metadata
cat <<EOF > "$DIR_NAME/002-Discovery-and-Metadata.md"
# Discovery & Metadata

- Well-Known Configuration Endpoint (/.well-known/openid-configuration)
- Provider Metadata Fields
- Dynamic Discovery
- Caching Considerations
EOF

# 15. JSON Web Key Set (JWKS)
cat <<EOF > "$DIR_NAME/003-JSON-Web-Key-Set.md"
# JSON Web Key Set (JWKS)

- JWKS Endpoint
- Key Structure (kty, kid, use, alg, n, e)
- Key Rotation
- Fetching & Caching Keys
EOF

# ==========================================
# PART 5: Client Registration & Types
# ==========================================
DIR_NAME="005-Client-Registration-and-Types"
mkdir -p "$DIR_NAME"

# 16. Client Types
cat <<EOF > "$DIR_NAME/001-Client-Types.md"
# Client Types

- Confidential Clients
- Public Clients
- Credentialed Clients
- Choosing the Right Client Type
EOF

# 17. Client Registration
cat <<EOF > "$DIR_NAME/002-Client-Registration.md"
# Client Registration

- Static Registration
- Dynamic Client Registration (RFC 7591)
- Registration Metadata
- Client ID & Client Secret Management
EOF

# 18. Client Authentication Methods
cat <<EOF > "$DIR_NAME/003-Client-Authentication-Methods.md"
# Client Authentication Methods

- client_secret_basic
- client_secret_post
- client_secret_jwt
- private_key_jwt
- none (Public Clients)
- mTLS Client Authentication
EOF

# ==========================================
# PART 6: Security
# ==========================================
DIR_NAME="006-Security"
mkdir -p "$DIR_NAME"

# 19. Token Security
cat <<EOF > "$DIR_NAME/001-Token-Security.md"
# Token Security

- Token Storage Best Practices
- Secure Transmission (TLS)
- Token Binding
- Sender-Constrained Tokens (DPoP, mTLS)
EOF

# 20. Common Vulnerabilities & Mitigations
cat <<EOF > "$DIR_NAME/002-Common-Vulnerabilities-and-Mitigations.md"
# Common Vulnerabilities & Mitigations

- CSRF Attacks & State Parameter
- Token Leakage via Referrer
- Open Redirector Attacks
- Authorization Code Injection
- ID Token Substitution
- Replay Attacks & Nonce
- Mix-Up Attacks
EOF

# 21. Security Best Practices
cat <<EOF > "$DIR_NAME/003-Security-Best-Practices.md"
# Security Best Practices

- Always Use HTTPS
- Validate All Tokens
- Implement Proper Redirect URI Validation
- Use Short-Lived Tokens
- Implement Token Revocation
- Secure Storage Guidelines
EOF

# 22. Advanced Security Topics
cat <<EOF > "$DIR_NAME/004-Advanced-Security-Topics.md"
# Advanced Security Topics

- Financial-grade API (FAPI) Profiles
- Pushed Authorization Requests (PAR)
- JWT Secured Authorization Request (JAR)
- Proof of Possession (PoP) Tokens
EOF

# ==========================================
# PART 7: Session Management
# ==========================================
DIR_NAME="007-Session-Management"
mkdir -p "$DIR_NAME"

# 23. Session Basics
cat <<EOF > "$DIR_NAME/001-Session-Basics.md"
# Session Basics

- OP Sessions vs RP Sessions
- Session Cookies
- Session Lifetime Management
EOF

# 24. Session Management Mechanisms
cat <<EOF > "$DIR_NAME/002-Session-Management-Mechanisms.md"
# Session Management Mechanisms

- Session Management via iframes (Legacy)
- Front-Channel Logout
- Back-Channel Logout
- RP-Initiated Logout
- Single Logout (SLO) Challenges
EOF

# 25. Token Refresh Strategies
cat <<EOF > "$DIR_NAME/003-Token-Refresh-Strategies.md"
# Token Refresh Strategies

- Silent Authentication
- Refresh Token Rotation
- Sliding Sessions
- Handling Expired Sessions
EOF

# ==========================================
# PART 8: Implementation
# ==========================================
DIR_NAME="008-Implementation"
mkdir -p "$DIR_NAME"

# 26. Implementing an OIDC Client
cat <<EOF > "$DIR_NAME/001-Implementing-an-OIDC-Client.md"
# Implementing an OIDC Client (Relying Party)

- Choosing a Library/SDK
- Configuration Setup
- Initiating Authentication
- Handling Callbacks
- Token Management
- Error Handling
EOF

# 27. Implementing an OIDC Provider
cat <<EOF > "$DIR_NAME/002-Implementing-an-OIDC-Provider.md"
# Implementing an OIDC Provider

- Architecture Considerations
- User Authentication Backend
- Token Generation & Signing
- Endpoint Implementation
- Compliance Considerations
EOF

# 28. Platform-Specific Implementation
cat <<EOF > "$DIR_NAME/003-Platform-Specific-Implementation.md"
# Platform-Specific Implementation

- Web Applications (Server-Side)
- Single Page Applications (SPA)
- Mobile Applications (iOS/Android)
- Desktop Applications
- CLI Tools
EOF

# 29. Popular OIDC Libraries & SDKs
cat <<EOF > "$DIR_NAME/004-Popular-OIDC-Libraries-and-SDKs.md"
# Popular OIDC Libraries & SDKs

- JavaScript/Node.js
- Python
- Java/.NET
- Go
- Mobile SDKs
EOF

# 30. Popular OIDC Providers
cat <<EOF > "$DIR_NAME/005-Popular-OIDC-Providers.md"
# Popular OIDC Providers

- Auth0
- Okta
- Keycloak
- Azure AD / Microsoft Entra ID
- Google Identity
- AWS Cognito
- PingIdentity
EOF

# ==========================================
# PART 9: Advanced Topics
# ==========================================
DIR_NAME="009-Advanced-Topics"
mkdir -p "$DIR_NAME"

# 31. Claims Aggregation & Distributed Claims
cat <<EOF > "$DIR_NAME/001-Claims-Aggregation-and-Distributed-Claims.md"
# Claims Aggregation & Distributed Claims

- Aggregated Claims
- Distributed Claims
- Use Cases
EOF

# 32. Identity Assurance & Verified Claims
cat <<EOF > "$DIR_NAME/002-Identity-Assurance-and-Verified-Claims.md"
# Identity Assurance & Verified Claims

- eKYC & Identity Assurance
- Verified Claims Structure
- Trust Frameworks
EOF

# 33. OIDC Federation
cat <<EOF > "$DIR_NAME/003-OIDC-Federation.md"
# OIDC Federation

- Federation Concepts
- Trust Chains
- Federation Metadata
EOF

# 34. Native SSO
cat <<EOF > "$DIR_NAME/004-Native-SSO.md"
# Native SSO

- Cross-App SSO on Mobile
- Token Exchange
- Device SSO
EOF

# 35. OIDC & Related Specifications
cat <<EOF > "$DIR_NAME/005-OIDC-and-Related-Specifications.md"
# OIDC & Related Specifications

- OAuth 2.0 Token Exchange (RFC 8693)
- OAuth 2.1 Draft
- OIDC for Identity Assurance
- Self-Issued OpenID Provider (SIOP)
- Decentralized Identity & Verifiable Credentials
EOF

# ==========================================
# PART 10: Testing & Debugging
# ==========================================
DIR_NAME="010-Testing-and-Debugging"
mkdir -p "$DIR_NAME"

# 36. Testing OIDC Implementations
cat <<EOF > "$DIR_NAME/001-Testing-OIDC-Implementations.md"
# Testing OIDC Implementations

- Conformance Testing Tools
- OIDC Certification Program
- Unit Testing Strategies
- Integration Testing
EOF

# 37. Debugging & Troubleshooting
cat <<EOF > "$DIR_NAME/002-Debugging-and-Troubleshooting.md"
# Debugging & Troubleshooting

- Common Errors & Solutions
- Decoding & Inspecting JWTs
- Network Traffic Analysis
- Logging Best Practices
EOF

# ==========================================
# PART 11: Real-World Patterns
# ==========================================
DIR_NAME="011-Real-World-Patterns"
mkdir -p "$DIR_NAME"

# 38. Common Integration Patterns
cat <<EOF > "$DIR_NAME/001-Common-Integration-Patterns.md"
# Common Integration Patterns

- Social Login Integration
- Enterprise SSO
- B2B Multi-Tenancy
- API Gateway Integration
- Microservices Authentication
EOF

# 39. Migration Strategies
cat <<EOF > "$DIR_NAME/002-Migration-Strategies.md"
# Migration Strategies

- Migrating from SAML to OIDC
- Migrating from Custom Auth to OIDC
- Gradual Rollout Strategies
EOF

# 40. Scaling & Performance
cat <<EOF > "$DIR_NAME/003-Scaling-and-Performance.md"
# Scaling & Performance

- Caching Strategies
- Token Introspection vs Local Validation
- High Availability Considerations
EOF

# ==========================================
# APPENDICES
# ==========================================
DIR_NAME="012-Appendices"
mkdir -p "$DIR_NAME"

# A. Specification Documents
cat <<EOF > "$DIR_NAME/001-Specification-Documents.md"
# OIDC Specification Documents & RFCs Reference
EOF

# B. Claims Reference
cat <<EOF > "$DIR_NAME/002-Claims-Reference.md"
# Complete Claims Reference
EOF

# C. Error Codes
cat <<EOF > "$DIR_NAME/003-Error-Codes.md"
# Error Codes Reference
EOF

# D. Glossary
cat <<EOF > "$DIR_NAME/004-Glossary.md"
# Glossary of Terms
EOF

# E. Recommended Reading
cat <<EOF > "$DIR_NAME/005-Recommended-Reading.md"
# Recommended Reading & Resources
EOF

# F. Certification Checklist
cat <<EOF > "$DIR_NAME/006-Certification-Checklist.md"
# Certification & Compliance Checklist
EOF

echo "Directory structure and files created successfully in $(pwd)"


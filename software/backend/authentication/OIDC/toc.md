# OpenID Connect (OIDC) - Developer Study Guide

## Table of Contents

---

### Part 1: Foundations

1. **Introduction to Identity & Authentication**
   - Authentication vs Authorization
   - History of Web Authentication
   - The Problem OIDC Solves

2. **OAuth 2.0 Primer** *(OIDC builds on OAuth 2.0)*
   - OAuth 2.0 Overview
   - Roles: Resource Owner, Client, Authorization Server, Resource Server
   - OAuth 2.0 Grant Types Overview
   - Access Tokens & Refresh Tokens
   - Scopes in OAuth 2.0
   - Limitations of OAuth 2.0 for Authentication

3. **OIDC Overview**
   - What is OpenID Connect?
   - OIDC vs OAuth 2.0 vs SAML
   - OIDC Architecture
   - Key Terminology

---

### Part 2: Core OIDC Concepts

4. **OIDC Roles & Components**
   - End-User (Resource Owner)
   - Relying Party (RP) / Client
   - OpenID Provider (OP) / Identity Provider (IdP)
   - UserInfo Endpoint

5. **Tokens in OIDC**
   - ID Token *(the core OIDC addition)*
   - Access Token
   - Refresh Token
   - Token Lifetimes & Expiration

6. **The ID Token Deep Dive**
   - JWT Structure (Header, Payload, Signature)
   - Standard Claims (`iss`, `sub`, `aud`, `exp`, `iat`, `nonce`, etc.)
   - Optional Claims (`auth_time`, `acr`, `amr`, `azp`)
   - Custom Claims
   - ID Token Validation Steps

7. **Scopes & Claims**
   - OIDC Standard Scopes (`openid`, `profile`, `email`, `address`, `phone`)
   - Requesting Specific Claims
   - Claims Parameter
   - Scope to Claims Mapping

---

### Part 3: Authentication Flows

8. **Authorization Code Flow**
   - Flow Diagram & Steps
   - When to Use
   - Security Considerations
   - Implementation Walkthrough

9. **Authorization Code Flow with PKCE**
   - The Problem with Public Clients
   - PKCE Explained (`code_verifier`, `code_challenge`)
   - Challenge Methods (`plain`, `S256`)
   - Implementation Steps
   - Why PKCE is Now Recommended for All Clients

10. **Implicit Flow** *(Legacy)*
    - Flow Diagram & Steps
    - Security Risks
    - Why It's Deprecated
    - Migration Path to Authorization Code + PKCE

11. **Hybrid Flow**
    - Flow Diagram & Steps
    - Response Type Combinations
    - Use Cases
    - Trade-offs

12. **Client Credentials & Other Flows**
    - Machine-to-Machine Authentication
    - Resource Owner Password Credentials *(Legacy)*
    - Device Authorization Flow

---

### Part 4: Endpoints & Discovery

13. **OIDC Endpoints**
    - Authorization Endpoint
    - Token Endpoint
    - UserInfo Endpoint
    - Revocation Endpoint
    - Introspection Endpoint
    - End Session Endpoint

14. **Discovery & Metadata**
    - Well-Known Configuration Endpoint (`/.well-known/openid-configuration`)
    - Provider Metadata Fields
    - Dynamic Discovery
    - Caching Considerations

15. **JSON Web Key Set (JWKS)**
    - JWKS Endpoint
    - Key Structure (`kty`, `kid`, `use`, `alg`, `n`, `e`)
    - Key Rotation
    - Fetching & Caching Keys

---

### Part 5: Client Registration & Types

16. **Client Types**
    - Confidential Clients
    - Public Clients
    - Credentialed Clients
    - Choosing the Right Client Type

17. **Client Registration**
    - Static Registration
    - Dynamic Client Registration (RFC 7591)
    - Registration Metadata
    - Client ID & Client Secret Management

18. **Client Authentication Methods**
    - `client_secret_basic`
    - `client_secret_post`
    - `client_secret_jwt`
    - `private_key_jwt`
    - `none` (Public Clients)
    - mTLS Client Authentication

---

### Part 6: Security

19. **Token Security**
    - Token Storage Best Practices
    - Secure Transmission (TLS)
    - Token Binding
    - Sender-Constrained Tokens (DPoP, mTLS)

20. **Common Vulnerabilities & Mitigations**
    - CSRF Attacks & State Parameter
    - Token Leakage via Referrer
    - Open Redirector Attacks
    - Authorization Code Injection
    - ID Token Substitution
    - Replay Attacks & Nonce
    - Mix-Up Attacks

21. **Security Best Practices**
    - Always Use HTTPS
    - Validate All Tokens
    - Implement Proper Redirect URI Validation
    - Use Short-Lived Tokens
    - Implement Token Revocation
    - Secure Storage Guidelines

22. **Advanced Security Topics**
    - Financial-grade API (FAPI) Profiles
    - Pushed Authorization Requests (PAR)
    - JWT Secured Authorization Request (JAR)
    - Proof of Possession (PoP) Tokens

---

### Part 7: Session Management

23. **Session Basics**
    - OP Sessions vs RP Sessions
    - Session Cookies
    - Session Lifetime Management

24. **Session Management Mechanisms**
    - Session Management via iframes *(Legacy)*
    - Front-Channel Logout
    - Back-Channel Logout
    - RP-Initiated Logout
    - Single Logout (SLO) Challenges

25. **Token Refresh Strategies**
    - Silent Authentication
    - Refresh Token Rotation
    - Sliding Sessions
    - Handling Expired Sessions

---

### Part 8: Implementation

26. **Implementing an OIDC Client (Relying Party)**
    - Choosing a Library/SDK
    - Configuration Setup
    - Initiating Authentication
    - Handling Callbacks
    - Token Management
    - Error Handling

27. **Implementing an OIDC Provider**
    - Architecture Considerations
    - User Authentication Backend
    - Token Generation & Signing
    - Endpoint Implementation
    - Compliance Considerations

28. **Platform-Specific Implementation**
    - Web Applications (Server-Side)
    - Single Page Applications (SPA)
    - Mobile Applications (iOS/Android)
    - Desktop Applications
    - CLI Tools

29. **Popular OIDC Libraries & SDKs**
    - JavaScript/Node.js
    - Python
    - Java/.NET
    - Go
    - Mobile SDKs

30. **Popular OIDC Providers**
    - Auth0
    - Okta
    - Keycloak
    - Azure AD / Microsoft Entra ID
    - Google Identity
    - AWS Cognito
    - PingIdentity

---

### Part 9: Advanced Topics

31. **Claims Aggregation & Distributed Claims**
    - Aggregated Claims
    - Distributed Claims
    - Use Cases

32. **Identity Assurance & Verified Claims**
    - eKYC & Identity Assurance
    - Verified Claims Structure
    - Trust Frameworks

33. **OIDC Federation**
    - Federation Concepts
    - Trust Chains
    - Federation Metadata

34. **Native SSO**
    - Cross-App SSO on Mobile
    - Token Exchange
    - Device SSO

35. **OIDC & Related Specifications**
    - OAuth 2.0 Token Exchange (RFC 8693)
    - OAuth 2.1 Draft
    - OIDC for Identity Assurance
    - Self-Issued OpenID Provider (SIOP)
    - Decentralized Identity & Verifiable Credentials

---

### Part 10: Testing & Debugging

36. **Testing OIDC Implementations**
    - Conformance Testing Tools
    - OIDC Certification Program
    - Unit Testing Strategies
    - Integration Testing

37. **Debugging & Troubleshooting**
    - Common Errors & Solutions
    - Decoding & Inspecting JWTs
    - Network Traffic Analysis
    - Logging Best Practices

---

### Part 11: Real-World Patterns

38. **Common Integration Patterns**
    - Social Login Integration
    - Enterprise SSO
    - B2B Multi-Tenancy
    - API Gateway Integration
    - Microservices Authentication

39. **Migration Strategies**
    - Migrating from SAML to OIDC
    - Migrating from Custom Auth to OIDC
    - Gradual Rollout Strategies

40. **Scaling & Performance**
    - Caching Strategies
    - Token Introspection vs Local Validation
    - High Availability Considerations

---

### Appendices

- **A.** OIDC Specification Documents & RFCs Reference
- **B.** Complete Claims Reference
- **C.** Error Codes Reference
- **D.** Glossary of Terms
- **E.** Recommended Reading & Resources
- **F.** Certification & Compliance Checklist

---
# OAuth 2.0 & OAuth 2.1 - Developer Study Guide

## Table of Contents

---

### Part 1: Foundations

1. **Introduction to Authorization**
   - Authentication vs Authorization
   - The Problem OAuth Solves
   - History of OAuth (OAuth 1.0 to OAuth 2.1)
   - Real-World Analogies

2. **OAuth 2.0 Overview**
   - What is OAuth 2.0?
   - OAuth 2.0 vs OAuth 1.0
   - OAuth 2.0 vs API Keys vs Basic Auth
   - Core Principles & Design Goals
   - Specification Documents (RFC 6749, RFC 6750)

3. **OAuth 2.0 Terminology**
   - Resource Owner
   - Client
   - Authorization Server
   - Resource Server
   - Protected Resource
   - Redirect URI / Callback URL
   - Scope
   - Grant
   - Token

---

### Part 2: Core Components

4. **Roles in OAuth 2.0**
   - Resource Owner (End-User)
   - Client Application
   - Authorization Server
   - Resource Server
   - Role Interactions & Trust Relationships

5. **Client Types**
   - Confidential Clients
   - Public Clients
   - Credentialed Clients *(OAuth 2.1)*
   - First-Party vs Third-Party Clients
   - Client Profiles (Web App, Browser-Based App, Native App)

6. **Client Registration**
   - Static Registration
   - Dynamic Client Registration (RFC 7591)
   - Dynamic Client Management (RFC 7592)
   - Registration Metadata
   - Client ID & Client Secret
   - Redirect URI Registration

7. **Tokens**
   - Access Tokens
   - Refresh Tokens
   - Token Types (Bearer, PoP, DPoP)
   - Token Formats (Opaque vs Structured)
   - Token Lifetime & Expiration
   - Token Metadata

8. **Scopes**
   - What are Scopes?
   - Scope Design Patterns
   - Scope Naming Conventions
   - Requesting Scopes
   - Scope Consent
   - Downscoping

---

### Part 3: Grant Types (Authorization Flows)

9. **Authorization Code Grant**
   - Flow Diagram & Steps
   - Authorization Request Parameters
   - Authorization Response
   - Token Request
   - Token Response
   - When to Use
   - Security Considerations

10. **Authorization Code Grant with PKCE**
    - The Problem with Public Clients
    - PKCE Overview (RFC 7636)
    - Code Verifier Generation
    - Code Challenge Methods (`plain`, `S256`)
    - Flow Diagram with PKCE
    - Implementation Steps
    - Why PKCE is Mandatory in OAuth 2.1

11. **Implicit Grant** *(Deprecated)*
    - Flow Diagram & Steps
    - Historical Use Cases
    - Security Vulnerabilities
    - Why It's Removed in OAuth 2.1
    - Migration Path

12. **Resource Owner Password Credentials Grant** *(Deprecated)*
    - Flow Diagram & Steps
    - Limited Use Cases
    - Security Risks
    - Why It's Removed in OAuth 2.1
    - Alternatives

13. **Client Credentials Grant**
    - Flow Diagram & Steps
    - Machine-to-Machine Authorization
    - Service Accounts
    - When to Use
    - Security Considerations

14. **Refresh Token Grant**
    - Flow Diagram & Steps
    - Refresh Token Rotation
    - Refresh Token Expiration Strategies
    - Binding Refresh Tokens to Clients
    - Revocation Considerations

15. **Device Authorization Grant (RFC 8628)**
    - Use Cases (Smart TVs, CLI Tools, IoT)
    - Flow Diagram & Steps
    - Device Code & User Code
    - Polling Mechanism
    - User Experience Considerations

16. **Token Exchange Grant (RFC 8693)**
    - Use Cases (Delegation, Impersonation)
    - Subject Token & Actor Token
    - Token Types
    - Flow Diagram & Steps
    - Delegation vs Impersonation

17. **JWT Bearer Assertion Grant (RFC 7523)**
    - Use Cases
    - JWT Assertion Structure
    - Flow Diagram & Steps
    - Service Account Authentication

18. **SAML 2.0 Bearer Assertion Grant (RFC 7522)**
    - Use Cases
    - SAML Assertion Requirements
    - Integration with Enterprise IdPs

---

### Part 4: Endpoints

19. **Authorization Endpoint**
    - Purpose & Behavior
    - Request Parameters
    - Response Modes (`query`, `fragment`, `form_post`)
    - Error Responses
    - User Interaction & Consent

20. **Token Endpoint**
    - Purpose & Behavior
    - Request Parameters by Grant Type
    - Client Authentication at Token Endpoint
    - Token Response Structure
    - Error Responses

21. **Redirect URI / Callback Endpoint**
    - Purpose
    - Validation Rules
    - Exact Match vs Pattern Matching
    - Localhost Considerations
    - Security Implications

22. **Revocation Endpoint (RFC 7009)**
    - Purpose & Behavior
    - Revoking Access Tokens
    - Revoking Refresh Tokens
    - Revocation Propagation
    - Error Handling

23. **Introspection Endpoint (RFC 7662)**
    - Purpose & Behavior
    - Request Structure
    - Response Structure
    - Active vs Inactive Tokens
    - Performance Considerations
    - When to Use Introspection vs Local Validation

24. **Device Authorization Endpoint**
    - Purpose & Behavior
    - Request & Response Structure
    - User Code Display

25. **Pushed Authorization Request Endpoint (RFC 9126)**
    - Purpose & Benefits
    - Request Structure
    - Request URI
    - Integration with Authorization Endpoint

---

### Part 5: Client Authentication

26. **Client Authentication Methods**
    - `none` (Public Clients)
    - `client_secret_basic`
    - `client_secret_post`
    - `client_secret_jwt` (RFC 7523)
    - `private_key_jwt` (RFC 7523)
    - `tls_client_auth` (RFC 8705)
    - `self_signed_tls_client_auth` (RFC 8705)

27. **Choosing Authentication Methods**
    - Security Comparison
    - Implementation Complexity
    - Platform Considerations
    - Best Practices

---

### Part 6: Token Types & Formats

28. **Bearer Tokens (RFC 6750)**
    - What are Bearer Tokens?
    - Transmitting Bearer Tokens
    - Authorization Header
    - Form-Encoded Body Parameter *(Discouraged)*
    - URI Query Parameter *(Discouraged)*
    - Security Considerations

29. **JWT Access Tokens (RFC 9068)**
    - Structure & Claims
    - Standard Claims (`iss`, `sub`, `aud`, `exp`, `iat`, `jti`, `client_id`, `scope`)
    - Signing Algorithms
    - Validation Steps
    - Pros & Cons vs Opaque Tokens

30. **Opaque Tokens**
    - Structure & Generation
    - Token Storage
    - Introspection Requirements
    - Pros & Cons vs JWT

31. **Proof-of-Possession Tokens**
    - The Problem with Bearer Tokens
    - DPoP (Demonstrating Proof of Possession) - RFC 9449
    - mTLS-Bound Tokens (RFC 8705)
    - Token Binding *(Deprecated)*

---

### Part 7: Security

32. **OAuth 2.0 Threat Model (RFC 6819)**
    - Threat Categories
    - Client Threats
    - Authorization Server Threats
    - Token Threats
    - Endpoint Threats

33. **Common Vulnerabilities**
    - Authorization Code Interception
    - CSRF Attacks
    - Open Redirector Attacks
    - Token Leakage via Referrer Header
    - Token Leakage in Browser History
    - Mix-Up Attacks
    - Clickjacking
    - Code Injection Attacks
    - Access Token Injection

34. **Security Mitigations**
    - State Parameter for CSRF Protection
    - PKCE for Code Interception
    - Exact Redirect URI Matching
    - TLS Everywhere
    - Short-Lived Access Tokens
    - Refresh Token Rotation
    - Token Binding / Sender-Constraining
    - `iss` Parameter for Mix-Up Prevention

35. **OAuth 2.0 Security Best Current Practice (RFC 9700)**
    - Recommendations Summary
    - Mandatory PKCE
    - Redirect URI Restrictions
    - Refresh Token Protection
    - Access Token Protection
    - Authorization Server Recommendations

36. **Browser-Based Application Security (RFC 8252 + BCP)**
    - SPA-Specific Threats
    - Token Storage in Browser
    - Backend-for-Frontend (BFF) Pattern
    - Same-Site Cookies
    - Cross-Origin Considerations

37. **Native Application Security (RFC 8252)**
    - Platform-Specific Considerations
    - Custom URI Schemes
    - Claimed HTTPS Schemes (Universal Links, App Links)
    - PKCE Requirement
    - System Browser vs Embedded WebView
    - Loopback Interface Redirect

---

### Part 8: OAuth 2.1

38. **OAuth 2.1 Overview**
    - What's New in OAuth 2.1
    - Consolidation of Security BCPs
    - Removed Features

39. **OAuth 2.1 Changes from OAuth 2.0**
    - PKCE Required for All Clients
    - Implicit Grant Removed
    - Password Grant Removed
    - Bearer Token in URI Query Removed
    - Refresh Token Rotation Recommended
    - Exact Redirect URI Matching Required
    - Security BCP Integration

40. **Migrating from OAuth 2.0 to OAuth 2.1**
    - Assessment Checklist
    - Migration Steps
    - Backward Compatibility Considerations

---

### Part 9: Advanced Topics

41. **Resource Indicators (RFC 8707)**
    - Purpose & Use Cases
    - Resource Parameter
    - Audience Restriction
    - Multi-Resource Requests

42. **Rich Authorization Requests (RFC 9396)**
    - Beyond Simple Scopes
    - Authorization Details Structure
    - Type-Specific Fields
    - Use Cases (Payments, Data Sharing)

43. **Pushed Authorization Requests (PAR) - RFC 9126**
    - Purpose & Benefits
    - Request Object Security
    - Integration Flow
    - Confidentiality & Integrity

44. **JWT-Secured Authorization Request (JAR) - RFC 9101**
    - Request Object
    - Signed & Encrypted Requests
    - Passing by Value vs by Reference
    - Security Benefits

45. **Mutual TLS (mTLS) - RFC 8705**
    - Client Certificate Authentication
    - Certificate-Bound Access Tokens
    - PKI Considerations
    - Implementation Complexity

46. **DPoP (Demonstrating Proof of Possession) - RFC 9449**
    - DPoP Proof JWT Structure
    - Binding Tokens to Key Pairs
    - Flow Diagram
    - Browser & Native App Considerations
    - DPoP Nonce

47. **Token Introspection & Management**
    - Centralized vs Distributed Validation
    - Token Caching Strategies
    - Real-Time Revocation Checking

48. **Step-Up Authentication**
    - ACR Values
    - Insufficient User Authentication Response
    - Re-Authentication Flows
    - `max_age` Parameter

49. **Financial-Grade API (FAPI)**
    - FAPI 1.0 Baseline & Advanced
    - FAPI 2.0 Security Profile
    - Use Cases (Banking, Open Finance)
    - Requirements Summary

50. **Global Token Revocation**
    - Revocation Challenges
    - Event-Based Revocation
    - Shared Signals Framework (SSF)
    - CAEP (Continuous Access Evaluation Protocol)

---

### Part 10: Implementation Patterns

51. **Web Application Integration**
    - Server-Side Flow
    - Session Management
    - Token Storage
    - Logout Handling

52. **Single Page Application (SPA) Integration**
    - Authorization Code + PKCE
    - Token Storage Options (Memory, Session Storage)
    - Silent Refresh Strategies
    - BFF Pattern Implementation

53. **Mobile Application Integration**
    - iOS Implementation (ASWebAuthenticationSession)
    - Android Implementation (Custom Tabs)
    - Secure Token Storage (Keychain, Keystore)
    - Biometric Protection
    - Deep Linking

54. **CLI & Desktop Application Integration**
    - Loopback Redirect
    - Device Authorization Flow
    - Manual Code Copy
    - Token Caching

55. **Microservices & API Gateway Integration**
    - Gateway Token Validation
    - Token Exchange Between Services
    - Service-to-Service Authorization
    - Propagating User Context

56. **Machine-to-Machine Integration**
    - Client Credentials Flow
    - Service Account Management
    - Secret Rotation
    - Workload Identity

---

### Part 11: Authorization Server Implementation

57. **Authorization Server Architecture**
    - Core Components
    - Storage Requirements
    - Scalability Considerations
    - High Availability

58. **Implementing Core Endpoints**
    - Authorization Endpoint Logic
    - Token Endpoint Logic
    - Consent Management
    - Error Handling

59. **Token Generation & Management**
    - Token Format Selection
    - Signing Keys Management
    - Token Storage & Indexing
    - Revocation Implementation

60. **Client Management**
    - Registration Workflows
    - Secret Management & Rotation
    - Client Policy Enforcement

61. **Consent & User Experience**
    - Consent Screen Design
    - Scope Descriptions
    - Consent Persistence
    - Consent Revocation

62. **Popular Authorization Servers**
    - Keycloak
    - IdentityServer / Duende
    - Auth0
    - Okta
    - AWS Cognito
    - Azure AD / Microsoft Entra ID
    - Hydra (Ory)
    - Spring Authorization Server
    - Authlib

---

### Part 12: Resource Server Implementation

63. **Resource Server Architecture**
    - Token Validation Strategies
    - Middleware / Filter Design
    - Caching Considerations

64. **Token Validation**
    - JWT Local Validation
    - Introspection-Based Validation
    - Hybrid Approaches
    - Clock Skew Handling
    - Key Rotation Handling

65. **Scope & Permission Enforcement**
    - Scope-Based Access Control
    - Fine-Grained Authorization
    - Policy Decision Points
    - Attribute-Based Access Control (ABAC)

66. **Error Responses (RFC 6750)**
    - `invalid_token`
    - `insufficient_scope`
    - `invalid_request`
    - WWW-Authenticate Header

---

### Part 13: Testing & Debugging

67. **Testing OAuth Implementations**
    - Unit Testing Strategies
    - Integration Testing
    - Mocking Authorization Servers
    - Conformance Testing

68. **Debugging & Troubleshooting**
    - Common Errors & Solutions
    - Token Inspection Tools
    - Network Traffic Analysis
    - Logging Best Practices

69. **Security Testing**
    - Penetration Testing Checklist
    - Automated Security Scanning
    - Vulnerability Assessment

---

### Part 14: Operations & Monitoring

70. **Token Lifecycle Management**
    - Issuance Monitoring
    - Usage Analytics
    - Revocation Tracking
    - Expiration Management

71. **Key Management**
    - Signing Key Generation
    - Key Rotation Strategies
    - Key Storage (HSM, Cloud KMS)
    - JWKS Endpoint Management

72. **Monitoring & Alerting**
    - Metrics to Track
    - Anomaly Detection
    - Rate Limiting
    - Abuse Prevention

73. **Audit & Compliance**
    - Audit Logging Requirements
    - Compliance Frameworks (SOC 2, GDPR, PCI-DSS)
    - Data Retention Policies

---

### Part 15: Related Specifications & Ecosystem

74. **OAuth Extensions & Related RFCs**
    - RFC Index & Summary
    - Experimental vs Standards Track
    - Draft Specifications to Watch

75. **OpenID Connect Relationship**
    - OIDC as OAuth Extension
    - When to Use OAuth vs OIDC
    - ID Tokens vs Access Tokens

76. **UMA (User-Managed Access)**
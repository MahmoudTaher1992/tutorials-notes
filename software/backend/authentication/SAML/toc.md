# SAML 2.0 - Developer Study Guide

## Table of Contents

---

### Part 1: Foundations

1. **Introduction to Federated Identity**
   - What is Federated Identity?
   - Identity Federation vs Single Sign-On
   - The Problem SAML Solves
   - Enterprise Identity Landscape

2. **History of SAML**
   - SAML 1.0 & 1.1
   - Evolution to SAML 2.0
   - OASIS Standards Organization
   - SAML's Role in Enterprise SSO

3. **SAML 2.0 Overview**
   - What is SAML 2.0?
   - SAML vs OAuth 2.0 vs OpenID Connect
   - SAML vs WS-Federation
   - When to Use SAML
   - Core Design Principles

4. **SAML Terminology**
   - Principal
   - Identity Provider (IdP)
   - Service Provider (SP)
   - Assertion
   - Binding
   - Profile
   - Metadata
   - Trust Relationship

---

### Part 2: Core Components

5. **SAML Roles**
   - Identity Provider (IdP)
   - Service Provider (SP)
   - Principal (User)
   - Attribute Authority
   - Policy Decision Point (PDP)

6. **SAML Assertions**
   - What is an Assertion?
   - Assertion Structure (XML)
   - Assertion ID & Versioning
   - Issuer Element
   - Signature Element
   - Subject Element
   - Conditions Element
   - Assertion Validity

7. **Assertion Statements**
   - Authentication Statement (`AuthnStatement`)
   - Attribute Statement (`AttributeStatement`)
   - Authorization Decision Statement (`AuthzDecisionStatement`)
   - Statement Combinations

8. **Authentication Context**
   - Authentication Context Classes
   - Password-Based Authentication
   - Multi-Factor Authentication Contexts
   - Certificate-Based Authentication
   - Custom Authentication Contexts
   - Requesting Specific Contexts

9. **Attributes & Attribute Statements**
   - Attribute Structure
   - Attribute Name Formats
   - Standard Attribute Profiles
   - eduPerson Attributes
   - Custom Attributes
   - Attribute Value Types

10. **Subject & Name Identifiers**
    - Subject Element Structure
    - NameID Formats
      - Unspecified
      - Email Address
      - Persistent
      - Transient
      - X.509 Subject Name
      - Windows Domain Qualified Name
      - Kerberos Principal Name
      - Entity Identifier
    - Subject Confirmation
    - Subject Confirmation Methods (`bearer`, `holder-of-key`, `sender-vouches`)

11. **Conditions & Constraints**
    - `NotBefore` & `NotOnOrAfter`
    - `AudienceRestriction`
    - `OneTimeUse`
    - `ProxyRestriction`
    - Custom Conditions

---

### Part 3: Protocols

12. **SAML Protocol Overview**
    - Request-Response Model
    - Protocol Message Structure
    - Status Codes
    - Protocol Extensions

13. **Authentication Request Protocol**
    - `AuthnRequest` Structure
    - Request Parameters
      - `ID`
      - `IssueInstant`
      - `Destination`
      - `AssertionConsumerServiceURL`
      - `ProtocolBinding`
      - `IsPassive`
      - `ForceAuthn`
    - `NameIDPolicy`
    - `RequestedAuthnContext`
    - Scoping & IdP Discovery

14. **Authentication Response**
    - `Response` Structure
    - Status Codes
      - `Success`
      - `Requester`
      - `Responder`
      - `VersionMismatch`
    - Second-Level Status Codes
    - Embedded Assertions
    - Encrypted Assertions

15. **Artifact Resolution Protocol**
    - What are Artifacts?
    - `ArtifactResolve` Request
    - `ArtifactResponse`
    - Artifact Format & Structure
    - Use Cases

16. **Single Logout Protocol**
    - `LogoutRequest` Structure
    - `LogoutResponse` Structure
    - Logout Initiators (IdP vs SP)
    - Session Index
    - Partial Logout Handling
    - Logout Propagation Challenges

17. **Name Identifier Management Protocol**
    - `ManageNameIDRequest`
    - `ManageNameIDResponse`
    - Name ID Termination
    - Name ID Format Changes

18. **Assertion Query & Request Protocol**
    - `AssertionIDRequest`
    - `AuthnQuery`
    - `AttributeQuery`
    - `AuthzDecisionQuery`
    - Use Cases

---

### Part 4: Bindings

19. **SAML Bindings Overview**
    - What are Bindings?
    - Binding Selection Criteria
    - Security Considerations per Binding

20. **HTTP Redirect Binding**
    - How It Works
    - URL Encoding
    - Deflate Compression
    - Signature in Query String
    - Size Limitations
    - Use Cases

21. **HTTP POST Binding**
    - How It Works
    - Auto-Submitting Forms
    - Base64 Encoding
    - Signature in XML
    - Use Cases

22. **HTTP Artifact Binding**
    - How It Works
    - Artifact Structure
    - Back-Channel Resolution
    - Security Benefits
    - Use Cases

23. **SOAP Binding**
    - How It Works
    - SOAP Envelope Structure
    - Synchronous Communication
    - Use Cases

24. **PAOS Binding (Reverse SOAP)**
    - Enhanced Client/Proxy Profile
    - Liberty Alliance Origins
    - Mobile & ECP Use Cases

25. **URI Binding**
    - Direct Assertion Retrieval
    - Limited Use Cases

---

### Part 5: Profiles

26. **SAML Profiles Overview**
    - What are Profiles?
    - Profile Components
    - Profile Selection

27. **Web Browser SSO Profile**
    - SP-Initiated SSO Flow
    - IdP-Initiated SSO Flow
    - Flow Diagrams
    - Binding Combinations
    - Implementation Steps
    - Security Considerations

28. **Enhanced Client or Proxy (ECP) Profile**
    - Use Cases (Mobile, Non-Browser)
    - PAOS Binding Usage
    - Flow Diagram
    - Implementation Considerations

29. **Single Logout Profile**
    - SP-Initiated Logout
    - IdP-Initiated Logout
    - Front-Channel vs Back-Channel Logout
    - Logout Propagation
    - Partial Logout Scenarios
    - User Experience Considerations

30. **Artifact Resolution Profile**
    - When to Use Artifacts
    - Flow Diagram
    - Security Benefits
    - Implementation Complexity

31. **Assertion Query/Request Profile**
    - Attribute Query Profile
    - Authentication Query Profile
    - Authorization Decision Query Profile
    - Use Cases

32. **Name Identifier Mapping Profile**
    - Cross-Domain Identity Mapping
    - Use Cases

33. **Name Identifier Management Profile**
    - Account Linking Changes
    - Federation Termination
    - Use Cases

34. **Identity Provider Discovery Profile**
    - Common Domain Cookie
    - Discovery Service
    - WAYF (Where Are You From) Services
    - User Experience

---

### Part 6: Metadata

35. **SAML Metadata Overview**
    - Purpose of Metadata
    - Metadata Exchange
    - Trust Establishment
    - Metadata Formats

36. **Entity Descriptor**
    - `EntityDescriptor` Structure
    - Entity ID
    - Valid Until & Cache Duration
    - Extensions

37. **IdP Metadata Elements**
    - `IDPSSODescriptor`
    - `SingleSignOnService`
    - `SingleLogoutService`
    - `ArtifactResolutionService`
    - `NameIDFormat`
    - `Attribute` (Supported Attributes)

38. **SP Metadata Elements**
    - `SPSSODescriptor`
    - `AssertionConsumerService`
    - `SingleLogoutService`
    - `AttributeConsumingService`
    - `RequestedAttribute`
    - `NameIDFormat`
    - `AuthnRequestsSigned`
    - `WantAssertionsSigned`

39. **Key Descriptors & Certificates**
    - `KeyDescriptor` Element
    - Signing Keys
    - Encryption Keys
    - Key Use Attribute
    - Certificate Embedding
    - Certificate Rotation

40. **Organization & Contact Information**
    - `Organization` Element
    - `ContactPerson` Element
    - Administrative Contacts
    - Technical Contacts
    - Support Contacts

41. **Metadata Extensions**
    - UI Elements (Logo, Display Name, Description)
    - Discovery Hints
    - Entity Attributes
    - Algorithm Support

42. **Metadata Management**
    - Metadata Publishing
    - Metadata Aggregates
    - Metadata Signing
    - Automated Refresh
    - Metadata Registries

---

### Part 7: Security

43. **XML Signature in SAML**
    - XML Digital Signature (XMLDSig) Overview
    - Enveloped Signatures
    - Signature Structure
    - Canonicalization
    - Signing Algorithms (RSA, ECDSA)
    - Digest Algorithms (SHA-256, SHA-384, SHA-512)
    - Reference URIs
    - What to Sign (Assertions, Messages)

44. **XML Encryption in SAML**
    - XML Encryption Overview
    - Encrypting Assertions
    - Encrypting NameID
    - Encrypting Attributes
    - Key Transport Algorithms
    - Block Encryption Algorithms
    - `EncryptedAssertion` Structure
    - `EncryptedID` Structure

45. **Certificate Management**
    - Certificate Requirements
    - Self-Signed vs CA-Signed
    - Certificate Lifecycle
    - Certificate Rotation Strategies
    - Key Rollover
    - Certificate Pinning
    - Trust Anchors

46. **Common Vulnerabilities**
    - XML Signature Wrapping Attacks
    - XML Injection
    - XXE (XML External Entity) Attacks
    - Assertion Replay Attacks
    - Man-in-the-Middle Attacks
    - Session Fixation
    - Open Redirect
    - Cross-Site Scripting (XSS) in Relay State

47. **Security Mitigations**
    - Strict Schema Validation
    - Signature Validation Best Practices
    - Audience Restriction Enforcement
    - Time Validation (`NotBefore`, `NotOnOrAfter`)
    - Replay Prevention (Assertion ID Caching)
    - Destination Validation
    - InResponseTo Validation
    - Secure RelayState Handling

48. **Security Best Practices**
    - Always Use HTTPS
    - Sign All Messages & Assertions
    - Encrypt Sensitive Assertions
    - Validate Everything
    - Use Strong Algorithms
    - Implement Proper Error Handling
    - Logging & Monitoring
    - Regular Security Audits

---

### Part 8: Implementation

49. **Implementing a Service Provider**
    - Architecture Overview
    - SP Metadata Generation
    - Initiating SSO
    - Handling SAML Response
    - Assertion Validation Steps
    - Session Management
    - Attribute Mapping
    - Error Handling

50. **Implementing an Identity Provider**
    - Architecture Overview
    - IdP Metadata Generation
    - User Authentication Backend
    - Assertion Generation
    - Attribute Retrieval & Release
    - Signing & Encryption
    - Session Management
    - Multi-SP Support

51. **SP-Initiated SSO Implementation**
    - Flow Walkthrough
    - AuthnRequest Generation
    - Redirect/POST to IdP
    - Response Handling
    - Assertion Processing
    - Session Creation
    - Error Scenarios

52. **IdP-Initiated SSO Implementation**
    - Flow Walkthrough
    - Unsolicited Response Generation
    - Deep Linking with RelayState
    - Security Considerations
    - When to Use/Avoid

53. **Single Logout Implementation**
    - SP-Initiated Logout Flow
    - IdP-Initiated Logout Flow
    - Session Tracking Requirements
    - Handling Partial Logout
    - User Experience Design
    - Timeout Handling

54. **Attribute Handling**
    - Attribute Mapping Configuration
    - Attribute Transformation
    - Required vs Optional Attributes
    - Attribute Release Policies
    - Just-In-Time Provisioning

55. **Session Management**
    - SP Session vs IdP Session
    - Session Index Tracking
    - Session Timeout Strategies
    - Session Revocation
    - Concurrent Session Handling

---

### Part 9: Platform-Specific Implementation

56. **Java Implementation**
    - OpenSAML Library
    - Spring Security SAML
    - pac4j
    - Shibboleth
    - Implementation Patterns

57. **.NET Implementation**
    - ITfoxtec.Identity.Saml2
    - Sustainsys.Saml2
    - ComponentSpace SAML
    - Azure AD Integration
    - Implementation Patterns

58. **Python Implementation**
    - python-saml (OneLogin)
    - pysaml2
    - Django SAML
    - Flask SAML
    - Implementation Patterns

59. **PHP Implementation**
    - SimpleSAMLphp
    - php-saml (OneLogin)
    - Laravel SAML
    - Implementation Patterns

60. **Node.js Implementation**
    - passport-saml
    - saml2-js
    - node-saml
    - Implementation Patterns

61. **Ruby Implementation**
    - ruby-saml
    - OmniAuth SAML
    - Implementation Patterns

62. **Go Implementation**
    - crewjam/saml
    - gosaml2
    - Implementation Patterns

---

### Part 10: Identity Providers

63. **Popular Identity Providers**
    - Microsoft Entra ID (Azure AD)
    - Okta
    - OneLogin
    - PingIdentity / PingFederate
    - Auth0
    - Google Workspace
    - Shibboleth IdP
    - Keycloak
    - ADFS (Active Directory Federation Services)
    - JumpCloud

64. **IdP Configuration Patterns**
    - Attribute Mapping
    - Group/Role Mapping
    - Conditional Access Policies
    - MFA Integration
    - Custom Claims
    - Certificate Management

65. **IdP-Specific Considerations**
    - Metadata URLs
    - Logout Behavior Differences
    - Attribute Format Variations
    - Clock Skew Handling
    - Error Response Differences

---

### Part 11: Federation & Trust

66. **Trust Establishment**
    - Metadata Exchange Methods
    - Out-of-Band Verification
    - Trust Anchors
    - Certificate Chain Validation

67. **Federation Models**
    - Bilateral Federation
    - Hub-and-Spoke Federation
    - Mesh Federation
    - Proxy-Based Federation

68. **Federation Metadata**
    - Metadata Aggregates
    - Interfederation
    - Trust Frameworks
    - Metadata Signing & Verification

69. **Academic & Research Federations**
    - InCommon (US)
    - UK Federation
    - eduGAIN
    - Federation Policies
    - Entity Categories

70. **Government Federations**
    - Federal Identity Frameworks
    - Cross-Agency Federation
    - Assurance Levels
    - Compliance Requirements

71. **Enterprise Federation Patterns**
    - Partner Federation
    - Customer Identity Federation
    - Workforce Federation
    - Multi-Tenant SaaS Federation

---

### Part 12: Advanced Topics

72. **Proxying & Identity Brokering**
    - SAML Proxy Architecture
    - Protocol Translation (SAML ↔ OIDC)
    - Attribute Aggregation
    - IdP Discovery Behind Proxy
    - Use Cases

73. **Step-Up Authentication**
    - Authentication Context Requests
    - Forcing Re-Authentication
    - MFA Step-Up Flows
    - Risk-Based Authentication

74. **Account Linking**
    - Persistent vs Transient Identifiers
    - Linking Strategies
    - User-Initiated Linking
    - Administrative Linking
    - Unlinking Accounts

75. **Just-In-Time Provisioning**
    - User Creation on First Login
    - Attribute-Based Provisioning
    - Group/Role Assignment
    - Conflict Resolution
    - Deprovisioning Considerations

76. **SCIM Integration with SAML**
    - Provisioning vs Authentication
    - SCIM for User Lifecycle
    - SAML + SCIM Architecture
    - Synchronization Strategies

77. **Holder-of-Key Assertions**
    - Subject Confirmation Method
    - Key Binding
    - Use Cases
    - Implementation Complexity

78. **Attribute Authorities**
    - Standalone Attribute Services
    - Attribute Query Protocol
    - Distributed Attribute Retrieval
    - Use Cases

---

### Part 13: Migration & Interoperability

79. **Migrating from SAML 1.1 to SAML 2.0**
    - Key Differences
    - Migration Steps
    - Backward Compatibility
    - Testing Strategies

80. **SAML to OIDC Migration**
    - Feature Comparison
    - Migration Strategies
    - Parallel Running
    - User Experience Considerations
    - Protocol Translation (Proxy)

81. **Hybrid SAML/OIDC Environments**
    - Use Cases
    - Architecture Patterns
    - Identity Broker Solutions
    - Attribute/Claim Mapping

82. **Interoperability Testing**
    - SAML Conformance Testing
    - IdP Testing Tools
    - SP Testing Tools
    - Common Interoperability Issues

---

### Part 14: Testing & Debugging

83. **Testing SAML Implementations**
    - Unit Testing Strategies
    - Integration Testing
    - Mock IdP/SP Tools
    - Conformance Testing

84. **SAML Testing Tools**
    - SAML Tracer (Browser Extension)
    - SAML Developer Tools
    - samltool.com
    - SAMLTest.id
    - Shibboleth Test IdP

85. **Debugging SAML Flows**
    - Capturing SAML Messages
    - Decoding Base64 Payloads
    - Validating Signatures Manually
    - Common Error Messages
    - Troubleshooting Checklist

86. **Common Issues & Solutions**
    - Clock Skew Errors
    - Certificate Mismatch
    - Audience Restriction Failures
    - NameID Format Mismatch
    - Attribute Mapping Issues
    - Redirect Loop Problems
    - Signature Validation Failures

---

### Part 15: Operations & Monitoring

87. **Certificate Lifecycle Management**
    - Certificate Generation
    - Certificate Rotation Planning
    - Dual-Certificate Support
    - Emergency Certificate Rollover
    - Expiration Monitoring

88. **Metadata Management Operations**
    - Metadata Publishing
    - Metadata Refresh Automation
    - Metadata Backup
    - Change Management

89. **Monitoring & Alerting**
    - SSO Success/Failure Metrics
    - Latency Monitoring
    - Certificate Expiration Alerts
    - Anomaly Detection
    - User Login Analytics

90. **High Availability & Scalability**
    - IdP Clustering
    - SP Session Distribution
    - Load Balancer Considerations
    - Failover Strategies

91. **Audit & Compliance**
    - Audit Logging Requirements
    - Log Retention Policies
    - Compliance Frameworks
    - Privacy Considerations (GDPR)
    - Consent Management

---

### Part 16: SAML in Modern Architecture

92. **SAML in Microservices**
    - Gateway Pattern
    - Token Translation
    - Service-to-Service Authentication
    - Challenges & Limitations

93. **SAML in Cloud Environments**
    - AWS SSO Integration
    - Azure AD Integration
    - Google Cloud Integration
    - Multi-Cloud Federation

94. **SAML for SaaS Applications**
    - Customer-Managed IdP Integration
    - Multi-Tenant SAML Configuration
    - Self-Service SSO Setup
    - SP Metadata Templates

95. **SAML Limitations & Alternatives**
    - Mobile Application Challenges
    - API Authentication Limitations
    - When to Choose OIDC Instead
    - Modern Alternatives

---

### Appendices

- **A.** SAML 2.0 Specification Documents Reference
- **B.** XML Namespaces Reference
- **C.** SAML URIs & Identifiers Registry
- **D.** Status Code Reference
- **E.** Authentication Context Class Reference
- **F.** NameID Format Reference
- **G.** Attribute Name Format Reference
- **H.** Common Attributes Reference (eduPerson, SCHAC, etc.)
- **I.** Error Messages & Troubleshooting Guide
- **J.** Glossary of Terms
- **K.** Security Checklist
- **L.** Metadata Template Examples
- **M.** Popular Libraries & Frameworks by Language
- **N.** Recommended Reading & Resources

---
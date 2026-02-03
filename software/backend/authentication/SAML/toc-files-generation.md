
#!/bin/bash

# Root directory name
ROOT_DIR="SAML-2.0-Developer-Study-Guide"

# Create root directory
mkdir -p "$ROOT_DIR"
echo "Creating study guide structure in: $ROOT_DIR"

# Function to create a file with content
create_file() {
    local dir_path="$1"
    local file_name="$2"
    local header="$3"
    local content="$4"
    local full_path="$ROOT_DIR/$dir_path/$file_name"

    # Create content
    echo "# $header" > "$full_path"
    echo "" >> "$full_path"
    echo "$content" >> "$full_path"
    echo "Created: $dir_path/$file_name"
}

# -----------------------------------------------------------------------------
# Part 1: Foundations
# -----------------------------------------------------------------------------
DIR="001-Foundations"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Introduction-to-Federated-Identity.md" "Introduction to Federated Identity" \
"- What is Federated Identity?
- Identity Federation vs Single Sign-On
- The Problem SAML Solves
- Enterprise Identity Landscape"

create_file "$DIR" "002-History-of-SAML.md" "History of SAML" \
"- SAML 1.0 & 1.1
- Evolution to SAML 2.0
- OASIS Standards Organization
- SAML's Role in Enterprise SSO"

create_file "$DIR" "003-SAML-2.0-Overview.md" "SAML 2.0 Overview" \
"- What is SAML 2.0?
- SAML vs OAuth 2.0 vs OpenID Connect
- SAML vs WS-Federation
- When to Use SAML
- Core Design Principles"

create_file "$DIR" "004-SAML-Terminology.md" "SAML Terminology" \
"- Principal
- Identity Provider (IdP)
- Service Provider (SP)
- Assertion
- Binding
- Profile
- Metadata
- Trust Relationship"

# -----------------------------------------------------------------------------
# Part 2: Core Components
# -----------------------------------------------------------------------------
DIR="002-Core-Components"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-SAML-Roles.md" "SAML Roles" \
"- Identity Provider (IdP)
- Service Provider (SP)
- Principal (User)
- Attribute Authority
- Policy Decision Point (PDP)"

create_file "$DIR" "002-SAML-Assertions.md" "SAML Assertions" \
"- What is an Assertion?
- Assertion Structure (XML)
- Assertion ID & Versioning
- Issuer Element
- Signature Element
- Subject Element
- Conditions Element
- Assertion Validity"

create_file "$DIR" "003-Assertion-Statements.md" "Assertion Statements" \
"- Authentication Statement (AuthnStatement)
- Attribute Statement (AttributeStatement)
- Authorization Decision Statement (AuthzDecisionStatement)
- Statement Combinations"

create_file "$DIR" "004-Authentication-Context.md" "Authentication Context" \
"- Authentication Context Classes
- Password-Based Authentication
- Multi-Factor Authentication Contexts
- Certificate-Based Authentication
- Custom Authentication Contexts
- Requesting Specific Contexts"

create_file "$DIR" "005-Attributes-and-Attribute-Statements.md" "Attributes & Attribute Statements" \
"- Attribute Structure
- Attribute Name Formats
- Standard Attribute Profiles
- eduPerson Attributes
- Custom Attributes
- Attribute Value Types"

create_file "$DIR" "006-Subject-and-Name-Identifiers.md" "Subject & Name Identifiers" \
"- Subject Element Structure
- NameID Formats (Unspecified, Email Address, Persistent, Transient, etc.)
- X.509 Subject Name
- Windows Domain Qualified Name
- Kerberos Principal Name
- Entity Identifier
- Subject Confirmation
- Subject Confirmation Methods (bearer, holder-of-key, sender-vouches)"

create_file "$DIR" "007-Conditions-and-Constraints.md" "Conditions & Constraints" \
"- NotBefore & NotOnOrAfter
- AudienceRestriction
- OneTimeUse
- ProxyRestriction
- Custom Conditions"

# -----------------------------------------------------------------------------
# Part 3: Protocols
# -----------------------------------------------------------------------------
DIR="003-Protocols"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-SAML-Protocol-Overview.md" "SAML Protocol Overview" \
"- Request-Response Model
- Protocol Message Structure
- Status Codes
- Protocol Extensions"

create_file "$DIR" "002-Authentication-Request-Protocol.md" "Authentication Request Protocol" \
"- AuthnRequest Structure
- Request Parameters (ID, IssueInstant, Destination, ACS URL, ProtocolBinding, IsPassive, ForceAuthn)
- NameIDPolicy
- RequestedAuthnContext
- Scoping & IdP Discovery"

create_file "$DIR" "003-Authentication-Response.md" "Authentication Response" \
"- Response Structure
- Status Codes (Success, Requester, Responder, VersionMismatch)
- Second-Level Status Codes
- Embedded Assertions
- Encrypted Assertions"

create_file "$DIR" "004-Artifact-Resolution-Protocol.md" "Artifact Resolution Protocol" \
"- What are Artifacts?
- ArtifactResolve Request
- ArtifactResponse
- Artifact Format & Structure
- Use Cases"

create_file "$DIR" "005-Single-Logout-Protocol.md" "Single Logout Protocol" \
"- LogoutRequest Structure
- LogoutResponse Structure
- Logout Initiators (IdP vs SP)
- Session Index
- Partial Logout Handling
- Logout Propagation Challenges"

create_file "$DIR" "006-Name-Identifier-Management-Protocol.md" "Name Identifier Management Protocol" \
"- ManageNameIDRequest
- ManageNameIDResponse
- Name ID Termination
- Name ID Format Changes"

create_file "$DIR" "007-Assertion-Query-and-Request-Protocol.md" "Assertion Query & Request Protocol" \
"- AssertionIDRequest
- AuthnQuery
- AttributeQuery
- AuthzDecisionQuery
- Use Cases"

# -----------------------------------------------------------------------------
# Part 4: Bindings
# -----------------------------------------------------------------------------
DIR="004-Bindings"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-SAML-Bindings-Overview.md" "SAML Bindings Overview" \
"- What are Bindings?
- Binding Selection Criteria
- Security Considerations per Binding"

create_file "$DIR" "002-HTTP-Redirect-Binding.md" "HTTP Redirect Binding" \
"- How It Works
- URL Encoding
- Deflate Compression
- Signature in Query String
- Size Limitations
- Use Cases"

create_file "$DIR" "003-HTTP-POST-Binding.md" "HTTP POST Binding" \
"- How It Works
- Auto-Submitting Forms
- Base64 Encoding
- Signature in XML
- Use Cases"

create_file "$DIR" "004-HTTP-Artifact-Binding.md" "HTTP Artifact Binding" \
"- How It Works
- Artifact Structure
- Back-Channel Resolution
- Security Benefits
- Use Cases"

create_file "$DIR" "005-SOAP-Binding.md" "SOAP Binding" \
"- How It Works
- SOAP Envelope Structure
- Synchronous Communication
- Use Cases"

create_file "$DIR" "006-PAOS-Binding.md" "PAOS Binding (Reverse SOAP)" \
"- Enhanced Client/Proxy Profile
- Liberty Alliance Origins
- Mobile & ECP Use Cases"

create_file "$DIR" "007-URI-Binding.md" "URI Binding" \
"- Direct Assertion Retrieval
- Limited Use Cases"

# -----------------------------------------------------------------------------
# Part 5: Profiles
# -----------------------------------------------------------------------------
DIR="005-Profiles"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-SAML-Profiles-Overview.md" "SAML Profiles Overview" \
"- What are Profiles?
- Profile Components
- Profile Selection"

create_file "$DIR" "002-Web-Browser-SSO-Profile.md" "Web Browser SSO Profile" \
"- SP-Initiated SSO Flow
- IdP-Initiated SSO Flow
- Flow Diagrams
- Binding Combinations
- Implementation Steps
- Security Considerations"

create_file "$DIR" "003-Enhanced-Client-or-Proxy-Profile.md" "Enhanced Client or Proxy (ECP) Profile" \
"- Use Cases (Mobile, Non-Browser)
- PAOS Binding Usage
- Flow Diagram
- Implementation Considerations"

create_file "$DIR" "004-Single-Logout-Profile.md" "Single Logout Profile" \
"- SP-Initiated Logout
- IdP-Initiated Logout
- Front-Channel vs Back-Channel Logout
- Logout Propagation
- Partial Logout Scenarios
- User Experience Considerations"

create_file "$DIR" "005-Artifact-Resolution-Profile.md" "Artifact Resolution Profile" \
"- When to Use Artifacts
- Flow Diagram
- Security Benefits
- Implementation Complexity"

create_file "$DIR" "006-Assertion-Query-Request-Profile.md" "Assertion Query/Request Profile" \
"- Attribute Query Profile
- Authentication Query Profile
- Authorization Decision Query Profile
- Use Cases"

create_file "$DIR" "007-Name-Identifier-Mapping-Profile.md" "Name Identifier Mapping Profile" \
"- Cross-Domain Identity Mapping
- Use Cases"

create_file "$DIR" "008-Name-Identifier-Management-Profile.md" "Name Identifier Management Profile" \
"- Account Linking Changes
- Federation Termination
- Use Cases"

create_file "$DIR" "009-Identity-Provider-Discovery-Profile.md" "Identity Provider Discovery Profile" \
"- Common Domain Cookie
- Discovery Service
- WAYF (Where Are You From) Services
- User Experience"

# -----------------------------------------------------------------------------
# Part 6: Metadata
# -----------------------------------------------------------------------------
DIR="006-Metadata"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-SAML-Metadata-Overview.md" "SAML Metadata Overview" \
"- Purpose of Metadata
- Metadata Exchange
- Trust Establishment
- Metadata Formats"

create_file "$DIR" "002-Entity-Descriptor.md" "Entity Descriptor" \
"- EntityDescriptor Structure
- Entity ID
- Valid Until & Cache Duration
- Extensions"

create_file "$DIR" "003-IdP-Metadata-Elements.md" "IdP Metadata Elements" \
"- IDPSSODescriptor
- SingleSignOnService
- SingleLogoutService
- ArtifactResolutionService
- NameIDFormat
- Attribute (Supported Attributes)"

create_file "$DIR" "004-SP-Metadata-Elements.md" "SP Metadata Elements" \
"- SPSSODescriptor
- AssertionConsumerService
- SingleLogoutService
- AttributeConsumingService
- RequestedAttribute
- NameIDFormat
- AuthnRequestsSigned
- WantAssertionsSigned"

create_file "$DIR" "005-Key-Descriptors-and-Certificates.md" "Key Descriptors & Certificates" \
"- KeyDescriptor Element
- Signing Keys
- Encryption Keys
- Key Use Attribute
- Certificate Embedding
- Certificate Rotation"

create_file "$DIR" "006-Organization-and-Contact-Information.md" "Organization & Contact Information" \
"- Organization Element
- ContactPerson Element
- Administrative Contacts
- Technical Contacts
- Support Contacts"

create_file "$DIR" "007-Metadata-Extensions.md" "Metadata Extensions" \
"- UI Elements (Logo, Display Name, Description)
- Discovery Hints
- Entity Attributes
- Algorithm Support"

create_file "$DIR" "008-Metadata-Management.md" "Metadata Management" \
"- Metadata Publishing
- Metadata Aggregates
- Metadata Signing
- Automated Refresh
- Metadata Registries"

# -----------------------------------------------------------------------------
# Part 7: Security
# -----------------------------------------------------------------------------
DIR="007-Security"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-XML-Signature-in-SAML.md" "XML Signature in SAML" \
"- XML Digital Signature (XMLDSig) Overview
- Enveloped Signatures
- Signature Structure
- Canonicalization
- Signing Algorithms (RSA, ECDSA)
- Digest Algorithms (SHA-256, SHA-384, SHA-512)
- Reference URIs
- What to Sign (Assertions, Messages)"

create_file "$DIR" "002-XML-Encryption-in-SAML.md" "XML Encryption in SAML" \
"- XML Encryption Overview
- Encrypting Assertions
- Encrypting NameID
- Encrypting Attributes
- Key Transport Algorithms
- Block Encryption Algorithms
- EncryptedAssertion Structure
- EncryptedID Structure"

create_file "$DIR" "003-Certificate-Management.md" "Certificate Management" \
"- Certificate Requirements
- Self-Signed vs CA-Signed
- Certificate Lifecycle
- Certificate Rotation Strategies
- Key Rollover
- Certificate Pinning
- Trust Anchors"

create_file "$DIR" "004-Common-Vulnerabilities.md" "Common Vulnerabilities" \
"- XML Signature Wrapping Attacks
- XML Injection
- XXE (XML External Entity) Attacks
- Assertion Replay Attacks
- Man-in-the-Middle Attacks
- Session Fixation
- Open Redirect
- Cross-Site Scripting (XSS) in Relay State"

create_file "$DIR" "005-Security-Mitigations.md" "Security Mitigations" \
"- Strict Schema Validation
- Signature Validation Best Practices
- Audience Restriction Enforcement
- Time Validation (NotBefore, NotOnOrAfter)
- Replay Prevention (Assertion ID Caching)
- Destination Validation
- InResponseTo Validation
- Secure RelayState Handling"

create_file "$DIR" "006-Security-Best-Practices.md" "Security Best Practices" \
"- Always Use HTTPS
- Sign All Messages & Assertions
- Encrypt Sensitive Assertions
- Validate Everything
- Use Strong Algorithms
- Implement Proper Error Handling
- Logging & Monitoring
- Regular Security Audits"

# -----------------------------------------------------------------------------
# Part 8: Implementation
# -----------------------------------------------------------------------------
DIR="008-Implementation"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Implementing-a-Service-Provider.md" "Implementing a Service Provider" \
"- Architecture Overview
- SP Metadata Generation
- Initiating SSO
- Handling SAML Response
- Assertion Validation Steps
- Session Management
- Attribute Mapping
- Error Handling"

create_file "$DIR" "002-Implementing-an-Identity-Provider.md" "Implementing an Identity Provider" \
"- Architecture Overview
- IdP Metadata Generation
- User Authentication Backend
- Assertion Generation
- Attribute Retrieval & Release
- Signing & Encryption
- Session Management
- Multi-SP Support"

create_file "$DIR" "003-SP-Initiated-SSO-Implementation.md" "SP-Initiated SSO Implementation" \
"- Flow Walkthrough
- AuthnRequest Generation
- Redirect/POST to IdP
- Response Handling
- Assertion Processing
- Session Creation
- Error Scenarios"

create_file "$DIR" "004-IdP-Initiated-SSO-Implementation.md" "IdP-Initiated SSO Implementation" \
"- Flow Walkthrough
- Unsolicited Response Generation
- Deep Linking with RelayState
- Security Considerations
- When to Use/Avoid"

create_file "$DIR" "005-Single-Logout-Implementation.md" "Single Logout Implementation" \
"- SP-Initiated Logout Flow
- IdP-Initiated Logout Flow
- Session Tracking Requirements
- Handling Partial Logout
- User Experience Design
- Timeout Handling"

create_file "$DIR" "006-Attribute-Handling.md" "Attribute Handling" \
"- Attribute Mapping Configuration
- Attribute Transformation
- Required vs Optional Attributes
- Attribute Release Policies
- Just-In-Time Provisioning"

create_file "$DIR" "007-Session-Management.md" "Session Management" \
"- SP Session vs IdP Session
- Session Index Tracking
- Session Timeout Strategies
- Session Revocation
- Concurrent Session Handling"

# -----------------------------------------------------------------------------
# Part 9: Platform-Specific Implementation
# -----------------------------------------------------------------------------
DIR="009-Platform-Specific-Implementation"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Java-Implementation.md" "Java Implementation" \
"- OpenSAML Library
- Spring Security SAML
- pac4j
- Shibboleth
- Implementation Patterns"

create_file "$DIR" "002-DotNET-Implementation.md" ".NET Implementation" \
"- ITfoxtec.Identity.Saml2
- Sustainsys.Saml2
- ComponentSpace SAML
- Azure AD Integration
- Implementation Patterns"

create_file "$DIR" "003-Python-Implementation.md" "Python Implementation" \
"- python-saml (OneLogin)
- pysaml2
- Django SAML
- Flask SAML
- Implementation Patterns"

create_file "$DIR" "004-PHP-Implementation.md" "PHP Implementation" \
"- SimpleSAMLphp
- php-saml (OneLogin)
- Laravel SAML
- Implementation Patterns"

create_file "$DIR" "005-NodeJS-Implementation.md" "Node.js Implementation" \
"- passport-saml
- saml2-js
- node-saml
- Implementation Patterns"

create_file "$DIR" "006-Ruby-Implementation.md" "Ruby Implementation" \
"- ruby-saml
- OmniAuth SAML
- Implementation Patterns"

create_file "$DIR" "007-Go-Implementation.md" "Go Implementation" \
"- crewjam/saml
- gosaml2
- Implementation Patterns"

# -----------------------------------------------------------------------------
# Part 10: Identity Providers
# -----------------------------------------------------------------------------
DIR="010-Identity-Providers"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Popular-Identity-Providers.md" "Popular Identity Providers" \
"- Microsoft Entra ID (Azure AD)
- Okta
- OneLogin
- PingIdentity / PingFederate
- Auth0
- Google Workspace
- Shibboleth IdP
- Keycloak
- ADFS (Active Directory Federation Services)
- JumpCloud"

create_file "$DIR" "002-IdP-Configuration-Patterns.md" "IdP Configuration Patterns" \
"- Attribute Mapping
- Group/Role Mapping
- Conditional Access Policies
- MFA Integration
- Custom Claims
- Certificate Management"

create_file "$DIR" "003-IdP-Specific-Considerations.md" "IdP-Specific Considerations" \
"- Metadata URLs
- Logout Behavior Differences
- Attribute Format Variations
- Clock Skew Handling
- Error Response Differences"

# -----------------------------------------------------------------------------
# Part 11: Federation & Trust
# -----------------------------------------------------------------------------
DIR="011-Federation-and-Trust"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Trust-Establishment.md" "Trust Establishment" \
"- Metadata Exchange Methods
- Out-of-Band Verification
- Trust Anchors
- Certificate Chain Validation"

create_file "$DIR" "002-Federation-Models.md" "Federation Models" \
"- Bilateral Federation
- Hub-and-Spoke Federation
- Mesh Federation
- Proxy-Based Federation"

create_file "$DIR" "003-Federation-Metadata.md" "Federation Metadata" \
"- Metadata Aggregates
- Interfederation
- Trust Frameworks
- Metadata Signing & Verification"

create_file "$DIR" "004-Academic-and-Research-Federations.md" "Academic & Research Federations" \
"- InCommon (US)
- UK Federation
- eduGAIN
- Federation Policies
- Entity Categories"

create_file "$DIR" "005-Government-Federations.md" "Government Federations" \
"- Federal Identity Frameworks
- Cross-Agency Federation
- Assurance Levels
- Compliance Requirements"

create_file "$DIR" "006-Enterprise-Federation-Patterns.md" "Enterprise Federation Patterns" \
"- Partner Federation
- Customer Identity Federation
- Workforce Federation
- Multi-Tenant SaaS Federation"

# -----------------------------------------------------------------------------
# Part 12: Advanced Topics
# -----------------------------------------------------------------------------
DIR="012-Advanced-Topics"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Proxying-and-Identity-Brokering.md" "Proxying & Identity Brokering" \
"- SAML Proxy Architecture
- Protocol Translation (SAML <-> OIDC)
- Attribute Aggregation
- IdP Discovery Behind Proxy
- Use Cases"

create_file "$DIR" "002-Step-Up-Authentication.md" "Step-Up Authentication" \
"- Authentication Context Requests
- Forcing Re-Authentication
- MFA Step-Up Flows
- Risk-Based Authentication"

create_file "$DIR" "003-Account-Linking.md" "Account Linking" \
"- Persistent vs Transient Identifiers
- Linking Strategies
- User-Initiated Linking
- Administrative Linking
- Unlinking Accounts"

create_file "$DIR" "004-Just-In-Time-Provisioning.md" "Just-In-Time Provisioning" \
"- User Creation on First Login
- Attribute-Based Provisioning
- Group/Role Assignment
- Conflict Resolution
- Deprovisioning Considerations"

create_file "$DIR" "005-SCIM-Integration-with-SAML.md" "SCIM Integration with SAML" \
"- Provisioning vs Authentication
- SCIM for User Lifecycle
- SAML + SCIM Architecture
- Synchronization Strategies"

create_file "$DIR" "006-Holder-of-Key-Assertions.md" "Holder-of-Key Assertions" \
"- Subject Confirmation Method
- Key Binding
- Use Cases
- Implementation Complexity"

create_file "$DIR" "007-Attribute-Authorities.md" "Attribute Authorities" \
"- Standalone Attribute Services
- Attribute Query Protocol
- Distributed Attribute Retrieval
- Use Cases"

# -----------------------------------------------------------------------------
# Part 13: Migration & Interoperability
# -----------------------------------------------------------------------------
DIR="013-Migration-and-Interoperability"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Migrating-from-SAML-1.1-to-SAML-2.0.md" "Migrating from SAML 1.1 to SAML 2.0" \
"- Key Differences
- Migration Steps
- Backward Compatibility
- Testing Strategies"

create_file "$DIR" "002-SAML-to-OIDC-Migration.md" "SAML to OIDC Migration" \
"- Feature Comparison
- Migration Strategies
- Parallel Running
- User Experience Considerations
- Protocol Translation (Proxy)"

create_file "$DIR" "003-Hybrid-SAML-OIDC-Environments.md" "Hybrid SAML/OIDC Environments" \
"- Use Cases
- Architecture Patterns
- Identity Broker Solutions
- Attribute/Claim Mapping"

create_file "$DIR" "004-Interoperability-Testing.md" "Interoperability Testing" \
"- SAML Conformance Testing
- IdP Testing Tools
- SP Testing Tools
- Common Interoperability Issues"

# -----------------------------------------------------------------------------
# Part 14: Testing & Debugging
# -----------------------------------------------------------------------------
DIR="014-Testing-and-Debugging"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Testing-SAML-Implementations.md" "Testing SAML Implementations" \
"- Unit Testing Strategies
- Integration Testing
- Mock IdP/SP Tools
- Conformance Testing"

create_file "$DIR" "002-SAML-Testing-Tools.md" "SAML Testing Tools" \
"- SAML Tracer (Browser Extension)
- SAML Developer Tools
- samltool.com
- SAMLTest.id
- Shibboleth Test IdP"

create_file "$DIR" "003-Debugging-SAML-Flows.md" "Debugging SAML Flows" \
"- Capturing SAML Messages
- Decoding Base64 Payloads
- Validating Signatures Manually
- Common Error Messages
- Troubleshooting Checklist"

create_file "$DIR" "004-Common-Issues-and-Solutions.md" "Common Issues & Solutions" \
"- Clock Skew Errors
- Certificate Mismatch
- Audience Restriction Failures
- NameID Format Mismatch
- Attribute Mapping Issues
- Redirect Loop Problems
- Signature Validation Failures"

# -----------------------------------------------------------------------------
# Part 15: Operations & Monitoring
# -----------------------------------------------------------------------------
DIR="015-Operations-and-Monitoring"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-Certificate-Lifecycle-Management.md" "Certificate Lifecycle Management" \
"- Certificate Generation
- Certificate Rotation Planning
- Dual-Certificate Support
- Emergency Certificate Rollover
- Expiration Monitoring"

create_file "$DIR" "002-Metadata-Management-Operations.md" "Metadata Management Operations" \
"- Metadata Publishing
- Metadata Refresh Automation
- Metadata Backup
- Change Management"

create_file "$DIR" "003-Monitoring-and-Alerting.md" "Monitoring & Alerting" \
"- SSO Success/Failure Metrics
- Latency Monitoring
- Certificate Expiration Alerts
- Anomaly Detection
- User Login Analytics"

create_file "$DIR" "004-High-Availability-and-Scalability.md" "High Availability & Scalability" \
"- IdP Clustering
- SP Session Distribution
- Load Balancer Considerations
- Failover Strategies"

create_file "$DIR" "005-Audit-and-Compliance.md" "Audit & Compliance" \
"- Audit Logging Requirements
- Log Retention Policies
- Compliance Frameworks
- Privacy Considerations (GDPR)
- Consent Management"

# -----------------------------------------------------------------------------
# Part 16: SAML in Modern Architecture
# -----------------------------------------------------------------------------
DIR="016-SAML-in-Modern-Architecture"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-SAML-in-Microservices.md" "SAML in Microservices" \
"- Gateway Pattern
- Token Translation
- Service-to-Service Authentication
- Challenges & Limitations"

create_file "$DIR" "002-SAML-in-Cloud-Environments.md" "SAML in Cloud Environments" \
"- AWS SSO Integration
- Azure AD Integration
- Google Cloud Integration
- Multi-Cloud Federation"

create_file "$DIR" "003-SAML-for-SaaS-Applications.md" "SAML for SaaS Applications" \
"- Customer-Managed IdP Integration
- Multi-Tenant SAML Configuration
- Self-Service SSO Setup
- SP Metadata Templates"

create_file "$DIR" "004-SAML-Limitations-and-Alternatives.md" "SAML Limitations & Alternatives" \
"- Mobile Application Challenges
- API Authentication Limitations
- When to Choose OIDC Instead
- Modern Alternatives"

# -----------------------------------------------------------------------------
# Appendices
# -----------------------------------------------------------------------------
DIR="017-Appendices"
mkdir -p "$ROOT_DIR/$DIR"

create_file "$DIR" "001-SAML-Specification-Documents.md" "SAML 2.0 Specification Documents Reference" "- Ref list"
create_file "$DIR" "002-XML-Namespaces-Reference.md" "XML Namespaces Reference" "- Ref list"
create_file "$DIR" "003-SAML-URIs-and-Identifiers.md" "SAML URIs & Identifiers Registry" "- Ref list"
create_file "$DIR" "004-Status-Code-Reference.md" "Status Code Reference" "- Ref list"
create_file "$DIR" "005-Authn-Context-Class-Reference.md" "Authentication Context Class Reference" "- Ref list"
create_file "$DIR" "006-NameID-Format-Reference.md" "NameID Format Reference" "- Ref list"
create_file "$DIR" "007-Attribute-Name-Format-Reference.md" "Attribute Name Format Reference" "- Ref list"
create_file "$DIR" "008-Common-Attributes-Reference.md" "Common Attributes Reference" "- eduPerson, SCHAC, etc."
create_file "$DIR" "009-Error-Messages-Guide.md" "Error Messages & Troubleshooting Guide" "- Guide"
create_file "$DIR" "010-Glossary.md" "Glossary of Terms" "- Definitions"
create_file "$DIR" "011-Security-Checklist.md" "Security Checklist" "- Checklist"
create_file "$DIR" "012-Metadata-Templates.md" "Metadata Template Examples" "- Examples"
create_file "$DIR" "013-Libraries-Frameworks.md" "Popular Libraries & Frameworks by Language" "- List"
create_file "$DIR" "014-Recommended-resources.md" "Recommended Reading & Resources" "- Resources"

echo "Done! All directories and files have been created in $ROOT_DIR"


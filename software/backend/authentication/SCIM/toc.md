# SCIM 2.0 - Developer Study Guide

## Table of Contents

---

### Part 1: Foundations

1. **Introduction to Identity Provisioning**
   - What is Identity Provisioning?
   - Provisioning vs Authentication
   - The User Lifecycle Problem
   - Manual vs Automated Provisioning
   - Business Drivers for Automated Provisioning

2. **History of Identity Provisioning**
   - Early Provisioning Approaches
   - Proprietary Connectors Era
   - SPML (Service Provisioning Markup Language)
   - Evolution to SCIM
   - SCIM 1.1 to SCIM 2.0

3. **SCIM 2.0 Overview**
   - What is SCIM?
   - SCIM Design Goals
   - SCIM vs SPML
   - SCIM vs LDAP
   - SCIM vs Proprietary APIs
   - When to Use SCIM
   - SCIM Specification Documents (RFC 7642, 7643, 7644)

4. **SCIM Terminology**
   - Service Provider
   - Client (Identity Provider / Provisioning System)
   - Resource
   - Resource Type
   - Schema
   - Attribute
   - Endpoint
   - Bulk Operation

---

### Part 2: Core Concepts

5. **SCIM Architecture**
   - Client-Server Model
   - RESTful Design Principles
   - JSON Data Format
   - HTTP Methods Usage
   - Stateless Operations
   - Trust Model

6. **SCIM Roles**
   - SCIM Client (Provisioning Source)
   - SCIM Service Provider (Target System)
   - Identity Provider as SCIM Client
   - SaaS Application as Service Provider
   - Role Interactions

7. **Resources**
   - What is a Resource?
   - Resource Identifiers (`id`)
   - External Identifiers (`externalId`)
   - Resource Metadata (`meta`)
   - Common Resource Types
   - Custom Resources

8. **Schemas**
   - Schema Definition
   - Schema URIs
   - Core Schemas
   - Extension Schemas
   - Schema Discovery
   - Schema Composition

9. **Attributes**
   - Attribute Characteristics
     - `name`
     - `type`
     - `multiValued`
     - `required`
     - `caseExact`
     - `mutability`
     - `returned`
     - `uniqueness`
   - Attribute Types
     - String
     - Boolean
     - Decimal
     - Integer
     - DateTime
     - Binary
     - Reference
     - Complex
   - Sub-Attributes
   - Canonical Values

---

### Part 3: Core Resources

10. **User Resource**
    - User Schema (`urn:ietf:params:scim:schemas:core:2.0:User`)
    - Core Attributes
      - `userName`
      - `name` (Complex)
      - `displayName`
      - `nickName`
      - `profileUrl`
      - `title`
      - `userType`
      - `preferredLanguage`
      - `locale`
      - `timezone`
      - `active`
      - `password`
    - Multi-Valued Attributes
      - `emails`
      - `phoneNumbers`
      - `ims`
      - `photos`
      - `addresses`
      - `groups`
      - `entitlements`
      - `roles`
      - `x509Certificates`

11. **Group Resource**
    - Group Schema (`urn:ietf:params:scim:schemas:core:2.0:Group`)
    - Core Attributes
      - `displayName`
      - `members`
    - Member Structure
    - Group Membership Management
    - Nested Groups

12. **Enterprise User Extension**
    - Extension Schema (`urn:ietf:params:scim:schemas:extension:enterprise:2.0:User`)
    - Enterprise Attributes
      - `employeeNumber`
      - `costCenter`
      - `organization`
      - `division`
      - `department`
      - `manager`
    - Manager Reference

13. **Resource Metadata**
    - `meta` Attribute Structure
    - `resourceType`
    - `created`
    - `lastModified`
    - `location`
    - `version` (ETag)

14. **Custom Resources**
    - Defining Custom Resource Types
    - Custom Schema URIs
    - Registration Considerations
    - Use Cases

15. **Schema Extensions**
    - Extension Mechanism
    - Adding Custom Attributes
    - Extension Schema Definition
    - Multiple Extensions per Resource
    - Use Cases

---

### Part 4: Protocol Operations

16. **HTTP Methods in SCIM**
    - GET (Read)
    - POST (Create)
    - PUT (Replace)
    - PATCH (Partial Update)
    - DELETE (Remove)
    - Method Safety & Idempotency

17. **Create Operation (POST)**
    - Request Format
    - Required Attributes
    - Server-Generated Attributes
    - Response Format
    - Status Codes
    - Error Handling
    - Examples

18. **Read Operation (GET)**
    - Retrieving Single Resource
    - Resource Endpoint URLs
    - Response Format
    - Attribute Selection
    - Status Codes
    - Error Handling
    - Examples

19. **Replace Operation (PUT)**
    - Full Resource Replacement
    - Request Format
    - Immutable Attributes Handling
    - Read-Only Attributes Handling
    - Response Format
    - Status Codes
    - Error Handling
    - Examples

20. **Partial Update Operation (PATCH)**
    - PATCH Request Structure
    - Operations Array
    - Operation Types
      - `add`
      - `remove`
      - `replace`
    - Path Expressions
    - Complex Attribute Patching
    - Multi-Valued Attribute Patching
    - Response Format
    - Status Codes
    - Error Handling
    - Examples

21. **Delete Operation (DELETE)**
    - Soft Delete vs Hard Delete
    - Request Format
    - Response Format
    - Status Codes
    - Error Handling
    - Cascading Deletes
    - Examples

22. **List/Query Operation (GET)**
    - Listing Resources
    - Pagination
      - `startIndex`
      - `count`
      - `totalResults`
      - `itemsPerPage`
    - Sorting
      - `sortBy`
      - `sortOrder`
    - Filtering (Overview)
    - Attribute Selection
    - Response Format (ListResponse)
    - Examples

23. **Bulk Operations**
    - Bulk Endpoint
    - Bulk Request Structure
    - Bulk Operations Array
    - `bulkId` References
    - `failOnErrors` Parameter
    - Bulk Response Structure
    - Partial Failure Handling
    - Performance Considerations
    - Use Cases
    - Examples

---

### Part 5: Filtering & Querying

24. **Filter Syntax**
    - Filter Parameter
    - Filter Expressions
    - Attribute Paths
    - Comparison Operators
      - `eq` (Equal)
      - `ne` (Not Equal)
      - `co` (Contains)
      - `sw` (Starts With)
      - `ew` (Ends With)
      - `gt` (Greater Than)
      - `ge` (Greater Than or Equal)
      - `lt` (Less Than)
      - `le` (Less Than or Equal)
      - `pr` (Present)
    - Logical Operators
      - `and`
      - `or`
      - `not`
    - Grouping with Parentheses
    - Complex Attribute Filtering
    - Value Path Filtering

25. **Filter Examples**
    - Simple Attribute Filters
    - Multi-Valued Attribute Filters
    - Complex Attribute Filters
    - Combined Filters
    - Extension Attribute Filters
    - Common Filter Patterns

26. **Attribute Projection**
    - `attributes` Parameter
    - `excludedAttributes` Parameter
    - Attribute Return Defaults
    - Minimal Response Requests
    - Performance Optimization

27. **Sorting**
    - `sortBy` Parameter
    - `sortOrder` Parameter (`ascending`, `descending`)
    - Default Sort Order
    - Sorting Complex Attributes
    - Multi-Level Sorting Limitations

28. **Pagination**
    - Index-Based Pagination
    - `startIndex` Parameter
    - `count` Parameter
    - Response Pagination Attributes
    - Cursor-Based Pagination (Non-Standard)
    - Pagination Best Practices
    - Large Dataset Handling

---

### Part 6: Service Provider Configuration

29. **Service Provider Configuration Endpoint**
    - `/ServiceProviderConfig` Endpoint
    - Configuration Resource Structure
    - `documentationUri`
    - `patch` Support
    - `bulk` Support
    - `filter` Support
    - `changePassword` Support
    - `sort` Support
    - `etag` Support
    - `authenticationSchemes`

30. **Resource Types Endpoint**
    - `/ResourceTypes` Endpoint
    - Resource Type Definition
    - `id`
    - `name`
    - `description`
    - `endpoint`
    - `schema`
    - `schemaExtensions`
    - Custom Resource Type Registration

31. **Schemas Endpoint**
    - `/Schemas` Endpoint
    - Schema Definition Structure
    - Attribute Definitions
    - Discovering Available Schemas
    - Schema Validation

32. **Authentication Schemes**
    - OAuth 2.0 Bearer Token
    - HTTP Basic Authentication
    - Mutual TLS
    - Custom Schemes
    - Scheme Declaration in Configuration

---

### Part 7: Protocol Details

33. **HTTP Headers**
    - `Content-Type`
    - `Accept`
    - `Authorization`
    - `Location`
    - `ETag`
    - `If-Match`
    - `If-None-Match`
    - Custom Headers

34. **Content Types**
    - `application/scim+json`
    - `application/json`
    - Character Encoding
    - Content Negotiation

35. **ETags & Versioning**
    - ETag Generation
    - Weak vs Strong ETags
    - Conditional Requests
    - Optimistic Concurrency Control
    - Conflict Detection
    - `If-Match` Header Usage
    - `If-None-Match` Header Usage

36. **Error Handling**
    - SCIM Error Response Format
    - `schemas` Array
    - `scimType` Error Codes
      - `invalidFilter`
      - `tooMany`
      - `uniqueness`
      - `mutability`
      - `invalidSyntax`
      - `invalidPath`
      - `noTarget`
      - `invalidValue`
      - `invalidVers`
      - `sensitive`
    - `detail` Message
    - `status` Code
    - HTTP Status Code Mapping

37. **HTTP Status Codes**
    - 200 OK
    - 201 Created
    - 204 No Content
    - 304 Not Modified
    - 400 Bad Request
    - 401 Unauthorized
    - 403 Forbidden
    - 404 Not Found
    - 409 Conflict
    - 412 Precondition Failed
    - 413 Payload Too Large
    - 500 Internal Server Error
    - 501 Not Implemented

---

### Part 8: Security

38. **Authentication**
    - OAuth 2.0 Bearer Tokens
    - Token Scopes for SCIM
    - HTTP Basic Authentication
    - Mutual TLS (mTLS)
    - API Keys (Non-Standard)
    - Authentication Best Practices

39. **Authorization**
    - Access Control Models
    - Resource-Level Authorization
    - Attribute-Level Authorization
    - Operation-Level Authorization
    - Role-Based Access Control
    - Tenant Isolation

40. **Transport Security**
    - TLS Requirements
    - Certificate Validation
    - Cipher Suite Selection
    - HSTS Headers

41. **Data Security**
    - Sensitive Attribute Handling
    - Password Handling
    - PII Protection
    - Data Masking
    - Encryption at Rest

42. **Common Vulnerabilities**
    - Injection Attacks
    - Broken Authentication
    - Excessive Data Exposure
    - Mass Assignment
    - Broken Object Level Authorization
    - Rate Limiting Bypass
    - SSRF via References

43. **Security Best Practices**
    - Input Validation
    - Output Encoding
    - Parameterized Queries
    - Principle of Least Privilege
    - Audit Logging
    - Rate Limiting
    - Request Size Limits

---

### Part 9: Implementation - Service Provider

44. **Service Provider Architecture**
    - Component Overview
    - API Layer Design
    - Data Layer Considerations
    - Integration Points
    - Scalability Planning

45. **Endpoint Implementation**
    - URL Structure
    - Routing Design
    - Controller Patterns
    - Middleware Pipeline
    - Request Parsing
    - Response Formatting

46. **Resource Storage**
    - Data Model Design
    - Schema to Database Mapping
    - Multi-Valued Attribute Storage
    - Complex Attribute Storage
    - Extension Storage
    - Indexing Strategies

47. **Filter Implementation**
    - Filter Parser
    - AST Generation
    - Query Translation
    - SQL Query Building
    - NoSQL Query Building
    - Performance Optimization

48. **PATCH Operation Implementation**
    - Path Expression Parsing
    - Operation Execution
    - Atomic Updates
    - Validation During Patch
    - Complex Scenarios

49. **Bulk Operation Implementation**
    - Request Processing
    - Transaction Management
    - `bulkId` Resolution
    - Partial Failure Handling
    - Performance Considerations
    - Async Processing Options

50. **Pagination Implementation**
    - Offset-Based Pagination
    - Cursor-Based Pagination
    - Total Count Calculation
    - Large Dataset Strategies
    - Consistency Considerations

51. **ETag Implementation**
    - ETag Generation Strategies
    - Version Column Approach
    - Hash-Based Approach
    - Conditional Update Logic
    - Conflict Response

52. **Validation**
    - Schema Validation
    - Required Attribute Validation
    - Uniqueness Validation
    - Reference Validation
    - Custom Business Rules
    - Validation Error Responses

---

### Part 10: Implementation - Client

53. **SCIM Client Architecture**
    - Client Component Overview
    - Connection Management
    - Request Building
    - Response Handling
    - Error Handling Strategy

54. **Discovery & Configuration**
    - Fetching Service Provider Config
    - Schema Discovery
    - Resource Type Discovery
    - Capability Detection
    - Caching Configuration

55. **User Provisioning Workflows**
    - Create User Flow
    - Update User Flow
    - Deactivate User Flow
    - Delete User Flow
    - Reactivate User Flow

56. **Group Provisioning Workflows**
    - Create Group Flow
    - Update Group Membership
    - Add Members
    - Remove Members
    - Delete Group Flow
    - Nested Group Handling

57. **Synchronization Strategies**
    - Full Sync
    - Incremental Sync
    - Delta Sync
    - Event-Driven Sync
    - Reconciliation
    - Conflict Resolution

58. **Bulk Provisioning**
    - When to Use Bulk
    - Bulk Request Construction
    - Dependency Ordering
    - Response Processing
    - Error Recovery
    - Performance Tuning

59. **Error Handling & Retry**
    - Transient vs Permanent Errors
    - Retry Strategies
    - Exponential Backoff
    - Circuit Breaker Pattern
    - Dead Letter Handling
    - Manual Intervention Workflows

60. **Rate Limiting Handling**
    - Detecting Rate Limits
    - `Retry-After` Header
    - Request Throttling
    - Queue-Based Approaches
    - Prioritization Strategies

---

### Part 11: Common Integrations

61. **Identity Provider Integration**
    - Okta as SCIM Client
    - Azure AD as SCIM Client
    - OneLogin as SCIM Client
    - PingIdentity as SCIM Client
    - Google Workspace as SCIM Client
    - JumpCloud as SCIM Client

62. **SaaS Application Integration**
    - Common SaaS SCIM Implementations
    - Slack SCIM
    - Zoom SCIM
    - Salesforce SCIM
    - GitHub SCIM
    - Atlassian SCIM
    - Dropbox SCIM
    - Box SCIM

63. **HR System Integration**
    - Workday
    - SAP SuccessFactors
    - BambooHR
    - ADP
    - HR as Source of Truth
    - Joiner-Mover-Leaver Workflows

64. **Directory Integration**
    - Active Directory
    - LDAP Directories
    - Azure AD
    - Google Directory
    - Bi-Directional Sync Challenges

65. **Custom Application Integration**
    - Adding SCIM to Existing Apps
    - Database Mapping
    - Legacy System Adapters
    - Webhook Alternatives

---

### Part 12: Advanced Topics

66. **Multi-Tenancy**
    - Tenant Identification
    - URL-Based Tenancy
    - Header-Based Tenancy
    - Token-Based Tenancy
    - Tenant Isolation
    - Cross-Tenant Operations

67. **Custom Schema Extensions**
    - Designing Extensions
    - Namespace Conventions
    - Extension Registration
    - Backward Compatibility
    - Documentation

68. **Custom Resource Types**
    - When to Create Custom Resources
    - Resource Type Definition
    - Schema Definition
    - Endpoint Design
    - Examples (Devices, Licenses, etc.)

69. **Reference Attributes**
    - `$ref` Attribute
    - Absolute vs Relative References
    - Reference Resolution
    - Circular Reference Handling
    - Cross-Resource References

70. **Password Management**
    - Password Attribute Handling
    - Write-Only Semantics
    - Password Sync Strategies
    - Password Policy Integration
    - Self-Service Password Reset

71. **Soft Delete & Deactivation**
    - `active` Attribute
    - Soft Delete Patterns
    - Retention Policies
    - Reactivation Workflows
    - Hard Delete Triggers

72. **Async Operations**
    - Long-Running Operations
    - Polling Patterns
    - Webhook Notifications
    - Status Endpoints
    - Non-Standard Extensions

73. **Change Detection & Events**
    - Polling for Changes
    - `lastModified` Filtering
    - Webhook/Event Integration
    - SCIM Events (Draft Spec)
    - Integration with SSF/CAEP

74. **Cross-Domain Identity Management**
    - Multi-Domain Scenarios
    - Identity Correlation
    - `externalId` Strategies
    - Account Linking
    - Federation Considerations

---

### Part 13: Testing

75. **Testing SCIM Service Providers**
    - Unit Testing
    - Integration Testing
    - Contract Testing
    - Conformance Testing
    - Load Testing

76. **Testing SCIM Clients**
    - Mock Service Providers
    - Integration Testing
    - Error Scenario Testing
    - Sync Testing

77. **SCIM Conformance Testing**
    - SCIM Compliance Test Suites
    - Runscope SCIM Test
    - SCIM 2.0 Compliance Checker
    - IdP-Specific Test Tools

78. **Test Data Management**
    - Test User Generation
    - Test Group Generation
    - Data Cleanup
    - Idempotent Testing

79. **Common Testing Scenarios**
    - CRUD Operations
    - Filter Testing
    - Pagination Testing
    - Bulk Operation Testing
    - Error Condition Testing
    - Concurrency Testing

---

### Part 14: Operations & Monitoring

80. **Logging**
    - Request/Response Logging
    - Audit Logging
    - Error Logging
    - PII Considerations
    - Log Retention

81. **Monitoring & Metrics**
    - Request Rate Metrics
    - Latency Metrics
    - Error Rate Metrics
    - Resource Count Metrics
    - Sync Health Metrics

82. **Alerting**
    - Error Rate Alerts
    - Latency Alerts
    - Sync Failure Alerts
    - Authentication Failure Alerts
    - Capacity Alerts

83. **Performance Optimization**
    - Query Optimization
    - Caching Strategies
    - Connection Pooling
    - Bulk Operation Tuning
    - Pagination Tuning

84. **Scaling**
    - Horizontal Scaling
    - Load Balancing
    - Database Scaling
    - Rate Limiting Implementation
    - Queue-Based Architecture

85. **High Availability**
    - Redundancy Patterns
    - Failover Strategies
    - Data Replication
    - Disaster Recovery

86. **Troubleshooting**
    - Common Issues
    - Sync Failures
    - Authentication Problems
    - Filter Errors
    - Performance Issues
    - Data Inconsistencies

---

### Part 15: Compliance & Governance

87. **Data Privacy**
    - GDPR Considerations
    - CCPA Considerations
    - Data Minimization
    - Purpose Limitation
    - Consent Management
    - Data Subject Rights

88. **Audit & Compliance**
    - Audit Trail Requirements
    - SOC 2 Compliance
    - ISO 27001 Compliance
    - Industry-Specific Requirements
    - Audit Log Retention

89. **Data Governance**
    - Data Ownership
    - Data Quality
    - Master Data Management
    - Data Lineage
    - Attribute Authority

90. **Access Governance**
    - Provisioning Approval Workflows
    - Access Reviews
    - Certification Campaigns
    - Segregation of Duties
    - Least Privilege Enforcement

---

### Part 16: SCIM in Modern Architecture

91. **SCIM in Microservices**
    - Service Decomposition
    - Event-Driven Provisioning
    - Saga Patterns
    - Eventual Consistency

92. **SCIM in Cloud Environments**
    - AWS Integration Patterns
    - Azure Integration Patterns
    - GCP Integration Patterns
    - Multi-Cloud Provisioning

93. **SCIM in Zero Trust Architecture**
    - Continuous Verification
    - Just-In-Time Provisioning
    - Attribute-Based Access
    - Dynamic Policy Enforcement

94. **SCIM with SAML/OIDC**
    - Combined Architecture
    - SSO + Provisioning Flow
    - JIT Provisioning vs SCIM
    - Attribute Synchronization

95. **SCIM Alternatives & Complements**
    - Direct API Integration
    - Webhook-Based Provisioning
    - GraphQL for Identity
    - Proprietary Connectors
    - When to Use Alternatives

---

### Part 17: Platform-Specific Implementation

96. **Java Implementation**
    - UnboundID SCIM SDK
    - Apache Directory SCIM
    - Spring-Based Implementation
    - Implementation Patterns

97. **.NET Implementation**
    - Microsoft.SCIM
    - Custom Implementation
    - Azure AD SCIM Templates
    - Implementation Patterns

98. **Python Implementation**
    - scim2-filter-parser
    - Flask-SCIM
    - Django SCIM
    - Implementation Patterns

99. **Node.js Implementation**
    - scimmy
    - scim-node
    - Custom Implementation
    - Implementation Patterns

100. **Go Implementation**
     - elimity-com/scim
     - Custom Implementation
     - Implementation Patterns

101. **Ruby Implementation**
     - scimitar
     - scim_rails
     - Implementation Patterns

---

### Appendices

- **A.** SCIM 2.0 RFC Reference (RFC 7642, 7643, 7644)
- **B.** Core Schema Attribute Reference
- **C.** Enterprise User Extension Attribute Reference
- **D.** Filter Operator Reference
- **E.** Error Code Reference
- **F.** HTTP Status Code Reference
- **G.** SCIM Media Types
- **H.** Schema URI Reference
- **I.** Glossary of Terms
- **J.** Compliance Checklist
- **K.** Security Checklist
- **L.** Popular Libraries & SDKs by Language
- **M.** IdP SCIM Configuration Guides
- **N.** Sample Request/Response Examples
- **O.** Recommended Reading & Resources

---
#!/bin/bash

# Configuration
ROOT_DIR="SCIM-2.0-Developer-Study-Guide"

# Function to create a part directory
create_part() {
    local part_num="$1"
    local part_name="$2"
    local dir_name="${part_num}-${part_name}"
    
    echo "Creating Directory: $dir_name"
    mkdir -p "$ROOT_DIR/$dir_name"
    CURRENT_DIR="$ROOT_DIR/$dir_name"
}

# Function to create a chapter file with content
create_file() {
    local file_num="$1"
    local title="$2"
    local content="$3"
    
    # Sanitize title for filename: lowercase, replace spaces with dashes, remove special chars
    local safe_title=$(echo "$title" | sed -e 's/ /-/g' -e 's/[^A-Za-z0-9-]//g')
    local filename="${file_num}-${safe_title}.md"
    local filepath="$CURRENT_DIR/$filename"
    
    echo "  Creating File: $filename"
    
    # Write content to file
    cat <<EOF > "$filepath"
# $title

$content

EOF
}

# Create Root Directory
echo "Setting up study guide in '$ROOT_DIR'..."
mkdir -p "$ROOT_DIR"

# ==========================================
# PART 1: Foundations
# ==========================================
create_part "001" "Foundations"

create_file "001" "Introduction to Identity Provisioning" \
"- What is Identity Provisioning?
- Provisioning vs Authentication
- The User Lifecycle Problem
- Manual vs Automated Provisioning
- Business Drivers for Automated Provisioning"

create_file "002" "History of Identity Provisioning" \
"- Early Provisioning Approaches
- Proprietary Connectors Era
- SPML (Service Provisioning Markup Language)
- Evolution to SCIM
- SCIM 1.1 to SCIM 2.0"

create_file "003" "SCIM 2.0 Overview" \
"- What is SCIM?
- SCIM Design Goals
- SCIM vs SPML
- SCIM vs LDAP
- SCIM vs Proprietary APIs
- When to Use SCIM
- SCIM Specification Documents (RFC 7642, 7643, 7644)"

create_file "004" "SCIM Terminology" \
"- Service Provider
- Client (Identity Provider / Provisioning System)
- Resource
- Resource Type
- Schema
- Attribute
- Endpoint
- Bulk Operation"

# ==========================================
# PART 2: Core Concepts
# ==========================================
create_part "002" "Core-Concepts"

create_file "001" "SCIM Architecture" \
"- Client-Server Model
- RESTful Design Principles
- JSON Data Format
- HTTP Methods Usage
- Stateless Operations
- Trust Model"

create_file "002" "SCIM Roles" \
"- SCIM Client (Provisioning Source)
- SCIM Service Provider (Target System)
- Identity Provider as SCIM Client
- SaaS Application as Service Provider
- Role Interactions"

create_file "003" "Resources" \
"- What is a Resource?
- Resource Identifiers (id)
- External Identifiers (externalId)
- Resource Metadata (meta)
- Common Resource Types
- Custom Resources"

create_file "004" "Schemas" \
"- Schema Definition
- Schema URIs
- Core Schemas
- Extension Schemas
- Schema Discovery
- Schema Composition"

create_file "005" "Attributes" \
"- Attribute Characteristics (name, type, multiValued, required, caseExact, mutability, returned, uniqueness)
- Attribute Types (String, Boolean, Decimal, Integer, DateTime, Binary, Reference, Complex)
- Sub-Attributes
- Canonical Values"

# ==========================================
# PART 3: Core Resources
# ==========================================
create_part "003" "Core-Resources"

create_file "001" "User Resource" \
"- User Schema (urn:ietf:params:scim:schemas:core:2.0:User)
- Core Attributes (userName, name, displayName, nickName, profileUrl, title, userType, preferredLanguage, locale, timezone, active, password)
- Multi-Valued Attributes (emails, phoneNumbers, ims, photos, addresses, groups, entitlements, roles, x509Certificates)"

create_file "002" "Group Resource" \
"- Group Schema (urn:ietf:params:scim:schemas:core:2.0:Group)
- Core Attributes (displayName, members)
- Member Structure
- Group Membership Management
- Nested Groups"

create_file "003" "Enterprise User Extension" \
"- Extension Schema (urn:ietf:params:scim:schemas:extension:enterprise:2.0:User)
- Enterprise Attributes (employeeNumber, costCenter, organization, division, department, manager)
- Manager Reference"

create_file "004" "Resource Metadata" \
"- meta Attribute Structure
- resourceType
- created
- lastModified
- location
- version (ETag)"

create_file "005" "Custom Resources" \
"- Defining Custom Resource Types
- Custom Schema URIs
- Registration Considerations
- Use Cases"

create_file "006" "Schema Extensions" \
"- Extension Mechanism
- Adding Custom Attributes
- Extension Schema Definition
- Multiple Extensions per Resource
- Use Cases"

# ==========================================
# PART 4: Protocol Operations
# ==========================================
create_part "004" "Protocol-Operations"

create_file "001" "HTTP Methods in SCIM" \
"- GET (Read)
- POST (Create)
- PUT (Replace)
- PATCH (Partial Update)
- DELETE (Remove)
- Method Safety & Idempotency"

create_file "002" "Create Operation POST" \
"- Request Format
- Required Attributes
- Server-Generated Attributes
- Response Format
- Status Codes
- Error Handling
- Examples"

create_file "003" "Read Operation GET" \
"- Retrieving Single Resource
- Resource Endpoint URLs
- Response Format
- Attribute Selection
- Status Codes
- Error Handling
- Examples"

create_file "004" "Replace Operation PUT" \
"- Full Resource Replacement
- Request Format
- Immutable Attributes Handling
- Read-Only Attributes Handling
- Response Format
- Status Codes
- Error Handling
- Examples"

create_file "005" "Partial Update Operation PATCH" \
"- PATCH Request Structure
- Operations Array
- Operation Types (add, remove, replace)
- Path Expressions
- Complex Attribute Patching
- Multi-Valued Attribute Patching
- Response Format
- Status Codes
- Error Handling
- Examples"

create_file "006" "Delete Operation DELETE" \
"- Soft Delete vs Hard Delete
- Request Format
- Response Format
- Status Codes
- Error Handling
- Cascading Deletes
- Examples"

create_file "007" "List Query Operation GET" \
"- Listing Resources
- Pagination (startIndex, count, totalResults, itemsPerPage)
- Sorting (sortBy, sortOrder)
- Filtering (Overview)
- Attribute Selection
- Response Format (ListResponse)
- Examples"

create_file "008" "Bulk Operations" \
"- Bulk Endpoint
- Bulk Request Structure
- Bulk Operations Array
- bulkId References
- failOnErrors Parameter
- Bulk Response Structure
- Partial Failure Handling
- Performance Considerations
- Use Cases
- Examples"

# ==========================================
# PART 5: Filtering & Querying
# ==========================================
create_part "005" "Filtering-Querying"

create_file "001" "Filter Syntax" \
"- Filter Parameter
- Filter Expressions
- Attribute Paths
- Comparison Operators (eq, ne, co, sw, ew, gt, ge, lt, le, pr)
- Logical Operators (and, or, not)
- Grouping with Parentheses
- Complex Attribute Filtering
- Value Path Filtering"

create_file "002" "Filter Examples" \
"- Simple Attribute Filters
- Multi-Valued Attribute Filters
- Complex Attribute Filters
- Combined Filters
- Extension Attribute Filters
- Common Filter Patterns"

create_file "003" "Attribute Projection" \
"- attributes Parameter
- excludedAttributes Parameter
- Attribute Return Defaults
- Minimal Response Requests
- Performance Optimization"

create_file "004" "Sorting" \
"- sortBy Parameter
- sortOrder Parameter (ascending, descending)
- Default Sort Order
- Sorting Complex Attributes
- Multi-Level Sorting Limitations"

create_file "005" "Pagination" \
"- Index-Based Pagination
- startIndex Parameter
- count Parameter
- Response Pagination Attributes
- Cursor-Based Pagination (Non-Standard)
- Pagination Best Practices
- Large Dataset Handling"

# ==========================================
# PART 6: Service Provider Configuration
# ==========================================
create_part "006" "Service-Provider-Configuration"

create_file "001" "Service Provider Configuration Endpoint" \
"- /ServiceProviderConfig Endpoint
- Configuration Resource Structure
- documentationUri
- patch Support
- bulk Support
- filter Support
- changePassword Support
- sort Support
- etag Support
- authenticationSchemes"

create_file "002" "Resource Types Endpoint" \
"- /ResourceTypes Endpoint
- Resource Type Definition
- id, name, description, endpoint, schema
- schemaExtensions
- Custom Resource Type Registration"

create_file "003" "Schemas Endpoint" \
"- /Schemas Endpoint
- Schema Definition Structure
- Attribute Definitions
- Discovering Available Schemas
- Schema Validation"

create_file "004" "Authentication Schemes" \
"- OAuth 2.0 Bearer Token
- HTTP Basic Authentication
- Mutual TLS
- Custom Schemes
- Scheme Declaration in Configuration"

# ==========================================
# PART 7: Protocol Details
# ==========================================
create_part "007" "Protocol-Details"

create_file "001" "HTTP Headers" \
"- Content-Type
- Accept
- Authorization
- Location
- ETag
- If-Match
- If-None-Match
- Custom Headers"

create_file "002" "Content Types" \
"- application/scim+json
- application/json
- Character Encoding
- Content Negotiation"

create_file "003" "ETags and Versioning" \
"- ETag Generation
- Weak vs Strong ETags
- Conditional Requests
- Optimistic Concurrency Control
- Conflict Detection
- If-Match Header Usage
- If-None-Match Header Usage"

create_file "004" "Error Handling" \
"- SCIM Error Response Format
- schemas Array
- scimType Error Codes (invalidFilter, tooMany, uniqueness, mutability, invalidSyntax, invalidPath, noTarget, invalidValue, invalidVers, sensitive)
- detail Message
- status Code
- HTTP Status Code Mapping"

create_file "005" "HTTP Status Codes" \
"- 200 OK
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
- 501 Not Implemented"

# ==========================================
# PART 8: Security
# ==========================================
create_part "008" "Security"

create_file "001" "Authentication" \
"- OAuth 2.0 Bearer Tokens
- Token Scopes for SCIM
- HTTP Basic Authentication
- Mutual TLS (mTLS)
- API Keys (Non-Standard)
- Authentication Best Practices"

create_file "002" "Authorization" \
"- Access Control Models
- Resource-Level Authorization
- Attribute-Level Authorization
- Operation-Level Authorization
- Role-Based Access Control
- Tenant Isolation"

create_file "003" "Transport Security" \
"- TLS Requirements
- Certificate Validation
- Cipher Suite Selection
- HSTS Headers"

create_file "004" "Data Security" \
"- Sensitive Attribute Handling
- Password Handling
- PII Protection
- Data Masking
- Encryption at Rest"

create_file "005" "Common Vulnerabilities" \
"- Injection Attacks
- Broken Authentication
- Excessive Data Exposure
- Mass Assignment
- Broken Object Level Authorization
- Rate Limiting Bypass
- SSRF via References"

create_file "006" "Security Best Practices" \
"- Input Validation
- Output Encoding
- Parameterized Queries
- Principle of Least Privilege
- Audit Logging
- Rate Limiting
- Request Size Limits"

# ==========================================
# PART 9: Implementation - Service Provider
# ==========================================
create_part "009" "Implementation-Service-Provider"

create_file "001" "Service Provider Architecture" \
"- Component Overview
- API Layer Design
- Data Layer Considerations
- Integration Points
- Scalability Planning"

create_file "002" "Endpoint Implementation" \
"- URL Structure
- Routing Design
- Controller Patterns
- Middleware Pipeline
- Request Parsing
- Response Formatting"

create_file "003" "Resource Storage" \
"- Data Model Design
- Schema to Database Mapping
- Multi-Valued Attribute Storage
- Complex Attribute Storage
- Extension Storage
- Indexing Strategies"

create_file "004" "Filter Implementation" \
"- Filter Parser
- AST Generation
- Query Translation
- SQL Query Building
- NoSQL Query Building
- Performance Optimization"

create_file "005" "PATCH Operation Implementation" \
"- Path Expression Parsing
- Operation Execution
- Atomic Updates
- Validation During Patch
- Complex Scenarios"

create_file "006" "Bulk Operation Implementation" \
"- Request Processing
- Transaction Management
- bulkId Resolution
- Partial Failure Handling
- Performance Considerations
- Async Processing Options"

create_file "007" "Pagination Implementation" \
"- Offset-Based Pagination
- Cursor-Based Pagination
- Total Count Calculation
- Large Dataset Strategies
- Consistency Considerations"

create_file "008" "ETag Implementation" \
"- ETag Generation Strategies
- Version Column Approach
- Hash-Based Approach
- Conditional Update Logic
- Conflict Response"

create_file "009" "Validation" \
"- Schema Validation
- Required Attribute Validation
- Uniqueness Validation
- Reference Validation
- Custom Business Rules
- Validation Error Responses"

# ==========================================
# PART 10: Implementation - Client
# ==========================================
create_part "010" "Implementation-Client"

create_file "001" "SCIM Client Architecture" \
"- Client Component Overview
- Connection Management
- Request Building
- Response Handling
- Error Handling Strategy"

create_file "002" "Discovery and Configuration" \
"- Fetching Service Provider Config
- Schema Discovery
- Resource Type Discovery
- Capability Detection
- Caching Configuration"

create_file "003" "User Provisioning Workflows" \
"- Create User Flow
- Update User Flow
- Deactivate User Flow
- Delete User Flow
- Reactivate User Flow"

create_file "004" "Group Provisioning Workflows" \
"- Create Group Flow
- Update Group Membership
- Add Members
- Remove Members
- Delete Group Flow
- Nested Group Handling"

create_file "005" "Synchronization Strategies" \
"- Full Sync
- Incremental Sync
- Delta Sync
- Event-Driven Sync
- Reconciliation
- Conflict Resolution"

create_file "006" "Bulk Provisioning" \
"- When to Use Bulk
- Bulk Request Construction
- Dependency Ordering
- Response Processing
- Error Recovery
- Performance Tuning"

create_file "007" "Error Handling and Retry" \
"- Transient vs Permanent Errors
- Retry Strategies
- Exponential Backoff
- Circuit Breaker Pattern
- Dead Letter Handling
- Manual Intervention Workflows"

create_file "008" "Rate Limiting Handling" \
"- Detecting Rate Limits
- Retry-After Header
- Request Throttling
- Queue-Based Approaches
- Prioritization Strategies"

# ==========================================
# PART 11: Common Integrations
# ==========================================
create_part "011" "Common-Integrations"

create_file "001" "Identity Provider Integration" \
"- Okta as SCIM Client
- Azure AD as SCIM Client
- OneLogin as SCIM Client
- PingIdentity as SCIM Client
- Google Workspace as SCIM Client
- JumpCloud as SCIM Client"

create_file "002" "SaaS Application Integration" \
"- Common SaaS SCIM Implementations
- Slack SCIM
- Zoom SCIM
- Salesforce SCIM
- GitHub SCIM
- Atlassian SCIM
- Dropbox SCIM
- Box SCIM"

create_file "003" "HR System Integration" \
"- Workday
- SAP SuccessFactors
- BambooHR
- ADP
- HR as Source of Truth
- Joiner-Mover-Leaver Workflows"

create_file "004" "Directory Integration" \
"- Active Directory
- LDAP Directories
- Azure AD
- Google Directory
- Bi-Directional Sync Challenges"

create_file "005" "Custom Application Integration" \
"- Adding SCIM to Existing Apps
- Database Mapping
- Legacy System Adapters
- Webhook Alternatives"

# ==========================================
# PART 12: Advanced Topics
# ==========================================
create_part "012" "Advanced-Topics"

create_file "001" "Multi-Tenancy" \
"- Tenant Identification
- URL-Based Tenancy
- Header-Based Tenancy
- Token-Based Tenancy
- Tenant Isolation
- Cross-Tenant Operations"

create_file "002" "Custom Schema Extensions" \
"- Designing Extensions
- Namespace Conventions
- Extension Registration
- Backward Compatibility
- Documentation"

create_file "003" "Custom Resource Types" \
"- When to Create Custom Resources
- Resource Type Definition
- Schema Definition
- Endpoint Design
- Examples (Devices, Licenses, etc.)"

create_file "004" "Reference Attributes" \
"- \$ref Attribute
- Absolute vs Relative References
- Reference Resolution
- Circular Reference Handling
- Cross-Resource References"

create_file "005" "Password Management" \
"- Password Attribute Handling
- Write-Only Semantics
- Password Sync Strategies
- Password Policy Integration
- Self-Service Password Reset"

create_file "006" "Soft Delete and Deactivation" \
"- active Attribute
- Soft Delete Patterns
- Retention Policies
- Reactivation Workflows
- Hard Delete Triggers"

create_file "007" "Async Operations" \
"- Long-Running Operations
- Polling Patterns
- Webhook Notifications
- Status Endpoints
- Non-Standard Extensions"

create_file "008" "Change Detection and Events" \
"- Polling for Changes
- lastModified Filtering
- Webhook/Event Integration
- SCIM Events (Draft Spec)
- Integration with SSF/CAEP"

create_file "009" "Cross-Domain Identity Management" \
"- Multi-Domain Scenarios
- Identity Correlation
- externalId Strategies
- Account Linking
- Federation Considerations"

# ==========================================
# PART 13: Testing
# ==========================================
create_part "013" "Testing"

create_file "001" "Testing SCIM Service Providers" \
"- Unit Testing
- Integration Testing
- Contract Testing
- Conformance Testing
- Load Testing"

create_file "002" "Testing SCIM Clients" \
"- Mock Service Providers
- Integration Testing
- Error Scenario Testing
- Sync Testing"

create_file "003" "SCIM Conformance Testing" \
"- SCIM Compliance Test Suites
- Runscope SCIM Test
- SCIM 2.0 Compliance Checker
- IdP-Specific Test Tools"

create_file "004" "Test Data Management" \
"- Test User Generation
- Test Group Generation
- Data Cleanup
- Idempotent Testing"

create_file "005" "Common Testing Scenarios" \
"- CRUD Operations
- Filter Testing
- Pagination Testing
- Bulk Operation Testing
- Error Condition Testing
- Concurrency Testing"

# ==========================================
# PART 14: Operations & Monitoring
# ==========================================
create_part "014" "Operations-Monitoring"

create_file "001" "Logging" \
"- Request/Response Logging
- Audit Logging
- Error Logging
- PII Considerations
- Log Retention"

create_file "002" "Monitoring and Metrics" \
"- Request Rate Metrics
- Latency Metrics
- Error Rate Metrics
- Resource Count Metrics
- Sync Health Metrics"

create_file "003" "Alerting" \
"- Error Rate Alerts
- Latency Alerts
- Sync Failure Alerts
- Authentication Failure Alerts
- Capacity Alerts"

create_file "004" "Performance Optimization" \
"- Query Optimization
- Caching Strategies
- Connection Pooling
- Bulk Operation Tuning
- Pagination Tuning"

create_file "005" "Scaling" \
"- Horizontal Scaling
- Load Balancing
- Database Scaling
- Rate Limiting Implementation
- Queue-Based Architecture"

create_file "006" "High Availability" \
"- Redundancy Patterns
- Failover Strategies
- Data Replication
- Disaster Recovery"

create_file "007" "Troubleshooting" \
"- Common Issues
- Sync Failures
- Authentication Problems
- Filter Errors
- Performance Issues
- Data Inconsistencies"

# ==========================================
# PART 15: Compliance & Governance
# ==========================================
create_part "015" "Compliance-Governance"

create_file "001" "Data Privacy" \
"- GDPR Considerations
- CCPA Considerations
- Data Minimization
- Purpose Limitation
- Consent Management
- Data Subject Rights"

create_file "002" "Audit and Compliance" \
"- Audit Trail Requirements
- SOC 2 Compliance
- ISO 27001 Compliance
- Industry-Specific Requirements
- Audit Log Retention"

create_file "003" "Data Governance" \
"- Data Ownership
- Data Quality
- Master Data Management
- Data Lineage
- Attribute Authority"

create_file "004" "Access Governance" \
"- Provisioning Approval Workflows
- Access Reviews
- Certification Campaigns
- Segregation of Duties
- Least Privilege Enforcement"

# ==========================================
# PART 16: SCIM in Modern Architecture
# ==========================================
create_part "016" "SCIM-in-Modern-Architecture"

create_file "001" "SCIM in Microservices" \
"- Service Decomposition
- Event-Driven Provisioning
- Saga Patterns
- Eventual Consistency"

create_file "002" "SCIM in Cloud Environments" \
"- AWS Integration Patterns
- Azure Integration Patterns
- GCP Integration Patterns
- Multi-Cloud Provisioning"

create_file "003" "SCIM in Zero Trust Architecture" \
"- Continuous Verification
- Just-In-Time Provisioning
- Attribute-Based Access
- Dynamic Policy Enforcement"

create_file "004" "SCIM with SAML OIDC" \
"- Combined Architecture
- SSO + Provisioning Flow
- JIT Provisioning vs SCIM
- Attribute Synchronization"

create_file "005" "SCIM Alternatives and Complements" \
"- Direct API Integration
- Webhook-Based Provisioning
- GraphQL for Identity
- Proprietary Connectors
- When to Use Alternatives"

# ==========================================
# PART 17: Platform-Specific Implementation
# ==========================================
create_part "017" "Platform-Specific-Implementation"

create_file "001" "Java Implementation" \
"- UnboundID SCIM SDK
- Apache Directory SCIM
- Spring-Based Implementation
- Implementation Patterns"

create_file "002" "NET Implementation" \
"- Microsoft.SCIM
- Custom Implementation
- Azure AD SCIM Templates
- Implementation Patterns"

create_file "003" "Python Implementation" \
"- scim2-filter-parser
- Flask-SCIM
- Django SCIM
- Implementation Patterns"

create_file "004" "Nodejs Implementation" \
"- scimmy
- scim-node
- Custom Implementation
- Implementation Patterns"

create_file "005" "Go Implementation" \
"- elimity-com/scim
- Custom Implementation
- Implementation Patterns"

create_file "006" "Ruby Implementation" \
"- scimitar
- scim_rails
- Implementation Patterns"

# ==========================================
# Appendices
# ==========================================
create_part "018" "Appendices"

create_file "001" "References" \
"- A. SCIM 2.0 RFC Reference (RFC 7642, 7643, 7644)
- B. Core Schema Attribute Reference
- C. Enterprise User Extension Attribute Reference
- D. Filter Operator Reference
- E. Error Code Reference
- F. HTTP Status Code Reference
- G. SCIM Media Types
- H. Schema URI Reference
- I. Glossary of Terms
- J. Compliance Checklist
- K. Security Checklist
- L. Popular Libraries & SDKs by Language
- M. IdP SCIM Configuration Guides
- N. Sample Request/Response Examples
- O. Recommended Reading & Resources"

echo ""
echo "Guide creation complete! Structure available in $ROOT_DIR"


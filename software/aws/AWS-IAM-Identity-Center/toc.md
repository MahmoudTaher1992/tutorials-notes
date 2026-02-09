# AWS IAM Identity Center - Developer & Administrator Study Guide

## Table of Contents

---

### Part 1: Foundations

1. **Introduction to Identity Management in AWS**
   - Identity & Access Management Concepts
   - Authentication vs Authorization in AWS
   - Centralized vs Decentralized Identity
   - Single Sign-On in Enterprise Environments
   - The Challenge of Multi-Account AWS Environments

2. **History & Evolution**
   - AWS Single Sign-On (AWS SSO) Origins
   - Rebranding to IAM Identity Center
   - Feature Evolution Timeline
   - Integration with AWS Organizations
   - Current Capabilities Overview

3. **IAM Identity Center Overview**
   - What is IAM Identity Center?
   - Core Value Proposition
   - IAM Identity Center vs IAM Users
   - IAM Identity Center vs AWS Directory Service
   - IAM Identity Center vs Third-Party SSO
   - Key Use Cases
   - Pricing Model

4. **Key Terminology**
   - Identity Source
   - User
   - Group
   - Permission Set
   - AWS Account Assignment
   - Application Assignment
   - Access Portal
   - Session
   - Identity Store
   - Trusted Identity Propagation

5. **Architecture Overview**
   - High-Level Architecture
   - Regional Deployment Model
   - Integration Points
   - Data Flow Overview
   - Trust Relationships

---

### Part 2: Core Components

6. **Identity Sources**
   - Identity Source Options Overview
   - Identity Center Directory (Built-in)
   - Active Directory Integration
   - External Identity Provider (SAML 2.0)
   - Choosing the Right Identity Source
   - Identity Source Limitations
   - Changing Identity Sources

7. **Identity Center Directory**
   - Built-in Directory Overview
   - When to Use Identity Center Directory
   - User Management
   - Group Management
   - Password Policies
   - MFA Configuration
   - Limitations & Considerations

8. **Users**
   - User Attributes
   - Core Attributes
     - Username
     - Email
     - First Name / Last Name
     - Display Name
   - Additional Attributes
   - Custom Attributes
   - User Lifecycle States
   - User Provisioning Methods

9. **Groups**
   - Group Purpose & Benefits
   - Group Attributes
   - Group Membership Management
   - Nested Groups (Limitations)
   - Groups from External Sources
   - Group-Based Access Patterns

10. **AWS Organizations Integration**
    - Organizations Prerequisite
    - Management Account Considerations
    - Organization Structure Impact
    - Organizational Units (OUs) & Assignments
    - Delegated Administrator
    - Cross-Organization Limitations

---

### Part 3: Active Directory Integration

11. **AWS Managed Microsoft AD Integration**
    - Integration Overview
    - Prerequisites
    - Configuration Steps
    - User & Group Sync
    - Attribute Mapping
    - Sync Frequency & Behavior
    - Troubleshooting Sync Issues

12. **Self-Managed Active Directory Integration**
    - AD Connector Overview
    - Prerequisites
    - Network Requirements
    - AD Connector Setup
    - Trust Relationships
    - Configuration Steps
    - Limitations

13. **Active Directory Sync Behavior**
    - Sync Scope Configuration
    - Incremental Sync
    - Full Sync
    - Attribute Mapping
    - Conflict Resolution
    - Handling AD Changes
    - Deleted Users/Groups Behavior

14. **Active Directory Best Practices**
    - OU Structure Recommendations
    - Group Strategy
    - Service Account Configuration
    - Network Architecture
    - High Availability Considerations
    - Security Hardening

---

### Part 4: External Identity Provider Integration

15. **SAML 2.0 Integration Overview**
    - How SAML Integration Works
    - IAM Identity Center as Service Provider
    - Supported SAML Features
    - Attribute Mapping Requirements
    - Session Behavior

16. **External IdP Configuration**
    - IdP Metadata Configuration
    - IAM Identity Center Metadata
    - Attribute Mapping
    - NameID Configuration
    - Signing Certificate Management
    - Session Duration Settings

17. **Automatic Provisioning (SCIM)**
    - SCIM Support Overview
    - Enabling SCIM Provisioning
    - SCIM Endpoint & Token
    - Supported SCIM Operations
    - Provisioning Scope
    - Sync Behavior
    - Troubleshooting SCIM

18. **Okta Integration**
    - Okta Configuration Steps
    - SAML Setup
    - SCIM Provisioning Setup
    - Attribute Mapping
    - Group Push Configuration
    - Troubleshooting

19. **Azure AD / Microsoft Entra ID Integration**
    - Azure AD Configuration Steps
    - Enterprise Application Setup
    - SAML Configuration
    - SCIM Provisioning Setup
    - Attribute Mapping
    - Group Synchronization
    - Conditional Access Considerations
    - Troubleshooting

20. **Google Workspace Integration**
    - Google Workspace Configuration
    - SAML Setup
    - SCIM Provisioning
    - Attribute Mapping
    - Troubleshooting

21. **PingFederate / PingIdentity Integration**
    - PingFederate Configuration
    - SAML Setup
    - SCIM Configuration
    - Troubleshooting

22. **OneLogin Integration**
    - OneLogin Configuration
    - SAML Setup
    - SCIM Provisioning
    - Troubleshooting

23. **Other IdP Integrations**
    - Generic SAML 2.0 Configuration
    - CyberArk Identity
    - JumpCloud
    - Duo Security
    - Custom IdP Considerations

---

### Part 5: Permission Sets

24. **Permission Sets Overview**
    - What are Permission Sets?
    - Permission Set vs IAM Policies
    - Permission Set Components
    - Permission Set Lifecycle
    - Maximum Permission Sets Limits

25. **Permission Set Types**
    - AWS Managed Policies in Permission Sets
    - Customer Managed Policies
    - Inline Policies
    - Permissions Boundary
    - Combining Policy Types

26. **AWS Managed Policies**
    - Common AWS Managed Policies
    - Job Function Policies
    - Service-Specific Policies
    - When to Use AWS Managed Policies
    - Limitations

27. **Custom Policies in Permission Sets**
    - Inline Policy Configuration
    - Customer Managed Policy References
    - Policy Size Limits
    - Policy Versioning Considerations
    - Best Practices

28. **Permissions Boundary**
    - Permissions Boundary Concept
    - Configuring Boundaries in Permission Sets
    - Use Cases
    - Effective Permissions Calculation
    - Troubleshooting Boundary Issues

29. **Session Policies & Settings**
    - Session Duration Configuration
    - Relay State Configuration
    - Session Tags
    - Session Behavior

30. **Permission Set Design Patterns**
    - Role-Based Access Control (RBAC)
    - Job Function-Based Sets
    - Environment-Based Sets
    - Least Privilege Design
    - Break-Glass Access
    - Temporary Elevated Access

31. **Permission Set Management**
    - Creating Permission Sets
    - Updating Permission Sets
    - Versioning Considerations
    - Deleting Permission Sets
    - Permission Set Provisioning
    - Provisioning Status

---

### Part 6: Account Assignments

32. **Account Assignments Overview**
    - What are Account Assignments?
    - Assignment Model
    - User vs Group Assignments
    - Assignment Propagation

33. **Creating Account Assignments**
    - Console-Based Assignment
    - CLI-Based Assignment
    - API-Based Assignment
    - CloudFormation-Based Assignment
    - Terraform-Based Assignment

34. **Assignment Strategies**
    - Individual Account Assignment
    - OU-Based Assignment Patterns
    - Group-Based Assignment Patterns
    - Multi-Permission Set Strategies
    - Environment Segregation

35. **Assignment Lifecycle**
    - Assignment Creation
    - Assignment Updates
    - Assignment Removal
    - Propagation Timing
    - Handling Assignment Conflicts

36. **Bulk Assignment Management**
    - Bulk Operations via CLI/API
    - Automation Approaches
    - Infrastructure as Code
    - Assignment Auditing

---

### Part 7: AWS Access Portal

37. **Access Portal Overview**
    - What is the Access Portal?
    - Portal URL Structure
    - User Experience
    - Customization Options

38. **Portal Customization**
    - Custom Portal URL
    - Branding Options
    - Session Settings
    - Relay State for Deep Linking

39. **User Access Portal Experience**
    - Login Flow
    - MFA Experience
    - Account & Role Selection
    - AWS Console Access
    - CLI Credential Retrieval
    - Application Access

40. **Access Portal Security**
    - Authentication Requirements
    - Session Management
    - Concurrent Session Handling
    - Session Revocation
    - Access Logging

---

### Part 8: Application Assignments

41. **AWS Application Integration**
    - AWS Applications Overview
    - Amazon Q Integration
    - Amazon QuickSight Integration
    - Amazon Redshift Integration
    - Amazon EMR Integration
    - AWS Lake Formation Integration
    - Amazon SageMaker Integration
    - Other AWS Service Integrations

42. **SAML 2.0 Application Integration**
    - Custom SAML Application Overview
    - Application Configuration
    - Attribute Mapping
    - Relay State Configuration
    - Certificate Management
    - Assignment to Users/Groups

43. **OAuth 2.0 Application Integration**
    - OAuth 2.0 Support Overview
    - Customer Managed Applications
    - Application Registration
    - Scopes Configuration
    - Token Settings

44. **Pre-Integrated Applications**
    - AWS Managed Applications Catalog
    - SaaS Application Templates
    - Configuration Patterns
    - Common Integrations
      - Salesforce
      - ServiceNow
      - Slack
      - Microsoft 365
      - Google Workspace
      - Zoom
      - Atlassian Cloud

45. **Custom Application Integration**
    - Custom SAML Application Setup
    - Metadata Configuration
    - Attribute Statements
    - Testing Integration
    - Troubleshooting

---

### Part 9: Trusted Identity Propagation

46. **Trusted Identity Propagation Overview**
    - What is Trusted Identity Propagation?
    - Use Cases
    - Supported Services
    - Architecture Patterns
    - Benefits over Traditional Patterns

47. **Identity-Aware AWS Services**
    - Amazon S3 Access Grants
    - Amazon Redshift
    - AWS Lake Formation
    - Amazon EMR
    - Amazon Athena
    - Amazon QuickSight
    - Amazon SageMaker

48. **Token Exchange & Propagation**
    - Token Types
    - Identity Context Propagation
    - Token Exchange Flows
    - Token Lifetime
    - Refresh Behavior

49. **S3 Access Grants Integration**
    - Access Grants Overview
    - Directory Identity Integration
    - Grant Configuration
    - Access Patterns
    - Audit & Logging

50. **Lake Formation Integration**
    - Lake Formation Overview
    - Identity-Based Permissions
    - Fine-Grained Access Control
    - Data Catalog Integration
    - Cross-Account Access

51. **Redshift Integration**
    - Redshift Identity Integration
    - Federation Configuration
    - Database User Mapping
    - Permission Management
    - Query Auditing

---

### Part 10: Multi-Factor Authentication

52. **MFA Overview in IAM Identity Center**
    - MFA Importance
    - Supported MFA Types
    - MFA Enforcement Options
    - MFA with External IdPs

53. **MFA Device Types**
    - Authenticator Apps (TOTP)
    - Hardware TOTP Tokens
    - FIDO2 Security Keys
    - Built-in Authenticators
    - Device Registration

54. **MFA Configuration**
    - Enabling MFA
    - MFA Enforcement Policies
    - Context-Aware MFA
    - Re-Authentication Requirements
    - Grace Periods

55. **MFA Enrollment**
    - Self-Service Enrollment
    - Admin-Assisted Enrollment
    - Multiple Device Registration
    - Device Management
    - Lost Device Procedures

56. **MFA with External Identity Providers**
    - MFA at IdP vs IAM Identity Center
    - Pass-Through MFA Context
    - Authentication Context Mapping
    - Best Practices

---

### Part 11: CLI & SDK Access

57. **AWS CLI Integration**
    - CLI v2 Integration Overview
    - `aws configure sso` Command
    - SSO Profile Configuration
    - Login Flow (`aws sso login`)
    - Session Caching
    - Multiple Profile Management

58. **CLI Configuration Patterns**
    - Named Profiles
    - Profile Inheritance
    - Default Profile Configuration
    - Environment Variables
    - Credential Process Integration

59. **SDK Integration**
    - SDK SSO Credential Provider
    - Supported SDKs
    - Configuration via Config Files
    - Programmatic Configuration
    - Credential Resolution Chain

60. **Short-Term Credentials**
    - Credential Retrieval Methods
    - Credential Caching
    - Credential Refresh
    - Session Duration Considerations
    - Security Best Practices

61. **Automation & CI/CD Integration**
    - Headless Authentication Challenges
    - OIDC Provider for CI/CD
    - GitHub Actions Integration
    - GitLab CI Integration
    - Jenkins Integration
    - Alternative Patterns

---

### Part 12: Infrastructure as Code

62. **CloudFormation Support**
    - Supported Resources
    - `AWS::SSO::PermissionSet`
    - `AWS::SSO::Assignment`
    - `AWS::SSO::InstanceAccessControlAttributeConfiguration`
    - Stack Deployment Patterns
    - Cross-Account Deployment
    - Limitations

63. **Terraform Support**
    - AWS Provider Resources
    - `aws_ssoadmin_permission_set`
    - `aws_ssoadmin_account_assignment`
    - `aws_ssoadmin_managed_policy_attachment`
    - `aws_ssoadmin_permission_set_inline_policy`
    - `aws_identitystore_user`
    - `aws_identitystore_group`
    - State Management Considerations
    - Module Patterns

64. **AWS CDK Support**
    - CDK Constructs
    - L1 vs L2 Constructs
    - Cross-Stack References
    - Deployment Patterns
    - Examples

65. **Pulumi Support**
    - Pulumi AWS Provider
    - Resource Definitions
    - Deployment Patterns

66. **IaC Best Practices**
    - Modular Design
    - Environment Segregation
    - State Management
    - Drift Detection
    - Change Management
    - Testing Strategies

---

### Part 13: API & Automation

67. **IAM Identity Center APIs Overview**
    - SSO Admin API
    - Identity Store API
    - SSO OIDC API
    - API Endpoint Regions
    - Authentication Requirements

68. **SSO Admin API**
    - Permission Set Operations
      - `CreatePermissionSet`
      - `DeletePermissionSet`
      - `UpdatePermissionSet`
      - `DescribePermissionSet`
      - `ListPermissionSets`
    - Assignment Operations
      - `CreateAccountAssignment`
      - `DeleteAccountAssignment`
      - `ListAccountAssignments`
    - Policy Operations
      - `AttachManagedPolicyToPermissionSet`
      - `PutInlinePolicyToPermissionSet`
      - `AttachCustomerManagedPolicyReferenceToPermissionSet`
    - Provisioning Operations
      - `ProvisionPermissionSet`
      - `DescribePermissionSetProvisioningStatus`

69. **Identity Store API**
    - User Operations
      - `CreateUser`
      - `DeleteUser`
      - `UpdateUser`
      - `DescribeUser`
      - `ListUsers`
      - `GetUserId`
    - Group Operations
      - `CreateGroup`
      - `DeleteGroup`
      - `UpdateGroup`
      - `DescribeGroup`
      - `ListGroups`
      - `GetGroupId`
    - Membership Operations
      - `CreateGroupMembership`
      - `DeleteGroupMembership`
      - `ListGroupMemberships`
      - `ListGroupMembershipsForMember`
      - `IsMemberInGroups`

70. **SSO OIDC API**
    - Device Authorization Flow
    - `RegisterClient`
    - `StartDeviceAuthorization`
    - `CreateToken`
    - Token Types
    - Use Cases

71. **Automation Patterns**
    - User Lifecycle Automation
    - Group Membership Automation
    - Permission Set Deployment
    - Assignment Automation
    - Reporting Automation
    - Compliance Automation

72. **Event-Driven Automation**
    - EventBridge Integration
    - IAM Identity Center Events
    - Lambda Triggers
    - Step Functions Workflows
    - Automation Examples

---

### Part 14: Security

73. **Security Model**
    - Shared Responsibility Model
    - IAM Identity Center Security Architecture
    - Data Protection
    - Network Security
    - Encryption

74. **Authentication Security**
    - Password Policies
    - MFA Enforcement
    - Session Management
    - Brute Force Protection
    - Account Lockout

75. **Authorization Security**
    - Least Privilege Principle
    - Permission Set Design
    - Permissions Boundary Usage
    - Regular Access Reviews
    - Separation of Duties

76. **Data Protection**
    - Data Encryption at Rest
    - Data Encryption in Transit
    - Customer Managed Keys (CMK)
    - PII Handling
    - Data Residency

77. **Network Security**
    - VPC Endpoints
    - Private Access Patterns
    - Network Isolation
    - Firewall Considerations

78. **Delegated Administration**
    - Delegated Admin Account
    - Configuration Steps
    - Delegated Permissions Scope
    - Security Implications
    - Best Practices

79. **Security Best Practices**
    - Management Account Protection
    - Admin Access Restrictions
    - MFA Everywhere
    - Regular Audits
    - Monitoring & Alerting
    - Incident Response Planning

---

### Part 15: Monitoring & Logging

80. **AWS CloudTrail Integration**
    - CloudTrail Event Types
    - Management Events
    - Data Events
    - Event Sources
    - Log Analysis
    - Example Events

81. **CloudTrail Event Examples**
    - Authentication Events
    - Permission Set Changes
    - Assignment Changes
    - User/Group Changes
    - Configuration Changes
    - Federated Login Events

82. **CloudWatch Integration**
    - CloudWatch Metrics
    - Custom Metrics
    - Dashboard Creation
    - Alarm Configuration

83. **EventBridge Integration**
    - Event Patterns
    - Rule Configuration
    - Target Integration
    - Automation Triggers
    - Event Examples

84. **Access Logging**
    - User Access Logs
    - Application Access Logs
    - CLI Access Logs
    - Log Retention
    - Log Analysis

85. **Security Monitoring**
    - Anomaly Detection
    - Failed Login Monitoring
    - Permission Change Alerts
    - Compliance Monitoring
    - Security Hub Integration

86. **Audit & Compliance Reporting**
    - Access Reports
    - Permission Reports
    - Assignment Reports
    - Compliance Evidence
    - Automated Reporting

---

### Part 16: Troubleshooting

87. **Common Issues**
    - Login Failures
    - MFA Issues
    - Permission Denied Errors
    - Sync Failures
    - Assignment Propagation Delays
    - Application Access Issues

88. **Authentication Troubleshooting**
    - IdP Communication Errors
    - SAML Assertion Issues
    - Attribute Mapping Errors
    - Session Issues
    - Browser Issues

89. **Authorization Troubleshooting**
    - Permission Set Issues
    - Policy Evaluation
    - Effective Permissions Analysis
    - IAM Policy Simulator
    - Access Denied Analysis

90. **Directory Sync Troubleshooting**
    - AD Connector Issues
    - SCIM Provisioning Failures
    - Attribute Sync Issues
    - User/Group Missing
    - Conflict Resolution

91. **CLI & SDK Troubleshooting**
    - Credential Issues
    - Session Expiration
    - Profile Configuration
    - Cache Issues
    - Debug Logging

92. **Application Integration Troubleshooting**
    - SAML Configuration Issues
    - Certificate Problems
    - Attribute Mapping Issues
    - Relay State Issues
    - Session Problems

93. **Diagnostic Tools**
    - CloudTrail Analysis
    - IAM Policy Simulator
    - AWS Support Tools
    - Browser Developer Tools
    - SAML Tracer

---

### Part 17: Migration & Adoption

94. **Migration Planning**
    - Current State Assessment
    - Target Architecture Design
    - Migration Strategy Selection
    - Risk Assessment
    - Rollback Planning
    - Timeline Planning

95. **Migrating from IAM Users**
    - Assessment of Current IAM Users
    - Mapping IAM Users to Identity Center
    - Permission Mapping
    - Migration Steps
    - Coexistence Period
    - Decommissioning IAM Users

96. **Migrating from AWS SSO (Legacy)**
    - Feature Parity Assessment
    - Configuration Migration
    - Testing Procedures
    - Cutover Planning

97. **Migrating from Third-Party SSO**
    - Current Integration Assessment
    - Feature Comparison
    - Migration Approach
    - User Communication
    - Parallel Running
    - Cutover Process

98. **Migrating Identity Sources**
    - Planning Source Migration
    - User/Group Mapping
    - Migration Steps
    - Data Validation
    - Rollback Procedures

99. **Adoption Best Practices**
    - Phased Rollout
    - Pilot Groups
    - User Training
    - Documentation
    - Support Procedures
    - Feedback Collection

---

### Part 18: Multi-Account Strategies

100. **AWS Organizations Patterns**
     - Organization Structure Design
     - OU Hierarchy
     - Account Vending
     - IAM Identity Center Placement

101. **Landing Zone Integration**
     - AWS Control Tower Integration
     - Account Factory
     - Guardrails
     - Baseline Configuration
     - Customization Options

102. **Multi-Account Permission Strategies**
     - Centralized Permission Management
     - Federated Permission Management
     - Hybrid Approaches
     - Cross-Account Access Patterns

103. **Environment Segregation**
     - Development/Staging/Production
     - Permission Set per Environment
     - Group-Based Environment Access
     - Break-Glass Procedures

104. **Large-Scale Deployments**
     - Scaling Considerations
     - Automation Requirements
     - Performance Optimization
     - Quota Management
     - Support Escalation

---

### Part 19: Advanced Topics

105. **Attribute-Based Access Control (ABAC)**
     - ABAC Overview
     - Access Control Attributes
     - Configuring ABAC
     - Attribute Sources
     - Policy Conditions with Attributes
     - Use Cases
     - Limitations

106. **Session Tags**
     - Session Tag Concept
     - Propagating Attributes as Tags
     - Tag-Based Policies
     - Cross-Account Tag Propagation
     - Use Cases

107. **Instance Access Control**
     - Instance Configuration
     - Access Control Attributes
     - Identity Store Attributes
     - External IdP Attributes
     - Mapping Configuration

108. **Custom SAML Applications Advanced**
     - Complex Attribute Mapping
     - Role-Based Attributes
     - Dynamic Attribute Values
     - Multi-Value Attributes
     - Conditional Attributes

109. **Cross-Region Considerations**
     - Regional Deployment Model
     - Data Residency
     - Disaster Recovery
     - Multi-Region Access
     - Latency Considerations

110. **Integration with AWS Services**
     - Service Control Policies (SCPs)
     - AWS Config Rules
     - AWS Security Hub
     - Amazon GuardDuty
     - AWS Audit Manager
     - AWS IAM Access Analyzer

---

### Part 20: Governance & Compliance

111. **Access Governance**
     - Access Review Processes
     - Certification Campaigns
     - Orphaned Access Detection
     - Excessive Permissions Detection
     - Automated Remediation

112. **Compliance Frameworks**
     - SOC 2 Compliance
     - ISO 27001 Compliance
     - PCI DSS Compliance
     - HIPAA Compliance
     - FedRAMP Compliance
     - GDPR Compliance

113. **Policy Governance**
     - Permission Set Standards
     - Policy Review Processes
     - Change Management
     - Approval Workflows
     - Policy Documentation

114. **Audit Preparation**
     - Evidence Collection
     - Access Reports
     - Configuration Documentation
     - Change History
     - Incident Documentation

115. **Continuous Compliance**
     - Automated Compliance Checks
     - Drift Detection
     - Remediation Automation
     - Compliance Dashboards
     - Alerting

---

### Part 21: Operational Excellence

116. **Day-to-Day Operations**
     - User Onboarding
     - User Offboarding
     - Access Requests
     - Permission Changes
     - Incident Response

117. **Change Management**
     - Change Request Process
     - Testing Procedures
     - Approval Workflows
     - Deployment Procedures
     - Rollback Procedures

118. **Capacity Planning**
     - Service Quotas
     - Quota Monitoring
     - Quota Increase Requests
     - Growth Planning

119. **Disaster Recovery**
     - Backup Considerations
     - Recovery Procedures
     - Alternative Access Methods
     - Communication Plans
     - Testing DR Procedures

120. **Operational Runbooks**
     - Common Procedures
     - Troubleshooting Guides
     - Escalation Procedures
     - Contact Information
     - Decision Trees

---

### Appendices

- **A.** Service Quotas & Limits Reference
- **B.** API Reference Summary
- **C.** CloudTrail Event Reference
- **D.** Error Code Reference
- **E.** SAML Attribute Mapping Reference
- **F.** SCIM Attribute Mapping Reference
- **G.** AWS Managed Policies Reference
- **H.** CLI Commands Reference
- **I.** Terraform Resource Reference
- **J.** CloudFormation Resource Reference
- **K.** Glossary of Terms
- **L.** Security Checklist
- **M.** Migration Checklist
- **N.** Troubleshooting Flowcharts
- **O.** Sample Architectures
- **P.** Recommended Reading & Resources
- **Q.** AWS Documentation Links

---
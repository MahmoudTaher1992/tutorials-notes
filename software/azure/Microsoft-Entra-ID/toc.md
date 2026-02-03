# Microsoft Entra ID - Developer & Administrator Study Guide

## Table of Contents

---

### Part 1: Foundations

1. **Introduction to Identity in Microsoft Cloud**
   - Identity as the Control Plane
   - Zero Trust Security Model
   - Identity-Driven Security
   - Microsoft's Identity Vision
   - Hybrid Identity Landscape

2. **History & Evolution**
   - Azure Active Directory Origins
   - Evolution from On-Premises AD
   - Rebranding to Microsoft Entra ID
   - Microsoft Entra Product Family Overview
   - Feature Evolution Timeline

3. **Microsoft Entra ID Overview**
   - What is Microsoft Entra ID?
   - Core Capabilities
   - Entra ID vs Active Directory Domain Services
   - Entra ID vs Azure AD B2C
   - Entra ID vs Entra External ID
   - Cloud-Only vs Hybrid Identity
   - Multi-Tenant Architecture

4. **Licensing & Editions**
   - Free Tier
   - Microsoft 365 Licensing
   - Entra ID P1 Features
   - Entra ID P2 Features
   - Entra ID Governance Add-on
   - Feature Comparison Matrix
   - Licensing Best Practices

5. **Key Terminology**
   - Tenant
   - Directory
   - User Object
   - Group Object
   - Service Principal
   - Application Registration
   - Managed Identity
   - Conditional Access
   - Identity Protection

6. **Architecture Overview**
   - Global Service Architecture
   - Regional Data Residency
   - Multi-Tenant Isolation
   - High Availability Design
   - Replication & Consistency
   - Trust Boundaries

---

### Part 2: Tenant & Directory Management

7. **Tenant Fundamentals**
   - What is a Tenant?
   - Tenant Creation
   - Tenant Properties
   - Primary Domain
   - Tenant ID & Object IDs
   - Tenant Isolation
   - Multi-Tenant Considerations

8. **Directory Structure**
   - Directory Objects Overview
   - Object Types
   - Object Attributes
   - Object Relationships
   - Directory Extensions
   - Schema Extensions

9. **Domain Management**
   - Default Domain (onmicrosoft.com)
   - Custom Domain Registration
   - Domain Verification
   - DNS Record Requirements
   - Federated Domains
   - Primary Domain Selection
   - Domain Removal

10. **Tenant Settings & Configuration**
    - Tenant Properties
    - User Settings
    - External Collaboration Settings
    - Security Defaults
    - Consent Settings
    - Enterprise Application Settings
    - Device Settings

11. **Administrative Units**
    - Administrative Units Overview
    - Creating Administrative Units
    - Assigning Members
    - Delegated Administration
    - Restricted Management Administrative Units
    - Use Cases & Patterns

12. **Multi-Tenant Management**
    - Multi-Tenant Organizations
    - Cross-Tenant Access Settings
    - Cross-Tenant Synchronization
    - B2B Direct Connect
    - Tenant Restrictions
    - Azure Lighthouse Integration

---

### Part 3: User Management

13. **User Objects**
    - User Object Overview
    - User Types (Member vs Guest)
    - User Attributes
      - Identity Attributes
      - Job Information
      - Contact Information
      - Settings
    - Custom Security Attributes
    - Extension Attributes
    - User Principal Name (UPN)
    - Immutable ID

14. **User Lifecycle Management**
    - User Creation Methods
    - User Provisioning
    - User Updates
    - User Deactivation
    - User Deletion
    - Soft Delete & Recovery
    - Hard Delete

15. **Cloud-Only Users**
    - Creating Cloud Users
    - Password Management
    - Attribute Management
    - Bulk User Operations
    - CSV Import/Export

16. **Synchronized Users**
    - Entra Connect Sync
    - Entra Cloud Sync
    - Source of Authority
    - Attribute Flow
    - Write-Back Capabilities
    - Handling Sync Conflicts

17. **Guest Users (B2B)**
    - B2B Collaboration Overview
    - Inviting Guest Users
    - Invitation Redemption
    - Guest User Properties
    - Guest Access Levels
    - Guest Lifecycle Management
    - Converting Guests to Members

18. **User Settings & Preferences**
    - Default User Permissions
    - User Consent Settings
    - Group Creation Restrictions
    - Application Registration Restrictions
    - LinkedIn Integration
    - Usage Location

---

### Part 4: Group Management

19. **Group Types**
    - Security Groups
    - Microsoft 365 Groups
    - Distribution Groups
    - Mail-Enabled Security Groups
    - Group Comparison Matrix
    - Choosing the Right Group Type

20. **Group Membership Types**
    - Assigned Membership
    - Dynamic User Membership
    - Dynamic Device Membership
    - Membership Rules Syntax
    - Rule Builder
    - Processing Latency

21. **Dynamic Group Rules**
    - Rule Syntax Overview
    - Supported Operators
    - Supported Properties
    - Complex Rule Construction
    - Rule Validation
    - Troubleshooting Rules
    - Performance Considerations

22. **Group Lifecycle Management**
    - Group Creation
    - Group Owners
    - Group Members Management
    - Nested Groups
    - Group Expiration Policies
    - Group Naming Policies
    - Group Deletion & Recovery

23. **Self-Service Group Management**
    - Self-Service Group Creation
    - Self-Service Join/Leave
    - Access Reviews for Groups
    - Group Approval Workflows
    - Owner Management

24. **Privileged Access Groups**
    - Role-Assignable Groups
    - PIM for Groups
    - Just-In-Time Access
    - Approval Workflows
    - Access Reviews

---

### Part 5: Application Integration

25. **Application Model Overview**
    - Application Objects vs Service Principals
    - Multi-Tenant Application Model
    - Single-Tenant Applications
    - Application Ownership
    - Application Lifecycle

26. **Application Registration**
    - Registering Applications
    - Application ID (Client ID)
    - Redirect URIs
    - Supported Account Types
    - Application Credentials
    - Branding Configuration
    - Token Configuration

27. **Application Credentials**
    - Client Secrets
    - Certificates
    - Federated Credentials
    - Credential Rotation
    - Credential Expiration
    - Best Practices

28. **Service Principals**
    - Service Principal Types
      - Application
      - Managed Identity
      - Legacy
    - Service Principal Properties
    - Service Principal vs Application
    - Enterprise Applications Blade

29. **API Permissions**
    - Permission Types
      - Delegated Permissions
      - Application Permissions
    - Microsoft Graph Permissions
    - First-Party API Permissions
    - Custom API Permissions
    - Permission Consent
    - Least Privilege Approach

30. **Consent Framework**
    - User Consent
    - Admin Consent
    - Consent Settings Configuration
    - Admin Consent Workflow
    - Consent Grant Types
    - Revoking Consent
    - Consent Audit

31. **OAuth 2.0 & OpenID Connect**
    - Supported OAuth 2.0 Flows
    - Authorization Code Flow
    - Authorization Code with PKCE
    - Client Credentials Flow
    - On-Behalf-Of Flow
    - Device Code Flow
    - Implicit Flow (Legacy)
    - ROPC Flow (Legacy)
    - Refresh Token Behavior

32. **SAML Integration**
    - SAML SSO Overview
    - SAML Configuration
    - Signing Certificates
    - Attribute Mapping
    - SAML Token Customization
    - User Attributes & Claims
    - Troubleshooting SAML

33. **Application Gallery**
    - Pre-Integrated Applications
    - Gallery vs Non-Gallery
    - SaaS Application Templates
    - Provisioning Templates
    - Configuration Tutorials

34. **Custom Applications**
    - Developing Custom Apps
    - MSAL Libraries
    - Authentication Patterns
    - Token Acquisition
    - Token Caching
    - Error Handling

---

### Part 6: Authentication

35. **Authentication Methods Overview**
    - Password-Based Authentication
    - Passwordless Authentication
    - Multi-Factor Authentication
    - Authentication Strengths
    - Method Registration

36. **Password Authentication**
    - Password Policies
    - Password Protection
    - Banned Password Lists
    - Custom Banned Passwords
    - Password Spray Protection
    - Smart Lockout

37. **Multi-Factor Authentication (MFA)**
    - MFA Overview
    - MFA Methods
      - Microsoft Authenticator
      - OATH Hardware Tokens
      - OATH Software Tokens
      - SMS
      - Voice Call
    - MFA Registration
    - Per-User MFA (Legacy)
    - Conditional Access MFA
    - Number Matching
    - Additional Context

38. **Passwordless Authentication**
    - Passwordless Overview
    - Windows Hello for Business
    - FIDO2 Security Keys
    - Microsoft Authenticator (Passwordless)
    - Certificate-Based Authentication
    - Deployment Strategies

39. **FIDO2 Security Keys**
    - FIDO2 Overview
    - Supported Key Types
    - Key Registration
    - Authentication Flow
    - Key Restrictions
    - Deployment Planning

40. **Certificate-Based Authentication**
    - CBA Overview
    - Certificate Requirements
    - PKI Configuration
    - Authentication Binding
    - High Affinity vs Low Affinity
    - Revocation Checking
    - Deployment Considerations

41. **Windows Hello for Business**
    - WHfB Overview
    - Deployment Models
    - Key Trust vs Certificate Trust
    - Cloud Trust
    - Hybrid Deployment
    - Configuration Policies

42. **Authentication Methods Policy**
    - Policy Configuration
    - Method Targeting
    - Migration from Legacy Policies
    - Combined Registration
    - System-Preferred MFA

43. **Self-Service Password Reset (SSPR)**
    - SSPR Overview
    - SSPR Configuration
    - Authentication Methods for SSPR
    - Password Writeback
    - Registration Requirements
    - Notifications
    - Customization

44. **Authentication Flows**
    - Sign-In Flow
    - MFA Flow
    - SSPR Flow
    - Passwordless Flow
    - Federated Authentication Flow
    - Pass-Through Authentication Flow

---

### Part 7: Authorization & Access Control

45. **Role-Based Access Control (RBAC)**
    - RBAC Overview
    - Entra ID Roles vs Azure RBAC
    - Built-In Directory Roles
    - Custom Directory Roles
    - Role Scope
    - Role Assignment

46. **Built-In Directory Roles**
    - Global Administrator
    - Privileged Role Administrator
    - User Administrator
    - Application Administrator
    - Cloud Application Administrator
    - Authentication Administrator
    - Helpdesk Administrator
    - Security Roles
    - Compliance Roles
    - Complete Role Reference

47. **Custom Roles**
    - Custom Role Creation
    - Role Permissions
    - Permission Categories
    - Role Definition
    - Role Assignment
    - Custom Role Limitations

48. **Privileged Identity Management (PIM)**
    - PIM Overview
    - Eligible vs Active Assignments
    - Just-In-Time Access
    - Time-Bound Access
    - Activation Workflow
    - Approval Requirements
    - Notifications
    - Access Reviews Integration

49. **PIM for Entra Roles**
    - Configuring PIM for Directory Roles
    - Role Settings
    - Activation Settings
    - Assignment Settings
    - Notification Settings
    - Activating Roles
    - Audit History

50. **PIM for Groups**
    - PIM for Groups Overview
    - Role-Assignable Groups
    - Group Settings Configuration
    - Member Activation
    - Owner Activation
    - Use Cases

51. **PIM for Azure Resources**
    - Azure Resource Roles
    - Subscription & Resource Group Scope
    - Management Group Scope
    - Activation Workflow
    - Cross-Resource Access

52. **Access Reviews**
    - Access Reviews Overview
    - Review Types
      - Group Membership Reviews
      - Application Access Reviews
      - Role Assignment Reviews
      - Access Package Reviews
    - Review Configuration
    - Reviewer Selection
    - Review Decisions
    - Auto-Apply Results
    - Multi-Stage Reviews
    - Recurring Reviews

---

### Part 8: Conditional Access

53. **Conditional Access Overview**
    - What is Conditional Access?
    - Policy Components
    - Signal-Based Decisions
    - Zero Trust Enforcement
    - Common Scenarios

54. **Conditional Access Signals (Conditions)**
    - User & Group Assignment
    - Cloud Apps & Actions
    - Device Platforms
    - Locations
    - Client Applications
    - Device State
    - Filter for Devices
    - User Risk
    - Sign-In Risk
    - Authentication Context

55. **Conditional Access Controls**
    - Grant Controls
      - Block Access
      - Require MFA
      - Require Compliant Device
      - Require Hybrid Azure AD Joined Device
      - Require Approved Client App
      - Require App Protection Policy
      - Require Password Change
      - Require Authentication Strength
      - Require All/One of Selected Controls
    - Session Controls
      - App Enforced Restrictions
      - Conditional Access App Control
      - Sign-In Frequency
      - Persistent Browser Session
      - Customize Continuous Access Evaluation
      - Disable Resilience Defaults

56. **Named Locations**
    - IP-Based Locations
    - Country-Based Locations
    - Trusted Locations
    - MFA Trusted IPs
    - Compliant Network Locations
    - GPS-Based Locations

57. **Device Conditions**
    - Device Platform Conditions
    - Device State Conditions
    - Filter for Devices
    - Device Compliance Integration
    - Hybrid Join Requirements

58. **Authentication Strength**
    - Authentication Strength Overview
    - Built-In Strengths
    - Custom Authentication Strengths
    - Phishing-Resistant MFA
    - Passwordless Strength
    - Combining with Conditional Access

59. **Authentication Context**
    - Authentication Context Overview
    - Defining Contexts
    - Assigning to Applications
    - Step-Up Authentication
    - Sensitivity Labels Integration
    - SharePoint Sites Integration

60. **Conditional Access Policies Design**
    - Policy Design Principles
    - Common Policy Templates
    - Baseline Policies
    - Emergency Access Accounts
    - Policy Testing (What If)
    - Report-Only Mode
    - Policy Deployment Strategy

61. **Conditional Access for Workload Identities**
    - Workload Identity Overview
    - Service Principal Policies
    - Location-Based Controls
    - Risk-Based Controls
    - Monitoring & Alerts

62. **Continuous Access Evaluation (CAE)**
    - CAE Overview
    - Critical Event Evaluation
    - IP-Based Evaluation
    - CAE-Capable Applications
    - Token Lifetime Impact
    - Strict vs Non-Strict Enforcement

---

### Part 9: Identity Protection

63. **Identity Protection Overview**
    - Identity Protection Capabilities
    - Risk Detection
    - Risk Remediation
    - Risk-Based Conditional Access
    - Investigation Tools

64. **User Risk**
    - User Risk Concept
    - User Risk Detections
      - Leaked Credentials
      - Anomalous User Activity
      - Malware-Linked IP
      - Unfamiliar Sign-In Properties
      - Malicious IP Address
      - Suspicious Inbox Manipulation
      - Password Spray
      - Impossible Travel
    - User Risk Levels
    - User Risk Policies
    - Remediation Actions

65. **Sign-In Risk**
    - Sign-In Risk Concept
    - Sign-In Risk Detections
      - Anonymous IP Address
      - Atypical Travel
      - Malware-Linked IP
      - Unfamiliar Sign-In Properties
      - Admin Confirmed Compromise
      - Token Issuer Anomaly
      - Suspicious Browser
      - Suspicious Inbox Forwarding
    - Sign-In Risk Levels
    - Sign-In Risk Policies
    - Real-Time vs Offline Detection

66. **Risk Policies**
    - User Risk Policy Configuration
    - Sign-In Risk Policy Configuration
    - MFA Registration Policy
    - Policy Interaction with Conditional Access
    - Migration to Conditional Access

67. **Risk Investigation & Remediation**
    - Risky Users Report
    - Risky Sign-Ins Report
    - Risk Detections Report
    - Confirming Compromise
    - Dismissing Risk
    - User Remediation
    - Bulk Operations

68. **Identity Protection Alerts**
    - Weekly Digest
    - Users at Risk Alerts
    - Alert Configuration
    - Integration with SIEM

---

### Part 10: Hybrid Identity

69. **Hybrid Identity Overview**
    - What is Hybrid Identity?
    - Hybrid Identity Goals
    - Design Considerations
    - Hybrid Identity Components
    - Choosing a Sync Method
    - Choosing an Auth Method

70. **Microsoft Entra Connect Sync**
    - Entra Connect Overview
    - Installation Requirements
    - Express vs Custom Installation
    - Sync Engine Architecture
    - Sync Cycle
    - Full vs Delta Sync
    - Staging Mode

71. **Entra Connect Sync Configuration**
    - Source Anchor Selection
    - UPN & Domain Configuration
    - Filtering Options
      - Domain-Based Filtering
      - OU-Based Filtering
      - Attribute-Based Filtering
      - Group-Based Filtering
    - Optional Features
    - Password Hash Sync
    - Pass-Through Authentication
    - Federation Configuration

72. **Microsoft Entra Cloud Sync**
    - Cloud Sync Overview
    - Cloud Sync vs Connect Sync
    - Agent Architecture
    - Configuration in Portal
    - Scoping Filters
    - Attribute Mapping
    - Provisioning Logs
    - Use Cases

73. **Password Hash Synchronization**
    - PHS Overview
    - How PHS Works
    - Security Considerations
    - PHS Configuration
    - PHS as Backup
    - Leaked Credentials Detection

74. **Pass-Through Authentication**
    - PTA Overview
    - How PTA Works
    - PTA Agents
    - High Availability
    - Security Considerations
    - Limitations

75. **Federation with AD FS**
    - AD FS Overview
    - AD FS Architecture
    - Federation Configuration
    - Claims Rules
    - Certificate Management
    - High Availability
    - Migrating Away from AD FS

76. **Federation with Third-Party IdPs**
    - SAML/WS-Fed Federation
    - Direct Federation
    - Configuration Steps
    - Attribute Mapping
    - Use Cases

77. **Seamless Single Sign-On**
    - Seamless SSO Overview
    - How It Works
    - Prerequisites
    - Configuration
    - Browser Support
    - Troubleshooting

78. **Password Writeback**
    - Password Writeback Overview
    - Configuration
    - Requirements
    - Security Considerations
    - Troubleshooting

79. **Device Writeback**
    - Device Writeback Overview
    - Hybrid Azure AD Join
    - Configuration
    - Use Cases

80. **Group Writeback**
    - Group Writeback Overview
    - Microsoft 365 Group Writeback
    - Configuration
    - Limitations

---

### Part 11: Device Identity

81. **Device Identity Overview**
    - Device Identity Concepts
    - Device Registration Types
    - Device Trust Levels
    - Device Identity Benefits

82. **Azure AD Registered Devices**
    - Registration Overview
    - BYOD Scenarios
    - Registration Process
    - Supported Platforms
    - Capabilities & Limitations

83. **Azure AD Joined Devices**
    - Azure AD Join Overview
    - Cloud-Only Scenarios
    - Join Process
    - User Experience
    - Administrator Experience
    - SSO Behavior

84. **Hybrid Azure AD Joined Devices**
    - Hybrid Join Overview
    - Prerequisites
    - Configuration Methods
    - Managed Domains vs Federated
    - Troubleshooting Join Issues
    - Migration Scenarios

85. **Device Management Integration**
    - Microsoft Intune Integration
    - Device Compliance Policies
    - Conditional Access Integration
    - Co-Management Scenarios
    - MDM Auto-Enrollment

86. **Windows Hello for Business (Device Context)**
    - WHfB & Device Identity
    - Deployment Models
    - Key Registration
    - Certificate Enrollment
    - Cloud Trust Deployment

87. **Primary Refresh Token (PRT)**
    - PRT Overview
    - PRT Contents
    - PRT Acquisition
    - PRT Refresh
    - Cloud AP Plugin
    - MFA Claim in PRT
    - PRT Security

88. **Device Settings & Policies**
    - Device Settings Configuration
    - Join & Registration Permissions
    - Enterprise State Roaming
    - BitLocker Key Storage
    - Local Admin Password Solution (LAPS)

---

### Part 12: External Identities

89. **External Identities Overview**
    - External Identities Concepts
    - B2B Collaboration
    - B2B Direct Connect
    - External ID for Customers (CIAM)
    - Choosing the Right Model

90. **B2B Collaboration**
    - B2B Collaboration Overview
    - Invitation Process
    - Redemption Experience
    - Guest User Management
    - Cross-Tenant Access
    - B2B Licensing

91. **B2B Invitation & Redemption**
    - Invitation Methods
    - Bulk Invitations
    - Invitation API
    - Redemption Flow
    - Identity Providers for Guests
    - One-Time Passcode
    - Customizing Invitations

92. **Cross-Tenant Access Settings**
    - Inbound Access Settings
    - Outbound Access Settings
    - Trust Settings
    - B2B Collaboration Settings
    - B2B Direct Connect Settings
    - Tenant Restrictions v2

93. **B2B Direct Connect**
    - Direct Connect Overview
    - Teams Connect Shared Channels
    - Configuration
    - User Experience
    - Limitations

94. **External Identity Providers**
    - Microsoft Account
    - Google Federation
    - Facebook Federation
    - SAML/WS-Fed IdP Federation
    - Email One-Time Passcode
    - Default Identity Provider

95. **Self-Service Sign-Up**
    - User Flows Overview
    - Creating User Flows
    - Built-In Attributes
    - Custom Attributes
    - API Connectors
    - Page Customization
    - Language Customization

96. **Microsoft Entra External ID**
    - External ID Overview
    - Customer Identity (CIAM)
    - External Tenant Configuration
    - Branding & Customization
    - User Flows for Customers
    - Authentication Methods

---

### Part 13: Identity Governance

97. **Identity Governance Overview**
    - Governance Capabilities
    - Governance Scenarios
    - Licensing Requirements
    - Governance Framework

98. **Entitlement Management**
    - Entitlement Management Overview
    - Catalogs
    - Access Packages
    - Policies
    - Connected Organizations
    - Lifecycle Management

99. **Access Packages**
    - Access Package Components
    - Resource Roles
    - Request Policies
    - Assignment Policies
    - Approval Workflows
    - Expiration & Reviews
    - Separation of Duties

100. **Entitlement Management Catalogs**
     - Catalog Purpose
     - Catalog Creation
     - Catalog Owners
     - Adding Resources
     - Delegated Management
     - General vs Specific Catalogs

101. **Access Reviews (Governance Context)**
     - Access Reviews for Governance
     - Review Scheduling
     - Reviewer Types
     - Review Recommendations
     - Auto-Apply Settings
     - Reporting & Compliance

102. **Lifecycle Workflows**
     - Lifecycle Workflows Overview
     - Workflow Templates
     - Joiner Workflows
     - Mover Workflows
     - Leaver Workflows
     - Custom Tasks
     - Execution Conditions
     - Workflow History

103. **Terms of Use**
     - Terms of Use Overview
     - Creating Terms of Use
     - PDF Requirements
     - Conditional Access Integration
     - Expiration & Re-Consent
     - Audit & Reporting

104. **Identity Governance Dashboard**
     - Dashboard Overview
     - Key Metrics
     - Governance Insights
     - Recommendations

---

### Part 14: Provisioning

105. **Provisioning Overview**
     - Automated Provisioning Concepts
     - Provisioning Use Cases
     - Provisioning Architecture
     - Supported Applications

106. **HR-Driven Provisioning**
     - HR as Source of Truth
     - Workday Integration
     - SAP SuccessFactors Integration
     - API-Driven Provisioning
     - Attribute Mapping
     - Provisioning Rules

107. **Application Provisioning**
     - SCIM-Based Provisioning
     - Provisioning Configuration
     - Attribute Mapping
     - Scoping Filters
     - Provisioning Cycles
     - On-Demand Provisioning
     - Provisioning Logs

108. **Cross-Tenant Synchronization**
     - Cross-Tenant Sync Overview
     - Configuration Steps
     - Attribute Mapping
     - Scoping
     - Multi-Tenant Organizations
     - Use Cases

109. **On-Premises Provisioning**
     - Provisioning Agent
     - SQL Connector
     - LDAP Connector
     - SCIM On-Premises
     - PowerShell Connector
     - Web Services Connector

110. **Provisioning Troubleshooting**
     - Provisioning Logs Analysis
     - Quarantine Status
     - Common Errors
     - Attribute Mapping Issues
     - Scoping Issues
     - Connectivity Issues

---

### Part 15: Microsoft Graph API

111. **Microsoft Graph Overview**
     - What is Microsoft Graph?
     - Graph API vs Azure AD Graph (Deprecated)
     - API Endpoints
     - API Versions (v1.0 vs Beta)
     - Authentication Requirements

112. **Graph API for Identity**
     - User Operations
     - Group Operations
     - Application Operations
     - Service Principal Operations
     - Directory Role Operations
     - Policy Operations
     - Audit Log Operations

113. **Graph API Authentication**
     - Delegated Permissions
     - Application Permissions
     - Token Acquisition
     - Permission Consent
     - Least Privilege

114. **Graph SDKs**
     - SDK Overview
     - .NET SDK
     - JavaScript SDK
     - Python SDK
     - Java SDK
     - Go SDK
     - PowerShell SDK

115. **Graph Explorer**
     - Using Graph Explorer
     - Sample Queries
     - Permission Consent in Explorer
     - Testing & Debugging

116. **Common Graph Operations**
     - User CRUD Operations
     - Group Management
     - Application Management
     - Role Assignments
     - Conditional Access Policies
     - Batch Requests
     - Delta Queries
     - Change Notifications

117. **Graph API Best Practices**
     - Pagination Handling
     - Throttling & Retry
     - Batching Requests
     - Delta Queries for Sync
     - Error Handling
     - Performance Optimization

---

### Part 16: PowerShell & CLI

118. **Microsoft Graph PowerShell SDK**
     - Module Overview
     - Installation
     - Authentication
     - Common Commands
     - Permission Management
     - Scripting Patterns

119. **Azure CLI for Entra ID**
     - `az ad` Commands
     - User Management
     - Group Management
     - Application Management
     - Service Principal Management
     - Role Management

120. **Legacy PowerShell Modules**
     - AzureAD Module (Deprecated)
     - MSOnline Module (Deprecated)
     - Migration to Graph PowerShell
     - Compatibility Considerations

121. **Automation Scripts**
     - User Provisioning Scripts
     - Group Management Scripts
     - Reporting Scripts
     - Cleanup Scripts
     - Bulk Operations

---

### Part 17: Monitoring & Logging

122. **Sign-In Logs**
     - Sign-In Log Overview
     - Interactive Sign-Ins
     - Non-Interactive Sign-Ins
     - Service Principal Sign-Ins
     - Managed Identity Sign-Ins
     - Log Retention
     - Log Schema
     - Filtering & Analysis

123. **Audit Logs**
     - Audit Log Overview
     - Activity Categories
     - Log Schema
     - Retention
     - Filtering & Analysis
     - Common Audit Events

124. **Provisioning Logs**
     - Provisioning Log Overview
     - Log Schema
     - Success & Failure Analysis
     - Troubleshooting with Logs

125. **Identity Protection Reports**
     - Risky Users Report
     - Risky Sign-Ins Report
     - Risk Detections Report
     - Report Analysis
     - Export Options

126. **Workbooks & Dashboards**
     - Entra ID Workbooks
     - Sign-In Analysis Workbook
     - Conditional Access Insights
     - Provisioning Insights
     - Custom Workbooks
     - Dashboard Creation

127. **Log Analytics Integration**
     - Diagnostic Settings
     - Log Analytics Workspace
     - Data Retention
     - KQL Queries
     - Alert Rules
     - Cost Considerations

128. **SIEM Integration**
     - Azure Sentinel Integration
     - Splunk Integration
     - Third-Party SIEM Integration
     - Log Streaming
     - Event Hub Integration
     - Storage Account Export

129. **Alerting**
     - Entra ID Alerts
     - Azure Monitor Alerts
     - Conditional Access Alerts
     - Identity Protection Alerts
     - Custom Alert Rules

---

### Part 18: Security Operations

130. **Security Best Practices**
     - Secure Defaults
     - MFA Enforcement
     - Conditional Access Baseline
     - Admin Account Protection
     - Emergency Access Accounts
     - Least Privilege Principle

131. **Secure Score for Identity**
     - Identity Secure Score
     - Score Components
     - Improvement Actions
     - Score Tracking
     - Comparison & Benchmarks

132. **Emergency Access Accounts**
     - Break-Glass Account Purpose
     - Account Configuration
     - Exclusions from Policies
     - Monitoring & Alerts
     - Testing Procedures

133. **Privileged Access Strategy**
     - Privileged Access Workstations
     - Tiered Administration
     - Just-In-Time Access
     - Just-Enough-Access
     - Monitoring Privileged Activity

134. **Threat Investigation**
     - Investigation Tools
     - Sign-In Investigation
     - User Investigation
     - Compromised Account Response
     - Security Playbooks

135. **Incident Response**
     - Incident Detection
     - Containment Actions
     - Eradication Steps
     - Recovery Procedures
     - Post-Incident Review
     - Automation with Logic Apps

---

### Part 19: Microsoft Entra Suite

136. **Microsoft Entra Product Family**
     - Entra ID
     - Entra ID Governance
     - Entra External ID
     - Entra Permissions Management
     - Entra Verified ID
     - Entra Workload ID
     - Entra Internet Access
     - Entra Private Access

137. **Entra Permissions Management**
     - CIEM Overview
     - Multi-Cloud Support
     - Permission Analytics
     - Right-Sizing Permissions
     - Anomaly Detection
     - Remediation

138. **Entra Verified ID**
     - Verifiable Credentials Overview
     - Issuing Credentials
     - Verifying Credentials
     - Use Cases
     - Integration Scenarios

139. **Entra Workload Identities**
     - Workload Identity Overview
     - App Registrations
     - Managed Identities
     - Service Principals
     - Workload Identity Federation
     - Conditional Access for Workloads

140. **Entra Internet Access**
     - Secure Web Gateway
     - Traffic Forwarding
     - Web Filtering
     - Threat Protection
     - Integration with Conditional Access

141. **Entra Private Access**
     - Zero Trust Network Access
     - Application Segments
     - Traffic Forwarding
     - Replacing VPN
     - Quick Access Configuration

---

### Part 20: Integration Scenarios

142. **Microsoft 365 Integration**
     - M365 Identity Foundation
     - Exchange Online
     - SharePoint Online
     - Teams
     - OneDrive
     - License Assignment

143. **Azure Integration**
     - Azure RBAC
     - Azure Resource Access
     - Managed Identities
     - Key Vault Integration
     - Subscription Management

144. **SaaS Application Integration**
     - Gallery Applications
     - SAML Configuration
     - OIDC Configuration
     - Provisioning Setup
     - SSO Testing
     - Common Integrations
       - Salesforce
       - ServiceNow
       - Workday
       - SAP
       - Zoom
       - Slack
       - Atlassian

145. **On-Premises Application Integration**
     - Application Proxy
     - Header-Based Authentication
     - Kerberos Constrained Delegation
     - SAML for On-Premises Apps
     - Hybrid Access Patterns

146. **Application Proxy**
     - Application Proxy Overview
     - Connector Architecture
     - Connector Groups
     - Pre-Authentication
     - SSO Methods
     - Custom Domains
     - Wildcard Applications
     - High Availability

147. **Developer Integration**
     - MSAL Libraries
     - Authentication Patterns
     - Authorization Patterns
     - API Protection
     - Token Validation
     - Best Practices

---

### Part 21: Compliance & Data Residency

148. **Compliance Certifications**
     - ISO Certifications
     - SOC Reports
     - FedRAMP
     - GDPR
     - HIPAA
     - Industry-Specific Compliance

149. **Data Residency**
     - Data Storage Locations
     - Regional Data Residency
     - Multi-Geo Considerations
     - EU Data Boundary
     - Sovereign Clouds

150. **Privacy & Data Protection**
     - Data Collection
     - Data Processing
     - Data Retention
     - Data Subject Requests
     - Privacy Controls

151. **Sovereign Clouds**
     - Azure Government
     - Azure China (21Vianet)
     - Feature Parity
     - Configuration Differences

---

### Part 22: Troubleshooting

152. **Authentication Troubleshooting**
     - Sign-In Error Codes
     - Common Authentication Failures
     - MFA Issues
     - Conditional Access Blocks
     - Federation Issues
     - Token Issues

153. **Hybrid Identity Troubleshooting**
     - Sync Errors
     - Password Sync Issues
     - PTA Issues
     - Seamless SSO Issues
     - Object Not Syncing
     - Attribute Mismatch

154. **Application Troubleshooting**
     - SSO Configuration Issues
     - SAML Debugging
     - Token Claims Issues
     - Consent Issues
     - Provisioning Failures

155. **Conditional Access Troubleshooting**
     - What If Tool
     - Sign-In Log Analysis
     - Policy Conflicts
     - Unexpected Blocks
     - Grant Control Issues

156. **Device Troubleshooting**
     - Join Failures
     - Registration Issues
     - PRT Issues
     - SSO Problems
     - Compliance Issues

157. **Diagnostic Tools**
     - Sign-In Diagnostic
     - AAD Connect Health
     - What If Tool
     - Graph Explorer
     - Browser Developer Tools
     - Fiddler/Charles Proxy

---

### Part 23: Migration & Modernization

158. **AD FS to Cloud Authentication**
     - Migration Planning
     - Staged Migration
     - Cutover Migration
     - Application Migration
     - Testing Strategy
     - Rollback Planning

159. **Azure AD Graph to Microsoft Graph**
     - Deprecation Timeline
     - API Mapping
     - Permission Changes
     - Code Migration
     - Testing

160. **Legacy Protocol Modernization**
     - Legacy Authentication Identification
     - Blocking Legacy Auth
     - Modern Auth Adoption
     - Application Updates

161. **Tenant Consolidation**
     - Consolidation Planning
     - User Migration
     - Application Migration
     - Data Migration
     - Cutover Strategy

162. **B2C to External ID Migration**
     - Feature Comparison
     - Migration Planning
     - Configuration Migration
     - User Migration
     - Application Updates

---

### Part 24: Best Practices & Architecture

163. **Tenant Architecture**
     - Single vs Multi-Tenant
     - Tenant Design Considerations
     - Administrative Boundaries
     - Collaboration Patterns

164. **Identity Architecture Patterns**
     - Cloud-Only Architecture
     - Hybrid Architecture
     - Multi-Forest Patterns
     - Acquisition Scenarios

165. **Security Architecture**
     - Zero Trust Architecture
     - Identity as Perimeter
     - Layered Security
     - Defense in Depth

166. **Operational Excellence**
     - Change Management
     - Deployment Practices
     - Monitoring Strategy
     - Incident Management
     - Capacity Planning

167. **Cost Optimization**
     - License Optimization
     - Feature Utilization
     - Right-Sizing
     - Cost Monitoring

---

### Appendices

- **A.** Error Code Reference
- **B.** Sign-In Log Schema Reference
- **C.** Audit Log Category Reference
- **D.** Directory Role Reference
- **E.** Graph API Permission Reference
- **F.** PowerShell Command Reference
- **G.** SAML Claim Reference
- **H.** OIDC Claim Reference
- **I.** Conditional Access Conditions Reference
- **J.** Authentication Method Reference
- **K.** Service Limits & Quotas
- **L.** Feature Comparison by License
- **M.** Glossary of Terms
- **N.** Troubleshooting Flowcharts
- **O.** Security Checklist
- **P.** Migration Checklist
- **Q.** Recommended Learning Paths
- **R.** Official Documentation Links

---
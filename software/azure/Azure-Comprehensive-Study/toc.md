# Azure: Comprehensive Study Table of Contents

## Part I: Azure Fundamentals & Core Principles

### A. Introduction to Cloud Computing & Azure
*   What is Cloud Computing?
    *   Benefits of Cloud Computing (High Availability, Scalability, Elasticity, etc.).
    *   Consumption-based model.
*   Cloud Service Models: IaaS, PaaS, SaaS.
*   Cloud Deployment Models: Public, Private, Hybrid.
*   Introduction to Microsoft Azure
    *   Overview of Azure's global infrastructure: Regions, Availability Zones, and Datacenters.
    *   Tour of the Azure Portal, Azure CLI, and PowerShell.

### B. Foundational Azure Concepts
*   The Shared Responsibility Model in the cloud.
*   Azure Architectural Components:
    *   Resources and Resource Groups.
    *   Subscriptions and Management Groups.
*   Azure Governance and Compliance:
    *   Azure Policy for enforcing organizational standards.
    *   Role-Based Access Control (RBAC)
    *   Resource Locks to prevent accidental deletion.
*   Understanding Azure Pricing and Support:
    *   Factors affecting costs in Azure.
    *   Pricing Calculator and Total Cost of Ownership (TCO) Calculator
    *   Azure Cost Management and Billing tools

## Part II: Identity, Access, and Governance

### A. Microsoft Entra ID (Formerly Azure Active Directory)
*   Core Concepts: Identities, Accounts, and Tenants
*   Users and Groups management
*   Authentication Methods: Password Hash Sync, Pass-through Authentication, Federation
*   Multi-Factor Authentication (MFA) for enhanced security
*   Conditional Access policies
*   Role-Based Access Control (RBAC) in detail

### B. Azure Governance
*   Azure Policy and Initiatives for compliance
*   Azure Blueprints for standardized environment creation
*   Resource Tagging for cost management and organization.
*   Microsoft Purview for unified data governance.

## Part III: Core Compute Services

### A. Azure Virtual Machines (VMs)
*   VM Planning: Sizing, Pricing, and Operating Systems
*   Creating and managing Windows and Linux VMs in Azure.
*   VM Storage: Managed Disks and Storage Tiers
*   VM Networking and Security
*   High Availability: Availability Sets and Availability Zones
*   Virtual Machine Scale Sets for automatic scaling.

### B. Azure App Service
*   Web Apps for hosting web applications and APIs.
*   Deployment Slots for staging and production environments
*   Scaling App Service Plans (Scale up vs. Scale out)
*   App Service Security and Networking features

### C. Azure Container Apps & Azure Kubernetes Service (AKS)
*   Introduction to Containers and Orchestration
*   Azure Container Instances (ACI) for simple container workloads
*   Azure Kubernetes Service (AKS) for managing containerized applications
    *   AKS Cluster Architecture
    *   Deploying and scaling applications in AKS

### D. Serverless Computing
*   Azure Functions for event-driven serverless code.
    *   Triggers and Bindings
    *   Durable Functions for stateful workflows
*   Azure Logic Apps for building automated workflows

## Part IV: Storage Solutions

### A. Azure Storage Accounts
*   Core Storage Services:
    *   Blob Storage for unstructured object data.
    *   File Storage for cloud-based file shares
    *   Table Storage for NoSQL key-value data.
    *   Queue Storage for messaging between application components
*   Storage Tiers (Hot, Cool, Archive)
*   Storage account redundancy options (LRS, GRS, ZRS)
*   Securing Storage Accounts: Access keys, Shared Access Signatures (SAS), and network security.

## Part V: Databases

### A. Relational Databases
*   Azure SQL Database: a managed relational database service.
*   Azure Database for MySQL, PostgreSQL, and MariaDB
*   Elastic Pools for managing multiple databases

### B. NoSQL and Other Database Services
*   Azure Cosmos DB: a globally distributed, multi-model database.
*   Azure Cache for Redis for high-performance caching

## Part VI: Networking and Content Delivery

### A. Azure Virtual Networks (VNets)
*   VNet fundamentals: Address spaces, subnets, and routing
*   Network Security Groups (NSGs) for filtering network traffic.
*   Azure Firewall for centralized network protection
*   Connecting VNets: VNet Peering and VPN Gateways.
*   Hybrid Connectivity: Connecting on-premises networks to Azure

### B. Azure Load Balancing
*   Azure Load Balancer for distributing traffic within a VNet.
*   Azure Application Gateway for application-level load balancing.
*   Azure Front Door for global traffic management

### C. Content Delivery
*   Azure Content Delivery Network (CDN) for caching content closer to users.

## Part VII: Monitoring and Management

### A. Azure Monitor
*   Collecting and analyzing telemetry data from Azure resources.
*   Log Analytics for querying log data.
*   Alerts and Action Groups for proactive notifications.
*   Application Insights for application performance monitoring.

### B. Management and Automation
*   Azure Resource Manager (ARM) templates for Infrastructure as Code.
*   Azure Automation for process automation
*   Azure Advisor for personalized recommendations and best practices.

## Part VIII: Security and Compliance

### A. Security Posture Management
*   Microsoft Defender for Cloud for unified security management.
*   Azure Key Vault for secure storage of secrets and keys

### B. Identity and Access Security
*   Advanced Microsoft Entra ID features
*   Azure Bastion for secure RDP/SSH access to VMs.

### C. Network Security
*   Advanced Network Security Groups and Application Security Groups.
*   Distributed Denial of Service (DDoS) Protection

---
**Appendices**
*   Glossary of Common Azure Terms
*   Azure CLI and PowerShell Quick Reference
*   Practical Project Scenarios for Applying Azure Knowledge
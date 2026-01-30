#!/bin/bash

# Define the root directory name
ROOT_DIR="Azure-Comprehensive-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure for: $ROOT_DIR"

# ==========================================
# PART I: Azure Fundamentals & Core Principles
# ==========================================
PART_DIR="001-Azure-Fundamentals-Core-Principles"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Introduction-to-Cloud-Computing-Azure.md"
# Introduction to Cloud Computing & Azure

* What is Cloud Computing?
    * Benefits of Cloud Computing (High Availability, Scalability, Elasticity, etc.).
    * Consumption-based model.
* Cloud Service Models: IaaS, PaaS, SaaS.
* Cloud Deployment Models: Public, Private, Hybrid.
* Introduction to Microsoft Azure
    * Overview of Azure's global infrastructure: Regions, Availability Zones, and Datacenters.
    * Tour of the Azure Portal, Azure CLI, and PowerShell.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Foundational-Azure-Concepts.md"
# Foundational Azure Concepts

* The Shared Responsibility Model in the cloud.
* Azure Architectural Components:
    * Resources and Resource Groups.
    * Subscriptions and Management Groups.
* Azure Governance and Compliance:
    * Azure Policy for enforcing organizational standards.
    * Role-Based Access Control (RBAC)
    * Resource Locks to prevent accidental deletion.
* Understanding Azure Pricing and Support:
    * Factors affecting costs in Azure.
    * Pricing Calculator and Total Cost of Ownership (TCO) Calculator
    * Azure Cost Management and Billing tools
EOF


# ==========================================
# PART II: Identity, Access, and Governance
# ==========================================
PART_DIR="002-Identity-Access-Governance"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Microsoft-Entra-ID.md"
# Microsoft Entra ID (Formerly Azure Active Directory)

* Core Concepts: Identities, Accounts, and Tenants
* Users and Groups management
* Authentication Methods: Password Hash Sync, Pass-through Authentication, Federation
* Multi-Factor Authentication (MFA) for enhanced security
* Conditional Access policies
* Role-Based Access Control (RBAC) in detail
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Azure-Governance.md"
# Azure Governance

* Azure Policy and Initiatives for compliance
* Azure Blueprints for standardized environment creation
* Resource Tagging for cost management and organization.
* Microsoft Purview for unified data governance.
EOF


# ==========================================
# PART III: Core Compute Services
# ==========================================
PART_DIR="003-Core-Compute-Services"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Azure-Virtual-Machines.md"
# Azure Virtual Machines (VMs)

* VM Planning: Sizing, Pricing, and Operating Systems
* Creating and managing Windows and Linux VMs in Azure.
* VM Storage: Managed Disks and Storage Tiers
* VM Networking and Security
* High Availability: Availability Sets and Availability Zones
* Virtual Machine Scale Sets for automatic scaling.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Azure-App-Service.md"
# Azure App Service

* Web Apps for hosting web applications and APIs.
* Deployment Slots for staging and production environments
* Scaling App Service Plans (Scale up vs. Scale out)
* App Service Security and Networking features
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Azure-Container-Apps-AKS.md"
# Azure Container Apps & Azure Kubernetes Service (AKS)

* Introduction to Containers and Orchestration
* Azure Container Instances (ACI) for simple container workloads
* Azure Kubernetes Service (AKS) for managing containerized applications
    * AKS Cluster Architecture
    * Deploying and scaling applications in AKS
EOF

# Section D
cat << 'EOF' > "$PART_DIR/004-Serverless-Computing.md"
# Serverless Computing

* Azure Functions for event-driven serverless code.
    * Triggers and Bindings
    * Durable Functions for stateful workflows
* Azure Logic Apps for building automated workflows
EOF


# ==========================================
# PART IV: Storage Solutions
# ==========================================
PART_DIR="004-Storage-Solutions"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Azure-Storage-Accounts.md"
# Azure Storage Accounts

* Core Storage Services:
    * Blob Storage for unstructured object data.
    * File Storage for cloud-based file shares
    * Table Storage for NoSQL key-value data.
    * Queue Storage for messaging between application components
* Storage Tiers (Hot, Cool, Archive)
* Storage account redundancy options (LRS, GRS, ZRS)
* Securing Storage Accounts: Access keys, Shared Access Signatures (SAS), and network security.
EOF


# ==========================================
# PART V: Databases
# ==========================================
PART_DIR="005-Databases"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Relational-Databases.md"
# Relational Databases

* Azure SQL Database: a managed relational database service.
* Azure Database for MySQL, PostgreSQL, and MariaDB
* Elastic Pools for managing multiple databases
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-NoSQL-and-Other-Database-Services.md"
# NoSQL and Other Database Services

* Azure Cosmos DB: a globally distributed, multi-model database.
* Azure Cache for Redis for high-performance caching
EOF


# ==========================================
# PART VI: Networking and Content Delivery
# ==========================================
PART_DIR="006-Networking-Content-Delivery"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Azure-Virtual-Networks.md"
# Azure Virtual Networks (VNets)

* VNet fundamentals: Address spaces, subnets, and routing
* Network Security Groups (NSGs) for filtering network traffic.
* Azure Firewall for centralized network protection
* Connecting VNets: VNet Peering and VPN Gateways.
* Hybrid Connectivity: Connecting on-premises networks to Azure
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Azure-Load-Balancing.md"
# Azure Load Balancing

* Azure Load Balancer for distributing traffic within a VNet.
* Azure Application Gateway for application-level load balancing.
* Azure Front Door for global traffic management
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Content-Delivery.md"
# Content Delivery

* Azure Content Delivery Network (CDN) for caching content closer to users.
EOF


# ==========================================
# PART VII: Monitoring and Management
# ==========================================
PART_DIR="007-Monitoring-Management"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Azure-Monitor.md"
# Azure Monitor

* Collecting and analyzing telemetry data from Azure resources.
* Log Analytics for querying log data.
* Alerts and Action Groups for proactive notifications.
* Application Insights for application performance monitoring.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Management-and-Automation.md"
# Management and Automation

* Azure Resource Manager (ARM) templates for Infrastructure as Code.
* Azure Automation for process automation
* Azure Advisor for personalized recommendations and best practices.
EOF


# ==========================================
# PART VIII: Security and Compliance
# ==========================================
PART_DIR="008-Security-Compliance"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Security-Posture-Management.md"
# Security Posture Management

* Microsoft Defender for Cloud for unified security management.
* Azure Key Vault for secure storage of secrets and keys
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Identity-and-Access-Security.md"
# Identity and Access Security

* Advanced Microsoft Entra ID features
* Azure Bastion for secure RDP/SSH access to VMs.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Network-Security.md"
# Network Security

* Advanced Network Security Groups and Application Security Groups.
* Distributed Denial of Service (DDoS) Protection
EOF


# ==========================================
# Appendices
# ==========================================
PART_DIR="009-Appendices"
mkdir -p "$PART_DIR"

cat << 'EOF' > "$PART_DIR/001-Glossary.md"
# Glossary of Common Azure Terms

* (Add definitions here)
EOF

cat << 'EOF' > "$PART_DIR/002-CLI-PowerShell-Reference.md"
# Azure CLI and PowerShell Quick Reference

* (Add cheat sheet here)
EOF

cat << 'EOF' > "$PART_DIR/003-Practical-Project-Scenarios.md"
# Practical Project Scenarios

* (Add project ideas here)
EOF


echo "Success! Directory structure created at ./$ROOT_DIR"

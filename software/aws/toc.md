# AWS: Comprehensive Study Table of Contents

## Part I: AWS Fundamentals & Core Principles

### A. Introduction to Cloud Computing & AWS
*   What is Cloud Computing?
    *   On-Premise vs. Cloud
    *   The Six Advantages of Cloud Computing
*   Cloud Service Models: IaaS, PaaS, SaaS
*   Cloud Deployment Models: Public, Private, Hybrid
*   Introduction to Amazon Web Services (AWS)
*   Overview of the AWS Global Infrastructure (Regions, Availability Zones, Edge Locations)
*   Navigating the AWS Management Console, CLI, and SDKs

### B. Foundational AWS Concepts
*   The AWS Shared Responsibility Model
*   The AWS Well-Architected Framework
    *   Operational Excellence Pillar
    *   Security Pillar
    *   Reliability Pillar
    *   Performance Efficiency Pillar
    *   Cost Optimization Pillar
*   Understanding AWS Pricing and Billing
    *   Core Pricing Principles (Pay-as-you-go, Save when you commit, Pay less as you use more)
    *   AWS Free Tier
    *   AWS Budgets and Cost Explorer

## Part II: Identity, Access, and Network Foundation

### A. AWS Identity and Access Management (IAM)
*   Core IAM Concepts: Principals, Policies, and Resources
*   IAM Users and User Groups.
*   IAM Policies:
    *   JSON Policy Documents
    *   Identity-based vs. Resource-based Policies.
    *   AWS Managed vs. Customer Managed vs. Inline Policies
    *   The Principle of Least Privilege.
*   IAM Roles for AWS Services and Cross-Account Access.
*   Securing AWS Access:
    *   Multi-Factor Authentication (MFA).
    *   Access Keys and Programmatic Access.
    *   IAM Best Practices.

### B. Virtual Private Cloud (VPC) - Your Private Network in the Cloud
*   Introduction to VPCs and IP Addressing (CIDR notation)
*   Core VPC Components:
    *   Subnets: Public vs. Private
    *   Route Tables and Routing
    *   Internet Gateways (IGW)
    *   NAT Gateways for Private Subnet Outbound Access
*   Network Security:
    *   Security Groups (Stateful Firewalls)
    *   Network Access Control Lists (NACLs) (Stateless Firewalls)
*   VPC Peering and VPC Endpoints

## Part III: Core Compute Services

### A. Amazon Elastic Compute Cloud (EC2) - Virtual Servers
*   EC2 Fundamentals:
    *   Amazon Machine Images (AMIs).
    *   Instance Types (General Purpose, Compute Optimized, Memory Optimized, etc.).
    *   EC2 Pricing Models (On-Demand, Reserved Instances, Spot Instances, Savings Plans)
*   Launching and Connecting to EC2 Instances:
    *   Key Pairs for Secure SSH/RDP Access.
    *   User Data for Bootstrapping.
*   EC2 Storage:
    *   Elastic Block Store (EBS) Volumes and Snapshots
    *   Instance Store
*   Networking:
    *   Elastic IP Addresses.
    *   Placement Groups
*   Scalability and High Availability:
    *   Elastic Load Balancing (ELB)
    *   Auto Scaling Groups

## Part IV: Storage and Content Delivery

### A. Amazon Simple Storage Service (S3) - Object Storage
*   S3 Core Concepts: Buckets and Objects.
*   S3 Storage Classes for Different Use Cases (Standard, Intelligent-Tiering, Glacier).
*   Managing S3 Buckets and Objects:
    *   Versioning and Lifecycle Policies.
    *   S3 Replication
*   S3 Security and Access Control:
    *   Bucket Policies and Access Control Lists (ACLs)
    *   Server-Side Encryption.
    *   Presigned URLs
*   Static Website Hosting with S3.

### B. Amazon CloudFront - Content Delivery Network (CDN)
*   How CloudFront Improves Performance with Edge Locations.
*   Distributions: Web vs. RTMP
*   Origins and Behaviors (Caching Rules)
*   Securing Content with HTTPS and Signed URLs/Cookies
*   CloudFront with S3 for Accelerated Content Delivery

## Part V: Databases and Data Stores

### A. Amazon Relational Database Service (RDS) - Managed SQL Databases
*   Introduction to Managed Database Services
*   Supported Database Engines (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server)
*   RDS Key Features:
    *   Multi-AZ Deployments for High Availability
    *   Read Replicas for Scalability
    *   Automated Backups and Snapshots
*   Security and Networking for RDS

### B. Amazon DynamoDB - Managed NoSQL Database
*   Core Concepts: Tables, Items, and Attributes
*   Primary Keys: Partition Key and Sort Key
*   Data Modeling in DynamoDB
*   Read/Write Capacity Modes: Provisioned vs. On-Demand
*   Secondary Indexes: Global and Local
*   DynamoDB Streams for Change Data Capture

### C. Amazon ElastiCache - In-Memory Caching
*   Introduction to Caching and its Benefits
*   ElastiCache Engines: Redis vs. Memcached.
*   Common Caching Strategies (Lazy Loading, Write-Through)
*   Use Cases for ElastiCache (Database Caching, Session Storage)

## Part VI: Application Integration and Monitoring

### A. Amazon Simple Email Service (SES)
*   Sending Emails with SES
*   Identity Management: Verifying Domains and Email Addresses
*   Handling Bounces and Complaints
*   Sender Reputation Management

### B. Amazon Route 53 - Scalable DNS
*   Hosted Zones and DNS Record Types
*   Routing Policies (Simple, Weighted, Latency, Failover, Geolocation).
*   Health Checks and DNS Failover.
*   Domain Registration with Route 53.

### C. Amazon CloudWatch - Monitoring and Observability
*   CloudWatch Metrics: Monitoring AWS Resource Performance.
*   CloudWatch Alarms for Automated Notifications and Actions.
*   CloudWatch Logs: Centralized Log Management.
*   CloudWatch Events for Responding to State Changes in AWS Resources.
*   Custom Dashboards for Visualizing Metrics.

## Part VII: Containers and Serverless Computing

### A. Container Services on AWS
*   Introduction to Containers (Docker)
*   Amazon Elastic Container Registry (ECR) for Storing Container Images
*   Amazon Elastic Container Service (ECS):
    *   ECS Core Components: Clusters, Task Definitions, Tasks, and Services.
    *   Launch Types: EC2 vs. AWS Fargate.
*   Amazon Elastic Kubernetes Service (EKS):
    *   Managed Kubernetes Control Plane.
    *   Worker Nodes and Node Groups
    *   Integrating EKS with other AWS services

### B. AWS Lambda - Serverless Functions
*   Introduction to Serverless Computing.
*   Lambda Functions: Triggers, Code, and Configuration
*   Supported Runtimes and Programming Models.
*   Integrating Lambda with other AWS Services (API Gateway, S3, DynamoDB).
*   Lambda Execution Roles and Permissions
*   Understanding Lambda Concurrency and Scaling.
*   Lambda Layers for Code Sharing

---
**Appendices**
*   Glossary of Common AWS Terms
*   AWS CLI and SDK Configuration Guide
*   Practical Project Ideas for Applying AWS Knowledge
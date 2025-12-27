Based on the Table of Contents provided, here is a detailed breakdown of **Part III, Section C: Cloud Integrations**.

This section focuses on how Dynatrace moves beyond standard server monitoring (installing an agent on a specific Linux/Windows box) and integrates directly with the Cloud Platforms themselves (AWS, Azure, GCP).

---

### **The Core Concept: OneAgent vs. Cloud Integration**
Before diving into the details, it is crucial to understand *why* this section exists.
*   **OneAgent** is great for Virtual Machines (EC2, Azure VMs, GCE) where you have root access to install software.
*   **Cloud Integration** is necessary for **PaaS** (Platform as a Service) and **FaaS** (Function as a Service) where you **cannot install an agent**.

*Example:* You cannot install software on an AWS Load Balancer or an Azure SQL Database. To monitor these, Dynatrace must talk to the Cloud Provider's API to fetch the data.

---

### **1. AWS, Azure, GCP Monitoring**
This covers the setup and architecture of connecting Dynatrace to the "Big Three" cloud providers.

*   **How it works (API Polling):**
    Dynatrace does not magically see your cloud account. You must authorize it.
    *   **AWS:** You create an IAM Role that gives Dynatrace permission to read CloudWatch metrics.
    *   **Azure:** You create a Service Principal in Azure Active Directory (Entra ID) to read Azure Monitor data.
    *   **GCP:** You create a Service Account with permissions to access the Google Operations Suite (formerly Stackdriver).
*   **The Role of ActiveGate:**
    *   Dynatrace often uses a component called an **ActiveGate** to act as a proxy. The ActiveGate queries the AWS/Azure/GCP APIs, gathers the metrics, and pushes them to the Dynatrace server.
*   **Metadata Integration:**
    *   It’s not just about metrics (CPU/RAM); it’s about context. Dynatrace pulls in **tags**, **regions**, and **zones**.
    *   *Benefit:* You can create a Dynatrace Management Zone based on AWS Tags (e.g., `Project: Checkout`).

### **2. Cloud Services (PaaS & Serverless)**
Once the integration is set up, Dynatrace starts ingesting data from services where you cannot install the OneAgent.

*   **Database as a Service (DBaaS):**
    *   **AWS RDS, DynamoDB, Aurora:** Dynatrace pulls metrics like `ReadIOPS`, `WriteLatency`, and `BurstBalance` from CloudWatch.
    *   **Azure SQL, CosmosDB:** Pulls DTUs (Database Transaction Units) and storage metrics.
*   **Storage & Networking:**
    *   **S3 / Blob Storage:** Monitoring bucket size, number of objects, and request costs.
    *   **Load Balancers:** AWS ALB/ELB or Azure Load Balancers. This is critical for seeing traffic *before* it hits your servers.
*   **Serverless (Lambda / Azure Functions):**
    *   **Basic Monitoring:** Without touching code, Dynatrace pulls invocation counts, error rates, and duration from the cloud API.
    *   **Advanced Tracing:** To see *inside* the function code (PurePath), you add a Dynatrace library/layer to the function code. This section covers how to blend API metrics with code-level tracing in a serverless environment.

### **3. Hybrid & Multi-Cloud Observability**
Most large enterprises are **Hybrid** (On-premise data centers + Cloud) or **Multi-Cloud** (AWS + Azure).

*   **Unified Topology (Smartscape):**
    *   Dynatrace creates a visual map connecting your On-Premise legacy Mainframe or Database to your new AWS Microservices.
    *   *Example:* Smartscape will show that a `Tomcat` service on a physical server in your basement is calling an `API Gateway` in AWS.
*   **Data Normalization:**
    *   Cloud providers call things by different names. AWS calls it "EC2," Azure calls it "VM," GCP calls it "Compute Engine."
    *   Dynatrace normalizes this data so you can query "Host CPU" across all three clouds in one chart without writing complex queries for each provider.
*   **Cloud Migration Monitoring:**
    *   This is a major use case. You monitor the application On-Prem (baseline), migrate it to AWS/Azure, and compare the performance. This section covers how to validate that the cloud version performs as well as, or better than, the on-prem version.

---

### **Summary: What you will learn in this section**
By the end of this module, you should be able to answer:
1.  How do I monitor an AWS RDS database if I can't install an agent on it?
2.  How do I troubleshoot why my Azure Function is timing out?
3.  How do I see a single dashboard that shows the health of my infrastructure across AWS, Azure, and my local data center simultaneously?

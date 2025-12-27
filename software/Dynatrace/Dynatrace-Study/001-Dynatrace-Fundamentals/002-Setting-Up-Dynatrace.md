Here is a detailed breakdown of **Part I: Section B - Setting Up Dynatrace**.

This phase is critical because it establishes the foundation of your observability. If you set this up incorrectly, your data might be disorganized, your security might be compromised, or you might overspend on licensing.

---

# 002 - Setting Up Dynatrace (Detailed Explanation)

This section covers the "infrastructure" of the tool itself—how you deploy it, how you organize it, and how you pay for it.

## 1. SaaS vs. Managed Deployment Models
Before you install anything, you must understand where your data is going. Dynatrace offers two main ways to host the **Dynatrace Cluster** (the server that processes and stores data).

*   **Dynatrace SaaS (Software as a Service):**
    *   **How it works:** Dynatrace hosts the cluster in the cloud (AWS, Azure, or GCP). You just log in via a browser.
    *   **Pros:** No maintenance, instant updates, lower overhead.
    *   **Cons:** Data leaves your network (though it is encrypted).
    *   **Best for:** Most companies who want a "hands-off" maintenance experience.
*   **Dynatrace Managed:**
    *   **How it works:** You install the Dynatrace Cluster on your *own* on-premise servers or your own cloud VPC. However, Dynatrace "manages" it remotely (pushes updates to it).
    *   **Pros:** Data never leaves your infrastructure (Data Residency).
    *   **Cons:** You have to manage the hardware, OS, and backups for the cluster.
    *   **Best for:** Banks, Government, and Healthcare with strict regulatory compliance (GDPR, HIPAA) requiring data to stay on-prem.

## 2. Installing OneAgent
The **OneAgent** is the software you install on your servers to collect data. It is unique because it uses a single binary to monitor the Host, Process, and Code level simultaneously.

*   **Full-Stack Mode:**
    *   The standard installation. It injects itself into the Operating System and automatically detects running processes (Java, Node, .NET, Go, etc.) to capture code-level traces.
*   **Infrastructure-Only Mode:**
    *   A lighter version that only looks at CPU, RAM, Disk, and Network. It does *not* look inside the code. Used for licensing savings on non-critical servers.
*   **Installation Targets:**
    *   **Linux/Windows:** A simple shell script or MSI installer runs on the host OS.
    *   **Kubernetes (K8s):** You install the **OneAgent Operator**. It deploys a `DaemonSet`, ensuring that every time a new Node is added to your K8s cluster, Dynatrace automatically installs itself on it.
    *   **Cloud (PaaS/FaaS):** For things like AWS Fargate or Azure App Service where you don't own the "host," you install OneAgent via application libraries or container sidecars.

## 3. Environment Configuration
Once Dynatrace is running, you need to configure the global settings for your specific tenant (Environment).

*   **Privacy & GDPR:** You can configure Dynatrace to mask IP addresses (e.g., turn `192.168.1.50` into `192.168.1.0`) and mask user input (e.g., hide credit card numbers in logs) to ensure you don't accidentally capture sensitive data (PII).
*   **Integration configuration:** Setting up connections to Slack, PagerDuty, Jira, or ServiceNow so that when Dynatrace detects a problem, it knows where to send the alert.

## 4. Account Structure: Environments, Management Zones, Tags
This is the **most important concept for organization**. Without this, your dashboard will be a mess of thousands of unconnected services.

*   **Environments (Tenants):**
    *   These are hard separations. Data in Environment A cannot see Data in Environment B.
    *   *Example:* You might have one Environment for `Production` and a totally different one for `Staging/Dev`.
*   **Management Zones (Logical Views):**
    *   These act as "filters" or "permissions." They slice the data based on ownership.
    *   *Example:* You have 100 servers. You create a Management Zone called `Payment Team`. When a developer from that team logs in, they *only* see the 10 servers related to Payments, filtering out the noise from the `Inventory Team`.
*   **Tags:**
    *   Labels applied to hosts and services.
    *   **Manual Tags:** You type them in (hard to maintain).
    *   **Automated Tags:** You write rules (e.g., "If the Kubernetes Namespace is `prod-cart`, apply the tag `App:Shopping-Cart`").
    *   *Why it matters:* You use Tags to create Management Zones.

## 5. Licensing and Consumption Model (DDUs)
Dynatrace does not charge a flat fee; it charges based on what you consume. You need to understand this to avoid budget overruns.

*   **Host Units:**
    *   Charged based on the size (RAM) of the servers you monitor. A 16GB RAM server = 1 Host Unit. This covers standard infrastructure and APM monitoring.
*   **Davis Data Units (DDUs):**
    *   A "credit" currency used for advanced features.
    *   You pay DDUs for: **Custom Metrics** (ingesting data from Prometheus), **Log Monitoring** (ingesting GBs of logs), and **Serverless** functions.
*   **DEM Units (Digital Experience Monitoring):**
    *   Charged for Real User Monitoring (RUM). You pay per "User Session" or per "Synthetic Test run."

---

### Summary of Workflow for this Section:
1.  **Decide:** SaaS or Managed?
2.  **Install:** specific scripts for Linux, Windows, or Kubernetes.
3.  **Organize:** Create Rules to auto-tag your servers (e.g., `owner:backend`).
4.  **Slice:** Create Management Zones so teams only see their own data.
5.  **Monitor Costs:** Check your DDU and Host Unit consumption.

Based on the Table of Contents you provided, the section **"009-Appendices/003-Practical-Project-Scenarios.md"** represents the **"Lab" or "Capstone"** portion of the curriculum.

While Parts I through VIII teach you the *theory* and *individual components* of Azure, this specific appendix is designed to give you **holistic, real-world problems to solve**. It bridges the gap between knowing what a Virtual Machine is and actually building a functional, secure application architecture.

Here is a detailed explanation of what this file contains, broken down by difficulty levels that correspond to the knowledge gained in the previous sections.

---

### Phase 1: Beginner Scenarios (Fundamentals & Compute)
*Targeting Parts I, II, and III (A)*

These projects verify that you can navigate the portal, create basic resources, and manage costs.

#### **Scenario 1: The "Lift and Shift" Web Server**
*   **The Goal:** Simulate moving an on-premises server to the cloud.
*   **The Task:**
    1.  Create a Virtual Network (VNet) with proper subnets.
    2.  Deploy a Windows or Linux Virtual Machine (VM).
    3.  Install a web server (IIS or Nginx) on the VM.
    4.  Configure Network Security Groups (NSGs) to allow traffic only on port 80 (HTTP) and restrict SSH/RDP access to your specific home IP address.
*   **Skills Applied:** VM creation, Networking basics, Security rules, Cost Management (shutting it down when not in use).

#### **Scenario 2: Static Website Hosting (Serverless Storage)**
*   **The Goal:** Host a resume or portfolio website without managing a server.
*   **The Task:**
    1.  Create an Azure Storage Account.
    2.  Enable the "Static Website" feature on the Blob Storage.
    3.  Upload HTML/CSS files using Azure Storage Explorer.
    4.  (Bonus) Put an Azure CDN (Content Delivery Network) in front of it to make it load fast globally.
*   **Skills Applied:** Storage Accounts, Blob Storage, CDN, global infrastructure.

---

### Phase 2: Intermediate Scenarios (PaaS, Databases, & Networking)
*Targeting Parts III (B), V, and VI*

These projects move away from managing servers (IaaS) toward managed services (PaaS), which is the preferred modern cloud approach.

#### **Scenario 3: The Multi-Tier Web Application**
*   **The Goal:** Build a scalable web app connected to a database.
*   **The Task:**
    1.  Deploy a web application code (Node.js, .NET, or Python) to **Azure App Service** (Web Apps).
    2.  Provision an **Azure SQL Database**.
    3.  Secure the connection so the App Service can talk to the SQL Database (using Connection Strings stored in Key Vault or Managed Identity).
    4.  Set up **Auto-scaling** on the App Service Plan so that if CPU usage goes above 70%, a second instance is automatically created.
*   **Skills Applied:** App Service, Azure SQL, Auto-scaling, Managed Identity.

#### **Scenario 4: High Availability Load Balancing**
*   **The Goal:** Ensure an application survives if one server dies.
*   **The Task:**
    1.  Create two distinct VMs in an **Availability Set** or across different **Availability Zones**.
    2.  Deploy the same simple web page to both.
    3.  Place an **Azure Load Balancer** (Layer 4) or **Application Gateway** (Layer 7) in front of them.
    4.  Test it by shutting down "VM 1" and verifying the website still loads because traffic is routed to "VM 2."
*   **Skills Applied:** Load Balancing, High Availability, Health Probes.

---

### Phase 3: Advanced Scenarios (Serverless, Security, & DevOps)
*Targeting Parts III (C/D), VII, and VIII*

These projects focus on modern architecture, automation, and security best practices.

#### **Scenario 5: Event-Driven Image Processor (Serverless)**
*   **The Goal:** Automate a workflow without running a server 24/7.
*   **The Task:**
    1.  User uploads an image to a Storage Account (Blob).
    2.  This upload triggers an **Azure Function**.
    3.  The Function resizes the image (creates a thumbnail) and saves it to a different folder.
    4.  Use **Logic Apps** to send an email notification when the process is complete.
*   **Skills Applied:** Azure Functions (Serverless), Event Grid/Triggers, Logic Apps, Coding.

#### **Scenario 6: The "Compliance & Security" Lockdown**
*   **The Goal:** Secure an environment and monitor it as a Security Engineer would.
*   **The Task:**
    1.  Create an **Azure Policy** that forbids creating resources in any region other than "East US" (Governance).
    2.  Store a "Secret" (like a password) in **Azure Key Vault**.
    3.  Configure a VM to retrieve that password safely without you typing it.
    4.  Set up **Azure Monitor** alerts to email you if anyone deletes a resource.
*   **Skills Applied:** Policy, Key Vault, Monitor/Alerts, RBAC.

#### **Scenario 7: Infrastructure as Code (IaC)**
*   **The Goal:** Automate the creation of resources so you never have to click in the portal again.
*   **The Task:**
    1.  Take "Scenario 1" (The VM and VNet).
    2.  Write an ARM Template, Bicep file, or Terraform script that defines these resources.
    3.  Deploy the entire environment using a single command in **Azure CLI** or **PowerShell**.
*   **Skills Applied:** Automation, JSON/Bicep, CLI/PowerShell, DevOps principles.

---

### Why this specific appendix file is crucial:
1.  **Portfolio Building:** If you are looking for a job, you cannot just say "I studied Azure." You need to say, *"I built a Highly Available, Load Balanced web application using Azure App Service and SQL."* This file gives you the blueprints for those portfolio pieces.
2.  **Cost Awareness:** These scenarios usually include tips on how to build these things cheaply (e.g., "Use the B-series burstable VMs" or "Delete the resource group immediately after the lab") to avoid unexpected bills.
3.  **Synthesis:** It forces you to combine Networking, Compute, and Storage—topics that are usually taught separately but always work together in the real world.

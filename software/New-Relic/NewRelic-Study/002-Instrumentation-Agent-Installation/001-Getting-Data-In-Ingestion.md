Here is a detailed breakdown of **Part II, Section A: Getting Data In (Ingestion)**.

This section represents the foundational step of New Relic. Before you can analyze performance, you must establish the "pipes" that move telemetry data from your servers, applications, and cloud environments into the New Relic One database (NRDB).

---

### 1. Guided Install (CLI) vs. Manual Installation

There are two primary ways to install the New Relic agents. Understanding the difference is crucial for both ease of use and automation strategies.

#### **Guided Install (The "Magic" CLI)**
This is the modern, recommended approach for manual set up on a single host.
*   **How it works:** You run a single command (curl/PowerShell) provided by the New Relic UI. This downloads a CLI tool (`newrelic-cli`).
*   **What it does:**
    1.  **Discovery:** It scans your server to see what is running (e.g., "I see you are on Ubuntu, running Java, and have a Docker container active").
    2.  **Recommendation:** It suggests which agents (Infrastructure, APM, Logs) you should install.
    3.  **Execution:** It automatically installs the Infrastructure agent, configures permissions, and sets up Log Forwarding.
*   **Pros:** Extremely fast (5 minutes), reduces human error, handles dependencies automatically.
*   **Cons:** Harder to use in "Infrastructure as Code" (Terraform/Ansible) pipelines; requires outbound network access during install.

#### **Manual Installation (The "DevOps" Way)**
This involves installing the specific package repositories and binaries yourself.
*   **How it works:** You add the New Relic repository to your package manager (like `apt`, `yum`, or `zypper` for Linux, or `MSI` for Windows) and run the install command.
*   **Use Case:** This is required when using configuration management tools like **Ansible, Chef, Puppet, or Terraform**. You want the installation to be reproducible and version-controlled, not "magical."
*   **Configuration:** You must manually create and edit the configuration files (e.g., `/etc/newrelic-infra.yml`) to add your license key.

---

### 2. License Keys vs. User Keys vs. Ingest Keys

New Relic uses several types of keys to secure data. Confusing these is a common source of errors.

#### **License Key (or Ingest License Key)**
*   **The "Write" Key.**
*   **Purpose:** This is the most common key. It is used by Agents (APM, Infrastructure) to **send** data to New Relic.
*   **Direction:** *From* Your Server -> *To* New Relic.
*   **Security:** If this leaks, someone can send fake data to your account, but they cannot *read* your existing data or change your account settings.

#### **User Key (API Key)**
*   **The "Read/Admin" Key.**
*   **Purpose:** This key is tied to a specific user. It is used to query data (via NerdGraph or REST API) or configure the platform (create alerts, dashboards).
*   **Direction:** *From* Your Script/Terminal -> *To* New Relic (Requesting info).
*   **Security:** Highly sensitive. If this leaks, someone can delete your dashboards, change your alerts, or export your data.

#### **Ingest Key (Specific API usage)**
*   **Purpose:** Specifically for the Telemetry Data Platform APIs (Metric API, Trace API, Log API).
*   **Nuance:** In modern New Relic, the **License Key** serves as the Ingest Key for most standard agents. However, if you are writing a custom script to push custom metrics (without an agent), you technically use an Ingest type key.

---

### 3. Host-level Integrations (Linux/Windows)

This refers to monitoring the operating system and the services running on top of it, usually handled by the **Infrastructure Agent**.

#### **The Infrastructure Agent**
Unlike APM (which lives inside your code), the Infrastructure agent lives on the OS (Daemon on Linux, Service on Windows).
*   **Base Metrics:** It automatically collects CPU, Memory, Disk I/O, and Network traffic.
*   **Inventory:** It captures a live list of every package installed and every active process.

#### **On-Host Integrations (OHIs)**
The Infrastructure Agent is extensible. You can "bolt-on" integrations to monitor third-party services running on that host without modifying their code.
*   **Examples:** NGINX, MySQL, Redis, Apache, Kafka, MongoDB.
*   **How it works:**
    1.  You have the Infra Agent installed.
    2.  You install the specific integration (e.g., `nri-mysql`).
    3.  You configure a YAML file with the database credentials (user/pass).
    4.  The agent queries the database (e.g., `SHOW STATUS`) every 15 seconds and sends those metrics to New Relic.

---

### 4. Cloud Integrations (AWS, Azure, GCP)

If you use cloud services where you cannot install an agent (like a managed database, a load balancer, or serverless functions), you use Cloud Integrations.

#### **API Polling (The Old/Standard Way)**
*   **Mechanism:** You give New Relic a "Read Only" role in your cloud account (e.g., an AWS IAM Role ARN).
*   **Process:** New Relic's servers wake up every 5-10 minutes, query the AWS CloudWatch API for your metrics, and copy them into New Relic.
*   **Drawback:** It is slower (metrics are delayed by 10+ minutes) and can cost money (AWS charges for API requests).

#### **Metric Streams (The Modern/AWS Way)**
*   **Mechanism:** AWS CloudWatch **Metric Streams**.
*   **Process:** Instead of New Relic asking for data, AWS pushes data immediately via **Amazon Kinesis Data Firehose** directly to New Relic.
*   **Benefit:** Much faster (near real-time, ~1-2 minute latency) and often cheaper than API polling fees.

#### **What allows you to see:**
*   **AWS:** RDS, DynamoDB, ELB/ALB, Lambda, SQS, SNS.
*   **Azure:** CosmosDB, Azure SQL, Blob Storage.
*   **GCP:** BigQuery, Cloud Functions, Pub/Sub.

---

### Summary Table

| Concept | Explanation |
| :--- | :--- |
| **Guided Install** | Automated CLI script. Best for quick setup and discovering what to monitor. |
| **Manual Install** | Package manager based. Best for Automation (Ansible/Terraform). |
| **License Key** | Used by agents to **send** data to New Relic. |
| **User Key** | Used by admins/scripts to **query** or **configure** New Relic. |
| **Host Integration** | The Infrastructure agent monitoring the OS + Services (MySQL, Nginx) on the box. |
| **Cloud Integration** | Connecting New Relic to AWS/Azure to monitor managed services (RDS, Load Balancers). |

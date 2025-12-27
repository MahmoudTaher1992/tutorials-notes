Based on the Table of Contents provided, **"Part II, Section B: Cloud & Integrations"** is a critical module. It bridges the gap between monitoring a raw server (CPU/Memory) and monitoring the actual ecosystem (AWS/Azure, Databases, Web Servers) that runs your business.

Here is a detailed breakdown of each concept in that section.

---

### 1. Cloud Provider Integrations (AWS, Azure, GCP)

This refers to connecting Datadog directly to the management console of your cloud provider (Amazon Web Services, Microsoft Azure, Google Cloud Platform).

*   **The Concept:** Even if you don’t install a Datadog Agent on a Virtual Machine (VM), Cloud Providers generate their own metrics (e.g., AWS CloudWatch, Azure Monitor). Datadog connects to the cloud provider's API to "ingest" these metrics.
*   **Why it is needed:**
    *   **Managed Services:** You cannot install an Agent on AWS RDS (Database as a Service), AWS ELB (Load Balancers), or Azure Logic Apps. The *only* way to monitor them is via Cloud Integration.
    *   **Metadata:** It pulls in tags automatically (e.g., `region:us-east-1`, `availability-zone`, `instance-type`).
*   **How it works (AWS Example):**
    *   You create an IAM Role in AWS with specific read-only permissions.
    *   You give Datadog the "Trust" to assume that role.
    *   Datadog queries the AWS API periodically to fetch data.

### 2. Metric Polling vs. Metric Streams

When integrating with a Cloud Provider (specifically AWS), there are two ways Datadog can get the data. This is a common interview/exam topic.

#### A. Metric Polling (API Pull)
*   **Mechanism:** Datadog's servers "wake up" every 10 minutes (configurable) and ask AWS CloudWatch: *"Do you have new data for these 100 servers?"*
*   **Pros:** Easy to set up (just requires the IAM Role).
*   **Cons:**
    *   **Latency:** Data is often delayed by 10–15 minutes.
    *   **API Limits:** If you have massive infrastructure, AWS might throttle (block) Datadog's requests because you are hitting the API too often.
    *   **Cost:** API `GetMetricData` calls can get expensive on the AWS bill.

#### B. Metric Streams (Push)
*   **Mechanism:** Instead of Datadog asking for data, AWS pushes the data the moment it is generated.
    *   *AWS CloudWatch* $\to$ *AWS Kinesis Data Firehose* $\to$ *Datadog HTTP Endpoint*.
*   **Pros:**
    *   **Real-time:** Latency drops to seconds (or < 2 minutes).
    *   **Completeness:** Captures all metrics without API throttling.
*   **Cons:** slightly more complex setup (requires configuring Kinesis Firehose in AWS).

### 3. Installing 3rd Party Integrations

While "Cloud Integrations" look at the infrastructure from the outside, "3rd Party Integrations" look at the software running *inside* the OS.

*   **What are they?** These are plugins for the Datadog Agent that know how to talk to specific software like Postgres, Redis, Nginx, Kafka, Apache, etc.
*   **The Configuration Pattern:**
    Almost all integrations follow the same setup pattern on a Linux/Windows host:
    1.  **Locate the Config:** Go to the configuration folder (usually `/etc/datadog-agent/conf.d/`).
    2.  **Find the Folder:** Look for the folder matching the software (e.g., `postgres.d/` or `nginx.d/`).
    3.  **Create yaml:** Copy `conf.yaml.example` to `conf.yaml`.
    4.  **Edit details:** Input the connection details.
        *   *Example (Postgres):* You provide the `host`, `port`, `username`, and `password` so the Agent can run SQL queries to get status.
        *   *Example (Nginx):* You provide the `nginx_status_url` so the Agent can `curl` it to get request counts.
*   **Kubernetes Difference:** In K8s, you rarely edit files manually. Instead, you use **Autodiscovery**. You place "Annotations" on your Pods, and the Agent automatically detects that Redis is running and applies the config.

### 4. Custom Checks (Writing Python Checks)

Sometimes you have a proprietary internal application, or a legacy system that Datadog doesn't have an official integration for. You need to write your own logic.

*   **Language:** Custom checks are written in **Python**.
*   **Architecture:**
    1.  **Inheritance:** You create a Python class that inherits from `AgentCheck`.
    2.  **The `check` method:** You must implement a method called `def check(self, instance):`.
*   **What the script does:**
    Inside the script, you write logic to gather data (e.g., parse a local text file, run a shell command, query a strange database).
*   **Sending Data:** You use Datadog methods to send the data back:
    *   `self.gauge('my_custom.metric', 100)` -> Sends a metric.
    *   `self.service_check('my_custom.status', AgentCheck.OK)` -> Sends a status (OK/CRITICAL).
*   **File Locations:**
    *   The Python logic goes in `/etc/datadog-agent/checks.d/my_check.py`.
    *   The configuration (how often to run it) goes in `/etc/datadog-agent/conf.d/my_check.yaml`.

---

### Summary Table

| Concept | Purpose | Key Terminology |
| :--- | :--- | :--- |
| **Cloud Integrations** | Monitor managed services (RDS, S3, Azure SQL) without installing software. | IAM Role, Crawler, API Access |
| **Metric Streams** | Getting Cloud data *fast* (push) vs. *slow* (pull). | Kinesis Firehose, Latency, API Throttling |
| **3rd Party Integrations** | Monitoring standard software (DBs, Web Servers) via the Agent. | `conf.d`, `conf.yaml`, `stub_status` |
| **Custom Checks** | Monitoring custom logic via Python scripts. | `AgentCheck` class, `checks.d`, Python |

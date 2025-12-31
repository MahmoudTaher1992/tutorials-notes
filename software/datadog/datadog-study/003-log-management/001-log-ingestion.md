Based on the structure provided in your Table of Contents, here is a detailed explanation of **Part III: Log Management — A. Log Ingestion**.

This section focuses entirely on the **"How"**: How do we get text data from your servers, containers, or cloud services safely into the Datadog platform?

---

# 003-Log-Management / 001-Log-Ingestion.md

This phase is critical because "Garbage In, Garbage Out" applies heavily to logging. If ingestion is configured poorly, you will have broken stack traces, leaked passwords, or missing data.

## 1. Log Collection Methods
Datadog is agnostic about where logs come from, but there are three primary ways to send them.

### A. The Datadog Agent (The "Tailing" Approach)
This is the standard method for Virtual Machines (EC2, Compute Engine) and On-Premise servers.

*   **How it works:** The Agent runs on your server. You configure it to "tail" (watch the end of) specific log files (e.g., `/var/log/nginx/access.log` or `/var/log/app.log`).
*   **Container Logging:** In Docker/Kubernetes environments, the Agent listens to the Docker Socket. It automatically captures the `stdout` and `stderr` streams from all running containers.
*   **Key Configuration:** To enable logs, you must change `datadog.yaml`:
    ```yaml
    logs_enabled: true
    ```
*   **Integration Config:** You then tell the agent where the files are via a `conf.yaml` file for that specific integration:
    ```yaml
    logs:
      - type: file
        path: /var/log/myapp/error.log
        service: my-payment-service
        source: java
    ```

### B. HTTP API (The "Direct" Approach)
Sometimes you cannot install the Datadog Agent. This is common in **Frontend** environments, **Mobile Apps**, or **IoT devices**.

*   **How it works:** Your application sends a JSON payload via an HTTP POST request directly to the Datadog intake URL (`http-intake.logs.datadoghq.com`).
*   **Pros:** No infrastructure dependency; works from anywhere with internet.
*   **Cons:** You have to handle network retries and buffering inside your application code (blocking the Agent handles this for you automatically).

### C. AWS Lambda Forwarder (The "Serverless" Approach)
When using managed cloud services (like AWS RDS, AWS Lambda, or ELB), you cannot SSH into the server to install an agent.

*   **The Flow:**
    1.  The AWS Service (e.g., RDS) writes logs to **AWS CloudWatch**.
    2.  You deploy a special **Datadog Forwarder** (a Python Lambda function provided by Datadog).
    3.  This Forwarder subscribes to the CloudWatch Log Group.
    4.  When logs arrive in CloudWatch, the Forwarder triggers, formats them, and pushes them to Datadog via API.
*   *Note: While Datadog now supports Kinesis Firehose for high-volume ingestion, the Lambda Forwarder remains a core method for many AWS setups.*

---

## 2. Multi-line Aggregation
This is the most common technical headache in log ingestion.

### The Problem: Stack Traces
In a log file, a Java or Python error usually looks like this:

```text
2023-10-27 10:00:01 ERROR: Something failed
  at com.mycompany.app.Method(File.java:10)
  at com.mycompany.app.Other(File.java:20)
  at javax.servlet.something...
```

To a computer reading line-by-line, **this looks like 4 separate logs.**
1.  Log 1: "2023-10-27..."
2.  Log 2: "at com.mycompany..."
3.  Log 3: "at com.mycompany..."

If these are ingested separately, your logs will be unreadable noise.

### The Solution: `log_processing_rules`
You configure the Agent to recognize the **start** of a new log. Anything that *doesn't* look like the start is assumed to belong to the previous line.

**Configuration Example (in your `conf.yaml`):**
```yaml
logs:
  - type: file
    path: /var/log/java_app.log
    log_processing_rules:
      - type: multi_line
        name: new_log_start_with_date
        # Regex: Matches a timestamp at the start of the line
        pattern: \d{4}-\d{2}-\d{2}
```
*   **Result:** The Agent buffers the lines starting with "at..." and stitches them to the previous line containing the timestamp before sending them to Datadog.

---

## 3. Scrubbing and Redaction (PII Protection)
Security and Compliance (GDPR, HIPAA, PCI) dictate that you **cannot** store Sensitive Data (PII - Personally Identifiable Information) in a third-party log tool.

Examples of data to scrub: **Credit Card Numbers, Social Security Numbers, API Keys, Passwords, Email Addresses.**

### The "Before Sending" Strategy
While you can redact logs *after* they reach Datadog, it is much safer to redact them **at the Agent level** (before the data ever leaves your server).

### How to Configure Scrubbing
You use `log_processing_rules` with the type `mask_sequences`.

**Example: Redacting an Email Address**
Imagine your log is: `User login failed: email=bob@example.com`

**Configuration:**
```yaml
logs:
  - type: file
    path: /var/log/auth.log
    source: python
    log_processing_rules:
      - type: mask_sequences
        name: mask_emails
        replace_placeholder: "[REDACTED_EMAIL]"
        # Regex pattern to find emails
        pattern: ([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)
```

**What Datadog receives:**
`User login failed: email=[REDACTED_EMAIL]`

### Summary of Rules
1.  **Blocklist:** Do not send lines containing specific words (e.g., "HealthCheck" spam).
2.  **Allowlist:** *Only* send lines containing specific words (e.g., only send "ERROR").
3.  **Masking:** Replace sensitive patterns with safe text.

---

### Summary of Part III.A
In this section, we learned:
1.  **Ingestion:** Use the Agent for servers/containers, the Forwarder for Cloud/Serverless.
2.  **Multi-line:** Use Regex to stitch stack traces together so errors are readable.
3.  **Scrubbing:** Use Regex to mask passwords and PII *before* the data travels over the internet.

Based on the roadmap provided, **Part XII: Governance, Security & Compliance / Section B: Compliance** focuses on how Dynatrace handles sensitive data, meets legal requirements, and tracks user activity within the platform.

When working with full-stack observability, you are potentially capturing everything from database queries to real user IP addresses and session clicks. Therefore, ensuring this data is handled legally and securely is critical.

Here is a detailed breakdown of the concepts within this section:

---

### 1. Data Privacy & Regulatory Standards (GDPR, HIPAA, CCPA)
This subsection covers how to configure Dynatrace to respect privacy laws like GDPR (Europe), CCPA (California), and HIPAA (Healthcare).

#### **The Core Problem:**
Dynatrace OneAgent captures data automatically. By default, this might include:
*   User IP addresses.
*   Geographic locations.
*   URL parameters (which might contain email addresses or session IDs).
*   Form data (if configured).

#### **How Dynatrace Solves This (Study Points):**
*   **Data Masking:** You must learn how to configure **global masking settings**. Dynatrace allows you to mask IP addresses (e.g., changing `192.168.1.50` to `192.168.1.0` or `0.0.0.0`) and mask specific URLs to prevent PII (Personally Identifiable Information) from being stored.
*   **User Opt-In Modes:** For Real User Monitoring (RUM), Dynatrace has strict privacy settings. You can configure it to only capture data if the user clicks "Accept Cookies" on your website.
*   **Do Not Track (DNT):** Dynatrace can automatically respect the browser's "Do Not Track" header.
*   **PCI-DSS (Payment Cards):** You must ensure that "Capture Request Data" is configured *not* to capture credit card numbers from HTTP POST bodies.

### 2. Data Retention Policies
Compliance often dictates how long you *must* keep data (for auditing) or how quickly you *must* delete it (for privacy).

#### **The Core Problem:**
Storing every single millisecond of data forever is too expensive and technically impossible. Dynatrace aggregates data over time.

#### **Dynatrace Retention Periods (Crucial for Exams/Admin):**
You need to understand the lifecycle of data in Dynatrace SaaS (Managed customers can adjust these, but SaaS is fixed):
*   **Code-Level (PurePaths/Traces):** Kept for **10 days**. After this, you cannot see individual stack traces, only aggregated stats.
*   **Service Request Key Metrics (1-minute resolution):** Kept for **14 days**.
*   **Service Request Metrics (5-minute resolution):** Kept for **28 days**.
*   **Transaction/Service Metrics (aggregated):** Kept for **forever** (technically 5 years for historical trending).
*   **RUM (User Sessions):** Kept for **35 days**.
*   **Log Monitoring:** You pay for retention buckets (e.g., 30 days, 60 days).

*Why this is a Compliance topic:* If a legal audit requires you to produce a specific user's session from 6 months ago, you need to know that Dynatrace *does not have it* by default.

### 3. Audit Logs
Audit logs are the "black box" recording of the Dynatrace platform itself. This is a requirement for **SOC2** compliance.

#### **The Core Problem:**
If a monitoring alert was disabled right before a major crash, you need to know: **Who disabled it?**

#### **What Dynatrace Logs:**
*   **Configuration Changes:** Who changed a specific threshold? Who turned off a specific plugin?
*   **User Management:** Who invited a new user? Who added a permission to a group?
*   **Login History:** Who logged into the tenant and when?
*   **API Token Management:** Who created a new API token that allows external access?

#### **How to use it:**
*   You can view Audit Logs in the Dynatrace UI (`Settings > Audit logs`).
*   For strict compliance, you can stream these audit logs out of Dynatrace to an external SIEM (like Splunk) so they cannot be tampered with.

### 4. Data Sovereignty (SaaS vs. Managed)
This touches on **where** the data physically resides.

*   **SaaS:** Data lives in Dynatrace's cloud (usually AWS, Azure, or GCP). For strict compliance (e.g., German Banking laws), this might not be allowed.
*   **Dynatrace Managed:** This is a hybrid model where the Dynatrace software runs **on your own servers** (on-premise or your private cloud). The data stays within your firewall. This is often the chosen route for Government and Healthcare to meet strict compliance rules regarding where data is stored.

### Summary Checklist for this Section
To master this section, you should be able to answer:
1.  How do I mask an IP address in Dynatrace RUM settings?
2.  What is the difference between data retention for *Services* vs. *PurePaths*?
3.  How can I find out which user deleted a Management Zone yesterday?
4.  How do I configure Dynatrace to capture user data only after they accept a GDPR cookie?

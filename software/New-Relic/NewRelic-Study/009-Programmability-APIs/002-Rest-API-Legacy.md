Based on the Table of Contents you provided, here is a detailed explanation of **Part IX, Section B: Rest API (Legacy)**.

---

# 009-Programmability-APIs / 002-Rest-API-Legacy

## What is the New Relic REST API?

The New Relic REST API (specifically **API v2**) is the original programmatic interface for interacting with the New Relic platform. Before New Relic moved to a unified data model, this was the primary way developers and operations teams extracted data, configured alerts, and listed applications via code.

It is labeled **"Legacy"** because New Relic has shifted its focus to **NerdGraph (GraphQL)** as the modern standard for all API interactions. However, the REST API is still fully functional, widely used in older scripts, and necessary for certain specific tasks.

### 1. Key Characteristics
*   **Resource-Based:** It follows standard REST principles where you access specific "resources" via unique URLs (e.g., `/applications`, `/alerts_policies`).
*   **JSON Output:** It returns data in JSON format.
*   **Pagination:** Unlike GraphQL, large datasets in REST are handled via numbered pagination (e.g., `?page=2`).
*   **Rate Limits:** It has strict limits on how many requests you can make per minute to prevent system overload.

---

## Key Capabilities (What you can do with it)

While NerdGraph handles most modern tasks, the REST API is historically used for:

### A. Retrieving Metric Data
You can pull specific metric data (raw numbers) for an application.
*   *Example:* "Give me the average response time and throughput for 'Checkout Service' for the last 30 minutes."
*   **Note:** In the modern platform, it is usually easier to query this data using NRQL, but the REST API allows you to pull the raw metric names directly.

### B. Listing Entities
You can request a list of all APM applications, Browser applications, or Mobile apps reporting to your account to get their IDs, health status (Green/Yellow/Red), and basic summary data.

### C. Deployment Markers
This is one of the most enduring use cases for the REST API. When you deploy new code, your CI/CD pipeline (Jenkins, GitHub Actions, etc.) sends a `POST` request to the REST API.
*   This places a vertical line on your APM charts, helping you correlate a code deployment with changes in performance.

### D. Managing Legacy Alerts
Before "New Relic Alerts" became fully programmable via NerdGraph and Terraform, the REST API was used to create alert channels and policies. (This is largely discouraged now in favor of NerdGraph).

---

## Authentication & Usage

To use the REST API, you generally need an **API Key**.

1.  **User Key:** The most common key type. It identifies the specific user making the request.
2.  **REST API Key (Admin):** Older accounts use this for account-level administrative changes.

**The Request Structure:**
All requests go to `https://api.newrelic.com/v2/`. You must pass your key in the Header.

**Example: Listing all Applications (cURL)**
```bash
curl -X GET 'https://api.newrelic.com/v2/applications.json' \
     -H 'X-Api-Key: YOUR_API_KEY_HERE'
```

**Example: creating a Deployment Marker**
```bash
curl -X POST 'https://api.newrelic.com/v2/applications/YOUR_APP_ID/deployments.json' \
     -H 'X-Api-Key: YOUR_USER_KEY' \
     -H 'Content-Type: application/json' \
     -d '{
           "deployment": {
             "revision": "v2.1.0",
             "user": "datanerd"
           }
         }'
```

---

## REST API vs. NerdGraph (GraphQL)

It is vital to understand the difference to know which tool to choose.

| Feature | REST API (Legacy) | NerdGraph (GraphQL) |
| :--- | :--- | :--- |
| **Data Fetching** | **Over-fetching:** You get a massive JSON blob even if you only need one field. <br>**Under-fetching:** You might need to make 3 separate API calls to get Application details + Alert status + Recent errors. | **Exact-fetching:** You request exactly the fields you want. <br>**Unified:** You can get App details, Alerts, and Errors in a single API call. |
| **Flexibility** | Rigid. The endpoints are fixed by New Relic. | Flexible. You traverse the "Graph" of your data (Entity -> Tags -> Alert Conditions). |
| **Documentation** | API Explorer (v2) documentation. | GraphiQL Explorer (built-in interactive documentation). |
| **Speed** | Can be slower due to multiple round-trips. | Generally faster and more efficient. |
| **Future Proof** | Maintenance mode. | Active development. |

---

## Summary for the Exam/Study

If you are studying for a certification or interview based on this TOC, remember:

1.  **Status:** The REST API is legacy but not deprecated (it still works).
2.  **Primary Use Case:** Existing automation scripts and recording **Deployment Markers**.
3.  **Modern Alternative:** For almost all new development, querying data, or configuring infrastructure, use **NerdGraph (GraphQL)**.
4.  **Data Access:** The REST API accesses specific *metric names* (e.g., `WebTransaction/TotalTime`), whereas modern New Relic focuses on *NRQL* queries.

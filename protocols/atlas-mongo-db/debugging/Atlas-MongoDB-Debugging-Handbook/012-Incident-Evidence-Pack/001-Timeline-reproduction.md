Based on the structure of the handbook you provided, the file **`012-Incident-Evidence-Pack/001-Timeline-reproduction.md`** corresponds to **Section 12.1** in your Table of Contents.

This is arguably the most critical document for **Post-Incident Reviews (PIRs)** or **Root Cause Analysis (RCA)**. It is the "Detective's Log" that helps you move from "fixing the fire" to "understanding why the fire started."

Here is a detailed explanation of what this file contains, why it exists, and how to fill it out.

---

### 📂 File Purpose
**The goal of this document is to establish a single source of truth regarding *Time* and *Causality*.**

When a MongoDB incident occurs (e.g., Connection Saturation), logs are scattered across AWS/ECS (Application), Atlas (Database), and Slack (Human communication). This file merges those distinct sources into one linear story to prove exactly what triggered the issue.

---

### 📝 Detailed Content Breakdown

This file is usually split into two main sections: **The Timeline** and **Reproduction Steps**.

#### 1. The Timeline (Chronology)
This section maps out the incident minute-by-minute. It is crucial for correlating **Application symptoms** with **Database behavior**.

*   **Timezone Standardization:** (Critical) All times should be logged in **UTC** to match Mongo logs, avoiding confusion with local laptop times.
*   **The "Boom" Moment:** Pinpoint the exact second performance degraded.
*   **Event Correlation columns:**
    *   *Timestamp:* `YYYY-MM-DD HH:MM:SS UTC`
    *   *App Event:* "ECS service returned 504 Gateway Timeout."
    *   *DB Event:* "Atlas Connections spiked from 400 to 1500."
    *   *Human Action:* "Developer deployed v1.2.0 patch."

**Why this matters:**
Often, the DB spike happens *after* an app deployment, or *during* a scheduled cron job. Without a timeline, you cannot prove causing vs. correlation.

#### 2. Reproduction Context (The "Recipe")
This section documents the specific conditions required to make the error happen again. If you can reproduce it, you can fix it.

*   **Trigger Mechanism:** What specific API call, query, or user action caused the crash?
    *   *Example:* "Endpoint `GET /api/v1/dashboard/stats` with a date range > 1 year."
*   **Environment Variables:** Was the specific load balancer configuration involved? Was it only on the Primary node?
*   **Data State:** Does this happen with an empty DB, or only when the collection has > 10 million documents?
*   **Proof of Concept (PoC):** A script or CLI command (e.g., `curl` or a Python script) that triggers the failure on demand.

---

### 📄 Example Template
If you were to open `012-Incident-Evidence-Pack/001-Timeline-reproduction.md`, it should look something like this:

```markdown
# Incident Timeline & Reproduction
**Incident ID:** INC-2023-10-05
**Date:** 2023-10-05
**Severity:** High (Connection Saturation)

## 1. Timeline (UTC)
| Time (UTC) | Application Log (ECS) | MongoDB Atlas Metric | Human/System Action |
| :--- | :--- | :--- | :--- |
| 14:00:00 | Normal Traffic | Conn: 15% | Routine Backup started |
| 14:05:00 | Response time > 2s | Conn: 30% | No action |
| 14:07:30 | **502 Bad Gateway** | **Conn: 85% (Alert Fired)** | **New deployment (v2.1) rollout finish** |
| 14:08:00 | Apps restarting | Conn: 100% (Maxed) | Auto-scaling triggered |
| 14:15:00 | Error logs stabilize | Conn: 20% | Reverted to v2.0 |

**Conclusion from Timeline:**
The incident correlates perfectly with the completion of the v2.1 deployment, not the backup.

## 2. Reproduction Steps
**Hypothesis:** The new "Notifications" feature in v2.1 opens a DB connection but fails to close it on error.

**Steps to Reproduce:**
1. Connect to Staging DB.
2. Deploy app version v2.1.
3. Run the load test script: `./scripts/load-test-notifications.sh`.
4. Observe Atlas "Connections" metric.

**Result:**
Connections increase by 500 every minute until saturation. Confirmed connection leak in `NotificationService.js`.
```

### 💡 Strategic Value
In the context of your Handbook:
1.  **It exonerates the innocent:** It proves whether the issue was the Network, the App logic, or the Database hardware.
2.  **It defines the fix:** You cannot fix a connection storm if you don't know *which* deployment caused it.
3.  **It builds the "Evidence Pack":** This file is the cover sheet for the screenshots and logs you will gather in the other sections of the Evidence Pack.

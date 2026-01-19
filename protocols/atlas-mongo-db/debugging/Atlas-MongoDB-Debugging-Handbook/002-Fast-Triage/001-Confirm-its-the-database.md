Based on the Table of Contents you provided, here is a detailed breakdown of what the file **`002-Fast-Triage/001-Confirm-its-the-database.md`** should contain.

This section is the "Emergency Room" triage desk. Before you start running complex database profiling scripts or adding indexes, you must answer one question: **Is the database actually the problem, or is it a victim of an upstream issue?**

Below is the detailed content explanation for this specific file.

---

# 📂 File: `002-Fast-Triage/001-Confirm-its-the-database.md`

## 1. The Objective 🎯
The goal of this phase is to strictly determine if the **MongoDB Atlas cluster is the primary bottleneck**.
*   **Stop** if the issue is actually a network outage, a bad application deployment, or a load balancer configuration.
*   **Proceed** only if evidence suggests the database is rejecting connections, answering too slowly, or throwing internal errors.

---

## 2. 📝 The Symptoms Checklist
You are looking for specific fingerprints in your application logs or monitoring tools (DataDog, New Relic, CloudWatch) that point to the database.

### A. Differentiate the Timeouts
Not all timeouts are the same. Distinguish between them:

| Symptom | Error Message Example | Meaning | Verdict |
| :--- | :--- | :--- | :--- |
| **Connection Timeout** | `MongoTimeoutError: Server selection timed out after 30000 ms` | The App cannot reach the DB or the DB is too busy to accept a handshake. | **Likely DB** (Full or Network down) |
| **Socket/Execution Timeout** | `MongoNetworkError: connection timed out` (during query) | The connection exists, but the query took too long to return data. | **Definite DB** (Slow Query) |
| **HTTP 502/504** | `Gateway Timeout` | The App failed to respond to the Load Balancer. | **Maybe DB** (App waiting on DB) |

### B. "The Big Four" Signals
Check your APM (Application Performance Monitor) for these specific signals:
1.  **Elevated Latency in Data Layer:** Does the breakdown of a request show 90% of time spent in `mongo` or `mongoose` operations?
2.  **Throttling:** Do you see errors related to `MaxPoolSize`, `ConnectionPool`, or "No connections available"?
3.  **Throughput Drop:** Did the number of handled requests drop while database *latency* spiked?
4.  **Specific Errors:** specifically looking for "Write Concern" errors or "Execution TimeLimitExceeded".

---

## 3. 🔄 Timeline Correlation (App vs. DB)
This is the "Smoking Gun" test. You need to overlay the timeline of the application failure with the timeline of the database metrics.

### Scenario A: The "Victim" Database (Not the Root Cause)
*   **Observation:** The App receives 10x normal traffic (DDOS or viral event).
*   **Timeline:** App traffic spikes ⮕ Application servers autoscale ⮕ Database connections spike ⮕ Database slows down.
*   **Conclusion:** The database is slow because it is overwhelmed by the App. **Fix the App scaling/caching.**

### Scenario B: The "Culprit" Database (Root Cause)
*   **Observation:** Traffic is normal/flat, but App starts erroring out.
*   **Timeline:** Database CPU spikes independently ⮕ Database latency rises ⮕ Application threads get stuck waiting ⮕ App crashes.
*   **Conclusion:** The database suddenly got slow (bad index, maintenance window, bad neighbor). **Fix the Database.**

### Scenario C: The "Ghost" (Network/Infra)
*   **Observation:** App logs say "Connection Refused" but Atlas metrics show *zero* activity (flat CPU, Connections drop to zero).
*   **Conclusion:** The App cannot reach the Database. **Check VPC Peering, Whitelists, or AWS Networking.**

---

## 4. 🧪 The "Can I Connect?" Test
Before assuming the DB is dead, try to connect manually from a safe location (e.g., a Bastion host, VPN, or your local machine if whitelisted).

1.  **Run `mongosh` connection string:**
    *   *If it connects instantly:* The DB is up. The issue might be the Application Server's connection pool.
    *   *If it hangs:* The DB is likely paused, restarting, or under severe lock contention.
    *   *If it connects but is slow:* The DB is resource-starved (maxed CPU/Disk).

---

## 5. Decision Gate 🚧

At the end of this 10-minute triage, you must make a choice:

*   **path A: It IS the Database.**
    *   *Evidence:* High DB CPU, Slow Queries in logs, Connection Pool errors.
    *   *Action:* **Proceed to `2.2 Review Atlas Alert Details`** and use the **Protocol Catalog**.

*   **path B: It is NOT the Database.**
    *   *Evidence:* DB metrics are flat/bored, but App is crashing. Or DB is unreachable (Network).
    *   *Action:* Escalate to DevOps/Infrastructure team. Check AWS ECS, Caddy, or Redis. **Do not modify the database.**

---

### Summary for your "Evidence Pack"
*   [ ] Timestamp of first error.
*   [ ] Exact error message from App logs.
*   [ ] Did DB CPU spike **before** or **after** the crash?

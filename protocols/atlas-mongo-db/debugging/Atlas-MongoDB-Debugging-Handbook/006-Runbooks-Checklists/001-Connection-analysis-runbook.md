Based on the Table of Contents you provided, the file **`006-Runbooks-Checklists/001-Connection-analysis-runbook.md`** (which corresponds to **Protocol 1**) is arguably the most critical operational document. In MongoDB, connection issues are the #1 cause of "down" scenarios that aren't actually hardware failures.

Here is the detailed explanation and likely content of that specific runbook.

---

# 🔌 Detailed Breakdown: Connection Analysis Runbook
**File:** `006-Runbooks-Checklists/001-Connection-analysis-runbook.md`

### 1. 🎯 Objective
To determine if the database connection count is approaching a saturation point that will reject new requests, and to identify *why* the connection count is high (Application leak? Misconfiguration? Traffic spike?).

### 2. 🚨 When to use this Runbook (Triggers)
*   **Alert:** Atlas triggers `Connections % > 80%`.
*   **App Error:** Logs show `MongoTimeoutError: Timed out after 30000ms` or `Connection Pool Closed`.
*   **Performance:** Latency increases across *all* operations, not just complex queries.

---

### 3. Step-by-Step Investigation Procedure

#### Step 1: Metric Verification (Is the server full?)
Go to the **Atlas Metrics** tab and check the **Connections** chart.

*   **Current Connections:** The number of active TCP connections.
*   **Available Connections:** The remaining capacity.
*   **Calculation:** `Used % = (Current / (Current + Available)) * 100`
*   **Analysis:**
    *   If **< 70%**: The DB is fine; the issue is likely client-side (app connection pool is exhausted, but DB has room).
    *   If **> 90%**: Critical. The DB is about to lock up.

#### Step 2: Identify the Connection Pattern (Visual Diagnosis)
Look at the shape of the connection graph over the last 3 hours. match it to one of these three profiles:

| Pattern | Visual Shape | Likely Root Cause |
| :--- | :--- | :--- |
| **The Leak** | 📈 **Linear Ramp** (Stairs) | Does not drop. Increases steadily until crash. Caused by code opening connections but not closing them. |
| **The Storm** | 🪜 **Vertical Wall** | Sudden spike from 100 to 2000 connections in seconds. Usually happens after an App restart or Autoscaling event. |
| **The Plateau** | ➖ **Flat High Line** | Stays constantly high (e.g., 95%). Means `minPoolSize` is set too high or you have too many microservices for the instance size. |

#### Step 3: Application & Driver Configuration Check
Before blaming the database, check the application configuration.

*   **Total App Instances:** How many ECS tasks/Pods are running?
*   **MaxPoolSize:** What is the driver setting? (Default is usually 100).
*   **The Math:** `(Total Pods) * (MaxPoolSize)` = **Potential Max Connections**.
    *   *Example:* 50 Pods * 100 Pool Size = 5,000 Potential Connections.
    *   *Atlas M30 Limit:* ~3,000 connections.
    *   *Result:* **Configuration Danger.** The app is allowed to kill the DB.

#### Step 4: Shell Investigation (Who are you?)
If you can connect via `mongosh` or Compass, run these commands to see exactly what is happening inside the connections.

**A. Count connections by Client IP:**
*Use this to spot if a specific service or developer machine is spamming the DB.*
```javascript
db.currentOp(true).inprog.reduce(
  (acc, o) => {
    if (o.client) {
      const clientIP = o.client.split(":")[0];
      acc[clientIP] = (acc[clientIP] || 0) + 1;
    }
    return acc;
  }, {}
);
```

**B. Check for "Idle" vs "Active" connections:**
*High idle count means the App opened a pool but isn't using it (wasted resources).*
```javascript
db.serverStatus().connections
// Look at 'current' vs 'active'
// if current is 2000 but active is 5, you have a pooling configuration issue.
```

---

### 4. 🩹 Remediation & Fixes (The "Do This" Section)

#### Scenario A: The Connection Storm (Emergency)
**Symptoms:** App restart triggered 1000s of connections, DB is unresponsive.
1.  **Immediate:** Stop the application auto-scaler. Do not let it add more pods.
2.  **Action:** If DB is 100% locked, you may need to force a primary failover (Atlas Cluster -> "Test Failover") to drop all connections and let applications reconnect slowly.
3.  **Fix:** Implement "Exponential Backoff" in your detailed connection logic.

#### Scenario B: The Connection Leak (Code Bug)
**Symptoms:** Connections grow over 24 hours and never drop.
1.  **Immediate:** Rolling restart of the Application servers. This severs the TCP links and resets the count to zero.
2.  **Fix:** Audit code. Look for `MongoClient.connect()` inside function loops. Ensure a Singleton pattern is used (connect once at startup, reuse the object).

#### Scenario C: Capacity Exhaustion (Growth)
**Symptoms:** Everything is configured right, but traffic is just too high.
1.  **Action:** Check CPU. It is likely low because the CPU spends all almost time context-switching between connections.
2.  **Fix (Short term):** Upgrade instance size (Scale Up) to get a higher connection limit.
3.  **Fix (Long term):** Use a Proxy (like **Atlas Queryable Encryption** or **ProxySQL** equivalent for Mongo) or reduce `maxPoolSize` in the app driver (e.g., drop from 100 to 50).

---

### 5. ⚠️ Key Takeaways for the Engineer
*   **Do not** increase `ulimit` on the server blindly; this usually leads to the DB crashing from memory exhaustion instead of connection exhaustion.
*   **The 80% Rule:** If you are consistently above 80% connections, you have no buffer for failovers. Scale up or optimize immediately.

Based on the Table of Contents you provided, specifically **Section 5 (Debugging Protocols**) and the file name `005-Debugging-Protocols/001-Protocol-Connection-Analysis.md`, here is the detailed breakdown of what that protocol contains.

 This protocol is designed to be executed when you receive an alert like **"Connections % > 80"**.

---

# 🔌 Protocol 1: Connection Analysis & Saturation Debugging

## 1. 🎯 Objective
To determine if the high connection count is a symptom of **application misconfiguration** (leaks/pooling), **scaling events** (too many containers), or **database performance** (slow queries causing a backlog).

## 2. 🚨 Trigger Conditions
*   **Alert:** Atlas "Connections %" > 80%.
*   **Symptom:** Application reports `MongoTimeoutError: trace wait queue timeout`.
*   **Symptom:** "Connection refused" errors in application logs.

---

## 3. 🕵️ Step-by-Steps Analysis

### Phase 1: Identify the Pattern (The "Shape" of the Spike)
Go to **Atlas Metrics** tab $\rightarrow$ **Connections**. Look at the graph shape:

| Graph Shape | Diagnosis Description | Likely Cause |
| :--- | :--- | :--- |
| **Gradual Climb (Slope)** | Connections increase strictly over time without dropping. | **Connection Leak.** App is opening connections but never closing them. |
| **Vertical Wall (Spike)** | Sudden jump from normal to max in seconds. | **Connection Storm.** Usually caused by an app restart, ECS auto-scaling, or a cache miss. |
| **Plateau (Flat Line)** | Stays exactly at a specific number (e.g., 500) consistently. | **Application Side Saturation.** You have hit the `maxPoolSize` limit configured in your code. |
| **Jagged/High Variance** | Rapid up/down movement. | **No Connection Pooling.** The app is opening/closing a socket for every single request (Very bad for CPU). |

---

### Phase 2: Correlate with App Infrastructure (ECS / Caddy)
*Context from your TOC 1.2*

Before blaming the database, check the application scaling:
1.  **Did ECS scale out?** If you went from 10 containers to 50 containers, and each container has a connection pool of 20:
    *   *Old Math:* $10 \times 20 = 200$ connections.
    *   *New Math:* $50 \times 20 = 1,000$ connections.
    *   **Verdict:** This is "Total Connection Count" exhaustion. You must lower `maxPoolSize` in the app config.
2.  **Are specific IPs flooding?** If you have network access, check if one specific service (or the Caddy proxy) is holding all connections.

---

### Phase 3: Inspect "Active" vs. "Idle" Connections
Go to **Atlas Real-Time Performance Panel (RTPP)** or minimize the sidebar metrics.

*   **Scenario A: High Connections + Low CPU + Low Active Operations**
    *   **Diagnosis:** Many *Idle* connections.
    *   **Meaning:** The app has opened pools it isn't using.
    *   **Severity:** Low (unless you hit the hard limit). This wastes RAM but doesn't slow down queries.
    *   **Action:** Reduce `minPoolSize` or `maxIdleTimeMS` in code.

*   **Scenario B: High Connections + High CPU + High Active Operations**
    *   **Diagnosis:** The "Traffic Jam" (The most common critical issue).
    *   **Meaning:** Queries are processing so slowly that new requests keep coming in, piling up connections waiting for the DB to answer.
    *   **Action:** **Do not add more connections.** You must find the **Slow Query** (Protocol 3) and kill it or index it.

---

### Phase 4: Detailed Investigation (Commands)
If you have shell access (Mongosh/Compass), run these to see exactly what is happening.

#### 1. Check current connection usage
```javascript
db.serverStatus().connections
```
*   `current`: Total open connections.
*   `active`: Currently executing a read/write (If this is high, it's a query performance issue).
*   `totalCreated`: If this number creates millions per hour, your pooling is broken.

#### 2. Identify who is holding connections
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
*   *Output:* A count of connections per IP address. Helps identify if a specific ECS task or developer laptop is the flooding source.

---

## 4. 🛠 Root Causes & Fixes Matrix

| Root Cause | Evidence | Resolution |
| :--- | :--- | :--- |
| **Connection Storm** | All apps restarted at once; Connections spiked vertically. | **Wait it out** or implement "Jitter" (random delays) in app startup logic. |
| **Bad Pooling Config** | `Connections` = (`NumContainers` × `maxPoolSize`). | **Reduce `maxPoolSize`**. (e.g., Change from 100 to 10). |
| **Slow Query Backlog** | High *Active* connections; High CPU; Queued Reads/Writes. | **Kill the operation** blocking the queue. Add missing index. (See Protocol 3). |
| **Connection Leak** | Linear growth of connections over days. | **Code Fix.** Look for code creating new `MongoClient` instances inside function loops. |

---

## 5. 🩹 Emergency Remediation (Panic Button)
If the database is unresponsive due to connection saturation:

1.  **Kill Long Running Ops:**
    ```javascript
    // Kill ops running longer than 10 seconds
    db.currentOp().inprog.forEach(
       function(op) {
         if(op.secs_running > 10) db.killOp(op.opid);
       }
    )
    ```
2.  **Restart the Application (Scaling Down):**
    Temporarily scale down ECS tasks to reduce the sheer number of incoming sockets.
3.  **Atlas Failover:**
    Triggering a failover (Plan change or manual failover) will drop all connections and force the app to reconnect. *Warning: This causes 5-10 seconds of downtime.*

---

## 6. 📝 Evidence for Postmortem
*   Screenshot of **Connections** graph (metrics).
*   Screenshot of **CPU** graph (verify if CPU spiked *with* connections).
*   Value of `maxPoolSize` in the application code.
*   Number of App Containers/Pods running at the time of incident.

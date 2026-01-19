Based on the context of the **Atlas MongoDB Debugging Protocols Handbook**, the section **"Evidence-friendly outputs"** (item 008/003) refers to a specific set of techniques and query styles designed to extract data that is **clean, concise, and shareable** for incident reports, support tickets, or debugging logs.

When a database incident occurs, raw outputs from MongoDB (like `db.currentOp()` or full server status objects) are often thousands of lines of nested JSON. They are too noisy to paste into Slack or a Jira ticket.

Here is a detailed explanation of what this section entails and how to use it.

---

### What is an "Evidence-Friendly Output"?

An evidence-friendly output is the result of a database query that has been **filtered, formatted, and minimized** to prove a specific point without the noise.

**Characteristics:**
1.  **Summarized:** Counts and averages rather than raw lists.
2.  **Readable:** Formatted as tables or clean text blocks, not massive nested JSON.
3.  **Sanitized:** Removes sensitive PII (if necessary) but keeps technical context (IPs, Drivers, Query patterns).
4.  **Actionable:** Highlights the "smoking gun" (e.g., specific blocking locks or a single IP flooding the pool).

---

### Why is this section critical?

In a high-pressure incident (e.g., CPU is at 99%, App is down):
1.  **Speed:** You don’t have time to read 4,000 lines of logs.
2.  **Collaboration:** You need to paste a snippet into Slack to tell the Dev team, *"This query is killing us"* without them scrolling for pages.
3.  **Post-Mortem:** You need a snapshot of the state *during* the crash to prove why a fix is needed later.

---

### Examples of Contents in this Section

This section of the handbook likely contains pre-written scripts/commands like the examples below.

#### 1. connection Analysis (The "Who is flooding us?" approach)
**The Problem:** Running `db.serverStatus().connections` just gives you a total number (e.g., `1500`). It doesn't tell you *who* is connecting.

**The Evidence-Friendly Query:**
A script that groups connections by Client IP and Driver version.

```javascript
/* Evidence-Friendly: Count connections by Client IP */
db.currentOp(true).inprog.reduce((acc, curr) => { 
    if(curr.client) {
        let ip = curr.client.split(":")[0];
        acc[ip] = (acc[ip] || 0) + 1;
    }
    return acc;
}, {});
```
*   **Output:** `{"10.0.1.25": 50, "10.0.1.26": 800, "10.0.1.99": 5}`
*   **Why it's friendly:** It immediately acts as evidence that `10.0.1.26` is the culprit.

#### 2. Identifying Long-Running Queries
**The Problem:** `db.currentOp()` returns massive documents describing the lock state, namespace, and detailed query plan for every operation.

**The Evidence-Friendly Query:**
Values that are flattened to show only Duration, Namespace, and the Query String.

```javascript
/* Evidence-Friendly: Top 5 longest running ops (Clean format) */
db.currentOp({ "secs_running": { $gt: 3 } }).inprog.forEach(op => {
    print(`[${op.secs_running}s] Type: ${op.op} | NS: ${op.ns} | Client: ${op.client}`);
    print("Query: " + JSON.stringify(op.query || op.command).substring(0, 100) + "...");
    print("---------------------------------------------------");
})
```
*   **Output:**
    ```text
    [45s] Type: query | NS: production.orders | Client: 10.1.5.4:54321
    Query: {"created_at": {"$lt": "2023-01-01"}, "status": "pending"}...
    ---------------------------------------------------
    ```
*   **Why it's friendly:** You can copy-paste this directly into an incident ticket as proof of a missing index or bad query.

#### 3. Analyzing Lock Contention
**The Problem:** Understanding MongoDB lock hierarchies from raw JSON is incredibly difficult for humans.

**The Evidence-Friendly Query:**
A query specifically looking for operations waiting on locks.

```javascript
/* Evidence-Friendly: Show me what is BLOCKED and WAITING */
db.currentOp({ "waitingForLock": true }).inprog.map(op => {
    return {
        opId: op.opid,
        duration: op.secs_running,
        waitingFor: op.lockStats ? "Lock Details Hidden" : "Global/Collection Lock",
        command: op.command
    }
})
```

---

### How to use "Reference 008-003" in Practice

When you are following the handbook logic:

1.  **Diagnose:** You suspect a connection storm (Section 4.1).
2.  **Consult 008/003:** Go to this file to grab the specific "Evidence-Friendly" command.
3.  **Execute:** Run the specific snippet in Mongosh (MongoDB Shell) or Compass.
4.  **Capture:** simpler text output is returned.
5.  **Report:** Copy that text. Paste it into your **Incident "Evidence Pack" (Section 12)**.

**Summary:** This section transforms you from a database administrator looking at raw data into an investigator presenting clear facts.

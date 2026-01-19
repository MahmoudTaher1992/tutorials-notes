Based on section **7.2 Key metrics to track continuously** of your handbook, here is a detailed explanation of what this file should contain.

These are the "Vital Signs" of your MongoDB cluster. You shouldn't just look at these when things break; you should know their "normal" baseline so you can spot deviations early.

Here is the detailed breakdown for **007-Dashboards-Instrumentation/002-Key-metrics-to-track.md**:

---

# 📊 7.2 Key Metrics to Track Continuously

This section defines the "Big 5" metrics that dictate the health of your MongoDB cluster. If any of these go into the red, user-facing latency or outages are imminent.

## 1. 🏊 Pool Usage (Connection Pooling)
**What it is:**
This measures the number of active connections the application is borrowing from its driver's connection pool versus the maximum allowed.
*   **App Side:** "How many connections have I borrowed?"
*   **DB Side:** "How many distinct socket connections are open?"

**Why track it?**
*   **Saturation:** If your app hits the `maxPoolSize`, new requests will pause (wait in a queue *inside the app server*) until a connection is freed. This manifests as high latency in the app, even if the Database CPU is low.
*   **Leaks:** If connections rise steadily over time and never drop, your application code is likely failing to close connections properly.

**🚩 Red Flag:** Usage stays at 90-100% of the limit continuously.

## 2. ⏳ Queues (Queued Operations)
**What it is:**
The number of operations (Reads/Writes) that have been received by MongoDB but are waiting for their turn to be executed.

**Why track it?**
*   **The Canary in the Coal Mine:** This is often the *first* sign of a bottleneck.
*   If operations are queuing, it means the database is processing requests slower than they are arriving. This is caused by CPU saturation, slow Disk I/O, or resource contention.

**🚩 Red Flag:** A flat line at 0 is healthy. Any sustained "hills" or spikes in the Queue depth indicate the cluster is hitting a hardware limit.

## 3. 🐢 Slow Ops (Slow Operations)
**What it is:**
The count of queries taking longer than a specific threshold (e.g., >100ms) to complete.

**Why track it?**
*   **The root cause of connection spikes:** One slow query isn't bad. However, if a query takes 5 seconds, it holds a connection open for 5 seconds. If traffic is high, this causes a "pile-up" (Connection Storm).
*   **Performance degradation:** Indicates missing indexes, inefficient aggregations, or "Scanning" (looking at documents it doesn't need to).

**🚩 Red Flag:** A sharp rise in the count of "Scanned Objects" or query times exceeding 1s.

## 4. 🎫 Tickets (WiredTiger Read/Write Tickets)
**What it is:**
Specific to the WiredTiger storage engine. Think of these as "entry passes." By default, MongoDB usually allows **128 concurrent active reads** and **128 concurrent active writes**.
*   When a query starts, it takes a ticket.
*   When it finishes, it returns the ticket.

**Why track it?**
*   **Concurrency Death Spiral:** If the "Available Tickets" graph drops to 0, the database effectively hangs. No new work can start.
*   **Correlation:** Tickets usually run out because the **Disk I/O** is too slow (queries take too long to return the ticket) or **CPU** is choked.

**🚩 Red Flag:** If "Available Tickets" drops below 100 (on a standard configuration), your database is struggling to keep up with concurrency. **0 tickets = Outage.**

## 5. 🔁 Replication Lag
**What it is:**
The time difference (in seconds) between an operation writing to the **Primary** node and that same operation being written to the **Secondary** nodes.

**Why track it?**
*   **Data Safety:** If the Primary crashes and you have 10 seconds of lag, you just lost 10 seconds of data during the failover.
*   **Read Consistency:** If your app reads from Secondaries (Read Preference: `secondaryPreferred`), users might see stale data (e.g., they update their profile, refresh, and still see the old name).
*   **Oplog Window:** Heavy lag can cause the Secondary to fall off the Oplog (the transaction log), requiring a full (and painful) resync.

**🚩 Red Flag:** Lag consistently > 2–5 seconds during normal operations.

---

### 💡 Summary for your Dashboard View:
If you are building a custom view in Datadog, Grafana, or just staring at Atlas, arrange these 5 charts next to each other.

1.  **Connections** (Is the door jammed?)
2.  **Queues** (Is the Waiting Room full?)
3.  **Tickets** (Are the workers overwhelmed?)
4.  **Slow Ops** (Are we doing hard work or efficient work?)
5.  **Replication Lag** (Are the backups keeping up?)

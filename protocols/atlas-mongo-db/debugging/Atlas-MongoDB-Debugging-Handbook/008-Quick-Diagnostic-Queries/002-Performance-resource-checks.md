Based on the structure of your **Atlas MongoDB Debugging Protocols Handbook**, the file `008-Quick-Diagnostic-Queries/002-Performance-resource-checks.md` corresponds to **Section 8 (Quick Diagnostic Queries & Commands)**.

This specific file is designed to provide **copy-paste shell (`mongosh`) commands** that give you an immediate, raw look at the underlying resources (CPU, Memory, Disk, Locks) without relying on the Atlas UI graphs.

Here is a detailed explanation of what is inside this file, why it matters, and how to interpret the results.

---

# 📂 Explanation: 002-Performance-resource-checks.md

### **Context**
When the Atlas UI is lagging, or when you need exact numbers to confirm a suspicion (e.g., "Is the cache actually full?"), you use these queries. They interact directly with the database engine (WiredTiger) to see how it is handling resources.

### **The 3 Core Checks in this File**
Usually, this file contains queries covering three specific areas:
1.  **Memory & Cache Health** (WiredTiger Cache)
2.  **Concurrency & Tickets** (CPU/Throughput availability)
3.  **Storage & Data Size** (Disk footprint)

---

## 1. 🧠 Memory Check: WiredTiger Cache Status
MongoDB relies heavily on RAM. The **WiredTiger Cache** is where working data lives. If the cache is full of "dirty" data (data modified but not written to disk yet), the database stalls to flush it to the disk.

#### **The Query:**
```javascript
db.serverStatus().wiredTiger.cache['maximum bytes configured']
db.serverStatus().wiredTiger.cache['bytes currently in the cache']
db.serverStatus().wiredTiger.cache['tracked dirty bytes in the cache']
```

#### **How to Interpret (The "Red Flags"):**
*   **Dirty Bytes:** If `tracked dirty bytes` approaches 5% to 20% of the `maximum bytes configured`, MongoDB starts pausing operations to write to the disk. This causes **latency spikes**.
*   **Cache Utilization:** If `bytes currently in the cache` is close to `maximum bytes configured` (usually >95%), it means your working set (the data your app frequently accesses) fits in RAM *just barely*. If queries scan data outside this cache, you will hit **Disk I/O** (which is slow).

---

## 2. 🎟️ Concurrency Check: Read/Write Tickets
MongoDB uses a "Ticket" system (semaphores) to control how many operations can happen simultaneously inside the storage engine. 

#### **The Query:**
```javascript
db.serverStatus().wiredTiger.concurrentTransactions
```

#### **The Output Look:**
```json
{
  "write": { "out": 0, "available": 128, "totalTickets": 128 },
  "read": { "out": 5, "available": 123, "totalTickets": 128 }
}
```

#### **How to Interpret (The "Red Flags"):**
*   **Available Tickets:** Standard Atlas clusters usually have **128** tickets.
*   **The Danger Zone:** If `available` drops close to **0**, strictly queuing occurs.
    *   **Low Read Tickets:** You have slow queries clogging the CPU.
    *   **Low Write Tickets:** You have disk saturation or massive lock contention.
*   **Diagnostic:** If you see `available: 0`, your detailed diagnosis (Protocol 4.3 or 4.4) is confirmed: The DB is choked.

---

## 3. 🔒 Queuing Check: Global Locks
Are operations waiting in line because the CPU or Disk is too busy to serve them?

#### **The Query:**
```javascript
db.serverStatus().globalLock.currentQueue
```

#### **The Output Look:**
```json
{
  "total": 15,
  "readers": 10,
  "writers": 5
}
```

#### **How to Interpret (The "Red Flags"):**
*   **Total:** Ideally, this should be **0** or very low single digits.
*   **High Queue:** If typically `total` is 0, but suddenly it is **50+**, your database is saturated. It cannot process requests as fast as the application is sending them. This usually precedes a "Connection Storm."

---

## 4. 💽 Storage Stats: Database Size
Sometimes performance drops because a specific collection grew unexpectedly (e.g., a logs collection that wasn't capped), consuming all RAM.

#### **The Query:**
```javascript
// Get stats scaled to Gigabytes
db.stats(1024*1024*1024)
```

#### **How to Interpret:**
*   **dataSize:** How much raw data you have.
*   **indexSize:** **Critical Metric.** If `indexSize` > `System RAM`, your performance *will* degrade because indexes must be swapped to disk constantly.

---

## 📝 Summary: How to use this file
When you are in the **"Fast Triage"** phase (Section 2 of your Handbook) and you have shell access:

1.  Run the **Ticket Check** first. If tickets are low, you have a congestion problem.
2.  Run the **Cache Check**. If "dirty bytes" are high, you have a Disk I/O problem.
3.  Run the **Queue Check**. If queues are high, you have a specific slow query or hardware limit issue.

This file provides the "pulse check" numbers to decide which deep-dive Protocol (Section 5) to run next.

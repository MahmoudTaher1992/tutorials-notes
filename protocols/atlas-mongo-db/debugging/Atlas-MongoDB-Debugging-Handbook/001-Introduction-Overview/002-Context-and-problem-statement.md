Based on the Table of Contents you provided, here is a detailed explanation of what goes into the **1.2 Context & problem statement** section.

This section is the "Why are we here?" phase of the handbook. It prevents engineers from wasting time debugging the database when the problem might actually be in the application code or the network layer.

Here is the deep dive into its two core components:

---

### Part 1: ⚡ DB Bottleneck Confirmation (Excluding ECS / Caddy)

Before assuming MongoDB is the villain, this section mandates a "process of elimination." In a typical architecture, a request flows like this:
**User → Load Balancer/Proxy (Caddy) → Application Server (ECS) → Database (MongoDB).**

This part of the document explains that you must ensure the failure is actually happening at the end of that chain.

*   **The Problem:** Sometimes the App (ECS) is slow because of bad code, or the Proxy (Caddy) is misconfigured, but it *looks* like a database error because the user sees a "504 Gateway Timeout."
*   **The Check:**
    *   **Check ECS (Elastic Container Service):** Is the Application CPU at 100%? If yes, the app is crashing on its own calculation, not waiting for the DB.
    *   **Check Caddy/Load Balancer:** Are there 502/504 errors? If Caddy says "upstream connect error," it often means the App isn't responding.
*   **The Confirmation:** You only proceed with this MongoDB handbook if:
    *   App CPU/Memory is normal.
    *   App logs explicitly say `MongoTimeoutError` or `ConnectionPoolTimeout`.
    *   New Relic/Datadog spans show a long purple bar (Database duration) and a short green bar (App duration).

### Part 2: 🚨 Connection Saturation Alert (`Connections % > 80`)

Once you confirm the DB is the bottleneck, this section defines the specific *type* of incident this handbook addresses: **Connection Saturation.**

*   **The Metric:** MongoDB has a hard limit on how many simultaneous connections it can accept (based on instance size, e.g., M30, M50).
    *   *Formula:* `(Current Connections / Max Configured Connections) * 100`.
*   **The Threshold (80%):**
    *   This section explains that **80% is the danger zone**.
    *   When you cross 80% (e.g., the **85.3%** example mentioned), the database usually stops processing queries efficiently because it creates a "Connection Storm."
    *   The CPU spends more time shaking hands with new clients (authentication/SSL) than actually reading data.
*   **The Symptom:**
    *   The application cannot open a new connection.
    *   Existing queries become incredibly slow because the CPU is fighting to manage the queue.
    *   This is distinct from "High CPU due to a breakdown" or "Running out of Disk Space." This is specifically about **concurrency**.

---

### Summary: The "Go/No-Go" Decision

**Section 1.2 essentially tells the reader:**

> "Do not use these protocols if your application server is on fire. Only use this handbook if you have proven the app is waiting on the database, **AND** you see your connection count rising dangerously close to (or above) 80% of the limit."

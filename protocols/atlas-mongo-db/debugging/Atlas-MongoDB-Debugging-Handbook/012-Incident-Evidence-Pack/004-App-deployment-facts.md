Based on the context of the **Atlas MongoDB Debugging Protocols Handbook**, here is the detailed explanation for the file labeled **`012-Incident-Evidence-Pack/004-App-deployment-facts.md`**.

---

### 📂 File: `004-App-deployment-facts.md`
**Part of:** Section 12 (Incident Evidence Pack)  
**Goal:** To capture the "Client-Side" configuration and state at the exact moment of the incident.

### 1. The "Why" (Context)
Database issues are rarely caused by the database acting alone. They are usually caused by the *application* asking the database to do something efficient or overwhelming.

In your specific context (a **Connection Saturation** incident where `Connections % > 80`), looking at the database metrics is only half the battle. You need to know **who** is opening those connections and **how** they are configured.

This file serves as the **"Defense Exhibit"** to prove whether the application architecture caused the database bottleneck.

### 2. Key Information to Record (The "Facts")
When filling out this evidence file during or after an incident, you focus on three specific areas:

#### A. The Scale (The "Multiplier Effect")
This is the most critical factor for connection saturation.
*   **Infrastructure Type:** (e.g., AWS ECS, Kubernetes, EC2, Serverless/Lambda).
*   **Instance Count:** How many application instances (containers/pods) were running during the incident?
    *   *Why it matters:* If you have autoscaling enabled, a traffic spike might increase your App ECS tasks from 5 to 50.
*   **Autoscaling Events:** Did the app scale up right before the DB alerted?

#### B. The Driver Configuration (The "Equation")
This explains how the application *talks* to MongoDB.
*   **Language/Framework:** (e.g., Node.js/Mongoose, Python/PyMongo, Go).
*   **Connection Pool Size (`maxPoolSize`):** What is the hard limit of connections **per container**?
*   **Connection String Options:** Are there settings for `socketTimeoutMS`, `connectTimeoutMS`, or `waitQueueTimeoutMS`?

> **🛑 The Critical Calculation:**
> To debug a connection storm, you must document this math in this file:
> `(Number of App Containers) x (maxPoolSize per Container) = Total Possible Connections`
>
> *Example:* 20 ECS Tasks x 100 Pool Size = **2,000 Potential Connections**. If your Atlas tier limit is 1,500, **your app deployment facts prove the crash was architectural, not a DB failure.**

#### C. Recently Deployed Changes
*   **Git Commit/Tag:** What version was running?
*   **Deployment Time:** Did the incident start 5 minutes after a deployment?
*   **Code Changes:** Did the new deploy introduce a new feature that uses a heavy aggregation query or a `lookup` running on the dashboard?

---

### 3. Example Template
Here is what the content of `004-App-deployment-facts.md` should actually look like when filled out:

```markdown
# ⚙️ App Deployment Facts & Configuration
**Incident ID:** INC-2023-10-24
**Service Name:** Payment-Service-API

## 1. Infrastructure State
- **Environment:** Production / AWS ECS
- **Container Count (Normal):** 4
- **Container Count (During Incident):** ⚠️ 25 (Autoscaling triggered due to CPU)
- **Restart Loop:** Yes, containers were crashing and restarting (causing connection churn).

## 2. MongoDB Driver Config
- **Driver:** Node.js Mongoose v6.8
- **Connection String Settings:**
    - `maxPoolSize`: 50
    - `minPoolSize`: 5
    - `maxIdleTimeMS`: 30000
- **The Calculation:**
    - 25 Containers x 50 Pool Size = **1,250 Max Connections**
    - **Atlas Limit:** 1,500 (We were close to the limit, leaving no room for other services).

## 3. Deployment Context
- **Last Deploy Time:** 2023-10-24 @ 14:00 UTC
- **Version:** v2.4.5
- **Suspect Change:** Added a new background cron job running `updateMany` every minute without an index.
```

### 4. How to use this in Post-Mortem
When you present your findings to the team:
1.  Open the **Atlas Graph** showing connection spikes.
2.  Open this **App Deployment Facts** file.
3.  **Correlate:** "You can see here that Atlas connections peaked at 14:15. This file confirms that ECS autoscaled from 4 to 25 tasks at 14:12. The database didn't fail; the application flooded it."

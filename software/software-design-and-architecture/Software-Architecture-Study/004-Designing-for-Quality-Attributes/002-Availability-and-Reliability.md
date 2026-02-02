This section is crucial because, as an architect, you aren't just paid to make software that *works*; you are paid to make software that **keeps working** when things go wrong.

Here is a detailed breakdown of **004-Designing-for-Quality-Attributes/002-Availability-and-Reliability**.

---

# 002. Availability and Reliability

## 1. Defining the Terms: It’s Not Just "Uptime"

While often used interchangeably, these two concepts are distinct metrics in systems engineering.

*   **Reliability:** The probability that a system will produce correct outputs without failure over a given period. It answers: *"Does the system crash often?"*
    *   **Key Metric:** **MTBF** (Mean Time Between Failures).
*   **Availability:** The percentage of time a system is operational and accessible when required. It answers: *"Is the system there when I try to access it?"*
    *   **Key Metric:** **“The Nines”** (e.g., 99.9% or 99.999% uptime).

> **Architectural Insight:** A system can be highly *available* but not perfectly *reliable*. For example, if a microservice crashes every 10 minutes (low reliability) but restarts automatically in 5 milliseconds (high recoverability), the users might never notice the downtime, resulting in high *availability*.

---

## 2. High Availability (HA) and Fault Tolerance

**High Availability** is a system design approach that ensures a prearranged level of operational performance (usually uptime) for a specific period. "Fault Tolerance" is the capability of a system to continue operating properly in the event of the failure of some of its components.

### Strategies to achieve HA:
The primary enemy of HA is the **Single Point of Failure (SPOF)**. If one component failure brings down the whole system, you do not have HA.

1.  **Eliminate SPOFs:** Every layer (Load Balancer, Web Server, Database) must have backup instances.
2.  **Graceful Degradation:** If a recommendation engine fails, the e-commerce site should not crash. It should simply show specific products instead of personalized ones. The system remains "Available," just with reduced functionality.

---

## 3. Redundancy and Failover Strategies

Redundancy means having extra components that are not strictly necessary for functioning if everything goes right, but are essential if things go wrong.

### A. Redundancy Models
*   **Active-Passive (Master-Slave/Standby):**
    *   **How it works:** One server handles traffic (Active). The other sits idle (Passive), replicating data. Only if Active dies does Passive take over.
    *   **Pro:** Easier to reason about; no data conflict issues.
    *   **Con:** Waste of resources (you pay for a server you aren't using); slower failover (time needed to promote the slave).
*   **Active-Active (Master-Master):**
    *   **How it works:** Both servers handle traffic simultaneously. A load balancer distributes requests between them.
    *   **Pro:** Higher throughput; instant failover (if one dies, the LB just stops sending traffic there).
    *   **Con:** Much more complex. You have to handle data synchronization conflicts (e.g., User A updates their profile on Server 1, User B updates the same profile on Server 2 at the exact same second).

### B. Failover
This is the operational process of switching to the redundant system.
*   **Health Checks:** Automated "pings" that ask "Are you alive?"
*   **Circuit Breakers:** A pattern (often in code) that detects if a service is failing and stops sending requests to it to prevent cascading failures across the system.

---

## 4. Disaster Recovery (DR) Planning

**HA** handles everyday failures (a hard drive breaks, a server crashes).
**DR** handles catastrophic events (data center floods, region outage, massive cyberattack).

As an architect, you must define two critical business metrics with stakeholders:

1.  **RTO (Recovery Time Objective):** "How long can we afford to be down?"
    *   *Example:* If RTO is 1 hour, we must be back online within 60 minutes of the disaster.
2.  **RPO (Recovery Point Objective):** "How much data can we afford to lose?"
    *   *Example:* If RPO is 5 minutes, we must back up data every 5 minutes. If a crash happens, we lose only the last 5 minutes of data.

> **Trade-off:** The lower the RTO/RPO (closer to zero), the exponentially higher the cost of the infrastructure.

---

## 5. CAP Theorem (Brewer's Theorem)

This is the "Physics" of distributed systems. It states that a distributed data store can only provide **two** of the following three guarantees:

1.  **Consistency (C):** Every read receives the most recent write or an error. (Everyone sees the same data at the same time).
2.  **Availability (A):** Every request receives a (non-error) response, without the guarantee that it contains the most recent write. (The system acts even if nodes are disconnected).
3.  **Partition Tolerance (P):** The system continues to operate despite an arbitrary number of messages being dropped or delayed by the network between nodes.

**The Reality:** In a distributed system (cloud), network failures occur (**P** is inevitable). Therefore, you **must** choose between **CP** or **AP**.
*   **CP (Consistency + Partition Tolerance):** If the network splits, the system shuts down or returns errors to ensure data doesn't get out of sync. (Crucial for Banking/Finance).
*   **AP (Availability + Partition Tolerance):** If the network splits, the system keeps accepting writes, even if the data might be temporarily inconsistent between nodes. (Crucial for Social Media feeds/Shopping Carts).

---

## 6. ACID vs. BASE

These are the consistency models you choose based on the CAP theorem.

### ACID (The "Strict" Approach)
Usually associated with Relational Databases (SQL like PostgreSQL, Oracle).
*   **A - Atomicity:** All-or-nothing transactions.
*   **C - Consistency:** Database moves from one valid state to another valid state.
*   **I - Isolation:** Transactions don't interfere with each other.
*   **D - Durability:** Once saved, it stays saved (even if power fails).
*   *Use case:* Financial ledgers, inventory management where exact count matters.

### BASE (The "Flexible" Approach)
Usually associated with NoSQL Databases (MongoDB, Cassandra, DynamoDB).
*   **BA - Basically Available:** The system guarantees availability.
*   **S - Soft State:** The state of the system may change over time, even without input (due to eventual consistency replication).
*   **E - Eventual Consistency:** The system will *eventually* become consistent once it stops receiving input.
*   *Use case:* Likes on a post, comments, analytics data. It is okay if I see 100 likes and you see 101 likes for a few seconds, as long as the system is fast.

### Summary for the Architect
When designing for **Availability and Reliability**:
1.  **Identify SPOFs** and remove them via redundancy.
2.  **Determine RTO/RPO** based on business budget and risk tolerance.
3.  **Make the CAP Choice:** Does this specific feature need to be strictly correct (Banking/CP) or always accessible (Social/AP)? You cannot have both perfectly in a distributed system.

Based on the Table of Contents you provided, here is a detailed explanation of **Part I: Availability / A. Core Concepts and Principles**.

This section sets the foundation for how we keep cloud systems running, measuring their reliability, and handling failures.

---

### 1. High Availability (HA) vs. Disaster Recovery (DR)

While these two terms are often used together, they solve different problems.

#### High Availability (HA)
*   **The Goal:** To keep the system operational and accessible during normal times and minor failures. It focuses on **uptime**.
*   **How it works:** It eliminates single points of failure. If one server crashes, another takes over immediately. Users usually don’t notice anything happened.
*   **The Scale:** Usually handles component failures (e.g., a hard drive failure, a server crash, or a software bug).
*   **The Metric:** Measured in "nines" (e.g., 99.99% availability).
*   **Analogy:** A twin-engine airplane. If one engine fails, the plane can still fly using the other engine.

#### Disaster Recovery (DR)
*   **The Goal:** To restore the system and its data after a catastrophic event. It focuses on **survival and restoration**.
*   **How it works:** It involves backups, replication to a different geographical region, and a manual or automated "runbook" to rebuild the environment.
*   **The Scale:** Handles site-wide or regional failures (e.g., a data center flood, an earthquake, a major cyberattack/ransomware, or a massive human error deleting the database).
*   **Key Metrics:**
    *   **RTO (Recovery Time Objective):** How long can you afford to be down? (e.g., "We must be back up within 4 hours").
    *   **RPO (Recovery Point Objective):** How much data can you afford to lose? (e.g., "We can only lose the last 15 minutes of data").
*   **Analogy:** The airplane crashes. DR is the insurance policy that buys you a new plane and the backup data that lets you load your flight plans back into the computer.

**Summary:** HA is about **staying up** despite small failures. DR is about **getting back up** after big failures.

---

### 2. Key Performance Indicators (KPIs)
To manage availability, you must measure it. In Cloud Architecture (specifically Site Reliability Engineering - SRE), we use three distinct acronyms: **SLI, SLO, and SLA**.

#### SLI (Service Level Indicator) - "The Measurement"
*   This is the actual number you measure. It represents the current state of your system.
*   **Examples:** Latency (how fast pages load), Error Rate (percentage of 500 errors), or Throughput (requests per second).
*   *Statement:* "Our current uptime is 99.8%."

#### SLO (Service Level Objective) - "The Goal"
*   This is the internal target the engineering team aims for. It is usually slightly stricter than the SLA. If you break your SLO, you pause new feature releases to fix stability issues.
*   *Statement:* "We aim for 99.9% uptime."

#### SLA (Service Level Agreement) - "The Contract"
*   This is the legal or formal promise made to the customer. If you breach this, there are consequences (usually financial credits or refunds).
*   *Statement:* "If we provide less than 99.0% uptime, we will refund 10% of your monthly bill."

**The Relationship:**
You measure the **SLI** to see if you are meeting your **SLO**. If you miss the SLO badly enough, you breach the **SLA** and owe money.

---

### 3. Redundancy and Failover
This is the physical implementation of High Availability.

#### Redundancy
Redundancy means having more than one of a critical component. "Two is one, and one is none."
*   **Active-Active:** You have two servers (Server A and Server B). Both are running and taking traffic at the same time. If A dies, B simply takes the full load.
    *   *Pro:* No downtime during switch.
    *   *Con:* More complex to keep data synchronized.
*   **Active-Passive:** You have Server A (primary) taking all traffic. Server B (standby) is turned on but sitting idle. If A dies, B wakes up and takes over.
    *   *Pro:* Easier to manage data.
    *   *Con:* There is a slight delay while B takes over.

#### Failover
Failover is the **process** of switching from the broken component to the redundant one.
*   **Automatic Failover:** The system detects a crash (using Health Checks) and automatically redirects traffic. This is the gold standard for Cloud.
*   **Manual Failover:** A human engineer receives an alert, logs in, and presses a button to switch traffic. This is slower and more prone to error.

**Common Implementation:**
*   **Load Balancer:** A device sits in front of your web servers. It checks if they are alive. If a server stops responding, the Load Balancer stops sending it users and sends them to the healthy servers instead.

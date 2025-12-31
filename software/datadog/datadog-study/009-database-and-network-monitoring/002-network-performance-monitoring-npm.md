Based on the Table of Contents provided, here is a detailed explanation of **Part IX, Section B: Network Performance Monitoring (NPM)**.

---

# 009-Database-and-Network-Monitoring
## 002-Network-Performance-Monitoring-NPM

**Datadog Network Performance Monitoring (NPM)** is a tool designed to provide visibility into network traffic between services, containers, and availability zones. Unlike traditional network monitoring (which looks at switches and routers via SNMP), Datadog NPM focuses on application-layer connectivity—specifically, how the network impacts the performance of your code.

Here is a deep dive into the three specific concepts listed in your Table of Contents.

---

### 1. Flow Logs vs. eBPF-based NPM

This section distinguishes between the two primary ways to gather network data in modern environments. Datadog NPM primarily relies on the latter (eBPF).

#### **Flow Logs (The Traditional Cloud Method)**
*   **What they are:** Cloud providers (AWS VPC Flow Logs, Azure NSG Flow Logs, GCP VPC Flow Logs) generate records of traffic entering and leaving network interfaces.
*   **How they work:** They are like a phone bill—they tell you who called whom, how long the call lasted, and how many bytes were transferred.
*   **Limitations:** They are often delayed (not real-time), sampled (don't show every packet), and lack deep performance metrics (like TCP retransmits).
*   **Datadog Usage:** Datadog can ingest these for security and audit purposes, but they are not the primary engine for *Performance* Monitoring.

#### **eBPF-based NPM (The Datadog Method)**
*   **What is eBPF?** Extended Berkeley Packet Filter (eBPF) is a revolutionary technology in the Linux kernel. It allows programs to run safely inside the kernel without changing the kernel source code or loading modules.
*   **How Datadog uses it:** The Datadog Agent includes a component called the **System Probe**. This probe uses eBPF to inspect network packets *as they pass through the OS kernel*.
*   **The Advantage:**
    *   **Extremely Low Overhead:** It is much lighter than packet capturing (PCAP).
    *   **Deep Visibility:** It can measure **TCP Retransmits** (a key sign of network congestion) and **Round Trip Time (RTT)**.
    *   **Encryption Agnostic:** Because it looks at the TCP/UDP headers in the kernel, it can analyze the *performance* of the connection even if the payload inside (HTTPS) is encrypted.

---

### 2. Network Map (Cross-AZ Traffic, DNS Resolution)

The **Network Map** is the visualization layer of NPM. It automatically draws a map of your infrastructure based on the traffic flowing between nodes.

#### **The Visualization**
Instead of a static diagram that goes out of date instantly, the Network Map is dynamic. You can group nodes by Datadog tags (e.g., `service`, `team`, `env`, or `k8s_cluster`). This allows you to answer questions like: *"Is the Checkout Service talking to the Inventory Service?"*

#### **Cross-AZ Traffic (Availability Zones)**
*   **The Problem:** In cloud environments (like AWS), traffic that stays inside one Availability Zone (e.g., `us-east-1a` to `us-east-1a`) is usually free and fast. Traffic that crosses zones (e.g., `us-east-1a` to `us-east-1b`) costs money and adds latency.
*   **NPM Solution:** Datadog NPM automatically detects and highlights Cross-AZ traffic.
*   **Use Case:** You can visually identify if a Kubernetes pod in Zone A is accidentally connecting to a database in Zone B, incurring hidden cloud costs and slowing down the app.

#### **DNS Resolution**
*   **The Problem:** Sometimes the network is fine, and the app is fine, but the *DNS Server* is slow. If it takes 2 seconds to turn `google.com` into an IP address, the user perceives a 2-second delay.
*   **NPM Solution:** The Datadog System Probe intercepts DNS responses. It can tell you:
    *   Which DNS server is being used.
    *   The volume of DNS failures (NXDOMAIN, SERVFAIL).
    *   The response time of the DNS server.

---

### 3. Connection Tracing

This refers to the granular metrics collected regarding the health of the connections (usually TCP). This is where NPM bridges the gap between "Infrastructure is up" and "Application is fast."

#### **Key Metrics**
*   **Throughput:** Bytes sent/received per second.
*   **TCP Retransmits:** This is the "Golden Signal" of network health.
    *   *Scenario:* Server A sends a packet to Server B. Server B is too busy or the network is congested, so it drops the packet. Server A realizes it didn't get a receipt (ACK), so it sends the packet again (Retransmit).
    *   *Impact:* High retransmits mean the CPU is working harder to send data twice, and the user waits longer. NPM highlights this immediately.
*   **Round Trip Time (RTT):** The time it takes for a signal to go from the client to the server and back. This is pure network latency (excluding application processing time).
*   **Connection Churn:** The rate at which new connections are established and closed. High churn (opening a new DB connection for every user request instead of using a connection pool) destroys performance.

#### **Integration with APM**
Connection tracing allows you to pivot from a slow APM Trace to the underlying Network data.
*   *Example:* APM shows a database query took 5 seconds. You click the trace and switch to the **Network** tab.
*   *Diagnosis:* If Network RTT is 5ms but the query took 5s, the Database is slow (DBA problem). If Network RTT is 4.5s, the network pipe is clogged (Network Engineering problem).

### Summary Table

| Feature | Description | Why it matters |
| :--- | :--- | :--- |
| **eBPF** | Kernel-level technology used by Datadog Agent. | Allows deep monitoring without heavy CPU load or reading encrypted data. |
| **Cross-AZ** | Traffic moving between Cloud Availability Zones. | Major driver of Cloud costs and latency. |
| **Retransmits** | Packets sent more than once due to loss. | The #1 indicator that a network is physically congested or failing. |
| **DNS Monitoring** | Tracking domain name resolution speed. | Identifying if the "slowness" is actually just a slow directory lookup. |

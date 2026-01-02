Here is the summary of the material provided.

**Role:** I am your **DevOps & Observability Instructor**, specializing in cloud infrastructure and system monitoring. I am here to help you understand how we keep computer systems healthy using OpenTelemetry.

---

# OpenTelemetry Infrastructure Monitoring

*   **The Big Picture: Consolidation**
    *   **Definition**
        *   **Infrastructure Monitoring** in OTel is the ability of the **OTel Collector** to gather metrics from the underlying system, not just the application code.
        *   (Instead of just looking at the "software," we look at the "hardware" and the "environment" running it.)
    *   **The "Swiss Army Knife" Approach**
        *   Traditionally, engineers used many different tools for this:
            *   `node_exporter` (for Linux/OS metrics).
            *   `cAdvisor` (for Containers).
            *   Specific exporters (for databases like Redis).
        *   **OpenTelemetry Goal:** Replace all these separate tools with a **single binary** (The OTel Collector).
        *   (Imagine having one super-inspector for a building who checks the electricity, the water, and the security, instead of hiring three separate people.)

*   **1. The Host Metrics Receiver (`hostmetricsreceiver`)**
    *   **Purpose**
        *   Reads system-level usage data directly from the **Host OS** (Linux, Windows, macOS).
        *   (It checks the physical health of the server/computer.)
    *   **Mechanism**
        *   When running as an **Agent** (on every node), it reads the host's `/proc` and `/sys` filesystems.
        *   (It looks at the system's internal "diary" to see how hard the hardware is working.)
    *   **Modular Scrapers** (You pick what you want to measure)
        *   **CPU:** Usage per core (User, System, Idle).
        *   **Memory:** Physical RAM usage and Swap usage.
        *   **Disk/Filesystem:** Read/Write speeds and available storage space.
        *   **Network:** Packets sent/received and errors.
    *   **Why it Matters**
        *   Allows correlation between **Application Latency** and **System Health**.
        *   (If your app is slow, you can check if the computer's "brain"—the CPU—was overloaded at that exact moment.)

*   **2. The Kubelet Stats Receiver**
    *   **Purpose**
        *   Looks specifically at the **Kubernetes Layer**, not just the raw hardware.
        *   (If Host Metrics looks at the "Building," Kubelet Stats looks at the "Room Assignments" and "Tenants.")
    *   **Source of Truth**
        *   Talks to the **Kubelet** (The manager agent on every Kubernetes node).
        *   Tracks how much resource (CPU/RAM) every **Pod** and **Container** is using compared to its allowed limit.
    *   **Key Capabilities**
        *   **Pod/Container Metrics:** Individual usage stats.
        *   **Volume Metrics:** Storage usage for attached disks.
        *   **OOMKilled Detection:** Visualizes if a container runs out of memory and crashes.
    *   **Security & Connection**
        *   Requires a **Service Account** with specific permissions to talk to the Kubelet API.
        *   Uses **TLS** (Secure connection) for authentication.

*   **3. Third-Party Receiver Scrapers**
    *   **The Old Way vs. The OTel Way**
        *   Old Way: Deploy a separate "exporter" program for every database (e.g., `redis_exporter`).
        *   OTel Way: Use **Native Receivers** built into the Collector Contrib distribution.
    *   **Examples of Integrated Receivers**
        *   **Redis:** Connects via `INFO` command to track connected clients, cache hits/misses, and memory fragmentation.
        *   **PostgreSQL:** Connects via connection string to track active connections, commits, and rollbacks.
        *   **Nginx/Apache:** Connects to status pages to track active web connections and requests per second.

*   **4. Architecture & Strategy**
    *   **The DaemonSet (Agent) Pattern**
        *   **Deploy strategy:** Run the OTel Collector as a **DaemonSet**.
        *   (This guarantees that exactly **one** Collector runs on every single computer/node in your cluster.)
    *   **Efficiency**
        *   Since it is on the node, it can easily mount system files (`/proc`) for Host Metrics.
        *   It can talk to `localhost` to reach the Kubelet API quickly.
    *   **The "One Agent" Rule** (The ultimate takeaway)
        *   You can remove legacy tools: `node_exporter`, `telegraf`, `filebeat`, `promtail`.
        *   The **OTel Collector** handles:
            1.  **Host Metrics** (Hardware)
            2.  **Logs** (Text output)
            3.  **App Traces** (Code flow)
        *   (It unifies everything into one workflow, simplifying your system architecture.)

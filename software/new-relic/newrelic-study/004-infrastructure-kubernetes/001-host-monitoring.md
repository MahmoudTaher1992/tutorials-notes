Based on the Table of Contents provided, **Section 004-Infrastructure-Kubernetes / 001-Host-Monitoring** is the foundational layer of infrastructure observability. Before you can monitor complex containers or Kubernetes clusters, you must understand the health of the underlying servers (Virtual Machines, Bare Metal, or Cloud Instances).

In New Relic, this is primarily handled by the **New Relic Infrastructure Agent**, a lightweight executable installed on the server that collects metrics and sends them to the New Relic One platform.

Here is a detailed explanation of the three core pillars of Host Monitoring:

---

### 1. CPU, Memory, Disk, and Network Utilization
This section covers the "Four Golden Signals" applied to the infrastructure level. The agent samples the Operating System (Linux or Windows) usually every 15–60 seconds to answer: *"Is this machine healthy, or is it overwhelmed?"*

In New Relic, this data is primarily stored in the **`SystemSample`** event type.

*   **CPU (Compute):**
    *   **User %:** The CPU time spent running your actual applications. High user % usually means your app is working hard.
    *   **System %:** The CPU time spent on kernel tasks (OS). High system % might indicate driver issues or inefficient OS calls.
    *   **Steal % (Crucial for Cloud):** In AWS/Azure/GCP, you share physical hardware with others. "Steal" time is when your VM wanted CPU cycles, but the Hypervisor said "No, someone else is using it." This indicates a "Noisy Neighbor" problem.
    *   **I/O Wait:** The CPU is idle only because it is waiting for the Disk to finish writing/reading. This indicates a storage bottleneck, not a code issue.

*   **Memory (RAM):**
    *   **Used vs. Free:** How much RAM is left.
    *   **Cached/Buffers:** Linux uses unused RAM to cache files to speed up the system. New Relic distinguishes between "actual used" and "cached" so you don't panic when Linux reports 99% RAM usage (which is often healthy caching behavior).
    *   **Swap Usage:** If RAM is full, the OS writes memory to the disk (Swap). This is extremely slow. High swap usage is a major performance red flag.

*   **Network:**
    *   **Throughput:** Bytes sent vs. Bytes received per second.
    *   **Errors/Dropped Packets:** Indicates bad cabling, switch issues, or a saturated network card.
    *   **Saturation:** Is the bandwidth hitting the limit of the instance type? (e.g., an AWS t3.micro has a network cap).

*   **Disk (Performance/Block Device):**
    *   Note: This refers to the speed of the disk hardware, not the storage space.
    *   **IOPS (Input/Output Operations Per Second):** How many reads/writes happen per second.
    *   **Latency:** How long (in milliseconds) a read or write takes.

---

### 2. Process Usage and Inventory
While the previous section tells you *that* the CPU is high, this section tells you *who* is causing it.

#### **Process Usage**
The Infrastructure Agent watches the specific processes running on the OS (PIDs). In New Relic, this data is stored in the **`ProcessSample`** event type.

*   **Resource Mapping:** It breaks down CPU and Memory usage **per process**.
    *   *Example:* You see CPU is at 95%. You check Process Usage and see that `java.exe` is taking 10%, but a backup script `backup.sh` is taking 85%. You now know the application isn't the problem; the backup script is.
*   **Live Filtering:** You can configure the agent to only track specific processes (e.g., "only track Java and Nginx") to save on data ingestion costs, or track everything for full visibility.

#### **Inventory (Configuration Tracking)**
This is a security and operations feature. The agent scans the system for installed packages, kernel versions, and configuration files.

*   **Change Tracking:** This is the most powerful feature. If someone logs into a server and changes `nginx.conf` or updates a library, New Relic records a **Change Event**.
*   **Correlation:** If your website crashes at 2:00 PM, and Inventory shows a `yum update` or a config change happened at 1:59 PM, you have found your root cause immediately.
*   **Security:** You can search your entire fleet (e.g., 500 servers) to ask: *"Which servers are running the vulnerable version of Log4j?"*

---

### 3. Storage and Filesystem Monitoring
This deals with **Capacity** (Space) rather than Speed. In New Relic, this data is stored in the **`StorageSample`** event type.

*   **Filesystem Usage:**
    *   Tracks specific mount points (e.g., `/`, `/var`, `C:\`).
    *   **Used Bytes vs. Free Bytes:** The classic "Disk Full" monitor.
    *   **Usage Percentage:** Usually the trigger for alerts (e.g., "Alert me if Disk Space > 90%").

*   **Inodes (The Silent Killer):**
    *   On Linux, every file takes up an "Inode." A disk has a finite number of Inodes.
    *   **Scenario:** If an application generates millions of tiny 1KB empty files, your disk might have 500GB of free space (Bytes), but **0 Free Inodes**. The OS will treat the disk as full and the app will crash. New Relic monitors Inode usage specifically to catch this scenario.

*   **Device Mapping:**
    *   It maps the logical filesystem (e.g., `/data`) to the underlying device (e.g., `/dev/sda1`), helping sysadmins understand which physical drive needs to be expanded.

### Summary of Data Flow (NRQL Preview)
When you reach the **NRQL** section of your study path, you will query these concepts using these tables:

| Concept | NRQL Table (Event) | Example Query |
| :--- | :--- | :--- |
| **Host Health** | `SystemSample` | `SELECT average(cpuPercent) FROM SystemSample FACET hostname` |
| **Processes** | `ProcessSample` | `SELECT max(cpuPercent) FROM ProcessSample FACET processDisplayName` |
| **Disk Space** | `StorageSample` | `SELECT average(diskUsedPercent) FROM StorageSample FACET mountPoint` |

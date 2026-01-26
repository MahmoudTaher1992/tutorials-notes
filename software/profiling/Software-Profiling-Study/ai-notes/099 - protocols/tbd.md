This is a great initiative. To make this actionable for a team, we will convert the academic structure of the Table of Contents into a **Field Catalog of Protocols**.

Each protocol is designed as a "Playbook" entry: **Problem → Strategy → Tools (Linux) → Deliverable Report.**

Here is the **Performance Engineering Protocol Catalog**.

---

## 00. The Master Protocol: Triage Strategy
**Context:** Before selecting a specific profile, establish the baseline state.
**Methodology:** The USE Method (Utilization, Saturation, Errors).

*   **Checklist:**
    1.  **Utilization:** Is the resource busy? (e.g., CPU at 90%)
    2.  **Saturation:** Is work queuing up? (e.g., Load avg > CPU cores)
    3.  **Errors:** Are there functional failures? (e.g., HTTP 500s, TCP retransmits)
*   **Tools:** `htop`, `dmesg`, `syslog`
*   **Decision:**
    *   High CPU? → Go to **Protocol 01**
    *   High Memory/OOM? → Go to **Protocol 02**
    *   Slow Response/Blocking? → Go to **Protocol 03** or **04**
    *   Disk Churn? → Go to **Protocol 05**

---

## Protocol 01: CPU Analysis (The "Hot Path")
**Trigger:** High CPU utilization, sluggish processing, fan noise on bare metal, AWS/Cloud CPU credits depleting.

### 1.1 System-Level Analysis
**Goal:** Determine User vs. Kernel space usage.
*   **Tools:**
    *   `mpstat -P ALL 1` (Check for single-core saturation)
    *   `vmstat 1` (Check `us` vs `sy` columns)
*   **Report:** **CPU Utilization Breakdown** (User % vs System % vs Iowait %).

### 1.2 Code-Level Profiling (On-CPU)
**Goal:** Find exactly which function is burning cycles.
*   **Tools (Linux Native):**
    *   **Perf:** `perf record -F 99 -a -g -- sleep 30` (Sample stack traces at 99Hz for 30s).
    *   **eBPF:** `profile.py -F 99 -f 30` (BCC tool).
*   **Tools (Language Specific):**
    *   **Java:** Async Profiler / JFR.
    *   **Go:** `go tool pprof`.
    *   **Node:** `perf` (with `--perf-basic-prof-only-functions`).
*   **Deliverable Report:** **The Flame Graph**.
    *   *Interpretation:* Look for wide "plateaus" (functions taking the most time).
    *   *Action:* Identify if time is spent in business logic, serialization (JSON), or garbage collection.

---

## Protocol 02: Memory Forensics
**Trigger:** OOM Kills, gradual increase in RAM usage (Leaks), frequent GC pauses.

### 2.1 Usage & Saturation
**Goal:** Distinguish between actual usage and cache.
*   **Tools:**
    *   `free -m` (Check "Available" vs "Free").
    *   `vmstat 1` (Watch `si`/`so` for Swap usage/Thrashing).
    *   `dmesg | grep -i "out of memory"` (Check for OOM Killer intervention).
*   **Report:** **Memory Composition Chart** (RSS vs. Page Cache vs. Swap).

### 2.2 Leak Detection (Native/C++)
**Goal:** Find un-freed memory.
*   **Tools:**
    *   `valgrind --tool=massif ./app` (Heap profiler).
    *   eBPF: `memleak.py` (BCC tool to trace outstanding allocs).
*   **Report:** **Allocation Growth Chart** over time.

### 2.3 Managed Runtime Analysis (GC)
**Goal:** Analyze Object Churn.
*   **Tools:**
    *   **Java:** `jstat -gc <pid> 1000` (Watch Eden/Survivor/Old Gen capacity).
    *   **Node:** `node --inspect` + Chrome DevTools Memory Tab.
*   **Deliverable Report:** **Heap Dump Dominator Tree**.
    *   *Action:* Identify "Retained Size" vs "Shallow Size" to find objects holding references preventing GC.

---

## Protocol 03: Latency & Blocking (Off-CPU Analysis)
**Trigger:** Application responds slowly, but CPU usage is low. The app is "waiting" for something.

### 3.1 Thread State Analysis
**Goal:** Are threads sleeping, waiting for locks, or waiting for I/O?
*   **Tools:**
    *   `pidstat -t -p <PID> 1` (View stats per thread).
    *   `vmstat 1` (Check `b` column for blocked processes).
*   **Report:** **Thread State Distribution** (Running vs. Sleeping vs. Blocked).

### 3.2 Lock Contention Profiling
**Goal:** Identify Mutex/Spinlock contention.
*   **Tools:**
    *   **Perf:** `perf record -e sched:sched_switch -g -p <PID>` (Record context switches).
    *   eBPF: `offcputime.py` (Generate Off-CPU flame graphs).
*   **Deliverable Report:** **Off-CPU Flame Graph**.
    *   *Interpretation:* The "flames" show where the program is *waiting*, not executing.
    *   *Action:* Look for database driver waits, mutex locks, or explicit `sleep()` calls.

---

## Protocol 04: I/O Subsystem (Disk & Network)
**Trigger:** High `iowait`, slow database queries, slow file uploads/downloads.

### 4.1 Disk Profiling
**Goal:** Identify if the disk speed is the bottleneck.
*   **Tools:**
    *   `iostat -xz 1` (Key metric: `%util` and `await`).
    *   `iotop` (Find which process is hammering the disk).
    *   `biosnoop.py` (eBPF: Measure latency per disk operation).
*   **Report:** **Disk Latency Heatmap** or **IOPS Saturation Report**.

### 4.2 Network Profiling
**Goal:** Analyze packet loss, retransmits, and bandwidth.
*   **Tools:**
    *   `sar -n TCP,ETCP 1` (Check for retransmits).
    *   `ss -ti` (Inspect TCP info like RTT and congestion window).
    *   `tcpdump -i eth0 -w capture.pcap` (For Wireshark analysis).
*   **Deliverable Report:** **TCP Health Check** (Retransmission rates, Window clamping).

---

## Protocol 05: Runtime-Specific Tooling Reference
**Context:** Use these specific tools based on the stack being profiled.

| Language | Primary Profiler | Visualization | Key Flag/Command |
| :--- | :--- | :--- | :--- |
| **Java** | JFR / Async Profiler | JMC / FlameGraph | `-XX:StartFlightRecording` |
| **Go** | pprof | Go Web UI | `go tool pprof -http=:8080 cpu.prof` |
| **Node.js** | 0x / V8 Profiler | Chrome DevTools | `0x -o app.js` |
| **Python** | py-spy | Speedscope | `py-spy record -o profile.svg --pid <PID>` |
| **C/Rust** | perf | Firefox Profiler | `perf record -g -- <cmd>` |

---

## Protocol 06: Continuous Profiling Setup
**Context:** For capturing transient issues in production that cannot be reproduced locally.

### 6.1 Architecture Check
*   **Agent Deployment:** Ensure `Pyroscope` or `Parca` agent is running as a sidecar or daemonset.
*   **Overhead Monitor:** Ensure profiling overhead is < 2% CPU.

### 6.2 Analysis Workflow
**Goal:** Compare performance "Then" vs "Now".
*   **Report:** **Differential Flame Graph**.
    *   *Action:* Select a timeframe during the incident and compare it to a "normal" baseline timeframe. Red sections indicate regression.

---

## Deliverable Templates

When submitting a Performance finding, the engineer must fill out this "Profile Card":

> **Incident/Ticket:** [Link]
> **Protocol Used:** [e.g., Protocol 01 - CPU]
> **Observation:** "Function `JSON.parse` is consuming 40% of CPU cycles during user login."
> **Evidence:** [Attach Flame Graph or console output]
> **Proposed Fix:** "Switch to streaming parser or cache user profile."
> **Verification:** "Benchmark shows CPU drop from 40% to 5%."


Here is the **Report Utility & Value Catalog**. This section is designed to be appended to your protocols.

It provides your engineers with the **"Why"** behind the **"How."** It helps them translate technical charts into business value (Stability, Cost, Speed) when talking to stakeholders.

---

## Appendix: Report Value & Metrics Definition
*Use this reference to interpret data and justify optimization efforts to management.*

### 1. The CPU Flame Graph
**From Protocol:** 01 (CPU Analysis)
**Visual:** Stacked bars of varying widths; x-axis is population (frequency), y-axis is stack depth.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Code Path Frequency:** The width of the bar represents how often that function was found on the CPU. | **Root Cause ID:** Instantly identifies the "Hot Path." Eliminates guessing about which function is slow. | **Cost Reduction:** Reducing the width of the widest bar directly reduces cloud compute costs (EC2/K8s CPU requests). |
| **Stack Depth:** How deep the function calls go. | **Complexity Analysis:** Very deep stacks often indicate excessive abstraction or recursion issues. | **Maintainability:** Identifies overly complex logic that makes features harder to ship. |

---

### 2. The Off-CPU Flame Graph
**From Protocol:** 03 (Latency & Blocking)
**Visual:** Looks like a CPU flame graph, but measures time spent *waiting* rather than working.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Wait Time:** Time spent sleeping, waiting for I/O, or waiting for a Lock. | **Concurrency Debugging:** Highlights mutex contention (threads fighting for the same resource) or slow Database queries. | **User Experience (Latency):** Fixes "The server isn't busy, but the site feels slow" complaints. Improves P99 response times. |
| **Blocking Calls:** Functions that stop execution flow. | **Async Verification:** Proves if "Non-blocking" code is accidentally blocking the Event Loop (Node.js/Netty). | **Scalability:** Ensures the app can handle more concurrent users without freezing. |

---

### 3. The Heap Dominator Tree
**From Protocol:** 02 (Memory Forensics)
**Visual:** A tree view listing objects, sorted by "Retained Size" (percentage of total heap).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Retained Size:** The amount of memory that would be freed if this specific object were deleted. | **Leak Detection:** Distinguishes between massive objects (bloat) and objects holding onto chains of other data (leaks). | **System Stability:** Prevents Out-Of-Memory (OOM) crashes during peak traffic. |
| **GC Roots:** The static variable or thread keeping the data alive. | **Lifecycle Management:** Identifies caches that never expire or sessions that aren't closing. | **Hardware Efficiency:** Allows you to run the application on smaller/cheaper RAM instances. |

---

### 4. The I/O Saturation Heatmap
**From Protocol:** 04 (I/O Subsystem)
**Visual:** A grid showing latency over time. Darker colors = higher latency/queue depth.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Queue Depth:** How many requests are waiting to be written to disk/network. | **Bottleneck Isolation:** Proves if the slowdown is the Application (Code) or the Infrastructure (Disk/Network). | **Vendor Management:** Provides evidence if your Cloud Provider (AWS/Azure) is throttling your disk IOPS. |
| **Service Time:** Actual time the hardware takes to process a block. | **Config Tuning:** Helps tune buffer sizes and connection pools. | **Throughput:** Maximizes the number of transactions processed per second. |

---

### 5. The Differential Profile
**From Protocol:** 06 (Continuous Profiling)
**Visual:** A Flame Graph with Red (Growth) and Blue (Reduction) colors showing the *delta* between two timeframes.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Performance Regression:** The difference in resource usage between Version A and Version B. | **Impact Analysis:** Shows exactly what the new feature code "costs" in terms of resources. | **Risk Mitigation:** Catches performance bugs immediately after deployment, before they cause an outage. |
| **Optimization Verification:** The drop in usage after a fix. | **Success Validation:** visually proves that a fix actually worked (e.g., "See this big blue area? That's the CPU we saved"). | **Team Morale:** visually demonstrates the value of the engineering team's work. |

---

### 6. The Thread State Distribution Chart
**From Protocol:** 03 (Latency & Blocking)
**Visual:** A bar or pie chart breaking down time by state (Run, Sleep, Iowait).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **CPU Saturation vs. Starvation:** Are threads working or begging for CPU time? | **Capacity Planning:** Determines if adding more CPUs will actually help, or if the code is just single-threaded. | **Sizing Accuracy:** Prevents over-provisioning (wasting money buying CPUs that the software can't use). |


To expand your catalog, here are **5 additional high-value reports**. These focus on specific sub-disciplines like Garbage Collection, Microservices, and Kernel interactions.

Add these to your **Protocol** and **Benefit** appendices.

---

### 7. The GC Pause Scatterplot
**Context:** Essential for managed languages (Java, Go, Node.js, Python).
**Protocol Trigger:** "The app has random latency spikes every few minutes," or "Throughput drops periodically."

*   **How to Produce (Linux):**
    *   **Java:** Enable GC logs (`-Xlog:gc*`) -> Visualize with tools like GCViewer or GCeasy.
    *   **Go:** `GODEBUG=gctrace=1` -> Capture stderr -> Plot pause times.
    *   **Node:** `perf_hooks` (Trace Events) or APM agents.
*   **Visual:** X-axis is Time, Y-axis is "Pause Duration" (ms). Each dot is a GC event.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Stop-The-World Events:** Moments when the application freezes to clean memory. | **Tuning Strategy:** Determines if you need a concurrent collector (like ZGC/Shenandoah) or if you are allocating too fast. | **SLA Compliance:** Eliminates the "random" timeouts that violate P99/P99.9 latency agreements. |
| **Frequency of Collections:** How often cleanup happens. | **Allocation Rate Analysis:** High frequency = high object churn code. | **Consistent UX:** Ensures users don't experience "stuttering" performance. |

---

### 8. The Distributed Trace Waterfall (Span Chart)
**Context:** Essential for Microservices or Monoliths talking to Databases/External APIs.
**Protocol Trigger:** "The API is slow, but CPU and Memory are low on this server."

*   **How to Produce:**
    *   **Tools:** OpenTelemetry (Instrumentation) -> Jaeger, Zipkin, or Grafana Tempo.
    *   **Linux Side:** If no APM exists, use `tcpdump` correlated with logs, or `trace` (BCC) to watch specific port traffic.
*   **Visual:** Cascading horizontal bars showing the lifecycle of a single request across multiple systems.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Critical Path:** The sequence of sequential steps that define the total duration. | **Dependency Analysis:** Identifies if the slowdown is internal (code) or external (DB, Redis, 3rd Party API). | **Vendor Accountability:** Proves if a 3rd party service (like a Payment Gateway) is the actual bottleneck. |
| **Gap Analysis:** Empty space between bars. | **Processing Lag:** Highlights time lost in network latency or serialization/deserialization. | **Architecture ROI:** Justifies caching strategies (e.g., "If we cache this, we save 200ms"). |

---

### 9. The Syscall (System Call) Frequency Chart
**Context:** System-level optimization. When code logic seems fast, but execution is slow.
**Protocol Trigger:** High "System" time in `top`, or the application is chatty with the OS.

*   **How to Produce (Linux):**
    *   **Tool:** `syscount-bpfcc` (eBPF) or `strace -c -p <PID>` (Standard).
    *   **Command:** `strace -c -p <PID>` (Summary mode, minimal overhead).
*   **Visual:** A histogram or table ranking Top 10 System Calls by frequency and time accumulated.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Context Switching Cost:** How often the app asks the Kernel to do work (Open file, Read network, Get time). | **I/O Efficiency:** Reveals inefficient patterns (e.g., calling `read()` 1,000 times for 1 byte vs. 1 time for 1,000 bytes). | **Infrastructure Scaling:** Reducing syscalls creates huge efficiency gains, allowing more requests per CPU core. |
| **Error Rates (EAGAIN/ENOENT):** Failed system calls. | **Configuration Validation:** Finds silent failures (e.g., constantly trying to open a config file that doesn't exist). | **Stability:** Reduces the "noise" the OS has to handle, increasing overall system resilience. |

---

### 10. The CPI (Cycles Per Instruction) Flame Graph
**Context:** Advanced / Bare Metal / High-Frequency Trading.
**Protocol Trigger:** "We optimized the code logic, but it's still running slow on the hardware."

*   **How to Produce (Linux):**
    *   **Tool:** `perf` (Linux Profiler).
    *   **Command:** Measure standard cycles vs. stalled cycles.
*   **Visual:** A Flame Graph colored by "Stall" percentage rather than just time.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **CPU Efficiency:** How many CPU cycles are wasted waiting for data from RAM (Cache Misses). | **Data Locality:** Tells engineers they need to restructure data structures (Struct of Arrays vs Array of Structs) to fit in L1/L2 Cache. | **Hardware ROI:** Maximizes the value extracted from expensive server processors. |
| **Branch Mispredictions:** How often the CPU guesses the wrong "if" statement path. | **Algorithm Optimization:** Helps optimize complex conditional logic loops. | **Competitive Advantage:** Critical for ultra-low latency requirements (e.g., real-time bidding). |

---

### 11. The Lock Contention Graph (Wait Chain)
**Context:** Heavily multi-threaded applications (C++, Java, Rust).
**Protocol Trigger:** CPU is low, but the application isn't processing requests parallelly.

*   **How to Produce (Linux):**
    *   **eBPF:** `threadsnoop`, `lockstat`.
    *   **Java:** JFR Lock Profiling.
*   **Visual:** A Directed Graph showing which threads are holding locks that other threads want.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Wait Chains:** Thread A waits for B, which waits for C. | **Deadlock Prevention:** Identifies dangerous circular dependencies before they crash the production environment. | **Reliability:** Prevents total service freezes requiring manual restarts. |
| **Lock Granularity:** How "wide" a lock is (locking the whole DB vs. one row). | **Concurrency Tuning:** Indicates where to switch from coarse-grained locks to fine-grained locks (or lock-free structures). | **Vertical Scalability:** Enables the software to actually utilize 64 or 128 core machines effectively. |

---

### Summary of Report Hierarchy

When your engineers ask **"Which report do I generate?"**, give them this flow:

1.  **Is it crashing?** → `Heap Dominator Tree` (Memory)
2.  **Is it slow but CPU is busy?** → `CPU Flame Graph`
3.  **Is it slow but CPU is idle?** → `Off-CPU Flame Graph` or `Distributed Trace Waterfall`
4.  **Is it "stuttering"?** → `GC Pause Scatterplot`
5.  **Is the OS overloaded?** → `Syscall Frequency Chart`
6.  
Here are **5 additional specialized reports** to deepen your catalog.

These focus on **Containerization**, **Stability**, **Statistical Distribution**, and **Architectural Efficiency**.

---

### 12. The CPU Throttling Matrix (Container Saturation)
**Context:** Critical for Kubernetes (K8s), Docker, or Cgroups environments.
**Protocol Trigger:** "The app is slow, but CPU usage inside the container says only 10%."
**The Reality:** The container might be hitting its hard "limit" (quota) for 100ms, getting paused (throttled), and then resuming, creating "micro-stalls."

*   **How to Produce (Linux):**
    *   **Native:** `cat /sys/fs/cgroup/cpu/cpu.stat` (Look for `nr_throttled`).
    *   **Tools:** `cadvisor` (Prometheus), or eBPF scripts monitoring `sched` tracepoints.
*   **Visual:** A Line Chart comparing `CPU Usage` vs. `CPU Throttling Percentage`.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **CFS Throttling:** How often the Linux Scheduler forcibly paused the process because it used its millisecond quota. | **Configuration Tuning:** Proves that `resources.limits` in K8s are set too low (or `requests` are too low), causing artificial slowness. | **Cost/Performance Balance:** Ensures you aren't paying for cloud resources (RAM) that you can't use effectively because the CPU is choked. |
| **Burst Usage:** Spikes that trigger limits. | **Smoothness:** Identifying bursty behavior helps decide between "Provisioning more CPU" vs "Smoothing traffic." | **Reliability:** Prevents cascading timeouts during startup or traffic spikes. |

---

### 13. The Latency Distribution Histogram (The "Long Tail")
**Context:** Analyzing User Experience beyond averages. Averages hide outliers.
**Protocol Trigger:** "Users complain about slowness, but our dashboard says average response is 200ms."

*   **How to Produce (Linux):**
    *   **eBPF:** `funclatency` (BCC tool) - e.g., `funclatency -m do_sys_open`.
    *   **App Logs:** Parse web server logs (Nginx/Envoy) into buckets.
*   **Visual:** A Bar Chart (Histogram). X-axis = Time Buckets (0-10ms, 10-100ms, 1s+), Y-axis = Count.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Multi-Modal Distribution:** Do you have one "hump" (consistent behavior) or two (fast hits vs. slow misses)? | **Architecture Reality:** Often reveals distinct behaviors (e.g., "Cache Hits" take 5ms, "Cache Misses" take 2s). | **P99 Management:** Targets the specific "Long Tail" requests that frustrate the most valuable (power) users. |
| **Outlier Severity:** How bad is the "worst case"? | **SLA Verification:** Proves whether you are violating strict performance contracts. | **Customer Trust:** Eliminates the "Spinning Wheel of Death" scenarios. |

---

### 14. The Exception Impact Analysis ("Noise" Profile)
**Context:** High-throughput systems where errors are used for flow control.
**Protocol Trigger:** "High CPU usage, but no business logic seems to be running heavy computations."
**The Reality:** Creating an Exception object (filling the stack trace) is extremely expensive in Java/C#/Python.

*   **How to Produce (Linux):**
    *   **Java:** JFR (Exceptions thrown/sec).
    *   **eBPF:** `trace` on exception throw symbols.
    *   **Logs:** Grep/Awk error logs for frequency.
*   **Visual:** Bar chart ranking Top 5 Exceptions by frequency.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Stack Filling Cost:** The CPU time spent walking the stack to generate an error report. | **Code Hygiene:** Identifies "Exceptions as Control Flow" anti-patterns (e.g., throwing "UserNotFound" instead of returning null). | **Infrastructure Efficiency:** We have seen systems regain 30% CPU capacity just by fixing a recurring, silent exception. |
| **Log Volume:** Bandwidth used writing text to disk/network. | **I/O reduction:** Reduces pressure on logging infrastructure (Splunk/ELK). | **Incident Clarity:** Makes logs readable again by removing the "boy who cried wolf" errors. |

---

### 15. The Connection Pool Leaky Bucket
**Context:** Database (SQL) or Upstream Service connectivity.
**Protocol Trigger:** "We added more web servers, but the application got *slower*."

*   **How to Produce:**
    *   **App Metrics:** JMX (Java), Prometheus (Go/Node). Look for "Active Connections," "Idle Connections," and "Threads Waiting for Connection."
    *   **Linux:** `netstat -an | grep :5432 | wc -l` (Count established sockets).
*   **Visual:** Stacked Area Chart (Active vs. Idle vs. Waiting).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Pool Starvation:** Time threads spend waiting to *get* a connection handle. | **Capacity Planning:** Determines the optimal pool size. Too small = waiting; Too big = database thrashing. | **Scalability Limits:** Identifies the hard limit of how many concurrent users the system can handle before falling over. |
| **Leak Rate:** Connections created but never returned. | **Bug Detection:** Finds code paths where `db.close()` is missing. | **Uptime:** Prevents "Connection Reset" errors that require a full service restart. |

---

### 16. The Cache Efficacy Report
**Context:** Systems using Redis, Memcached, or in-memory LRU caches.
**Protocol Trigger:** "The database is overloaded, but we have a cache layer."

*   **How to Produce:**
    *   **Network:** Packet capture (Wireshark) analyzing request patterns.
    *   **Middleware:** Redis `INFO stats` (keyspace_hits / keyspace_misses).
*   **Visual:** Pie Chart (Hit vs. Miss) + Line Chart (Eviction Rate).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Hit/Miss Ratio:** Percentage of requests served from RAM vs. DB. | **Strategy Validation:** If Miss rate is >50%, the cache is useless or configured wrong (TTL is too low). | **Hardware ROI:** Determines if the money spent on large Redis instances is actually generating value. |
| **Eviction Rate:** How often the cache deletes data to make room for new data. | **Sizing Analysis:** High eviction rates mean the cache is too small (thrashing data in and out). | **Latency Stability:** A stable cache means stable response times for the end user. |

---

### Updated Protocol Catalog Index
*Here is the updated "Menu" for your engineers.*

1.  **CPU Flame Graph** (The Hot Path)
2.  **Off-CPU Flame Graph** (The Wait Path)
3.  **Heap Dominator Tree** (Memory Leaks)
4.  **I/O Saturation Heatmap** (Disk/Network Jams)
5.  **Differential Profile** (Before vs After)
6.  **Thread State Distribution** (Concurrency Health)
7.  **GC Pause Scatterplot** (Runtime Stutter)
8.  **Distributed Trace Waterfall** (Microservice Lag)
9.  **Syscall Frequency Chart** (Kernel/OS Efficiency)
10. **CPI Flame Graph** (Hardware/Cache Efficiency)
11. **Lock Contention Graph** (Multithreading Blockers)
12. **CPU Throttling Matrix** (Kubernetes Limits)
13. **Latency Histogram** (The Long Tail)
14. **Exception Impact Analysis** (Error Overhead)
15. **Connection Pool Analysis** (Database Bottlenecks)
16. **Cache Efficacy Report** (Architecture Efficiency)

Here are **5 additional deep-dive reports**.

These focus on **File System Internals**, **Network Quality**, **Database Logic**, and **Scheduler Behavior**. These are advanced protocols usually reserved for senior performance engineers.

---

### 17. The Page Cache Efficiency Report
**Context:** Databases (Postgres/MySQL/Kafka) or Static File Servers (Nginx).
**Protocol Trigger:** "Disk I/O is high, but we have plenty of free RAM. Why isn't Linux caching this?"

*   **How to Produce (Linux):**
    *   **eBPF:** `cachestat` (BCC tool). Measures Page Cache hits vs. misses.
    *   **Native:** `vmtouch` (Tool to visualize what files are currently resident in RAM).
*   **Visual:** Line Chart (Hits/sec vs. Misses/sec) + "Dirty Pages" count.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Cache Hit Ratio:** Percentage of file reads served from RAM instead of hitting the physical disk. | **IOPS Conservation:** A 99% hit ratio means your slow physical disk is irrelevant. A 50% ratio explains why the app is crawling. | **Cost Savings:** High cache efficiency means you can use cheaper/smaller disks (EBS gp3 vs io2) because you read from them less. |
| **Dirty Pages:** Data in RAM waiting to be flushed to disk. | **Write Safety:** High dirty page counts warn of massive "Write Spikes" (blocking) when the kernel finally flushes data. | **Data Integrity:** Helps tune checkpointing to prevent data loss during crashes. |

---

### 18. The TCP Congestion Window (CWND) Plot
**Context:** High-bandwidth data transfers, Video Streaming, or Cross-Region replication.
**Protocol Trigger:** "Download speed is 5MB/s, but we have a 1Gbps link. It’s not the CPU."

*   **How to Produce:**
    *   **Linux:** `ss -ti` (Look for `cwnd` and `ssthresh`).
    *   **Tool:** `tcptrace` (Visualizes Wireshark/tcpdump captures).
*   **Visual:** Time-series chart showing the TCP Window Size growing and collapsing (sawtooth pattern).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Window Collapse:** When the graph drops sharply, a packet was lost. | **Network Diagnostics:** Distinguishes between "Bandwidth Limits" (flat line) and "Packet Loss" (sawtooth drops). | **Transfer Speed:** Optimizing TCP parameters (BBR congestion control) can speed up file transfers by 10x without hardware changes. |
| **RTT (Round Trip Time):** Latency per packet. | **Geographic Tuning:** Shows if the physical distance between client and server is the bottleneck. | **Global Reach:** Justifies the need for CDNs or Edge locations. |

---

### 19. The Slow Query Fingerprint
**Context:** Database Application interactions.
**Protocol Trigger:** "The DB CPU is 100%, but connection counts are normal."
**The Reality:** One specific bad query is running 10,000 times.

*   **How to Produce:**
    *   **Postgres:** `pg_stat_statements`.
    *   **MySQL:** Slow Query Log + `pt-query-digest` (Percona Toolkit).
    *   **MongoDB:** Profiler collection.
*   **Visual:** Table ranking queries by **Total Time** (Frequency × Average Duration).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Query Fingerprint:** Removes specific IDs (e.g., `SELECT * FROM user WHERE id=?`) to group identical logic. | **Index Verification:** Instantly identifies "Full Table Scans" (missing indexes). | **Immediate ROI:** Adding one index to the #1 slow query often solves 80% of performance issues instantly. |
| **Rows Examined vs. Sent:** How much data the DB read vs. how much it actually needed. | **Efficiency:** Highlights "Over-fetching" (reading 1M rows to return 10 results). | **Scalability:** Prevents the database from becoming the single point of failure. |

---

### 20. The Context Switch Type Analysis
**Context:** High concurrency, multi-process systems (Apache, Oracle, legacy apps).
**Protocol Trigger:** "High System CPU usage, app feels 'jerky'."

*   **How to Produce (Linux):**
    *   **Native:** `pidstat -w -p <PID> 1` (Compare `cswch/s` vs `nvcswch/s`).
    *   **Perf:** `perf sched record` -> `perf sched map`.
*   **Visual:** Stacked Bar Chart comparing **Voluntary** vs. **Involuntary** Context Switches.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Voluntary (cswch):** The process gave up the CPU (e.g., "I'm waiting for disk"). | **IO Analysis:** High voluntary switches mean the app is IO-bound (waiting on data). | **Resource Allocation:** Indicates you need faster disks or network, not faster CPUs. |
| **Involuntary (nvcswch):** The OS kicked the process off the CPU (Time slice expired). | **CPU Contention:** High involuntary switches mean you have too many threads fighting for too few cores. | **Stability:** High contention kills responsiveness. This justifies reducing thread pool sizes. |

---

### 21. The DNS Resolution Latency Chart
**Context:** Microservices, Kubernetes, external API consumers.
**Protocol Trigger:** "Random API calls fail or take 5 seconds exactly (timeout default)."
**The Reality:** It's almost always DNS.

*   **How to Produce (Linux):**
    *   **eBPF:** `dnsslow` (BCC tool) or `dns-top`.
    *   **Network:** `tcpdump -i eth0 port 53`.
*   **Visual:** Scatterplot of DNS response times (ms).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Resolution Time:** Time from asking "Where is google.com?" to getting the IP. | **Config Debugging:** Finds issues with `ndots` config in Kubernetes or slow upstream DNS servers. | **Reliability:** Prevents "Phantom Outages" where the app is fine, but it can't find its dependencies. |
| **NXDOMAIN Responses:** "Domain not found" errors. | **Misconfiguration:** Spotlights typo'd service names or service discovery failures. | **Cleanup:** Reduces network noise and latency by fixing bad config. |

---

### The Complete Catalog Index (1-21)

To make this easy for your team to use, print this **"Symptom to Report"** Cheat Sheet:

| **Symptom** | **Primary Report** | **Secondary Report** |
| :--- | :--- | :--- |
| **High CPU** | 01. CPU Flame Graph | 20. Context Switch Analysis |
| **Slow Response (Low CPU)** | 03. Off-CPU Flame Graph | 08. Distributed Trace Waterfall |
| **OOM / Crash / Leak** | 02. Memory Dominator Tree | 05. Differential Profile |
| **App "Stutters"** | 07. GC Pause Scatterplot | 12. CPU Throttling Matrix |
| **Database Slow** | 19. Slow Query Fingerprint | 15. Connection Pool Analysis |
| **Disk Slow** | 04. I/O Heatmap | 17. Page Cache Efficiency |
| **Network Slow** | 18. TCP CWND Plot | 21. DNS Latency Chart |
| **Unexplained Slowness** | 09. Syscall Frequency | 13. Latency Histogram |
| **New Deployment Slow** | 05. Differential Profile | 14. Exception Impact |
| **Cache Issues** | 16. Cache Efficacy | - |
| **Hardware Limits** | 10. CPI Flame Graph | 12. CPU Throttling Matrix |



Here are **5 additional specialized reports**, focusing on **Security Performance**, **Scalability Balance**, **Resource Handles**, **Startup Latency**, and **GPU/AI Workloads**.

Following the new reports, I have compiled the **Master Catalog Index**, grouped by **Investigation Phase**, to make it easy for your team to navigate.

---

### 22. The TLS/SSL Handshake Waterfall
**Context:** HTTPS-heavy APIs, Microservices with mTLS, or public-facing gateways.
**Protocol Trigger:** "Connecting to the service takes 200ms, but the request processing is only 10ms."
**The Reality:** The cryptographic negotiation (Handshake) is unoptimized.

*   **How to Produce (Linux):**
    *   **eBPF:** `sslsnoop` or `ssltime` (BCC tools).
    *   **Network:** `tcpdump` filtering on port 443 (analyze Client Hello/Server Hello/Key Exchange).
    *   **CLI:** `curl -w "DNS: %{time_namelookup} TCP: %{time_connect} SSL: %{time_appconnect}\n" ...`
*   **Visual:** A segmented bar chart breaking down the "Connection Phase."

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Handshake Duration:** Time to negotiate encryption keys. | **Cipher Suite Tuning:** Identifies if you are using expensive keys (RSA 4096) when cheaper ones (ECDSA) would suffice. | **Latency Reduction:** Dramatically speeds up the "first impression" for mobile users on high-latency networks. |
| **Session Resumption:** Are we reusing previous keys? | **Keep-Alive Verification:** Confirms that `Keep-Alive` is working, avoiding the handshake entirely for subsequent calls. | **CPU Savings:** Encryption is CPU heavy. Reducing handshakes reduces server CPU load. |

---

### 23. The Load Balancer Skew Map
**Context:** Distributed systems (Kubernetes Ingress, Nginx, HAProxy).
**Protocol Trigger:** "One specific server crashed, but the other 9 were idle."
**The Reality:** The load balancing algorithm (Round Robin, Least Connections) isn't working, or sticky sessions are clumping users.

*   **How to Produce:**
    *   **Logs:** Aggregate access logs by `upstream_addr`.
    *   **Linux:** `ipvsadm -L --stats` (If using IPVS).
*   **Visual:** A Bar Chart where each bar is a backend server, and height is Request Count. (Ideally, they should be flat/equal).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Request Distribution:** The variance between the busiest server and the quietest. | **Algorithm Selection:** proves if "Round Robin" is failing and if you should switch to "Least Request" or "Peak EWMA." | **Asset Utilization:** Ensures you are getting value out of *all* your servers, not just the one getting hammered. |
| **Hot Spotting:** Specific shards/servers taking too much heat. | **Data Partitioning:** Reveals if a specific "Tenant" or "Customer" is too big for a single node. | **Reliability:** Prevents cascading failures where one node dies, and its traffic kills the next node. |

---

### 24. The File Descriptor (FD) Usage Trend
**Context:** High-throughput socket servers (Websockets, MQTT) or File processors.
**Protocol Trigger:** "The application randomly throws 'Too many open files' and crashes."

*   **How to Produce (Linux):**
    *   **Native:** `lsof -p <PID> | wc -l` or check `/proc/<PID>/fd`.
    *   **System:** `sar -v 1` (monitor `file-nr`).
*   **Visual:** Area Chart showing Open FDs over time, overlaid with the `ulimit` (Limit) line.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Resource Leaks:** FDs that rise but never drop (Line goes up to the right). | **Code Quality:** Identifies where developers forgot to call `socket.close()` or `file.close()`. | **Uptime:** Prevents hard crashes that require manual restarts. |
| **Concurrency Ceiling:** How close you are to the OS limit. | **Capacity Planning:** Determines if you need to tune `/etc/security/limits.conf` to allow more traffic. | **Scale:** Allows a single server to handle 10k or 100k concurrent connections (C10k problem). |

---

### 25. The Cold Start Boot Trace
**Context:** Serverless (Lambda/Cloud Run), Auto-scaling groups, or CLI tools.
**Protocol Trigger:** "Auto-scaling is too slow; new pods take 2 minutes to serve traffic."

*   **How to Produce:**
    *   **Language Specific:** Java (Startup Flight Recording), Node (`node --prof-process`), Python (`python -X importtime`).
    *   **Linux:** `systemd-analyze blame` (if profiling OS boot).
*   **Visual:** A Gantt Chart starting at T=0 (Process Start) ending at T=Ready (Port Open).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Classloading/Import Time:** Time spent reading code from disk into memory. | **Dependency pruning:** Reveals massive libraries being loaded that aren't actually used. | **Agility:** Faster startup means you can scale out faster during traffic spikes (Black Friday). |
| **Initialization Logic:** DB connections, config parsing. | **Lazy Loading:** Identifies logic that can be deferred until the first request, rather than at startup. | **Cost:** In Serverless, you pay for startup time. Reducing this directly lowers the bill. |

---

### 26. The GPU Kernel Pipeline (AI/ML)
**Context:** AI Models, Transcoding, CUDA workloads.
**Protocol Trigger:** "The AI model training is taking 3 days; we bought expensive GPUs but they seem slow."

*   **How to Produce (Linux):**
    *   **NVIDIA:** `nvidia-smi dmon` or `nsight-systems`.
    *   **Metric:** GPU Utilization vs. Memory Transfer (PCIe) vs. SM (Streaming Multiprocessor) Activity.
*   **Visual:** Stacked Chart: "Compute" (Green) vs. "Memory Wait" (Red).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **GPU Starvation:** Time the GPU spends waiting for the CPU to send it data. | **Data Loader Optimization:** Tells you if the bottleneck is actually the Python script reading images from disk, not the GPU math. | **ROI:** Ensures your $10,000 GPU is working 100% of the time, not 20%. |
| **VRAM Usage:** Memory pressure on the card. | **Batch Sizing:** Helps tune "Batch Size" to maximize throughput without crashing (OOM). | **Time-to-Market:** Speeds up model training from days to hours. |

---

# The Performance Protocol Master Index

Group your protocols into these **4 Phases** for your team. This creates a logical workflow.

### Phase 1: Triage & Health (The "Is it broken?" Phase)
*Use these to determine **where** the problem is.*
1.  **CPU Flame Graph** (Is code slow?)
2.  **Off-CPU Flame Graph** (Is it waiting?)
3.  **I/O Saturation Heatmap** (Is Disk/Network jammed?)
4.  **CPU Throttling Matrix** (Is Kubernetes choking it?)
5.  **Differential Profile** (Did a recent deploy break it?)

### Phase 2: Application Deep Dive (The "Why is code slow?" Phase)
*Use these once you know the bottleneck is in the application logic.*
6.  **Heap Dominator Tree** (Memory Leaks/Bloat)
7.  **GC Pause Scatterplot** (Stuttering/Jitter)
8.  **Thread State Distribution** (Starvation/Blocking)
9.  **Lock Contention Graph** (Multithreading issues)
10. **Exception Impact Analysis** (Error handling overhead)
11. **Cold Start Boot Trace** (Slow startup/Scaling)

### Phase 3: Infrastructure & Systems (The "Is the plumbing clogged?" Phase)
*Use these when the code looks fine, but the system is slow.*
12. **Syscall Frequency Chart** (OS/Kernel overhead)
13. **Page Cache Efficiency** (File System/Disk caching)
14. **TCP CWND Plot** (Network bandwidth/Packet loss)
15. **DNS Latency Chart** (Service Discovery lag)
16. **File Descriptor Usage** (Resource exhaustion)
17. **Load Balancer Skew Map** (Traffic distribution)
18. **TLS Handshake Waterfall** (Security overhead)

### Phase 4: Data & Specialized Hardware (The "Niche" Phase)
*Use these for Databases, AI, or specific architectural patterns.*
19. **Slow Query Fingerprint** (Database Logic)
20. **Connection Pool Analysis** (Database Connectivity)
21. **Cache Efficacy Report** (Redis/Memcached Health)
22. **Distributed Trace Waterfall** (Microservices)
23. **Latency Histogram** (The Long Tail/P99s)
24. **CPI Flame Graph** (Hardware/Bare Metal Efficiency)
25. **Context Switch Analysis** (Process Scheduling)
26. **GPU Kernel Pipeline** (AI/ML Workloads)


Yes, while the previous 26 reports cover the vast majority of application and system issues, there are **5 advanced "Edge Case" reports** missing.

These cover **Hardware Interrupts** (crucial for high throughput), **Capacity Limits** (Stress Testing), **Memory Addressing** (TLB), **JIT Compilation**, and **I/O Access Patterns**.

Here is the final expansion to complete your Performance Engineering Catalog.

---

### 27. The IRQ (Interrupt) Affinity Map
**Context:** High-throughput Network Gateways, Load Balancers, or Database Servers.
**Protocol Trigger:** "CPU Core 0 is at 100%, but Cores 1-63 are idle. Network packets are dropping."
**The Reality:** The Network Interface Card (NIC) is sending all hardware interrupts to a single CPU core, overwhelming it.

*   **How to Produce (Linux):**
    *   **Native:** `mpstat -I SUM -P ALL 1` (Watch the interrupt counts per core).
    *   **File System:** `cat /proc/interrupts`.
    *   **Helper:** `irqbalance` status.
*   **Visual:** A Heatmap. X-Axis = Time, Y-Axis = CPU Cores. Color = Number of Interrupts handled.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **SoftIRQ Distribution:** How the kernel handles hardware events (like incoming packets). | **Hardware Tuning:** Identifying this allows you to run `smp_affinity` scripts to spread the load across all cores. | **Throughput Maximization:** Allows a single server to handle 10x the traffic by utilizing the whole processor, not just one core. |
| **Context Switch Storms:** Excessive switching due to bad IRQ handling. | **Latency Jitter:** Resolving IRQ pile-ups reduces the "micro-stalls" that happen when a CPU is interrupted too often. | **CapEx Savings:** Reduces the need to buy more servers when the existing ones are just configured poorly. |

---

### 28. The Saturation Curve (The "Hockey Stick")
**Context:** Capacity Planning and Stress Testing.
**Protocol Trigger:** "We know the system works now, but will it survive Black Friday?"
**The Reality:** All systems are linear until they aren't. You need to find the "Knee of the Curve."

*   **How to Produce:**
    *   **Tools:** `k6`, `Artillery`, or `JMeter` generating load.
    *   **Metric:** Correlate **Throughput** (RPS) vs. **Latency** (ms) vs. **Error Rate**.
*   **Visual:** A Line Chart. X-Axis = Users/Load. Y-Axis = Latency.
    *   *Look for the point where Latency goes vertical while Throughput stays flat.*

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **The Breaking Point:** The exact number of Requests Per Second (RPS) where the system degrades. | **Failure Mode Analysis:** Does it degrade gracefully (slow down) or catastrophically (crash)? | **Risk Mitigation:** Provides the exact numbers needed for auto-scaling triggers (e.g., "Scale up at 80% of the breaking point"). |
| **Little's Law Limit:** The theoretical concurrency limit. | **Bottleneck Identification:** If the curve breaks early, it proves a configuration limit (locks/connections) rather than a resource limit. | **Budgeting:** Accurate prediction of how many servers are needed for a marketing event. |

---

### 29. The TLB (Translation Lookaside Buffer) Miss Rate
**Context:** Large Memory Database (Redis/Postgres) or Java Heap (>32GB).
**Protocol Trigger:** "The CPU is high, but instructions-per-cycle is low. We are using massive amounts of RAM."
**The Reality:** The CPU is spending all its time looking up memory addresses in the page table instead of processing data.

*   **How to Produce (Linux):**
    *   **Perf:** `perf stat -e dTLB-load-misses,iTLB-load-misses -p <PID>`.
    *   **Native:** `vmstat` (look for standard page size movements).
*   **Visual:** A Bar Chart comparing **Total Memory Accesses** vs. **TLB Misses**.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Page Table Walk Time:** Time spent by the CPU asking the OS "Where is this data?" | **Huge Pages Validation:** This is the primary report to justify enabling **Transparent Huge Pages (THP)** or HugeTLB. | **Free Performance:** Enabling Huge Pages on a database with high TLB misses can boost performance by 15-20% with zero code changes. |
| **Memory Fragmentation:** Inefficiency in how RAM is allocated. | **Allocator Tuning:** Suggests switching memory allocators (jemalloc vs glibc malloc). | **Infrastructure ROI:** extracting maximum speed from the RAM you are paying for. |

---

### 30. The JIT Compilation & De-optimization Log
**Context:** Managed Runtimes (Java JVM, Node.js V8, .NET, Go).
**Protocol Trigger:** "The app is fast, then suddenly gets slow for 5 seconds, then gets fast again. It's not GC."
**The Reality:** The JIT compiler is "de-optimizing" code because an assumption proved false, forcing a fallback to the interpreter.

*   **How to Produce:**
    *   **Java:** `-XX:+PrintCompilation` or JFR "Code Cache" events.
    *   **Node.js:** `node --trace-opt --trace-deopt`.
    *   **Linux:** `perf` with `jitdump` plugin.
*   **Visual:** A Timeline showing "Compilation Events" (Green) and "De-optimizations" (Red).

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Code Cache Churn:** Is the JIT running out of space to store compiled machine code? | **Startup Tuning:** Helps tune `ReservedCodeCacheSize`. | **Consistency:** Eliminates random slowdowns that confuse users. |
| **De-opt Storms:** Frequent switching between compiled and interpreted mode. | **Code Stability:** Identifies coding patterns (polymorphic calls) that confuse the compiler. | **Latency P99:** Ensures the code runs at "machine speed" 100% of the time. |

---

### 31. The I/O Access Pattern Scatterplot
**Context:** Storage performance tuning (Database files, Logging).
**Protocol Trigger:** "Disk throughput is low (20MB/s), but the disk claims it can do 500MB/s."
**The Reality:** You are doing random 4KB writes (slow) instead of sequential writes (fast).

*   **How to Produce (Linux):**
    *   **eBPF:** `biosnoop` or `biolatency` (BCC tools).
    *   **Trace:** Analyze the LBA (Logical Block Address) of read/write requests.
*   **Visual:** A Scatterplot. X-Axis = Time. Y-Axis = Disk Offset (Address).
    *   *Sequential Access* looks like a straight diagonal line.
    *   *Random Access* looks like white noise / clouds of dots.

| **What It Measures** | **Technical Benefit** | **Business Value** |
| :--- | :--- | :--- |
| **Sequentiality:** Are we reading the file from start to finish? | **Architecture Review:** Proves if you need to optimize database indexes (Scan vs Seek) or batch log writes. | **Hardware Cost:** Sequential I/O is cheap (HDDs). Random I/O is expensive (High-end SSDs). Optimizing this saves storage costs. |
| **Merge Efficiency:** Is the OS merging small requests into big ones? | **Kernel Tuning:** Helps tune the I/O Scheduler (`noop`, `deadline`, `cfq`). | **Throughput:** Increases the raw amount of data the system can process per second. |

---

### Final Master Checklist Update

You now have **31 Protocols**. Here is the final logical grouping for your "Table of Contents":

1.  **Fundamental Resource Health** (CPU, Memory, Disk, Net) [Reports 1-5]
2.  **Code Execution Efficiency** (Flame Graphs, Exceptions, JIT) [Reports 6, 14, 25, 30]
3.  **Concurrency & Locking** (Threads, Locks, IRQs) [Reports 8, 11, 20, 27]
4.  **Memory Architecture** (Leaks, GC, TLB, Cache) [Reports 2, 3, 7, 16, 29]
5.  **I/O & Storage Internals** (Patterns, Page Cache, FDs) [Reports 4, 17, 24, 31]
6.  **Network & Connectivity** (TCP, DNS, TLS, Load Balancing) [Reports 15, 18, 21, 22, 23]
7.  **Database & Data** (Slow Queries, Pools) [Reports 19, 15]
8.  **Architecture & Capacity** (Saturation, Microservices, Limits, Throttling) [Reports 5, 12, 13, 28]
9.  **Specialized Hardware** (GPU, Bare Metal) [Reports 10, 26]
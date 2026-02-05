# profiling protocols

## CPU analysis
*   System-Level Analysis
    *   CPU Utilization Breakdown (User % vs System % vs Iowait %).
*   Code-Level Profiling (On-CPU)
    *   Find exactly which function is burning cycles.
    *   Deliverable Report: The Flame Graph

## Memory analysis
*   Usage & Saturation
    *   Distinguish between actual usage and cache
    *   Report: Memory Composition Chart (RSS vs. Page Cache vs. Swap).
*   Leak Detection
    *   Find un-freed memory.
    *   Report: Allocation Growth Chart over time.
*   Managed Runtime Analysis (GC)
    *   Analyze Object Churn.
    *   Deliverable Report: Heap Dump Dominator Tree

## Latency & Blocking (Off-CPU Analysis)
*   Application responds slowly, but CPU usage is low
*   Thread State Analysis
    *   Are threads sleeping, waiting for locks, or waiting for I/O?
    *   Report: Thread State Distribution (Running vs. Sleeping vs. Blocked).
*   Lock Contention Profiling
    *   Identify Mutex/Spinlock contention.
    *   Deliverable Report: Off-CPU Flame Graph

## I/O Subsystem (Disk & Network)
*   High iowait, slow database queries, slow file uploads/downloads.
*   Disk Profiling
    *   Identify if the disk speed is the bottleneck.
    *   Report: Disk Latency Heatmap or IOPS Saturation Report.
*   Network Profiling
    *   Analyze packet loss, retransmits, and bandwidth.
    *   Deliverable Report: TCP Health Check (Retransmission rates, Window clamping).

## Continuous Profiling Setup
*   For capturing transient issues in production that cannot be reproduced locally.
*   Architecture Check
    *   Agent Deployment: Ensure Pyroscope or Parca agent is running as a sidecar or daemonset
    *   Overhead Monitor: Ensure profiling overhead is < 2% CPU.
*   Analysis Workflow
    *   Compare performance "Then" vs "Now".
    *   Report: Differential Flame Graph.

---

# Report Value & Metrics Definition

Here are the notes for protocols 1 through 11, formatted according to your example:

## The CPU Flame Graph
*   Measures
    *   Code Path Frequency: The width of the bar represents how often that function was found on the CPU. => Root Cause ID: Instantly identifies the "Hot Path." Eliminates guessing about which function is slow.
    *   Stack Depth: How deep the function calls go. => Complexity Analysis: Very deep stacks often indicate excessive abstraction or recursion issues.

## The Off-CPU Flame Graph
*   Measures
    *   Wait Time: Time spent sleeping, waiting for I/O, or waiting for a Lock. => Concurrency Debugging: Highlights mutex contention (threads fighting for the same resource) or slow Database queries.
    *   Blocking Calls: Functions that stop execution flow. => Async Verification: Proves if "Non-blocking" code is accidentally blocking the Event Loop (Node.js/Netty).

## The Heap Dominator Tree
*   Measures
    *   Retained Size: The amount of memory that would be freed if this specific object were deleted. => Leak Detection: Distinguishes between massive objects (bloat) and objects holding onto chains of other data (leaks).
    *   GC Roots: The static variable or thread keeping the data alive. => Lifecycle Management: Identifies caches that never expire or sessions that aren't closing.

## The I/O Saturation Heatmap
*   Measures
    *   Queue Depth: How many requests are waiting to be written to disk/network. => Bottleneck Isolation: Proves if the slowdown is the Application (Code) or the Infrastructure (Disk/Network).
    *   Service Time: Actual time the hardware takes to process a block. => Config Tuning: Helps tune buffer sizes and connection pools.

## The Differential Profile
*   Measures
    *   Performance Regression: The difference in resource usage between Version A and Version B. => Impact Analysis: Shows exactly what the new feature code "costs" in terms of resources.
    *   Optimization Verification: The drop in usage after a fix. => Success Validation: Visually proves that a fix actually worked (e.g., "See this big blue area? That's the CPU we saved").

## The Thread State Distribution Chart
*   Measures
    *   CPU Saturation vs. Starvation: Are threads working or begging for CPU time? => Capacity Planning: Determines if adding more CPUs will actually help, or if the code is just single-threaded.

## The GC Pause Scatterplot
*   Measures
    *   Stop-The-World Events: Moments when the application freezes to clean memory. => Tuning Strategy: Determines if you need a concurrent collector (like ZGC/Shenandoah) or if you are allocating too fast.
    *   Frequency of Collections: How often cleanup happens. => Allocation Rate Analysis: High frequency = high object churn code.

## The Distributed Trace Waterfall (Span Chart)
*   Measures
    *   Critical Path: The sequence of sequential steps that define the total duration. => Dependency Analysis: Identifies if the slowdown is internal (code) or external (DB, Redis, 3rd Party API).
    *   Gap Analysis: Empty space between bars. => Processing Lag: Highlights time lost in network latency or serialization/deserialization.

## The Syscall (System Call) Frequency Chart
*   Measures
    *   Context Switching Cost: How often the app asks the Kernel to do work (Open file, Read network, Get time). => I/O Efficiency: Reveals inefficient patterns (e.g., calling `read()` 1,000 times for 1 byte vs. 1 time for 1,000 bytes).
    *   Error Rates (EAGAIN/ENOENT): Failed system calls. => Configuration Validation: Finds silent failures (e.g., constantly trying to open a config file that doesn't exist).

## The CPI (Cycles Per Instruction) Flame Graph
*   Measures
    *   CPU Efficiency: How many CPU cycles are wasted waiting for data from RAM (Cache Misses). => Data Locality: Tells engineers they need to restructure data structures (Struct of Arrays vs Array of Structs) to fit in L1/L2 Cache.
    *   Branch Mispredictions: How often the CPU guesses the wrong "if" statement path. => Algorithm Optimization: Helps optimize complex conditional logic loops.

## The Lock Contention Graph (Wait Chain)
*   Measures
    *   Wait Chains: Thread A waits for B, which waits for C. => Deadlock Prevention: Identifies dangerous circular dependencies before they crash the production environment.
    *   Lock Granularity: How "wide" a lock is (locking the whole DB vs. one row). => Concurrency Tuning: Indicates where to switch from coarse-grained locks to fine-grained locks (or lock-free structures).


## The CPU Throttling Matrix (Container Saturation)
*   Measures
    *   CFS Throttling: How often the Linux Scheduler forcibly paused the process because it used its millisecond quota. => Configuration Tuning: Proves that `resources.limits` in K8s are set too low (or `requests` are too low), causing artificial slowness.
    *   Burst Usage: Spikes that trigger limits. => Smoothness: Identifying bursty behavior helps decide between "Provisioning more CPU" vs "Smoothing traffic."

## The Latency Distribution Histogram (The "Long Tail")
*   Measures
    *   Multi-Modal Distribution: Do you have one "hump" (consistent behavior) or two (fast hits vs. slow misses)? => Architecture Reality: Often reveals distinct behaviors (e.g., "Cache Hits" take 5ms, "Cache Misses" take 2s).
    *   Outlier Severity: How bad is the "worst case"? => SLA Verification: Proves whether you are violating strict performance contracts.

## The Exception Impact Analysis ("Noise" Profile)
*   Measures
    *   Stack Filling Cost: The CPU time spent walking the stack to generate an error report. => Code Hygiene: Identifies "Exceptions as Control Flow" anti-patterns (e.g., throwing "UserNotFound" instead of returning null).
    *   Log Volume: Bandwidth used writing text to disk/network. => I/O reduction: Reduces pressure on logging infrastructure (Splunk/ELK).

## The Connection Pool Leaky Bucket
*   Measures
    *   Pool Starvation: Time threads spend waiting to *get* a connection handle. => Capacity Planning: Determines the optimal pool size. Too small = waiting; Too big = database thrashing.
    *   Leak Rate: Connections created but never returned. => Bug Detection: Finds code paths where `db.close()` is missing.

## The Cache Efficacy Report
*   Measures
    *   Hit/Miss Ratio: Percentage of requests served from RAM vs. DB. => Strategy Validation: If Miss rate is >50%, the cache is useless or configured wrong (TTL is too low).
    *   Eviction Rate: How often the cache deletes data to make room for new data. => Sizing Analysis: High eviction rates mean the cache is too small (thrashing data in and out).

## The Page Cache Efficiency Report
*   Measures
    *   Cache Hit Ratio: Percentage of file reads served from RAM instead of hitting the physical disk. => IOPS Conservation: A 99% hit ratio means your slow physical disk is irrelevant. A 50% ratio explains why the app is crawling.
    *   Dirty Pages: Data in RAM waiting to be flushed to disk. => Write Safety: High dirty page counts warn of massive "Write Spikes" (blocking) when the kernel finally flushes data.

## The TCP Congestion Window (CWND) Plot
*   Measures
    *   Window Collapse: When the graph drops sharply, a packet was lost. => Network Diagnostics: Distinguishes between "Bandwidth Limits" (flat line) and "Packet Loss" (sawtooth drops).
    *   RTT (Round Trip Time): Latency per packet. => Geographic Tuning: Shows if the physical distance between client and server is the bottleneck.

## The Slow Query Fingerprint
*   Measures
    *   Query Fingerprint: Removes specific IDs (e.g., `SELECT * FROM user WHERE id=?`) to group identical logic. => Index Verification: Instantly identifies "Full Table Scans" (missing indexes).
    *   Rows Examined vs. Sent: How much data the DB read vs. how much it actually needed. => Efficiency: Highlights "Over-fetching" (reading 1M rows to return 10 results).

## The Context Switch Type Analysis
*   Measures
    *   Voluntary (cswch): The process gave up the CPU (e.g., "I'm waiting for disk"). => IO Analysis: High voluntary switches mean the app is IO-bound (waiting on data).
    *   Involuntary (nvcswch): The OS kicked the process off the CPU (Time slice expired). => CPU Contention: High involuntary switches mean you have too many threads fighting for too few cores.

## The DNS Resolution Latency Chart
*   Measures
    *   Resolution Time: Time from asking "Where is google.com?" to getting the IP. => Config Debugging: Finds issues with `ndots` config in Kubernetes or slow upstream DNS servers.
    *   NXDOMAIN Responses: "Domain not found" errors. => Misconfiguration: Spotlights typo'd service names or service discovery failures.

## The TLS/SSL Handshake Waterfall
*   Measures
    *   Handshake Duration: Time to negotiate encryption keys. => Cipher Suite Tuning: Identifies if you are using expensive keys (RSA 4096) when cheaper ones (ECDSA) would suffice.
    *   Session Resumption: Are we reusing previous keys? => Keep-Alive Verification: Confirms that `Keep-Alive` is working, avoiding the handshake entirely for subsequent calls.

## The Load Balancer Skew Map
*   Measures
    *   Request Distribution: The variance between the busiest server and the quietest. => Algorithm Selection: proves if "Round Robin" is failing and if you should switch to "Least Request" or "Peak EWMA."
    *   Hot Spotting: Specific shards/servers taking too much heat. => Data Partitioning: Reveals if a specific "Tenant" or "Customer" is too big for a single node.

## The File Descriptor (FD) Usage Trend
*   Measures
    *   Resource Leaks: FDs that rise but never drop (Line goes up to the right). => Code Quality: Identifies where developers forgot to call `socket.close()` or `file.close()`.
    *   Concurrency Ceiling: How close you are to the OS limit. => Capacity Planning: Determines if you need to tune `/etc/security/limits.conf` to allow more traffic.

## The Cold Start Boot Trace
*   Measures
    *   Classloading/Import Time: Time spent reading code from disk into memory. => Dependency pruning: Reveals massive libraries being loaded that aren't actually used.
    *   Initialization Logic: DB connections, config parsing. => Lazy Loading: Identifies logic that can be deferred until the first request, rather than at startup.

## The GPU Kernel Pipeline (AI/ML)
*   Measures
    *   GPU Starvation: Time the GPU spends waiting for the CPU to send it data. => Data Loader Optimization: Tells you if the bottleneck is actually the Python script reading images from disk, not the GPU math.
    *   VRAM Usage: Memory pressure on the card. => Batch Sizing: Helps tune "Batch Size" to maximize throughput without crashing (OOM).

## The IRQ (Interrupt) Affinity Map
*   Measures
    *   SoftIRQ Distribution: How the kernel handles hardware events (like incoming packets). => Hardware Tuning: Identifying this allows you to run `smp_affinity` scripts to spread the load across all cores.
    *   Context Switch Storms: Excessive switching due to bad IRQ handling. => Latency Jitter: Resolving IRQ pile-ups reduces the "micro-stalls" that happen when a CPU is interrupted too often.

## The Saturation Curve (The "Hockey Stick")
*   Measures
    *   The Breaking Point: The exact number of Requests Per Second (RPS) where the system degrades. => Failure Mode Analysis: Does it degrade gracefully (slow down) or catastrophically (crash)?
    *   Little's Law Limit: The theoretical concurrency limit. => Bottleneck Identification: If the curve breaks early, it proves a configuration limit (locks/connections) rather than a resource limit.

## The TLB (Translation Lookaside Buffer) Miss Rate
*   Measures
    *   Page Table Walk Time: Time spent by the CPU asking the OS "Where is this data?" => Huge Pages Validation: This is the primary report to justify enabling **Transparent Huge Pages (THP)** or HugeTLB.
    *   Memory Fragmentation: Inefficiency in how RAM is allocated. => Allocator Tuning: Suggests switching memory allocators (jemalloc vs glibc malloc).

## The JIT Compilation & De-optimization Log
*   Measures
    *   Code Cache Churn: Is the JIT running out of space to store compiled machine code? => Startup Tuning: Helps tune `ReservedCodeCacheSize`.
    *   De-opt Storms: Frequent switching between compiled and interpreted mode. => Code Stability: Identifies coding patterns (polymorphic calls) that confuse the compiler.

## The I/O Access Pattern Scatterplot
*   Measures
    *   Sequentiality: Are we reading the file from start to finish? => Architecture Review: Proves if you need to optimize database indexes (Scan vs Seek) or batch log writes.
    *   Merge Efficiency: Is the OS merging small requests into big ones? => Kernel Tuning: Helps tune the I/O Scheduler (`noop`, `deadline`, `cfq`).
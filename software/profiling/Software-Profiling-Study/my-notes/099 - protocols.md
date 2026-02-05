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

## The CPU Flame Graph
*   Measures
    *   Code Path Frequency => Root Cause ID
    *   Stack Depth => Complexity Analysis

## The Off-CPU Flame Graph
*   Measures
    *   Wait Time => Concurrency Debugging
    *   Blocking Calls => Async Verification

## The Heap Dominator Tree
*   Measures
    *   Retained Size => Leak Detection
    *   GC Roots => Lifecycle Management

## The I/O Saturation Heatmap
*   Measures
    *   Queue Depth => Bottleneck Isolation
    *   Service Time => Config Tuning: Helps tune buffer sizes and connection pools.

## The Differential Profile
*   Measures
    *   Performance Regression => Impact Analysis (code change)
    *   Optimization Verification => visually proves that a fix actually worked

## The Thread State Distribution Chart
*   Measures
    *   CPU Saturation vs. Starvation => Capacity Planning: Determines if adding more CPUs will actually help, or if the code is just single-threaded.

## The GC Pause Scatterplot
*   Measures
    *   Stop-The-World Events => Tuning Strategy: Determines if you need a concurrent collector (like ZGC/Shenandoah) or if you are allocating too fast.
    *   Frequency of Collections: How often cleanup happens => Allocation Rate Analysis: High frequency = high object churn code.

## The Distributed Trace Waterfall (Span Chart)
*   Measures
    *   Critical Path => Dependency Analysis: Identifies if the slowdown is internal (code) or external (DB, Redis, 3rd Party API).
    *   Gap Analysis => Processing Lag: Highlights time lost in network latency or serialization/deserialization.


# Systems Performance: Comprehensive Study Table of Contents

## Part I: Foundations & Methodologies

### A. Introduction to Systems Performance
- **The Performance Landscape**: Complexity, subjectivity, and multiple causes
- **Core Concepts**: Latency, Observability, and Experimentation
- **Roles & Activities**: Performance analysis in SRE, DevOps, and Engineering
- **Metric Fundamentals**:
    - Counters, Statistics, and Metrics
    - Profiling vs. Tracing
- **Cloud Computing Context**: How cloud changes performance analysis

### B. Analytical Methodologies
- **Terminology & Concepts**:
    - Latency, Time Scales, and Trade-offs
    - Utilization, Saturation, and Errors
    - Caching and the Known-Unknowns
- **Perspectives**: Resource Analysis vs. Workload Analysis
- **Standard Methods**:
    - The Scientific Method and Diagnosis Cycle
    - The **USE Method** (Utilization, Saturation, Errors)
    - The **RED Method** (Rate, Errors, Duration)
    - Workload Characterization and Drill-Down Analysis
- **Anti-Patterns**: Streetlight, Random Change, and Blame-Someone-Else
- **Modeling & Capacity Planning**:
    - Amdahl’s Law and Universal Scalability Law
    - Queuing Theory and Resource Limits
- **Statistics & Visualization**:
    - Averages, Percentiles, and Standard Deviation
    - Multimodal Distributions and Outliers
    - Heat Maps, Flame Graphs, and Surface Plots

## Part II: Operating Systems & Observability Layers

### A. Operating Systems Internals
- **Kernel Fundamentals**: Kernel mode vs. User mode
- **Core Subsystems**:
    - System Calls and Interrupts
    - Process Management and Stacks
    - Virtual Memory and Schedulers
    - VFS (Virtual File Systems) and Device Drivers
- **Linux Specifics**:
    - Kernel Developments and `systemd`
    - KPTI (Meltdown/Spectre mitigations)
    - Extended BPF (eBPF) integration
- **Alternative Kernels**: Unikernels, Microkernels, and Hybrid models

### B. Observability Tools & Sources
- **Tool Classifications**: Static, Crisis, Profiling, and Monitoring
- **Data Sources**:
    - `/proc` and `/sys` filesystems
    - Tracepoints, kprobes, uprobes, and USDT
    - Hardware Counters (PMCs)
- **Core Tooling**:
    - **sar**: Historical and live monitoring
    - **Tracing Tools**: Overview of the landscape
    - **Observing Observability**: Overhead analysis

## Part III: Application Performance

### A. Application Basics
- **Objectives**: Optimizing the common case
- **Algorithmic Complexity**: Big O Notation in practice
- **Programming Languages**:
    - Compiled vs. Interpreted
    - Virtual Machines (JVM, CLR)
    - Garbage Collection impact

### B. Performance Techniques
- I/O Sizes, Caching, and Buffering
- Concurrency, Parallelism, and Non-Blocking I/O
- Processor Binding (Affinity)

### C. Analysis & Methodology
- **Profiling**: CPU Profiling and Off-CPU Analysis
- **Thread Analysis**: State analysis, Locks, and Syscalls
- **Distributed Tracing**: Concepts and implementation
- **Gotchas**: Missing symbols and broken stacks

### D. Application Tools
- `perf`, `profile`, `offcputime`
- `strace`, `execsnoop`, `syscount`
- `bpftrace` for application introspection

## Part IV: CPU & Memory Resources

### A. CPU Performance
- **Architecture**:
    - Clock Rates, Instruction Pipelines, and IPC
    - CPU Caches (L1/L2/L3) and Interconnects
    - SMT (Hyper-threading) and Topology
- **Concepts**: User/Kernel time, Preemption, Priority Inversion
- **Methodology**:
    - Cycle Analysis and Workload Characterization
    - Scheduler Latency (Run Queue) analysis
- **Tools**:
    - `uptime`, `vmstat`, `mpstat`, `top`, `pidstat`
    - `turbostat`, `perf`, `runqlat`, `softirqs`
    - Visualizations: Flame Graphs and Heat Maps
- **Tuning**: Scheduler options, nice priorities, CPU binding, and Scaling Governors

### B. Memory Performance
- **Architecture**:
    - Virtual Memory, Paging, and Demand Paging
    - MMU and TLB behavior
    - NUMA (Non-Uniform Memory Access)
- **Lifecycle**: Allocators, Overcommit, and OOM (Out of Memory) Killer
- **Methodology**:
    - Saturation, Leak Detection, and Page Scanning
    - Analyzing Working Set Size (WSS)
- **Tools**:
    - `free`, `vmstat`, `psi` (Pressure Stall Information)
    - `slabtop`, `pmap`, `valgrind`
    - `drsnoop` and page fault analysis
- **Tuning**: Huge Pages, Swappiness, and Allocator selection

## Part V: Storage Systems (File Systems & Disks)

### A. File Systems
- **Concepts**:
    - VFS Stack, Inodes, and Dentries
    - Page Cache (Read-Ahead and Write-Back)
    - Journaling and Metadata
- **File System Types**: Ext4, XFS, ZFS, Btrfs
- **Methodology**: Latency Analysis and Cache Hit Ratios
- **Tools**:
    - `mount`, `free` (for cache), `latencytop`
    - `opensnoop`, `filetop`, `ext4slower`/`xfsslower`
- **Tuning**: Mount options, record sizes, and journal placement

### B. Disks & Block Devices
- **Hardware Models**:
    - Rotational (HDD) vs. Flash (SSD/NVMe)
    - Controllers and Interfaces (SCSI, SATA, SAS)
- **Concepts**:
    - IOPS, Throughput, and I/O Size
    - Random vs. Sequential access
    - I/O Wait and Saturation
- **Methodology**:
    - Use Method for Disks
    - Latency Heat Maps (Bi-modal distributions)
- **Tools**:
    - `iostat`, `biolatency`, `biosnoop`, `iotop`
    - `blktrace` and `megacli`
- **Tuning**: I/O Schedulers (mq-deadline, bfq, kyber) and Queue depths

## Part VI: Networking

### A. Network Fundamentals
- **Models**: Physical Interface, Controller, and Protocol Stack
- **Concepts**:
    - Bandwidth, Latency, and Packet Sizes (MTU)
    - TCP Handshakes, Congestion Control, and Buffering
    - Encapsulation overheads
- **Architecture**: Hardware offloads (TSO, LRO) and Kernel stack

### B. Network Methodology
- Packet Sniffing and TCP Analysis
- Dropped packet analysis and Retransmits
- Socket performance

### C. Network Tools
- **Configuration**: `ip`, `ethtool`, `ss` (Socket Statistics)
- **Monitoring**: `netstat`, `sar`, `nstat`, `nicstat`
- **Tracing**: `tcpdump`, `Wireshark`, `tcplife`, `tcpretrans`
- **Experimentation**: `iperf`, `netperf`, `ping`

## Part VII: Cloud & Virtualization

### A. Cloud Architecture
- Instance Types and Multitenancy ("Noisy Neighbors")
- Orchestration (Kubernetes) and Scalable Architecture
- Cloud Storage paradigms

### B. Virtualization Implementation
- **Hardware Virtualization**:
    - Hypervisors and overhead
    - AWS Nitro and modern offloads
- **OS Virtualization (Containers)**:
    - Namespaces and Cgroups
    - Docker/Podman overhead
- **Comparison**: Bare metal vs. VM vs. Container performance

## Part VIII: Benchmarking

### A. Benchmarking Principles
- **Types**: Micro-benchmarking vs. Macro-benchmarking (Simulation/Replay)
- **Methodology**: Active vs. Passive benchmarking
- **Statistical Analysis**: Sanity checks and confidence intervals
- **Common Failures**: Testing the wrong thing, cache effects, and "Benchmarking Crimes"

### B. Execution
- Load generation and Ramping
- Profiling during benchmarks to explain results

## Part IX: Advanced Instrumentation (Tracing)

### A. perf
- **Core Commands**: `stat`, `record`, `report`, `script`, `trace`
- **Events**: Hardware events, Software events, Tracepoints, and Probes
- **Workflows**: Generating Flame Graphs and Stack Walking

### B. Ftrace
- **Capabilities**: Function tracing and Graph tracing
- **Interface**: `tracefs`, `trace-cmd`, and `kernelshark`
- **kprobes/uprobes**: Dynamic instrumentation via Ftrace

### C. BPF (Berkeley Packet Filter)
- **BCC (BPF Compiler Collection)**:
    - Tool coverage (execsnoop, biolatency, etc.)
    - Python/Lua frontends
- **bpftrace**:
    - One-liners for system analysis
    - Scripting language syntax and variables
    - Creating custom tools on the fly

## Part X: Synthesis & Case Studies

### A. Case Study: An Unexplained Win
- Problem Statement and Analysis Strategy
- Using PMCs (Performance Monitoring Counters)
- Software Events and Tracing to find the root cause

### B. Reference & Guides
- **The USE Method Checklist**: Linux specific metrics
- **sar Summary**: Quick reference for arguments
- **bpftrace One-Liners**: Cheatsheet for rapid diagnosis
# Standard-Linux-Tools
*   there are lots of linux tools that can be used to gather profiling data

---

## The Process Viewers: top, htop, atop
*   gives an answer to the question "which process is slowing down the system"

#### top
*   sorting processes by CPU usage or Memory usage
*   provides a system summary header (Load Average, total Tasks, RAM usage)
*   purely real-time (no history)

#### htop
*   modern, colorful, interactive improvement over top.
*   much more user-friendly for killing processes or changing process priority

#### atop
*   "Advanced" system and process monitor.
*   run as a background daemon and record binary logs
*   allows you to see historical data
*   highlights resources (CPU, Memory, Disk, Network) in red when they are critical
*   one of the few standard tools that effectively shows Disk I/O per process

---

## The Statistics Collection: vmstat, iostat, netstat, mpstat
*   tools that provide high-level counters
*   they give statistics about hardware subsystems

#### vmstat (Virtual Memory Statistics):
*   A single-line summary of system health.
*   can show you
    *   CPU bottlenecks
    *   memory swap statistics
    *   ... (look at the menu)

#### iostat (Input/Output Statistics):
*   Measures disk storage performance

#### netstat (Network Statistics):
*   Shows network connections, routing tables, and interface statistics.

#### Shows network connections, routing tables, and interface statistics.
*   Breaks down CPU usage per core.

---

## strace (System Call Tracing)
*   This is the "Microscope" of Linux tools
*   It does not measure performance broadly; it debugs specific interactions between a program and the Linux Kernel.
*   It intercepts every "System Call" to get statistics/profiling data
*   strace has massive overhead
*   **Never run strace on a high-production database**
*   it can slow the application down by 10x or 100x.

---

## perf (Linux Profiling Subsystem)
*   "Heavy Artillery."
*   the official profiler of the Linux kernel.


-------
# eBPF
*   eBPF lets you run you process/app safely in the kernal mode
*   **Benifits:**
    *   you will get far more detailed/microscopic profiling data
*   **How to use it:**
    *   using a specific tools like `execsnoop`, `opensnoop`, `biolatency`, ...
*   **When to use it:**
    *   start with normal tools
    *   if you needed more details, you couldn't get from normal tools, go for eBPF


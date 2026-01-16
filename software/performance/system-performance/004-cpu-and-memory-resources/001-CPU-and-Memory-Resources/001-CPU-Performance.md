This outline appears to be based on the structure of **Brendan Gregg’s "Systems Performance" methodology**. It is a roadmap for understanding how CPUs and Memory work, how to measure them, and how to fix performance issues.

Here is a detailed breakdown of every section in the text provided.

---

# Part IV: CPU & Memory Resources

## A. CPU Performance (Chapter 6)

This section covers the brain of the computer. If the CPU is slow or overloaded, the whole system feels sluggish.

### 1. Terminology & Models
*   **CPU Architecture:** This describes the physical layout.
    *   **Sockets/Packages:** The physical slots on the motherboard.
    *   **Cores:** The independent processing units inside a socket.
    *   **Hardware Threads:** If Hyper-threading is on, one Core appears as two threads to the OS.
*   **CPU Memory Caches (L1, L2, L3):** The CPU is much faster than RAM. To avoid waiting for RAM, it stores data in tiny, ultra-fast internal memory banks called caches.
    *   **L1:** Smallest, fastest, closest to the core.
    *   **L3:** Largest, slower, usually shared between all cores on a socket.
*   **Run Queues:** Imagine a line at a grocery store. The "Cashier" is the CPU core. The "Line" is the Run Queue. If the Run Queue is long, processes are waiting (latency), meaning the system is overloaded.

### 2. Key CPU Concepts
*   **Clock Rate & Cycle Time:** The speed of the CPU (e.g., 3.0 GHz). A higher clock rate means more cycles per second, but modern CPUs change this dynamically (throttling) to save power or stay cool.
*   **Instructions (IPC & CPI):**
    *   **IPC (Instructions Per Cycle):** A high IPC means the CPU is efficient (doing a lot of work per clock tick).
    *   **CPI (Cycles Per Instruction):** The inverse. A high CPI usually means the CPU is "stalled," often waiting for memory.
*   **Hyper-threading (SMT):** A technique where one physical core pretends to be two logical cores. It allows the scheduler to assign two tasks to one core. While one task waits for memory, the other runs. It generally increases throughput by ~30% but can slow down single-threaded calculations.
*   **Utilization vs. Saturation:**
    *   **Utilization:** How busy the CPU is (e.g., 90%).
    *   **Saturation:** When utilization is 100% and tasks start piling up in the Run Queue (wait time).
*   **User Time vs. Kernel Time:**
    *   **User Time:** CPU time spent running your application code.
    *   **Kernel Time (System Time):** CPU time spent by the OS doing homework (hardware interrupts, managing disks/network). High kernel time usually indicates a system issue/misconfiguration.
*   **Priority Inversion:** A scenario where a low-priority task holds a resource (lock) that a high-priority task needs. The high-priority task is blocked, making the system feel unresponsive.

### 3. CPU Architecture Deep Dive
*   **Hardware (Interconnects/Word Size):** How fast data moves between sockets (e.g., Intel QPI or AMD Infinity Fabric). 64-bit word size allows handling larger memory chunks.
*   **Software (The OS Scheduler - CFS):** Use Linux's *Completely Fair Scheduler*. It tries to divide CPU time "fairly" among tasks. Preemption is the act of the scheduler forcing a task to stop so another can run.

### 4. Analysis Methodology
*   **USE Method (Utilization, Saturation, Errors):** This is the checklist you runs first:
    1.  Is the CPU utilized?
    2.  Is it saturated (is the run queue length > number of cores)?
    3.  Are there hardware errors?
*   **Workload Characterization:**
    *   **CPU-bound:** Throughput is limited by CPU speed (e.g., video rendering).
    *   **I/O-bound:** CPU is idle waiting for Disk or Network (e.g., a database reading files).
*   **Profiling (Flame Graphs):** Visualizing which specific function in your code is eating the CPU.
*   **Cycle Analysis:** Looking at *CPU Stalls*. If the CPU is utilized 100% but the IPC is low, it is likely "Memory Bound" (waiting for data), not "CPU Bound" (doing math).

### 5. CPU Observability Tools
*   **Load Averages (`uptime`):** The average number of processes running + waiting. **Misleading in Linux** because it counts processes waiting for Disk I/O as "load," not just CPU usage.
*   **Standard Metrics:**
    *   `top`: Quick overview.
    *   `mpstat`: Shows stats *per CPU core* (essential to find single-core bottlenecks).
    *   `vmstat`: System-wide summary.
*   **Advanced Tracing:**
    *   `perf`: The most powerful Linux profiler. Can read hardware counters.
    *   `runqlat`: Using eBPF to measure how long tasks sit in the waiting line before running.
    *   `softirqs`/`hardirqs`: Checks if the CPU is getting spammed by hardware interrupts (e.g., network card traffic).

### 6. Visualizations
*   **Heat Maps:** A grid showing utilization over time to find spikes that "average" graphs miss.
*   **Flame Graphs:** A visualization where the width of a bar represents how much CPU time a function used. It allows you to find which function (e.g., `process_json`) is the bottleneck.

### 7. CPU Tuning
*   **Scheduler Options (`nice`, `chrt`):**
    *   `nice`: Increase or decrease a process's priority.
    *   `chrt`: Give a process Real-Time priority (dangerous, can freeze the OS if bugged).
*   **Scaling Governors:** Telling the OS to maximize performance (keep frequency high) or save power (allow frequency drops).
*   **CPU Binding (`taskset`):** Forcing a process to stay on Core 0. This improves performance by keeping CPU Caches hot (Local L1/L2 cache hits).

---

## B. Memory Performance (Chapter 7)

Memory allows the CPU to work efficiently. If Main Memory (RAM) fills up, performance falls off a cliff.

### 1. Terminology & Concepts
*   **Virtual Memory:** Programs think they have a continuous block of memory (e.g., from 0 to 10GB). In reality, the OS breaks this into localized pieces scattered across physical RAM.
*   **Paging:** The OS manages memory in chunks called Pages (usually 4KB).
    *   **Demand Paging:** The OS lies to processes. It gives them memory addresses but doesn't assign physical RAM until the app actually touches it.
    *   **Minor Fault:** The application asks for memory, and the OS re-assigns an existing page (Fast).
    *   **Major Fault:** The application asks for memory, but the OS has to read it from the **HDD/SSD**. (Very Slow—avoids this at all costs).
*   **Swapping:** When RAM is full, the OS moves old data to the Hard Drive (Swap). Because disks are 1000x slower than RAM, the system becomes unresponsive.
*   **OOM Killer (Out Of Memory):** When RAM is full and Swap is full, the Linux Kernel selects a process to kill (usually the one using the most RAM) to prevent the system from crashing.
*   **File System Cache:** Linux calls empty RAM "wasted RAM." It uses almost all free RAM to cache files you've read from the disk. This is why `free -m` often shows very little free memory, but "available" memory is high.

### 2. Memory Architecture
*   **MMU (Memory Management Unit):** Hardware inside the CPU that maps Virtual Addresses (Software) to Physical Addresses (Hardware).
*   **TLB (Translation Lookaside Buffer):** A cache for the MMU. If the translation is in the TLB, it's fast. If not (TLB Miss), it takes time.
*   **NUMA (Non-Uniform Memory Access):** On servers with multiple CPU sockets.
    *   Socket 1 has its own local RAM.
    *   Socket 2 has its own local RAM.
    *   If Socket 1 tries to access Socket 2's RAM, it must cross an interconnect (slower). You want tasks to use local memory.

### 3. Analysis Methodology
*   **USE Method for Memory:**
    *   **Utilization:** How much RAM is used vs. cached?
    *   **Saturation:** Is the system swapping (paging) heavily?
    *   **Errors:** Failing `malloc()` calls.
*   **Leak Detection:** Finding programs that allocate memory but never `free()` it. The "RSS" (Resident Set Size) keeps growing over time.
*   **Working Set Size (WSS):** A process might allocate 10GB, but only actively use 1GB every minute. 1GB is the WSS. Knowing this helps scale servers correctly.

### 4. Memory Observability Tools
*   **Standard Metrics:**
    *   `free -h`: Show used/available RAM.
    *   `vmstat`: Shows "swap in" (`si`) and "swap out" (`so`). If these numbers are non-zero, you have a problem.
*   **PSI (Pressure Stall Information):** A modern Linux metric that tells you: "In the last 10 seconds, specific tasks spent 20% of their time just waiting for memory." It detects memory contention before swapping starts.
*   **Advanced Tracing:**
    *   `drsnoop`: Traces the kernel "Direct Reclaim" function (when the OS panics to find free RAM).
    *   `pmap`: Prints the memory map of a specific process (shows libraries, heap, stack).

### 5. Memory Tuning
*   **Huge Pages:** Standard pages are 4KB. Large databases (Oracle, Postgres, MongoDB) manage terabytes of RAM. Managing millions of 4KB pages overloads the MMU/TLB. **Huge Pages** (2MB or 1GB) reduce the bookkeeping overhead significantly.
*   **`vm.swappiness`:** A kernel setting (0-100). High value = swap aggressively. Low value = avoid swapping as much as possible.
*   **`overcommit_memory`:** Controls if the OS allows allocating more virtual memory than physical RAM exists.
*   **NUMA Binding (`numactl`):** Using commands to say "Run this database on CPU Socket 1 and *only* use the RAM attached to Socket 1." This prevents slow cross-interconnect memory access.

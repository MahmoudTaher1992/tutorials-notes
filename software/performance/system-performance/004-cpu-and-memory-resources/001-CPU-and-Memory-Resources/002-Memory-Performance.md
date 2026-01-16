Based on the Table of Contents you provided, this document outlines a comprehensive guide to understanding, analyzing, and tuning **CPU** and **Memory** resources in a computer system (likely Linux-based). This structure closely mirrors the methodologies found in systems engineering books like Brendan Gregg's *Systems Performance*.

Here is a detailed explanation of the concepts listed in your ToC, broken down by section.

---

### Part A: CPU Performance (The "Brain")

This section focuses on how the processor works, how to measure its efficiency, and how to fix bottlenecks.

#### 1. Terminology & Models
*   **CPU Architecture:**
    *   **Sockets/Packages:** The physical chips plugged into the motherboard.
    *   **Cores:** The independent processing units inside a physical chip.
*   **CPU Caches (L1, L2, L3):** This is crucial for speed. The CPU is incredibly fast, but RAM is relatively slow. Caches are tiny, ultra-fast memory banks located *on* the CPU.
    *   *L1:* Smallest, fastest, closest to the core.
    *   *L3:* Larger, shared between cores, slightly slower.
    *   *Concept:* If data is in L1, the CPU works instantly. If it has to fetch from RAM, the CPU sits idle (stalls) waiting for data.
*   **Run Queues:** A line of tasks (threads) waiting to be executed. If the CPU is 100% busy, tasks must wait in the "Run Queue." A long queue means high latency (lag).

#### 2. Key CPU Concepts
*   **IPC vs. CPI:**
    *   **Clock Rate (GHz):** How "fast" the engine spins.
    *   **IPC (Instructions Per Cycle):** How much work gets done per spin. A high GHz CPU with low IPC might actually be slower than a lower GHz CPU with high IPC.
*   **Hyper-threading (SMT):** Presenting one physical core as two "logical" processors to the OS. It allows the core to work on task B while Task A is stalled waiting for memory. It improves efficiency but does not double performance.
*   **User vs. Kernel Time:**
    *   **User Time:** CPU time spent running your application code (calculations, loops).
    *   **Kernel Time:** CPU time spent processing system calls (talking to disks, network, managing hardware). High kernel time usually indicates a system-level issue.
*   **Priority Inversion:** A scenario where a low-priority task holds a lock (resource) that a high-priority task needs, causing the high-priority task to wait.

#### 3. Analysis Methodology & Tools
*   **The USE Method:** A checklist for diagnosis:
    *   **Utilization:** Is the CPU busy? (e.g., 90% usage).
    *   **Saturation:** Is there a line forming? (Run queue length).
    *   **Errors:** Are there hardware errors?
*   **Flame Graphs:** A visualization method (usually red/orange stacked bars) that shows exactly which functions in your code are consuming the most CPU time.
*   **Tools:**
    *   `top` / `htop`: Basic monitoring.
    *   `vmstat 1`: Shows system-wide CPU lists and run queue length.
    *   `perf`: The "gold standard" tool. It can trace specific hardware events, count CPU cycles, and analyze cache misses.
    *   `runqlat`: Measures how long a task sits waiting for the CPU (latency).

#### 4. CPU Tuning
*   **Scheduler Options (`nice`):** Changing the priority of a process. A "nicer" process lets others go first.
*   **CPU Binding (`taskset`):** Forcing a process to run *only* on specific cores (e.g., Core 0 and 1). This increases cache efficiency (L1 cache remains "warm").

---

### Part B: Memory Performance (The "Workspace")

This section covers RAM, how the OS manages it, and what happens when you run out.

#### 1. Terminology & Concepts
*   **Virtual Memory:** The OS lies to programs. It tells every program: "You have access to all the memory." The OS maps this "Virtual" view to the actual "Physical" RAM sticks.
*   **Paging:** Memory is divided into small chunks called "Pages" (usually 4KB).
    *   **Minor Fault:** The program asks for memory, and the OS simply re-points a pointer. Fast.
    *   **Major Fault:** The program asks for memory, but the data is on the **Disk**. The OS must read from the disk (millions of times slower than RAM) to load it.
*   **Swapping:** When RAM is full, the OS moves inactive pages to the Hard Drive (Swap space) to free up RAM. This is the **Performance Killer**. If your system is swapping actively, it will become unresponsive.
*   **OOM Killer (Out of Memory):** If RAM is full and Swap is full, the Linux Kernel panics and selects a process (usually the one using the most RAM) and kills it instantly to save the rest of the system.

#### 2. Memory Architecture
*   **MMU (Memory Management Unit):** Hardware that translates Virtual Addresses to Physical Addresses.
*   **TLB (Translation Lookaside Buffer):** A "cheat sheet" (cache) for the MMU. If the address translation is in the TLB, it's fast. If not (TLB Miss), it's slower.
*   **NUMA (Non-Uniform Memory Access):** In servers with multiple CPUs (Sockets), RAM is attached directly to specific CPUs.
    *   If CPU 1 accesses its own RAM, it's fast.
    *   If CPU 1 accesses CPU 2's RAM, it's slower (cross-interconnect).

#### 3. Analysis Methodology
*   **Leak Detection:** Finding programs that grab memory (`malloc`) but never release it (`free`), causing available RAM to shrink over time until the server crashes.
*   **Working Set Size (WSS):** How much memory a program *actually* uses actively inside a specific time window, versus how much it requested.

#### 4. Memory Observability Tools
*   `free -m`: Shows total, used, and cached memory.
*   `vmstat`: Shows swap activity (`si`/`so` - Swap In/Swap Out). **Tip:** If `si` or `so` is non-zero, you have a memory shortage.
*   `drsnoop`: Traces "Direct Reclaim," which happens when the OS is desperately looking for free memory, slowing down applications.
*   `pmap`: Shows the memory map of a specific process (where its heap, stack, and libraries live).

#### 5. Memory Tuning
*   **Huge Pages (THP):** Standard pages are 4KB. "Huge Pages" are 2MB or 1GB.
    *   *Benefit:* The CPU has to track fewer pages, reducing TLB misses and improving performance for databases (like Oracle, PostgreSQL) or Java heaps.
*   **Swappiness (`vm.swappiness`):** A dial (0-100) telling the kernel how aggressively to use Swap.
    *   *Low value (0-10):* "Avoid swap unless absolutely necessary." (Good for databases).
    *   *Default (60):* Balanced usage.

---

### Summary of the Document
This document is a technical deep dive. It moves from **understanding** the hardware (Cores/RAM), to **measuring** it (Metics/Tools like `perf`), to **fixing** it (Tuning/Binding).

*   **If your specific problem is Slowness:** Focus on the **CPU Saturation** (Run Queues) section.
*   **If your specific problem is crashing apps:** Focus on the **Memory OOM and Leak Detection** section.

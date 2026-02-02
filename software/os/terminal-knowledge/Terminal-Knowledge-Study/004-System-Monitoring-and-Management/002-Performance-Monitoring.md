Based on the Table of Contents you provided, here is a detailed explanation of section **Part IV.B: Performance Monitoring**.

This section focuses on diagnosing the health of a Linux system. When a server feels "slow" or an application crashes, these are the concepts and tools used to investigate the root cause (bottlenecks).

---

# 002-Performance-Monitoring.md

## 1. CPU Usage
The Central Processing Unit (CPU) is the brain of the computer. If the CPU is 100% utilized, the system becomes sluggish because it cannot process instructions fast enough.

### Key Concepts
*   **User vs. Kernel Space:** Strategies to separate applications (User) from the core system (Kernel). If your User CPU is high, your app is busy. If System/Kernel CPU is high, the OS is struggling with hardware drivers or I/O.
*   **Load Average:** A distinct metric from "% usage." It measures the *trend* of system demand over 1, 5, and 15 minutes. A load of 1.0 means the CPU is fully utilized (on a single-core system). A load of 5.0 on a single-core system means 4 processes are waiting in line for every 1 currently running.

### The Tools
*   **`top`**: The classic, built-in task manager.
    *   *Use case:* Quickest way to check load average and see which process is eating the CPU.
    *   *Key metrics:* Look at `%CPU` (current usage) and `wa` (IO wait - meaning the CPU is idle only because it is waiting for the slow hard drive).
*   **`htop`**: An interactive, colorful, modern version of `top`.
    *   *Use case:* Easier for humans to read. It uses bar charts, allows scrolling with a mouse, and lets you kill processes easily.
*   **`vmstat`** (Virtual Memory Statistics):
    *   *Use case:* Unlike `top`, which refreshes the screen, `vmstat 1` prints a new line every second. This handles historical logging well.
    *   *Key columns:* `us` (user time), `sy` (system time), `id` (idle time), and `wa` (wait time).

---

## 2. Memory Usage (RAM)
When a system runs out of RAM (Random Access Memory), it either crashes applications (OOM Kill) or starts using the hard drive as fake RAM (Swap), which is incredibly slow.

### Key Concepts
*   **Physical vs. Swap:** Physical is your actual RAM sticks. **Swap** is a file on your hard drive used as overflow memory. If Swap usage is high, performance will tank.
*   **Buffers/Cache:** Linux loves to use "empty" RAM to cache files to speed up the disk.
    *   *Tip:* Do not panic if "Free" memory looks low. Look at "Available" memory. "Free" usually means memory that is doing absolutely nothing; Linux prefers to fill that with cache.

### The Tools
*   **`free`**: The standard command to check RAM.
    *   *Command:* `free -h` (human readable, shows GB/MB).
    *   *Key metrics:* `total`, `used`, and most importantly `available` (how much memory is actually open for new applications).
*   **`vmstat`**:
    *   *Key metrics:* The `si` (swap in) and `so` (swap out) columns. If these numbers are essentially anything other than zero, your specific system is out of RAM and is "thrashing" (writing to disk constantly).
*   **`top` / `htop`**:
    *   These show memory usage **per process**.
    *   *Key metrics:* `VIRT` (Virtual memory - huge and usually irrelevant) vs. `RES` (Resident memory - the actual physical RAM the app is using).

---

## 3. Disk I/O (Input/Output)
Often, a "slow CPU" is actually a slow disk. If the CPU requests a file and has to wait 10 milliseconds for the disk to spin, the CPU sits idle (in a state called I/O Wait).

### Key Concepts
*   **Throughput:** How much data is moving (e.g., 100 MB/s).
*   **IOPS:** Input/Output Operations Per Second. (e.g., Reading 1,000 tiny files is harder on a disk than reading 1 giant file, even if the total size is the same).
*   **Latency:** How long a read/write request takes to complete.

### The Tools
*   **`iostat`**: Part of the `sysstat` package. shows statistics for storage devices.
    *   *Command:* `iostat -xz 1` (extended stats, remove unused devices, refresh every 1 second).
    *   *Key Metric:* `%util`. If this is near 100%, your disk is physically saturated and cannot work any harder.
*   **`iotop`**:
    *   *Use case:* Just like `top`, but ranks processes by how much they are reading/writing to the disk.
    *   *Scenario:* You don't know *what* is slowing down the server, run `iotop` and you might see a backup script or database monopolizing the drive.

---

## 4. Comprehensive Tools
While the previous tools look at specific components, these tools provide a "Dashboard" view of the whole system at once.

### The Tools
*   **`atop` (Advanced System & Process Monitor)**:
    *   **The Killer Feature:** It records history. If your server crashed at 3:00 AM, standard tools can't tell you why. If `atop` is running as a service, you can "rewind" to 3:00 AM and see the state of the system then.
    *   It also highlights critical resources in **Red** automatically (e.g., if Disk is 90% busy, the disk lines turn red).
*   **`glances`**:
    *   A modern, Python-based monitoring tool.
    *   *Interface:* It packs incredible density into one screen: CPU, RAM, Load, Network rates, Disk I/O, Docker containers, System sensors (temperature), and heavy processes.
    *   *Web Mode:* You can run `glances -w` to view the terminal output in a web browser.

---

### Summary Workflow for Troubleshooting
If a system is slow, use this workflow based on these tools:

1.  **Run `top` or `htop`:** Is CPU high?
    *   *Yes:* Check which process is doing it.
    *   *No:* Check **Wait (wa)** percentage.
2.  **If Wait (wa) is high:**
    *   Run **`iotop`** to see who is writing to the disk.
3.  **If CPU is low but the system is slow:**
    *   Run **`free -h`**. Is `available` memory near zero?
    *   Run **`vmstat 1`**. Are `si`/`so` (swap) moving? You are out of RAM.

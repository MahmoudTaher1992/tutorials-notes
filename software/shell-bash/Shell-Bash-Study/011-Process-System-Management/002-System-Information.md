This section of the roadmap focuses on **System Observability**. As a user or administrator, you need to know the health of your machine. Is the hard drive full? Is the RAM maxed out? Is the CPU overloaded?

Here is a detailed breakdown of the commands listed in **Part XI, Section B: System Information**.

---

### 1. Memory Usage: `free`

The `free` command provides a snapshot of the memory (RAM) and Swap space on your system.

**Why use it?**
To diagnose if your system is running slowly because it has run out of RAM and is resorting to "swapping" (writing temporary memory to the slow hard disk).

**Key Flags:**
*   `free`: (Default) Shows numbers in kilobytes (hard to read).
*   **`free -h`**: (Most common) "Human-readable." Converts numbers to MB or GB automatically.
*   `free -s 5`: Updates the stats every 5 seconds.

**Understanding the Output:**
When you run `free -h`, you will see something like this:

```bash
              total        used        free      shared  buff/cache   available
Mem:           16Gi       4.5Gi       8.0Gi       200Mi       3.5Gi       11Gi
Swap:         2.0Gi          0B       2.0Gi
```

*   **Total:** Your total physical stick of RAM.
*   **Used:** Memory actively held by processes.
*   **Buff/Cache:** Linux is designed to use "unused" RAM to cache files so they open faster. **Do not panic if this number is high.** This memory can be dropped instantly if an application needs it.
*   **Available:** The most important number. This is the actual amount of memory available for new applications to start without swapping.

---

### 2. Disk Usage: `df` vs. `du`

Beginners often confuse these two. An easy mnemonic is:
*   **df** = **D**isk **F**ree (Filesystem level).
*   **du** = **D**isk **U**sage (File/Directory level).

#### The `df` command (Filesystem)
Reports the amount of disk space used and available on the overall file systems (partitions).

*   **`df -h`**: Human-readable (shows GB and TB).
*   **What to look for:** Look at the **`Use%`** column on the line ending with `/` (the root directory). If this is near 100%, your server is about to crash.

#### The `du` command (Directory size)
Estimates file space usage. It calculates the size of a specific directory and its contents.

*   **`du -sh foldername`**:
    *   `-s`: Summary (don't list every single file, just the total).
    *   `-h`: Human-readable.
    *   *Example:* `du -sh /var/log` (Tells you exactly how big your log folder is).
*   **`du -h --max-depth=1`**: Shows the size of the current folder and its immediate subfolders. Great for drilling down to find *what* is eating your disk space.

---

### 3. System Uptime: `uptime`

This simple command tells you how long the system has been running, how many users are logged in, and the **System Load Averages**.

**Output Example:**
` 14:30:05 up 10 days,  4:12,  2 users,  load average: 0.50, 0.80, 1.10`

**The Breakdown:**
1.  **Time:** Current system time.
2.  **Up:** How long since the last reboot.
3.  **Users:** Count of active terminal sessions.
4.  **Load Average:** This is the most complex concept here. It shows three numbers representing the average system load over the last **1**, **5**, and **15** minutes.

**Understanding Load Average:**
*   Load represents the number of processes **waiting** for the CPU time.
*   **Ideally:** The number should be lower than the number of CPU cores you have.
*   *Example:* If you have a **4-Core** CPU:
    *   Load of `2.0`: No problem (50% usage).
    *   Load of `4.0`: Fully utilized (100% usage).
    *   Load of `8.0`: Overloaded. Processes are waiting in line, causing lag.

---

### 4. I/O and CPU Stats: `iostat` and `vmstat`

When `top` or `uptime` shows a high load, these tools tell you *why*. Are we waiting on the Processor (CPU) or the Hard Drive (I/O)?

*(Note: These usually require installing the `sysstat` package).*

#### `iostat` (Input/Output Statistics)
This focuses heavily on your storage devices.

*   **Command:** `iostat -xz 1` (Extended stats, remove unused devices, update every 1 second).
*   **Key Metric: `%iowait`**: If the CPU is idle but `%iowait` is high, your CPU is bored waiting for the hard drive to read/write data. This usually means you need a faster SSD or your database is doing too much writing.

#### `vmstat` (Virtual Memory Statistics)
This gives a unified view of processes, memory, paging, block IO, traps, and CPU activity.

*   **Command:** `vmstat 1` (Update every second).
*   **Key Columns:**
    *   **`si` / `so` (Swap In / Swap Out):** If these numbers are consistently non-zero, your computer is actively reading/writing RAM to the hard drive. This kills performance. You need more RAM.
    *   **`us` (User time):** % of CPU used by your apps.
    *   **`sy` (System time):** % of CPU used by the Kernel.
    *   **`id` (Idle):** % of CPU doing nothing.

---

### Summary Workflow (How to use them together)

1.  **System feels slow.**
2.  Run **`uptime`**. Is the Load Average higher than your CPU core count?
    *   *Yes:* Something is hogging resources.
3.  Run **`free -h`**. Is RAM full? Is Swap used?
    *   *Yes:* You are out of memory (`vmstat` will confirm high swap usage).
4.  Run **`df -h`**. Is the disk 100% full?
    *   *Yes:* Programs can't write temp files and are crashing. Use `du -sh` to find the big files and delete them.
5.  If RAM and Disk space look fine, run **`iostat`** or **`top`**.
    *   Is `%iowait` high? Your weakness is the hard drive speed.
    *   Is `%user` high? A specific program process is eating the CPU.

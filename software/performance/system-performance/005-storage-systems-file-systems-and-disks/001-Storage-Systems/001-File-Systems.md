This outline comes from a systems engineering context (likely related to Linux performance analysis, similar to the structure found in Brendan Gregg’s work). It divides storage into two distinct layers:
1.  **File Systems:** The software layer that manages files, directories, and caching.
2.  **Disks (Block Devices):** The hardware layer (or virtualized hardware) that actually stores the bits.

Here is a detailed explanation of every section in the outline.

---

## Part V: Storage Systems (File Systems & Disks)

### A. File Systems (Chapter 8)
*The software abstraction that organizes data into files and directories.*

#### **1. Terminology & Models**
*   **VFS (Virtual File System):** This is the kernel's "universal translator." Applications (like Chrome or Python) engage with the VFS. The VFS then translates those requests to the specific file system driver (e.g., Ext4, NTFS, XFS). This allows Linux to read many different distinct file systems using the same standard commands (`open`, `read`, `write`).
*   **Logical I/O:** These are requests from the **Application to the Kernel**. Example: A web server asks to read a 1GB logical file.
*   **Physical I/O:** These are requests from the **Kernel to the Disk**.
    *   *Crucial distinction:* If you request a 1GB file (Logical I/O) and it is already in RAM, the Physical I/O is 0.
*   **Metadata:** Data describing the file, not the file contents itself.
    *   **Inode:** Stores permissions, owner, timestamps, and pointers to where the data blocks live on disk.
    *   **Dentry (Directory Entry):** Maps a filename (`holiday.jpg`) to an Inode number.

#### **2. Core Concepts**
*   **File System Caches (The most critical performance layer):**
    *   **Page Cache:** Linux uses unused RAM to cache file contents. Reads from here are measured in nanoseconds (vs. milliseconds for disk). This is why re-opening an app is faster the second time.
    *   **Dentry/Inode Cache:** Caches the existence of files and their permissions so the OS doesn't have to look up "Does `/etc/passwd` exist?" on the slow disk every time.
*   **I/O Access Patterns:**
    *   **Sequential:** Reading data in order (start to finish). HDDs love this because the physical head doesn't need to move much.
    *   **Random:** Jumping around a file. HDDs hate this (high seek time latency).
*   **Write Strategies:**
    *   **Write-Back (Async):** The app writes to RAM (Page Cache) and the OS says "Success!" immediately. The OS writes to disk later. *Risk:* If power fails before the flush, data is lost.
    *   **Write-Through (Sync):** The app waits until the data hits the physical disk. Much slower, but data is safe. Database logs usually use this.
*   **Features:**
    *   **mmap:** Maps a file directly into memory addresses, allowing the CPU to read a file as if it were RAM, skipping standard system call overhead.

#### **3. File System Architecture**
*   **The I/O Stack:** The path data travels:
    `App` calls `read()` $\to$ `VFS` checks Cache $\to$ `FS Driver` (e.g., Ext4) maps file to blocks $\to$ `Block Device Driver` $\to$ Physical Disk.
*   **File System Types:**
    *   **Ext4:** The Linux "workhorse." Reliable, standard, good all-rounder.
    *   **XFS:** Great for massive files and parallel operations (enterprise standard).
    *   **ZFS / Btrfs:** "Next-Gen" file systems. They include Volume Management (RAID functionality), Checksums (data integrity), and **COW** (Copy-On-Write).
*   **COW (Copy-On-Write):** When modifying a file, these systems don't overwrite the old data. They write the new data to a *new* block and update the pointer.
    *   *Benefit:* Crash consistency (no partial overwrites).
    *   *Downside:* Can cause fragmentation over time (files get scattered).

#### **4. Analysis & Observability**
*   **Methodology:** You analyze FS performance by checking **Latency** (how long syscalls take) and **Cache Hit Ratio** (are we avoiding the disk?).
*   **Tools:**
    *   **`df -h` / `mount`:** Check space and how the disk is configured.
    *   **`strace`:** Attaches to a specific process to see every read/write call. (Heavy distinct overhead, use with care).
    *   **`opensnoop`:** Uses eBPF to trace every file `open` across the whole system. Great for finding config files an app is desperately trying to find.
    *   **`*slower` tools (e.g., `ext4slower`):** Instead of logging everything, it only logs operations that take longer than (e.g.) 10ms. This finds the "needles in the haystack."
    *   **`cachestat`:** Tells you the percentage of reads served from RAM (Page Cache).

#### **5. Tuning**
*   **`noatime`:** A mount option. By default, Linux writes to the disk every time you *read* a file to update the "Access Time." Turning this off (`noatime`) saves huge amounts of unnecessary write I/O.
*   **Journaling:** You can tune how often the file system commits its journal (transaction log) to balance safety vs. speed.

---

### B. Disks & Block Devices (Chapter 9)
*The hardware layer (HDD/SSD) that handles raw data blocks.*

#### **1. Terminology & Models**
*   **Block Interface:** The disk does not know what a "file" or "image" is. It only knows "Sector 500." The OS sends requests to read/write specific numbered blocks.
*   **Rotational (HDD):** Mechanical disks. Latency is dominated by physics (moving the arm, spinning the platter).
*   **SSD/NVMe:** Flash storage. No moving parts. Requires complicated internal management (garbage collection) to clean up used cells.

#### **2. Core Concepts**
*   **Time Scales (The Grand Canyon):**
    *   CPU Cycle: ~0.3 nanoseconds.
    *   RAM Access: ~100 nanoseconds.
    *   HDD Seek involved: ~10,000,000 nanoseconds (10ms).
    *   *Concept:* When a CPU waits for a HDD, it is like a human waiting months for a letter to arrive.
*   **IOPS vs. Throughput:**
    *   **IOPS:** How *many* requests per second? (Important for databases/web servers).
    *   **Throughput:** How *much data* (MB/s)? (Important for streaming video/backups).
*   **I/O Size:**
    *   Small I/O (4KB) stresses IOPS.
    *   Large I/O (1MB) stresses Throughput.
*   **Saturation & Utilization:**
    *   **Utilization:** Is the disk working? (0-100%).
    *   **Saturation:** Is the disk *overwhelmed*? (Are requests piling up in a wait queue?).

#### **3. Disk Architecture**
*   **Interfaces:**
    *   **SATA/SAS:** Older protocols. Have a single command queue.
    *   **NVMe:** Modern protocol for SSDs which connects directly to the PCIe bus. Supports thousands of parallel queues.
*   **RAID (Redundant Array of Independent Disks):**
    *   **RAID 0 (Striping):** Fast, no redundancy. If one drive fails, all data is lost.
    *   **RAID 1 (Mirroring):** Data written to two drives. Safe, but writes are slower (must write twice).
    *   **RAID 5/6 (Parity):** Uses math to recover data if a drive fails. Has a "write penalty" (must read, calculate math, then write).

#### **4. Analysis Methodology (The USE Method)**
*   **Utilization:** Check `%util` in `iostat`.
*   **Saturation:** Check `avgqu-sz` (Queue size) in `iostat`.
*   **Errors:** Check kernel logs for SCSI errors (sign of dying hardware).
*   **Bi-Modal Latency:** If you graph disk latency, you usually see two humps:
    1.  **Fast hump:** The disk's internal RAM buffer caught the request.
    2.  **Slow hump:** The disk had to physically read the media.

#### **5. Disk Observability Tools**
*   **`iostat -xnz 1` (The Holy Grail):** The standard command to watch disks.
    *   **`await`**: Total time (wait in queue + service time). High await = Application hangs.
    *   **`avgqu-sz`**: How many requests are waiting. > 1 usually means saturation.
*   **`biolatency` / `biosnoop`:** Modern eBPF tools that measure exactly how long the disk takes to respond to the OS, ignoring filesystem overhead.
*   **`blktrace`:** A specialized debugger that records every single event in the Linux block layer (queue insert, merge, issue, complete).

#### **6. Visualizations**
*   **Latency Heat Maps:** A graph where X=Time, Y=Latency, Color=Frequency.
    *   This is superior to averages because an "Average" hides spikes. A heat map clearly shows if 99% of requests are fast but 1% are taking 5 seconds (which kills performance).

#### **7. Tuning**
*   **I/O Schedulers:** Algorithms the OS uses to re-order disk requests for efficiency.
    *   **`mq-deadline`**: Standard for SSDs.
    *   **`bfq`**: Complex; prioritizes interactivity (prevents mouse lag during large file copies).
    *   **`none` / `noop`**: Used for high-end NVMe. The hardware is so fast that the OS software scheduler only slows it down, so the OS just passes requests straight through.
*   **Read-Ahead:** The OS detects you are reading a file sequentially, so it speculatively reads the *next* blocks into RAM before you ask for them. Tuning this higher improves movie playback or backup speed.

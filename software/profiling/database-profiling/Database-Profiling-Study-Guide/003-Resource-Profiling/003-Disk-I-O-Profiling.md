Here is a detailed explanation of **Part 9: Disk I/O Profiling** from your study guide.

---

# 9. Disk I/O Profiling: Detailed Explanation

Disk I/O (Input/Output) is traditionally the slowest component of a database system. While CPU cycles are measured in nanoseconds and RAM access in microseconds, Disk I/O is measured in milliseconds. Because it is the bottleneck, profiling it is critical for performance tuning. This section focuses on how databases talk to storage, how to measure that conversation, and how to optimize it.

## 9.1 Database I/O Patterns

Databases do not read and write files like a text editor (loading the whole file at once). They perform specific types of I/O operations depending on the task.

### 9.1.1 Random vs. Sequential I/O
*   **Sequential I/O:** Reading or writing data in a contiguous block.
    *   *Example:* A **Full Table Scan** or writing to the **Transaction Log (WAL)**.
    *   *Performance:* Fast. Hard drives (HDDs) love this because the head doesn't move. SSDs prefer it because they can batch operations.
*   **Random I/O:** Jumping around the disk to find specific bits of data.
    *   *Example:* **Index Lookups** (finding one user by ID) or updating rows scattered across a table.
    *   *Performance:* Slow. This is the hardest workload for storage. The goal of database tuning is often to turn Random I/O into Sequential I/O (e.g., via buffering).

### 9.1.2 Read vs. Write Patterns
*   **Reads:** Often synchronous and blocking. The user sends a query and waits. If the data isn't in RAM (Buffer Pool), the database *must* go to disk immediately.
*   **Writes:** Often asynchronous. When you `UPDATE` a row, the database changes it in RAM and writes a small note to the Transaction Log. The actual data file on disk is updated later (by a "Checkpoint"). This makes writes feel faster than reads to the user.

### 9.1.3 Synchronous vs. Asynchronous I/O
*   **Synchronous:** The database thread pauses execution until the disk confirms, "I have finished writing/reading." Safe, but high latency.
*   **Asynchronous (AIO):** The database issues a request ("Go fetch these 10 pages") and continues doing other work. The OS notifies the database when the data arrives. Modern high-performance databases rely heavily on AIO to keep the CPU busy while waiting for the disk.

### 9.1.4 Direct I/O vs. Buffered I/O
*   **Buffered I/O:** The Standard OS behavior. The database writes to a file, but the OS keeps it in the "Page Cache" (OS RAM) and writes it to the physical disk later.
    *   *Problem:* This creates "Double Buffering." The data is in the Database RAM and the OS RAM. It wastes memory.
*   **Direct I/O (`O_DIRECT`):** The database tells the OS, "Bypass your cache; write directly to the physical hardware."
    *   *Benefit:* The database manages its own memory more efficiently than the general-purpose OS can. Most production databases (Oracle, MySQL InnoDB, Postgres) prefer Direct I/O.

---

## 9.2 I/O Metrics

To analyze storage performance, you need to understand the language of disk metrics.

### 9.2.1 IOPS (Inputs/Outputs Per Second)
*   **Definition:** The number of distinct read/write requests sent to the disk per second.
*   **Context:** Important for **Random I/O**.
    *   A standard HDD might do 150 IOPS.
    *   A SATA SSD might do 10,000 IOPS.
    *   An NVMe drive might do 500,000 IOPS.
*   **Profiling:** If your database demands 200 IOPS and you are on a spinning disk, the system will crawl.

### 9.2.2 Throughput (MB/s)
*   **Definition:** The volume of data transferred per second.
*   **Context:** Important for **Sequential I/O** (e.g., Backups, ETL jobs, Full Scans). You can have low IOPS (few requests) but high throughput (each request is huge).

### 9.2.3 Latency (Average vs. Percentiles)
*   **Definition:** How long a single I/O request takes to complete.
*   **The Trap of Averages:** "Average latency is 5ms" sounds good. But if 99 requests took 1ms and 1 request took 400ms, the average is low, but one user is very angry.
*   **Best Practice:** Always measure **p95** or **p99** latency (the experience of the slowest 5% or 1% of queries).

### 9.2.4 Queue Depth
*   **Definition:** The number of I/O requests waiting in line to be processed by the disk controller.
*   **Interpretation:**
    *   *Queue ~1:* The disk is idle.
    *   *Queue > 4 (per drive):* The disk is saturated (drowning in work). Latency will spike.

### 9.2.5 I/O Wait Time
*   **Definition:** The percentage of time the CPU was idle specifically because it was waiting on the disk.
*   **Analysis:** High I/O Wait usually means the CPU is powerful enough, but the storage is too slow.

---

## 9.3 Storage Components Profiling

Not all files on the disk are treated equally. You must profile *which* database files are being hit.

### 9.3.1 Data Files I/O
*   This is the main storage (the Heap).
*   **Pattern:** Mostly random reads (fetching rows) and random writes (updating rows).
*   **Profiling:** If this is high, you likely have a cold Buffer Pool (cache) or are doing too many Table Scans.

### 9.3.2 Index Files I/O
*   **Pattern:** Highly random reads (walking B-Tree nodes).
*   **Optimization:** Indexes should ideally fit entirely in RAM. If you see heavy *read* I/O on index files, it implies your indexes are too large for memory, killing performance.

### 9.3.3 Transaction Log / WAL (Write Ahead Log) I/O
*   **Pattern:** almost exclusively **Sequential Writes**.
*   **Criticality:** Every `COMMIT` waits for this write to finish (Durability). If this is slow, every write transaction in your system slows down.
*   **Optimization:** These files are often placed on a separate, dedicated, low-latency disk.

### 9.3.4 Temporary Files I/O
*   **Pattern:** Sequential reads/writes.
*   **Cause:** Occurs when a query (Sort/Hash) needs more memory than is allocated (`work_mem`). The database "spills" to disk.
*   **Profiling:** Any activity here is bad. It indicates memory configuration needs tuning or queries are inefficient.

### 9.3.5 Checkpoint I/O Patterns
*   **Definition:** The background process that takes "dirty" pages from RAM and flushes them to the Data Files.
*   **Pattern:** Heavy write bursts.
*   **Issue:** If not tuned, a checkpoint can saturate the disk controller, freezing user queries for seconds (a "Checkpoint Spike").

### 9.3.6 Background Writer Activity
*   **Definition:** A "janitor" process that trickles dirty pages to disk slowly to prevent the Checkpoint from having too much work to do at once. Profiling this ensures the load is spread out evenly.

---

## 9.4 I/O Bottleneck Identification

How do you spot the problem?

### 9.4.1 Storage Saturation Detection
*   Using tools like `iostat -x`, check `%util`. If it is near 100%, the disk is physically unable to do more work.
*   Check IOPS limits (especially in Cloud/AWS). If you bought a 3,000 IOPS EBS volume and you hit 3,000, latency will skyrocket due to throttling.

### 9.4.2 I/O Wait Analysis
*   Look at wait events inside the database.
    *   *Oracle:* `db file sequential read` (waiting on index), `db file scattered read` (waiting on full scan).
    *   *Postgres:* `WaitEventIO`.
    *   If these are the top wait events, you have an I/O bottleneck.

### 9.4.3 Hot Files/Tables Identification
*   Sometimes the whole disk isn't slow, just one specific area.
*   **Hotspotting:** If 90% of I/O is hitting one specific table file, that table might need partitioning, better indexing, or caching.

### 9.4.4 Log Write Bottlenecks
*   If `Log File Sync` (Oracle) or `WALWriteLock` (Postgres) is high, your commit speed is limited by the disk. Move the logs to faster storage (NVMe).

### 9.4.5 Checkpoint Spikes
*   Monitor throughput over time. If you see a "Sawtooth" pattern (performance is fine, then drops to zero for 10 seconds, then fine again), your checkpointing configuration is too aggressive.

---

## 9.5 I/O Optimization

How to fix I/O issues (besides "buying faster disks").

### 9.5.1 Storage Configuration
*   **RAID:**
    *   **RAID 10:** (Mirror + Stripe) Best for databases. High read/write speed, redundancy.
    *   **RAID 5/6:** (Parity). **Avoid for DBs.** Writes are slow because parity must be calculated for every write.
*   **SSD/NVMe:** Essential for OLTP.

### 9.5.2 Filesystem Selection and Tuning
*   **Selection:** XFS is generally preferred over EXT4 for databases on Linux due to better handling of large files and concurrency.
*   **noatime:** Mount disks with the `noatime` flag. Otherwise, every time you *read* a file, the OS writes to the disk to update the "Last Accessed Time," doubling I/O overhead.

### 9.5.3 File Placement Strategies
*   **Separation:** Physically separate the **WAL/Redo Logs** from the **Data Files**.
    *   *Reason:* Data files do random I/O. Logs do sequential I/O. If they share a spinning disk, the head jumps back and forth, destroying sequential performance.

### 9.5.4 I/O Scheduler Tuning
*   The Linux Kernel has a scheduler for disk requests.
*   **CFQ (Completely Fair Queuing):** Usually bad for databases.
*   **Deadline / Noop:** Usually better. For SSDs, use `none` or `kyber`/`bfq` (depending on kernel version), letting the SSD controller handle the ordering.

### 9.5.5 Read-Ahead Configuration
*   **Concept:** If you request block 10, the OS guesses you might want block 11 and reads it too.
*   **Tuning:**
    *   Good for sequential scans (OLAP).
    *   Bad for random index lookups (OLTP), as it pollutes the cache with data you don't need.

### 9.5.6 Write-Back vs. Write-Through Caching
*   **Hardware Controllers:** RAID cards have their own RAM cache.
*   **Write-Back:** The controller says "Written!" as soon as data hits the card's RAM (Fast). **Danger:** If power fails, data is lost. *Must* have a Battery Backup Unit (BBU).
*   **Write-Through:** The controller waits until data hits the physical disk (Safe, but slower).
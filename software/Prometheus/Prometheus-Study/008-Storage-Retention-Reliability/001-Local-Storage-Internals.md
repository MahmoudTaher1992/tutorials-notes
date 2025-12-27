This section delves into the engine room of Prometheus: its **Time Series Database (TSDB)**. Understanding this is critical for capacity planning, troubleshooting high memory usage, and ensuring your monitoring data survives a server crash.

Prometheus does not use SQL or a generic NoSQL database. It uses a custom-built local TSDB optimized for writing millions of data points per second and querying them via time ranges.

Here is the detailed breakdown of **008-Storage-Retention-Reliability / 001-Local-Storage-Internals**.

---

### 1. The Write-Ahead Log (WAL)

The WAL is the safety net that prevents data loss.

*   **The Problem:** When Prometheus scrapes metrics, it initially holds them in **RAM (Memory)** for speed. If the server crashes or restarts before that data is saved to the hard disk, that data would be lost forever.
*   **The Solution (WAL):** Before Prometheus records a metric in memory, it first appends it to a file on the disk called the **Write-Ahead Log**.
*   **How it works:**
    1.  **Ingestion:** A scrape occurs.
    2.  **Sequential Write:** The data is written to the end of the active WAL file (`data/wal` directory). This is very fast because it is a sequential disk write (no seeking required).
    3.  **In-Memory:** Once written to the WAL, the data is stored in RAM structures.
    4.  **Crash Recovery:** If Prometheus restarts, it reads the WAL file from start to finish to "replay" the history and rebuild the state of the memory exactly as it was before the crash.
*   **Checkpointing:** To prevent the WAL from getting infinitely large (which would make restarts take hours), the WAL is periodically "truncated" once the data has been securely flushed to permanent block files.

### 2. The Head Block (RAM) & Memory Mapping

Prometheus divides data storage into "Blocks." The most critical block is the **Head Block**.

#### The Head Block
*   **Active & Mutable:** The Head Block is the only part of the database that can accept *new* data. It covers the most recent time window (usually the last **2 to 3 hours**).
*   **In-Memory:** It lives almost entirely in RAM to allow for fast "recent data" queries and high-throughput writing.
*   **Flush:** Once the Head Block covers 2 hours of data, it is finalized. The data is compressed, written to a persistent block on the disk, and the Head is cleared to start a new 2-hour window.

#### Memory Mapping (`mmap`)
Once data leaves the Head Block and becomes a persistent file on disk (Historical Blocks), Prometheus needs a way to read it without loading terabytes of data into RAM.

*   **Mechanism:** Prometheus uses the OS system call `mmap`. This tells the Linux kernel: *"Map this file on the disk to a virtual memory address, but don't load it into RAM yet."*
*   **On-Demand Loading:** When you run a query for data from 3 days ago, Prometheus accesses the memory address. The OS realizes the data isn't in RAM, fetches only that specific page from the disk (Page Fault), and caches it.
*   **Memory Management:** This allows Prometheus to access huge datasets with limited RAM. The Operating System manages the memory cache. If the OS needs RAM for something else, it drops the cached pages. This is why Prometheus often looks like it is using all available memory, but much of it is actually just generic file caching.

### 3. Block Compaction and Retention Policies

If Prometheus simply created a new file every 2 hours, after a month you would have ~360 small files. Searching through hundreds of files is slow.

#### Compaction
Prometheus runs a background process called **Compaction** to solve the "too many files" problem.
*   **Merging:** It takes adjacent blocks (e.g., two 2-hour blocks) and merges them into one larger block (a 4-hour block). Later, it merges 4-hour blocks into an 8-hour block, and so on.
*   **Benefit:** This reduces the index size and speeds up queries that span long time ranges.
*   **The layout:** A Block on disk is a directory containing:
    *   `chunks`: The actual compressed data samples (Gorilla compression).
    *   `index`: An inverted index (like a book index) allowing fast lookup of labels (e.g., find all series where `app="backend"`).
    *   `meta.json`: Metadata about the block (start time, end time, version).

#### Retention Policies
You can't store data forever on a local disk. Prometheus allows you to configure when to delete old data via two flags:
1.  **Time-based:** `--storage.tsdb.retention.time` (e.g., `15d`). If a block's end time is older than 15 days, the whole block is deleted.
2.  **Size-based:** `--storage.tsdb.retention.size` (e.g., `50GB`). If the `data/` directory exceeds 50GB, Prometheus deletes the oldest blocks until it fits.

*Note: Deletion is efficient. It deletes entire directory blocks, not individual data points.*

### 4. Snapshots and Backups

Backing up a running database is difficult because files are constantly changing (locked). You cannot simply `cp -r /var/lib/prometheus` while the server is running, or you might get a corrupted backup.

#### Snapshots
Prometheus provides an API feature to help with backups.
*   **API Call:** `POST /api/v1/admin/tsdb/snapshot`
*   **Hard Links:** When you trigger this, Prometheus creates a `snapshot` directory. It uses filesystem **hard links** to point to the existing data blocks.
    *   This is almost instant.
    *   It takes up almost no extra disk space.
*   **Safety:** The snapshot directory is static and immutable. You can safely compress (tar/zip) this directory and upload it to S3 or a backup server.

#### Summary of the Data Lifecycle
1.  **Ingest:** Data arrives -> Written to **WAL** (Disk) -> Stored in **Head** (RAM).
2.  **Flush:** Every 2 hours -> Head is compressed -> Written to **Block** (Disk).
3.  **Read:** Queries for old data use **mmap** to read Blocks from disk via OS Cache.
4.  **Optimize:** Background **Compaction** merges small blocks into big blocks.
5.  **Prune:** **Retention** policy deletes blocks that are too old or too big.

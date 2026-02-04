# I/O and system level profiling

---
## Disk and File I/O
*   Profiling the desk is important because it is the slowest component in the machine

### IOPS (Input/Output Operations Per Second)
*   IOPS is the standard unit of measurement for the maximum number of reads and writes a storage device can perform in one second
*   there is a limit for each hard drive, if you exceed it, a queue will start to be filled up
*   **Throughput vs. IOPS**
    *   may be you have a high IOPS but low throughput, when handling thousands of small files
    *   low IOPS and high through put happens in handling large files


### Sequential vs. Random Access Patterns
*   describes how your software asks for data from the disk
*   Sequential => fast (writing a log file)
*   Random Access => slow (database reading data from disk)
*   to speed up the process, try to move from random access to sequential


### Page Cache Hit/Miss Ratios
*   the OS some times cache hard drive data in the memory
*   when needed it checks the memory, if not there, it loads it from hard drive
*   This area of RAM is called the Page Cache
*   analyzing the cache hit ratio, give info about how fast we cans access data on the desk, maybe we increase the memory to increase the speed


### Synchronous vs. Asynchronous I/O Blocking
*   if you wait for the IO => Synchronous
    *   increases the CPU time, low throughput
    *   the CPU is waiting
*   if you don't wait for the IO => Asynchronous
    *   decrease the CPU time, but the wall clock time is same
    *   frees the CPU to so other stuff instead of waiting
*   in profiling you will see thread state as "D" state (Uninterruptible Sleep)
    *   thread is blocked waiting for Synchronous Disk I/O
    *   you should convert it to Asynchronous

---

## Network Profiling
*   Software Network Profiling is about answering: "Is my application slow because the network is slow, or because my application is using the network inefficiently?"

#### Socket Buffers and Queue Depths
*   
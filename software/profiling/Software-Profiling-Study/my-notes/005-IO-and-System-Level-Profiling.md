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
*   answers the question, who is slow, your app or the network 3rd party on the other side
*   while networking the communications is saved some where called **Socket Buffers**
*   **Socket Buffers** contains 2 queues
    *   **Send-Q**
        *   the app writes the out going data here
    *   **Recv-Q**
        *   the app writes the incoming data here
*   if the **Send-Q** is high, then the network is busy, and can not consume the outbound data well, the 3rd party app is slow
*   if the **Recv-Q** is high, then the network is fast, and the app/CPU can not consume the inbound data well, the app is slow
*   you can use tools like `ss` or `netstat` to get such information

#### TCP Retransmissions and Window Sizes
*   **TCP Retransmissions:**
    *   TCP is designed to be relieable
    *   if the packet is lost then, it will be resent again
    *   the losses reasons are alot
        *   bad hardware
        *   congestion
        *   strict firewall
        *   ...
    *   this process costs time and resources
        *   a request that takes 1ms might take 300ms because of Retransmissions
    *   use `netstat -s` to get more info about the `TCP Retransmissions`
*   **Window Sizes (Flow Control):**
    *   TCP window is the max amount of data that can be sent before getting a message from the receiver that it is full and needs time to clear it's **Recv-Q**
    *   when receiver's buffer (Recv-Q) is full, it sends a "Zero Window" packet
    *   if you see "Zero Window" packet, it means that there is a bottleneck at the receiver's side

#### DNS Resolution Latency
*   gives you the time needed to resolve a DNS
*   it is a part of the latency, you may want to look at
*   use `dig` command for inspection

#### Packet Capture Analysis
*   if you need to have a look at the packets moving in and out of the machine
*   you sometimes need to see for analysis
*   use `tcpdump` and `Wireshark`
*   what can you see/profile
    *   **The 3-Way Handshake (SYN, SYN-ACK, ACK)**
    *   **TLS Handshake**
    *   **Application Chatter**
    *   **Keep-Alive**
*   looking at the numbers in packets trips, gives you indications

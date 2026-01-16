Based on the Table of Contents provided, **Section B: Disks & Block Devices (Chapter 9)** focuses on the storage layer that sits *below* the File System. While the File System manages "files" and "folders," this layer manages "sectors," "blocks," and the physical hardware itself.

Here is a detailed explanation of each concept in that section.

---

### 1. Terminology & Models
This section establishes the basic language used to describe how the Operating System talks to storage hardware.

*   **Block Interface**: The OS treats all disks as a giant array of numbered data chunks (blocks). The contract is simple: "Read me Block #500" or "Write data to Block #1000." The OS does not know *where* physically on the platter that block sits; it just knows the address (LBA - Logical Block Addressing).
*   **Rotational Media (HDD)**: Traditional Hard Disk Drives.
    *   **Platters & Spindles**: Spinning magnetic disks.
    *   **Actuator Arms**: Physical barriers to speed. To read data, a mechanical arm must physically move to the correct track. This movement is the slowest part of computing.
*   **Solid State Drives (SSD/NVMe)**: Modern storage with no moving parts.
    *   **Flash Memory**: Data is stored electrically.
    *   **Controller Logic**: SSDs are smart. They use "Wear Leveling" to spread writes evenly so one part of the drive doesn't burn out. They perform "Garbage Collection" in the background to clean up deleted data blocks, which can occasionally cause unexpected performance latency (stutters).

### 2. Core Concepts
These are the laws of physics and math that govern disk performance.

*   **Time Scales**: The most important concept in system performance.
    *   CPU cycles are measured in nanoseconds (0.000000001s).
    *   Disk I/O is measured in milliseconds (0.001s).
    *   *The Analogy:* If a CPU cycle takes 1 second, a solid-state disk access matches waiting a few days, and a rotational disk access matches waiting several months. This gap is why application performance dies when it hits the disk.
*   **IOPS (I/O Operations Per Second)**: The measure of "How many times can I ask the disk to do something in one second?"
    *   HDDs usually handle 100–200 IOPS.
    *   NVMe SSDs can handle 100,000+ IOPS.
*   **I/O Size (Throughput vs. IOPS)**:
    *   Throughput = IOPS $\times$ I/O Size.
    *   If you write tiny 4KB blocks, you get high IOPS but low Throughput (MB/s).
    *   If you write huge 1MB blocks, you get low IOPS but massive Throughput (MB/s).
*   **Seek Time & Rotational Latency (HDD only)**:
    *   **Seek**: Time for the arm to move to the track.
    *   **Rotation**: Time for the disk to spin until the data is under the head.
    *   This makes **Random I/O** (jumping around the disk) terrible on HDDs.
*   **Utilization**: The percentage of time the disk was doing work vs. sitting idle.
*   **Saturation**: When the disk is 100% utilized, incoming requests stick in a "Wait Queue." This leads to high latency.
*   **I/O Wait**: A CPU state. The CPU is technically idle (doing no math), but it "blocks" and refuses to proceed until the disk finishes a read operation. High I/O Wait usually means your disks are the bottleneck.

### 3. Disk Architecture
How the hardware and OS are wired together.

*   **Interfaces**:
    *   **SATA/SAS**: Legacy protocols designed for spinning disks. They usually have one single queue for commands.
    *   **NVMe**: Designed for Flash. It connects via PCIe (like a graphics card). It supports thousands of parallel queues, allowing the OS to bombard the drive with requests simultaneously.
*   **RAID (Redundant Array of Independent Disks)**:
    *   **RAID 0 (Striping)**: Splits data across drives. Double speed, zero safety.
    *   **RAID 1 (Mirroring)**: Copies data. Normal speed, high safety.
    *   **RAID 5/6 (Parity)**: Safe, but suffers a **Write Penalty**. Every write requires reading old data, calculating parity math, and writing new data.
*   **The Block Layer**: The part of the Linux Kernel that sits between the File System and the Driver. It creates specific "Request Queues" and tries to merge operations (e.g., if you ask for Block 1 and Block 2, it merges them into a single request for "Blocks 1-2" to save time).

### 4. Analysis Methodology
How to diagnose a slow disk using the **USE Method**.

*   **Utilization**: Look at `%util` in `iostat`. Is the device busy? (Note: On RAID/NVMe, high utilization suggests busyness, but the device might still accept more work, so 100% isn't always the limit).
*   **Saturation**: Are requests queueing up? Look at `avgqu-sz` (Average Queue Size) or high `await` times.
*   **Errors**: Checks system logs or `dmesg`. Are cables loose? Is the drive dying?
*   **Bi-Modal Latency**: A common phenomenon. When analyzing latency, the "Average" is often a lie.
    *   *Mode 1 (Fast)*: The disk controller had the data in its internal RAM cache (microseconds).
    *   *Mode 2 (Slow)*: The disk had to physically read from the media (milliseconds).
    *   *Result*: The average looks fine, but the user feels the "slow" spikes.

### 5. Disk Observability Tools
The commands you type to see what is happening.

*   **`iostat`**: The specific arguments usually are `iostat -xz 1`.
    *   `%util`: Device busyness.
    *   `avgqu-sz`: How many requests are waiting in line.
    *   `await`: The most critical metric. The total time (Wait + Service) from when the OS asked for data to when it got it. High `await` = Slow application.
    *   `svctm`: (Deprecated/Unreliable) Supposed to be the time the disk actually worked, ignoring the queue time.
*   **Latency Analysis (eBPF Tools)**:
    *   **`biolatency`**: Instead of an average, this draws a histogram (e.g., "1000 requests took 1ms, 5 requests took 100ms"). This reveals the Bi-Modal issues mentioned above.
    *   **`biosnoop`**: Prints a line of text for every single disk request. Useful for spotting exactly *which* file or process is hitting the disk.
*   **Workload Analysis**:
    *   **`biotop`**: Like the `top` command, but for Disk I/O. Shows who is eating the bandwidth.
    *   **`blktrace`**: A heavy-duty debugger that records every event in the kernel block layer. Used only for deep kernel debugging.
*   **Hardware Info**:
    *   **`smartctl`**: Reads the S.M.A.R.T. data from the drive firmware (health status, temperature, power-on hours).

### 6. Visualizations
*   **Latency Heat Maps**: A graph where X=Time, Y=Latency, and Color=Frequency. This allows you to see if the disk is slow *all* the time, or if there are specific "bands" of latency causing stuttering every few seconds (usually caused by flushing cache).
*   **Offset Heat Maps**: A graph where Y=Disk Location (Block Number). This lets you see if the disk access is **Sequential** (nice solid lines) or **Random** (a scattered cloud of points).

### 7. Tuning
How to configure Linux to handle disks better.

*   **I/O Schedulers**: The algorithm the kernel uses to re-order requests before sending them to the hardware.
    *   **`mq-deadline`**: (Multi-Queue Deadline). The default for most servers. It groups reads and writes and imposes a time limit so requests don't starve.
    *   **`bfq`**: (Budget Fair Queueing). Designed for desktops. It prioritizes interactive tasks (like moving a mouse or opening a clear menu) over bulk file transfers. It is computationally heavy.
    *   **`kyber`**: A simple scheduler designed specifically for fast NVMe devices.
    *   **`none`**: Modern practice for high-end NVMe. The hardware is so fast that the Linux scheduler actually slows it down. We set the scheduler to `none` to let the NVMe controller handle the ordering itself.
*   **Queue Depths**: Adjusting how many requests we send to the drive at once. High depths increase throughput (batching) but increase latency (waiting in line).
*   **Read-Ahead**: A setting (`blockdev --setra`) that tells the kernel: "If the app asks for Blocks 1-10, go ahead and grab Blocks 11-20 too, just in case." This drastically improves performance for sequential file reading (like video streaming or log reading).

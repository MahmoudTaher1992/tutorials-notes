## Part II: Operating Systems & Observability Layers

### A. Operating Systems Fundamentals
- **Kernel Architecture**
    - The Kernel's Role: Abstraction and Resource Management
    - **Kernel Mode vs. User Mode**: Protection rings (Ring 0 vs. Ring 3)
    - **System Calls (syscalls)**: The interface between User and Kernel (context switching)
    - **Interrupts**: Hardware vs. Software interrupts and handlers
- **Core Subsystems**
    - **Process Management**:
        - Processes vs. Threads
        - The Lifecycle (Fork, Exec, Exit, Wait)
        - Stacks (User stack vs. Kernel stack)
    - **Schedulers**: CPU time slicing, Preemption, and Load Balancing
    - **Virtual Memory**: Abstraction of physical RAM, Swap, and MMU
    - **File Systems (VFS)**: The Virtual File System abstraction layer
    - **Caching**: Page Cache, Inode Cache, Directory Entry Cache (Dentry)
    - **Networking**: Protocol stacks and sockets
    - **Device Drivers**: Interfacing with hardware
- **Hardware Interaction**
    - The Clock and Idle loops
    - Multiprocessor handling (SMP)

### B. The Linux Kernel (Specifics & History)
- **Lineage**: Unix vs. BSD vs. Solaris roots
- **Linux Evolution**: Key kernel version milestones
- **Modern Linux Components**:
    - **systemd**: Impact on boot, logging (journald), and service management
    - **eBPF (Extended BPF)**: The modern programmability of the kernel (sandboxed bytecode)
    - **KPTI (Kernel Page Table Isolation)**: Mitigations for Meltdown/Spectre and their performance cost
- **Alternative Kernel Models**:
    - Unikernels (Library OS)
    - Microkernels vs. Monolithic Kernels vs. Hybrid Kernels

### C. Observability Data Sources (Where data comes from)
- **File-Based Counters (The "Pull" Model)**
    - **/proc**: The process file system (kernel statistics interface)
    - **/sys**: The sysfs file system (device and driver info)
    - **Delay Accounting**: Per-task delay metrics
    - **Netlink**: Kernel-to-user communication (for network tools)
- **Instrumentation & Probes (The "Push/Event" Model)**
    - **Tracepoints**: Static, compiled-in kernel hooks (Stable API)
    - **kprobes** (Kernel Probes): Dynamic instrumentation of any kernel function (Unstable API)
    - **uprobes** (User Probes): Dynamic instrumentation of user-space application functions
    - **USDT** (User Statically Defined Tracing): "Dtrace-style" markers compiled into applications
- **Hardware Sources**
    - **PMCs (Performance Monitoring Counters)**: CPU-level registers for low-level events (cycles, cache misses, branch mispredictions)

### D. Observability Tooling Ecosystem
- **Tool Classifications**
    - **Static Performance Tools**: checking configuration attributes (e.g., `sysctl`)
    - **Crisis Tools**: Tools installed by default for when the network is down (e.g., `top`, `vmstat`)
- **Tool Types**
    - **Fixed Counters**: Simple additive metrics
    - **Profiling**: Frequency-based sampling (Snapshotting the CPU)
    - **Tracing**: Event-based logging (Capturing every occurrence)
    - **Monitoring**: Long-term trend recording
- **Deep Dive: sar (System Activity Reporter)**
    - `sar` coverage (CPU, Disk, Net, Memory)
    - Live mode vs. Historical (log) mode
    - Understanding `sar` output columns
- **Observing Observability**
    - The "Heisenbug" principle in performance
    - Cost of tracepoints vs. cost of dynamic probes
    - Tools to measure the overhead of your monitoring tools
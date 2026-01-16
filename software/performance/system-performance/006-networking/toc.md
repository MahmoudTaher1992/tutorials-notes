## Part VI: Networking (Chapter 10)

### A. Network Fundamentals
- **Models & Layers**
    - **The Protocol Stack**: Physical -> Data Link -> Network (IP) -> Transport (TCP/UDP) -> Application
    - **Encapsulation**: Headers, Footers, and Payload efficiency
- **Core Concepts**
    - **Latency**: Connection time (handshake) vs. Time-to-First-Byte (TTFB) vs. Round Trip Time (RTT)
    - **Bandwidth/Throughput**: Capacity vs. usage
    - **Packets**: MTU (Maximum Transmission Unit), Jumbo Frames, and Fragmentation
    - **Buffering**: The "Bufferbloat" problem
    - **Connection Lifecycle**: TCP Handshake (SYN, SYN-ACK, ACK) and Teardown (FIN)
    - **Congestion Control**: Slow Start, Congestion Windows (cwnd), and Retransmission
    - **Local Connections**: `localhost` optimizations (loopback)
- **Network Architecture**
    - **Hardware**: NICs, Offload Engines (TSO, LRO, CSO), Interrupt Coalescing
    - **Software**:
        - Socket Buffers (Send/Recv queues)
        - QDiscs (Queueing Disciplines)
        - NAPI (New API) polling mode
        - Kernel Bypass (DPDK, XDP) for high performance

### B. Network Analysis Methodology
- **The USE Method for Networks**:
    - Utilization (Interface throughput limits)
    - Saturation (Dropped packets, overrun queues)
    - Errors (Collisions, carrier errors)
- **Workload Characterization**: Packet rate (PPS) vs. Data rate (Bps), Protocol mix
- **Latency Analysis**: Isolating DNS vs. TCP Connect vs. Data Transfer
- **Packet Sniffing**: Inspecting headers and payloads (The ultimate source of truth)

### C. Network Observability Tools
- **Configuration & Status**:
    - `ip`: The modern replacement for ifconfig
    - `ethtool`: Checking hardware settings (speed, duplex, offloads)
- **Socket Statistics**:
    - `ss`: Investigating open sockets, queue sizes, and connection states
    - `netstat`: Legacy tool (still useful for summaries)
- **Traffic Monitoring**:
    - `sar -n DEV/EDEV/TCP`: Historical network stats
    - `nstat` / `/proc/net/snmp`: Kernel SNMP counters (Retransmits, OutOfOrder)
    - `nicstat`: Network throughput resembling `vmstat`
- **Tracing & Deep Dive**:
    - `tcpdump`: Capturing packets for analysis
    - `Wireshark`: Visualizing `tcpdump` output (GUIs)
    - `tcplife`: Logging TCP sessions with duration and throughput (eBPF)
    - `tcpretrans`: Tracing retransmission events live (eBPF)
    - `tcptop`: Top active TCP sessions (eBPF)

### D. Network Tuning
- **System-Wide Tunables**: `sysctl` parameters
    - Tuning TCP Window sizes (Scaling)
    - Increasing max connections (`somaxconn`)
    - Enabling BBR (Bottleneck Bandwidth and Round-trip propagation time) congestion control
- **Socket Options**: `SO_REUSEADDR`, `TCP_NODELAY` (Disabling Nagle's Algorithm)



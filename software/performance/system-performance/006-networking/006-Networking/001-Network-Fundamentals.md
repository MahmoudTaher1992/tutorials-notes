# Network Fundamentals

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

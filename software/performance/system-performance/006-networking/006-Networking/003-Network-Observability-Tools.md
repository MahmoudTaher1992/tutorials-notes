# Network Observability Tools

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

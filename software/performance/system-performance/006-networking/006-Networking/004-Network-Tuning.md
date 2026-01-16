# Network Tuning

- **System-Wide Tunables**: `sysctl` parameters
    - Tuning TCP Window sizes (Scaling)
    - Increasing max connections (`somaxconn`)
    - Enabling BBR (Bottleneck Bandwidth and Round-trip propagation time) congestion control
- **Socket Options**: `SO_REUSEADDR`, `TCP_NODELAY` (Disabling Nagle's Algorithm)

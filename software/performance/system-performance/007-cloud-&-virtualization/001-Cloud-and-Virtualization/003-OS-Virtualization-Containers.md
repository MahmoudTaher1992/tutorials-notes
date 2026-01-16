# OS Virtualization (Containers)

- **Implementation**:
    - **Namespaces**: Isolation (What you can see)
    - **Cgroups (Control Groups)**: Resource Limitation (What you can use)
    - **Union File Systems**: OverlayFS (Images and layers)
- **Overhead**: Near-zero CPU overhead, but potential complexity in networking (Bridge/NAT)
- **Resource Controls**: CPU Shares, Quotas, Memory Limits

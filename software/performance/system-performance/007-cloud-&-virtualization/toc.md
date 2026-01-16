## Part VII: Cloud & Virtualization (Chapter 11)

### A. Cloud Dynamics
- **The "Cloud Paradox"**: Infinite capacity vs. variable performance
- **Instance Types**: "Burstable" instances vs. Dedicated instances
- **The "Noisy Neighbor" Problem**: Resource contention in multi-tenant environments
- **Capacity Planning**: Autoscaling groups and spot instances

### B. Hardware Virtualization (VMs)
- **Implementation**:
    - **Type 1 Hypervisors** (Xen, ESXi) vs. **Type 2** (KVM - technically Type 1 but integrated into Linux)
    - **Virtio / Paravirtualization**: Drivers aware of virtualization (reducing overhead)
    - **Hardware Assist**: Intel VT-x/AMD-V
- **Overhead Analysis**:
    - **CPU Steal Time**: The metric showing the hypervisor stealing cycles
    - **VM Exits**: The cost of switching between Guest and Host
- **Observability**: The "Double Vision" problem (Host view vs. Guest view)

### C. OS Virtualization (Containers)
- **Implementation**:
    - **Namespaces**: Isolation (What you can see)
    - **Cgroups (Control Groups)**: Resource Limitation (What you can use)
    - **Union File Systems**: OverlayFS (Images and layers)
- **Overhead**: Near-zero CPU overhead, but potential complexity in networking (Bridge/NAT)
- **Resource Controls**: CPU Shares, Quotas, Memory Limits

### D. Modern Lightweight Virtualization
- **MicroVMs**: Firecracker (AWS Lambda foundation)
- **Unikernels**: Compiling the OS into the app

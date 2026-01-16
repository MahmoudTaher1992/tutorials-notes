# Hardware Virtualization (VMs)

- **Implementation**:
    - **Type 1 Hypervisors** (Xen, ESXi) vs. **Type 2** (KVM - technically Type 1 but integrated into Linux)
    - **Virtio / Paravirtualization**: Drivers aware of virtualization (reducing overhead)
    - **Hardware Assist**: Intel VT-x/AMD-V
- **Overhead Analysis**:
    - **CPU Steal Time**: The metric showing the hypervisor stealing cycles
    - **VM Exits**: The cost of switching between Guest and Host
- **Observability**: The "Double Vision" problem (Host view vs. Guest view)

Based on the Table of Contents you provided, here is a detailed breakdown of **Part III: Core Compute Services — A. Azure Virtual Machines (VMs)**.

This section covers the "Infrastructure as a Service" (IaaS) foundation of Azure. A Virtual Machine (VM) is essentially a software computer mimicking a physical computer.

---

### **1. VM Planning: Sizing, Pricing, and Operating Systems**
Before you click "Create," you must make architectural decisions regarding what the VM will look like and how much it will cost.

*   **Operating Systems (OS):** Azure supports a wide range of OS images.
    *   **Windows:** Server editions (2016, 2019, 2022) and Desktop editions (Windows 10/11 - usually for Virtual Desktop scenarios).
    *   **Linux:** Ubuntu, Red Hat (RHEL), CentOS, SUSE, Debian.
*   **Virtual Machine Sizing (Series):** Azure groups VMs into "families" optimized for specific tasks. You don't just pick "4 CPUs"; you pick a specific series. Common examples:
    *   **A-Series / B-Series:** Economical, burstable (good for testing or low traffic).
    *   **D-Series:** General Purpose (balanced CPU/RAM). Good for standard enterprise apps.
    *   **F-Series:** Compute Optimized (high CPU-to-RAM ratio). Good for gaming servers or heavy processing.
    *   **E-Series:** Memory Optimized (high RAM). Great for heavy databases (SQL, Oracle).
    *   **N-Series:** GPU enabled (for video rendering, AI/ML models).
*   **Pricing Models:**
    *   **Pay-as-you-go:** Pay by the second. Most expensive, but most flexible.
    *   **Reserved Instances (RI):** Commit to a 1 or 3-year contract for a specific VM size in exchange for huge discounts (up to 72%).
    *   **Spot Instances:** Use Azure's unused "spare" capacity for up to 90% off. *Catch:* Azure can evict your VM at any moment if they need the capacity back. Good for batch jobs that can handle interruption.

### **2. Creating and Managing VMs**
*   **Creation Tools:** You can create VMs using:
    *   **Azure Portal:** The graphical website (GUI).
    *   **Azure CLI / PowerShell:** Command-line scripts for automation.
    *   **ARM Templates / Bicep:** Infrastructure as Code (defining the VM in a text file).
*   **Accessing the VM:**
    *   **RDP (Remote Desktop Protocol):** Standard way to GUI into Windows VMs (Port 3389).
    *   **SSH (Secure Shell):** Standard way to command-line into Linux VMs (Port 22).
    *   **Azure Bastion:** A secure PaaS service that lets you connect to VMs via your web browser (HTTPS) without exposing the VM's RDP/SSH ports to the public internet.

### **3. VM Storage: Managed Disks and Storage Tiers**
When you create a VM, it needs drives to store the OS and data.

*   **Disk Types:**
    *   **OS Disk:** Contains the operating system (C: drive for Windows, /dev/sda for Linux).
    *   **Data Disks:** Attached separately to store application data (databases, files).
    *   **Temporary Disk:** A volatile drive physically attached to the Azure host server. **Warning:** Data here is lost if you reboot specific ways. It is only for page files or swap files.
*   **Managed Disks:** Azure manages the physical storage infrastructure for you. You just specify the size and type.
*   **Performance Tiers:**
    *   **HDD:** Spinning platters. Cheapest, slowest (Dev/Test).
    *   **Standard SSD:** Solid State. Better reliability (Entry-level production).
    *   **Premium SSD:** High IOPS (Input/Output Operations Per Second). Recommended for most production workloads.
    *   **Ultra Disk:** Extreme performance for massive databases.

### **4. VM Networking and Security**
A VM cannot exist in a vacuum; it needs to talk to the network.

*   **Virtual Network (VNet) & Subnet:** The VM must be placed inside a specific subnet within a VNet.
*   **Network Interface Card (NIC):** The virtual component that connects the VM to the VNet.
*   **Public IP:** An optional address that makes the VM accessible from the outside world (internet).
*   **Network Security Groups (NSGs):** This is the **firewall** for your VM.
    *   It contains rules like "Allow Traffic on Port 80 (HTTP)" or "Deny Traffic from IP X".
    *   It acts as a gatekeeper for traffic flowing in and out of the VM.

### **5. High Availability (Important Methodologies)**
Hardware fails. Azure provides constructs to ensure your application stays running even if a physical server or a datacenter goes down.

*   **Availability Sets (Protection against Rack failure):**
    *   You place multiple VMs in a "Set."
    *   **Fault Domains:** Azure ensures these VMs are on different power sources and network switches (different server racks).
    *   **Update Domains:** Azure ensures that when they patch the underlying software, they won't reboot all VMs in the set at the same time.
    *   *Limits:* Protects only within a single datacenter.
*   **Availability Zones (Protection against Datacenter failure):**
    *   Zones are physically separate datacenters (separate buildings with independent power/cooling) within one Region.
    *   By putting VM 1 in Zone 1 and VM 2 in Zone 2, your app survives even if the Zone 1 building burns down.
    *   *SLA:* Offers a higher Service Level Agreement (99.99% uptime) than Availability Sets (99.95%).

### **6. Virtual Machine Scale Sets (VMSS)**
Manual scaling (creating a new VM when traffic gets high) is slow and error-prone. VMSS automates this.

*   **What it is:** A group of **identical** load-balanced VMs.
*   **Elasticity (Auto-scaling):**
    *   **Scale Out:** If CPU usage goes above 75%, add 2 more VMs automatically.
    *   **Scale In:** If CPU usage drops below 25%, delete those 2 VMs to save money.
*   **Management:** You patch the "image," and Azure rolls that update out to all 1,000 instances automatically.
*   **Use Case:** Highly variable workloads like e-commerce sites (Black Friday traffic) or data processing clusters.

---
### **Summary Table**

| Component | Responsibility |
| :--- | :--- |
| **Compute** | Selecting the right Series (A, D, N) based on CPU/RAM needs. |
| **Storage** | Choosing SSD vs. HDD and attaching Data Disks. |
| **Networking** | Configuring NSGs (Firewall) and private/public IPs. |
| **Availability** | Using Zones (Buildings) or Sets (Racks) to prevent downtime. |
| **Scaling** | Using Scale Sets to automatically add/remove VMs based on demand. |

#!/bin/bash

# Define the root directory name
ROOT_DIR="Operating-Systems-Comprehensive-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
echo "Created root directory: $ROOT_DIR"

# Function to create a section file with content
create_file() {
    local dir_path="$1"
    local filename="$2"
    local title="$3"
    local content="$4"
    
    full_path="$ROOT_DIR/$dir_path/$filename"
    
    # Create the header
    echo "# $title" > "$full_path"
    echo "" >> "$full_path"
    
    # Add content
    echo "$content" >> "$full_path"
    echo "  - Created file: $filename"
}

# ==========================================
# Part I: Core Operating System Concepts
# ==========================================
PART_DIR="001-Core-Operating-System-Concepts"
mkdir -p "$ROOT_DIR/$PART_DIR"
echo "Created directory: $PART_DIR"

# A. Introduction
CONTENT_01=$(cat <<EOF
- **What is an Operating System?**: Role and purpose, evolution, and different types of OS (e.g., batch, multiprogramming, timesharing, real-time, distributed, mobile).
- **Key Functions of an OS**: Resource management, process management, memory management, storage management, and security.
- **Operating System Structures**: Monolithic, layered, microkernel, and modular approaches.
- **The User's View**: Command-line interface (CLI) vs. Graphical User Interface (GUI).
- **The System's View**: System calls, APIs, and the kernel.
EOF
)
create_file "$PART_DIR" "001-Introduction-to-Operating-Systems.md" "Introduction to Operating Systems" "$CONTENT_01"

# B. Computer System & Hardware Interaction
CONTENT_02=$(cat <<EOF
- **Booting Process**: From power-on to a usable system (BIOS/UEFI, bootloaders).
- **Interrupts & System Calls**: How the OS interacts with hardware and applications.
- **Direct Memory Access (DMA)**: Efficient data transfer between peripherals and memory.
- **Device Drivers**: The interface between the OS and hardware devices.
EOF
)
create_file "$PART_DIR" "002-Computer-System-and-Hardware-Interaction.md" "Computer System and Hardware Interaction" "$CONTENT_02"

# C. Process Management
CONTENT_03=$(cat <<EOF
- **Processes & Threads**: Process concept, states, and control block; threads and concurrency.
- **CPU Scheduling**: Algorithms (e.g., FCFS, SJF, Priority, Round Robin), multi-level queues, and thread scheduling.
- **Inter-Process Communication (IPC)**: Shared memory, message passing, pipes, and sockets.
- **Synchronization**: Critical section problem, semaphores, monitors, and deadlocks.
EOF
)
create_file "$PART_DIR" "003-Process-Management.md" "Process Management" "$CONTENT_03"

# D. Memory Management
CONTENT_04=$(cat <<EOF
- **Main Memory**: Logical vs. physical address space, swapping.
- **Memory Allocation**: Contiguous allocation, paging, and segmentation.
- **Virtual Memory**: Demand paging, copy-on-write, and page replacement algorithms.
EOF
)
create_file "$PART_DIR" "004-Memory-Management.md" "Memory Management" "$CONTENT_04"

# E. Storage and File Systems
CONTENT_05=$(cat <<EOF
- **File Systems**: File concept, access methods, and directory structure.
- **File System Implementation**: Allocation methods (e.g., contiguous, linked, indexed), free-space management.
- **Disk Management**: Disk structure, scheduling, and RAID.
- **I/O Systems**: I/O hardware, application I/O interface, and kernel I/O subsystem.
EOF
)
create_file "$PART_DIR" "005-Storage-and-File-Systems.md" "Storage and File Systems" "$CONTENT_05"


# ==========================================
# Part II: The UNIX Philosophy & Family
# ==========================================
PART_DIR="002-The-UNIX-Philosophy-and-Family"
mkdir -p "$ROOT_DIR/$PART_DIR"
echo "Created directory: $PART_DIR"

# A. The UNIX Environment
CONTENT_01=$(cat <<EOF
- **History and Philosophy**: Simplicity, modularity, and the "everything is a file" concept.
- **The UNIX Architecture**: The kernel, the shell, and user utilities.
- **POSIX Standards**: Ensuring portability across UNIX-like systems.
- **The Command-Line Interface (CLI)**: A deep dive into the shell and its power.
EOF
)
create_file "$PART_DIR" "001-The-UNIX-Environment.md" "The UNIX Environment" "$CONTENT_01"

# B. The Shell and Core Utilities
CONTENT_02=$(cat <<EOF
- **Navigating the Filesystem**: \`ls\`, \`cd\`, \`pwd\`, \`mkdir\`, \`rmdir\`.
- **File Manipulation**: \`touch\`, \`cp\`, \`mv\`, \`rm\`, \`cat\`, \`less\`, \`more\`, \`head\`, \`tail\`.
- **Text Processing**: \`grep\`, \`sed\`, \`awk\`, \`sort\`, \`uniq\`, \`cut\`.
- **Permissions and Ownership**: \`chmod\`, \`chown\`, \`chgrp\`, \`umask\`.
- **Pipes, Redirection, and Chaining Commands**: \`|\`, \`>\`, \`<\`, \`>>\`, \`&&\`, \`||\`.
- **Process Management from the CLI**: \`ps\`, \`top\`, \`kill\`, \`bg\`, \`fg\`.
EOF
)
create_file "$PART_DIR" "002-The-Shell-and-Core-Utilities.md" "The Shell and Core Utilities" "$CONTENT_02"

# C. Shell Scripting
CONTENT_03=$(cat <<EOF
- **Bash Scripting Fundamentals**: Variables, control structures (if, for, while), and functions.
- **Input/Output and Arguments**: Reading user input and command-line arguments.
- **Regular Expressions**: Pattern matching for powerful text manipulation.
- **Automating System Administration Tasks**: Writing scripts for backups, monitoring, etc.
EOF
)
create_file "$PART_DIR" "003-Shell-Scripting.md" "Shell Scripting" "$CONTENT_03"


# ==========================================
# Part III: The BSD Family
# ==========================================
PART_DIR="003-The-BSD-Family"
mkdir -p "$ROOT_DIR/$PART_DIR"
echo "Created directory: $PART_DIR"

# A. FreeBSD
CONTENT_01=$(cat <<EOF
- **Introduction**: History, goals, and key features.
- **Installation and Configuration**: The FreeBSD installer, initial setup.
- **Package Management**: The Ports Collection vs. binary packages (\`pkg\`).
- **System Administration**: Jails (containerization), ZFS (file system), and security features.
- **Networking**: Configuration and management of network services.
- **Kernel Customization**: When and why to build a custom kernel.
EOF
)
create_file "$PART_DIR" "001-FreeBSD.md" "FreeBSD" "$CONTENT_01"

# B. OpenBSD
CONTENT_02=$(cat <<EOF
- **Focus on Security**: Proactive security, exploit mitigation techniques.
- **Core Components**: OpenSSH, PF (Packet Filter firewall), and other integrated tools.
- **Installation and Maintenance**: Emphasis on a clean and secure base install.
- **Use Cases**: Ideal for firewalls, VPN gateways, and secure servers.
EOF
)
create_file "$PART_DIR" "002-OpenBSD.md" "OpenBSD" "$CONTENT_02"

# C. NetBSD
CONTENT_03=$(cat <<EOF
- **Portability as a Priority**: "Of course it runs NetBSD".
- **Supported Architectures**: A wide range of hardware platforms.
- **Package Management**: Using \`pkgsrc\`.
- **Embedded Systems and Niche Hardware**: Where NetBSD shines.
EOF
)
create_file "$PART_DIR" "003-NetBSD.md" "NetBSD" "$CONTENT_03"


# ==========================================
# Part IV: The Linux Ecosystem
# ==========================================
PART_DIR="004-The-Linux-Ecosystem"
mkdir -p "$ROOT_DIR/$PART_DIR"
echo "Created directory: $PART_DIR"

# A. The Linux Kernel and GNU Project
CONTENT_01=$(cat <<EOF
- **The Kernel**: What it is and its role in the operating system.
- **GNU Utilities**: The tools that make up the user-space of a Linux system.
- **Linux Distributions**: The concept of different "flavors" of Linux.
EOF
)
create_file "$PART_DIR" "001-The-Linux-Kernel-and-GNU-Project.md" "The Linux Kernel and GNU Project" "$CONTENT_01"

# B. Debian and its Derivatives (Ubuntu)
CONTENT_02=$(cat <<EOF
- **The Debian Project**: Philosophy and community.
- **Package Management**: \`apt\`, \`dpkg\`, and repositories.
- **System Administration**: \`systemd\`, user management, and network configuration.
- **Ubuntu**: Differences from Debian, release cycles, and desktop vs. server editions.
EOF
)
create_file "$PART_DIR" "002-Debian-and-Derivatives.md" "Debian and Derivatives" "$CONTENT_02"

# C. SUSE Linux
CONTENT_03=$(cat <<EOF
- **SUSE Linux Enterprise Server (SLES)**: Features for enterprise environments.
- **YaST**: The comprehensive configuration and administration tool.
- **Btrfs**: The default filesystem and its features.
- **openSUSE**: The community-driven version.
EOF
)
create_file "$PART_DIR" "003-SUSE-Linux.md" "SUSE Linux" "$CONTENT_03"

# D. RHEL and its Derivatives
CONTENT_04=$(cat <<EOF
- **Red Hat Enterprise Linux (RHEL)**: The leading enterprise Linux distribution.
- **Package Management**: \`yum\`, \`dnf\`, and RPM.
- **SELinux**: Mandatory Access Control for enhanced security.
- **System Administration**: Following the Red Hat Certified System Administrator (RHCSA) and Red Hat Certified Engineer (RHCE) curriculum.
EOF
)
create_file "$PART_DIR" "004-RHEL-and-Derivatives.md" "RHEL and Derivatives" "$CONTENT_04"


# ==========================================
# Part V: Advanced Topics & System Administration
# ==========================================
PART_DIR="005-Advanced-Topics-and-System-Administration"
mkdir -p "$ROOT_DIR/$PART_DIR"
echo "Created directory: $PART_DIR"

# A. Networking
CONTENT_01=$(cat <<EOF
- **TCP/IP Fundamentals**: The OSI model and the TCP/IP suite.
- **Network Configuration**: IP addressing, routing, and DNS.
- **Network Services**: SSH, FTP, web servers (Apache, Nginx), and email servers.
- **Firewalls and Security**: \`iptables\`, \`nftables\`, and \`firewalld\`.
EOF
)
create_file "$PART_DIR" "001-Networking.md" "Networking" "$CONTENT_01"

# B. Virtualization and Containers
CONTENT_02=$(cat <<EOF
- **Virtualization Concepts**: Hypervisors (Type 1 and Type 2).
- **KVM**: Kernel-based Virtual Machine.
- **Containerization**: Docker, Podman, and the Open Container Initiative (OCI).
- **Orchestration**: Kubernetes fundamentals.
EOF
)
create_file "$PART_DIR" "002-Virtualization-and-Containers.md" "Virtualization and Containers" "$CONTENT_02"

# C. Monitoring and Troubleshooting
CONTENT_03=$(cat <<EOF
- **System Logs**: \`syslog\`, \`journalctl\`.
- **Performance Monitoring**: \`top\`, \`htop\`, \`iostat\`, \`vmstat\`, \`netstat\`.
- **Troubleshooting Methodologies**: A systematic approach to problem-solving.
EOF
)
create_file "$PART_DIR" "003-Monitoring-and-Troubleshooting.md" "Monitoring and Troubleshooting" "$CONTENT_03"

# D. Backup and Recovery
CONTENT_04=$(cat <<EOF
- **Backup Strategies**: Full, incremental, and differential backups.
- **Backup Tools**: \`tar\`, \`rsync\`, and specialized backup software.
- **Disaster Recovery Planning**: Ensuring business continuity.
EOF
)
create_file "$PART_DIR" "004-Backup-and-Recovery.md" "Backup and Recovery" "$CONTENT_04"

# ==========================================
# Appendices
# ==========================================
PART_DIR="006-Appendices"
mkdir -p "$ROOT_DIR/$PART_DIR"
echo "Created directory: $PART_DIR"

CONTENT_APP=$(cat <<EOF
- **Glossary of Operating System Terms**
- **Further Reading and Resources**
- **Comparison of UNIX-like Operating Systems**
EOF
)
create_file "$PART_DIR" "001-Appendices-and-Resources.md" "Appendices and Resources" "$CONTENT_APP"

echo "======================================"
echo "Directory hierarchy generation complete!"
echo "Location: $(pwd)/$ROOT_DIR"

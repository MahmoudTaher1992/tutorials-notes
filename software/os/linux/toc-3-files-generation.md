
#!/bin/bash

# Define Root Directory
ROOT_DIR="Linux-Study-Guide"

# Create Root Directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating Linux Study Guide structure in $(pwd)..."

# ==========================================
# PART I: The Linux Command Line & Core Concepts
# ==========================================
DIR_NAME="001-The-Linux-Command-Line-and-Core-Concepts"
mkdir -p "$DIR_NAME"

# A. Introduction
cat <<'EOF' > "$DIR_NAME/001-Introduction-to-Linux-and-the-Shell.md"
# Introduction to Linux and the Shell

- What is Linux? (Kernel, Distributions, Philosophies)
- The Role of the Command-Line Interface (CLI)
- Introduction to the Shell (Bash, Zsh, etc.)
- Understanding the Shell Prompt
- Interacting with the System: Commands, Arguments, and Options
EOF

# B. Navigation
cat <<'EOF' > "$DIR_NAME/002-Navigation-Basics-and-Filesystem-Hierarchy.md"
# Navigation Basics & Filesystem Hierarchy

- **Directory Hierarchy Overview (FHS - Filesystem Hierarchy Standard)**
  - `/` (root), `/bin`, `/sbin`, `/etc`, `/home`, `/var`, `/tmp`, `/usr`
  - Purpose and Content of Key Directories
- **Essential Navigation Commands**
  - `pwd` (Print Working Directory)
  - `cd` (Change Directory): Absolute vs. Relative Paths
  - `ls` (List Contents): Common flags (`-l`, `-a`, `-h`)
  - `tree` (Visualizing Directory Structures)
- **Filesystem Concepts**
  - Understanding Paths (`/`, `~`, `.`, `..`)
  - File and Directory Naming Conventions
EOF

# C. Shell Basics
cat <<'EOF' > "$DIR_NAME/003-Shell-and-Other-Basics.md"
# Shell and Other Basics

- **Standard Streams: stdin, stdout, stderr**
  - Understanding Input (0), Output (1), and Error (2) streams
  - `echo` and `printf` for output generation
- **Redirection and Piping**
  - Redirecting Output: `>` (overwrite) and `>>` (append)
  - Redirecting Input: `<`
  - Redirecting stderr: `2>`, `2>>`
  - Combining stdout and stderr: `&>`, `2>&1`
  - The `pipe` (`|`) operator: Chaining commands together
  - `tee`: Splitting output to a file and stdout
- **Command History and Editing**
  - Accessing and searching command history (`history`, `Ctrl+R`)
  - Command-line editing shortcuts (e.g., `Ctrl+A`, `Ctrl+E`, `Alt+.`)
EOF

# D. Getting Help
cat <<'EOF' > "$DIR_NAME/004-Getting-Help.md"
# Getting Help

- `man` (Manual) pages: Reading and navigating
- `tldr`: Simplified and practical examples
- `--help` flag for command-specific assistance
- `whatis` and `apropos`: Finding commands by keyword
EOF


# ==========================================
# PART II: File and User Management
# ==========================================
DIR_NAME="002-File-and-User-Management"
mkdir -p "$DIR_NAME"

# A. Working with Files
cat <<'EOF' > "$DIR_NAME/001-Working-with-Files.md"
# Working with Files

- **Creating and Deleting Files & Directories**
  - `touch`: Creating empty files or updating timestamps
  - `mkdir`: Creating directories (`-p` for parent directories)
  - `rm`: Removing files (`-i` for interactive, `-f` for force)
  - `rmdir`: Removing empty directories
- **Copying, Moving, and Renaming**
  - `cp`: Copying files and directories (`-r` for recursive)
  - `mv`: Moving and renaming files and directories
- **Links: Soft Links vs. Hard Links**
  - `ln`: Creating links
  - Conceptual Differences (Inodes, Cross-filesystem)
  - Use cases for each type of link
- **Archiving and Compressing**
  - `tar`: The Tape Archive utility
    - Creating archives (`-c`)
    - Listing contents (`-t`)
    - Extracting archives (`-x`)
  - Compression Utilities: `gzip`, `bzip2`, `xz`
  - Combining `tar` with compression (e.g., `.tar.gz`, `.tar.bz2`)
EOF

# B. Permissions and Ownership
cat <<'EOF' > "$DIR_NAME/002-Permissions-and-Ownership.md"
# Permissions and Ownership

- **File Permissions Explained**
  - User, Group, and Other (u, g, o)
  - Read, Write, and Execute (r, w, x) permissions for files and directories
  - Understanding the permission string (e.g., `-rwxr-xr--`)
- **Managing Permissions**
  - `chmod`: Changing permissions
    - Symbolic notation (`u+x`, `g-w`, `o=r`)
    - Numeric (Octal) notation (e.g., `755`, `644`)
- **Managing Ownership**
  - `chown`: Changing the owner and group of a file
  - `chgrp`: Changing the group ownership
- **Special Permissions**
  - SUID, SGID, and the Sticky Bit: Concepts and security implications
EOF

# C. User and Group Management
cat <<'EOF' > "$DIR_NAME/003-User-and-Group-Management.md"
# User and Group Management

- **User Accounts**
  - Creating users: `useradd`, `adduser`
  - Modifying users: `usermod`
  - Deleting users: `userdel`, `deluser`
  - Managing user passwords: `passwd`
- **Group Management**
  - Creating groups: `groupadd`
  - Modifying groups: `groupmod`
  - Deleting groups: `groupdel`
  - Adding/removing users from groups
EOF

# D. The Super User
cat <<'EOF' > "$DIR_NAME/004-The-Super-User.md"
# The Super User

- The `root` user: Privileges and responsibilities
- `sudo`: Executing commands as another user
- The `/etc/sudoers` file and the `visudo` command
- Switching users with `su`
EOF


# ==========================================
# PART III: Process and System Management
# ==========================================
DIR_NAME="003-Process-and-System-Management"
mkdir -p "$DIR_NAME"

# A. Process Management
cat <<'EOF' > "$DIR_NAME/001-Process-Management.md"
# Process Management

- **Understanding Processes**
  - What is a process? (PID, PPID)
  - Process states (Running, Sleeping, Zombie)
- **Listing and Finding Processes**
  - `ps`: A snapshot of current processes (common flags: `aux`, `-ef`)
  - `top`: Real-time process monitoring
  - `htop`: An interactive process viewer
  - `pgrep`: Finding processes by name
- **Foreground and Background Processes**
  - Running a command in the background (`&`)
  - `jobs`: Listing background jobs
  - `fg`: Bringing a job to the foreground
  - `bg`: Resuming a stopped job in the background
  - Suspending a foreground job (`Ctrl+Z`)
- **Process Signals and Control**
  - Introduction to signals (SIGHUP, SIGINT, SIGKILL, SIGTERM, SIGSTOP)
  - `kill`: Sending signals to processes by PID
  - `killall`, `pkill`: Killing processes by name
EOF

# B. Service Management
cat <<'EOF' > "$DIR_NAME/002-Service-Management-systemd.md"
# Service Management (systemd)

- **Introduction to `systemd` and Services**
  - Role of an init system
  - Understanding units (service, socket, timer, etc.)
- **Managing Services**
  - `systemctl start <service>`
  - `systemctl stop <service>`
  - `systemctl restart <service>`
  - `systemctl status <service>`
  - `systemctl enable <service>` (start on boot)
  - `systemctl disable <service>`
- **Logs and Diagnostics**
  - `journalctl`: Querying the systemd journal
  - Filtering logs (by unit, time, priority)
- **Creating Custom Services**
  - Writing a basic `.service` unit file
  - Reloading `systemd` to apply changes
EOF

# C. Package Management
cat <<'EOF' > "$DIR_NAME/003-Package-Management.md"
# Package Management

- **Introduction to Package Managers** (APT, DNF/YUM, Pacman)
  - The role of package repositories
- **Core Operations**
  - Finding/searching for packages
  - Installing new packages
  - Upgrading installed packages
  - Removing packages
  - Listing installed packages
- **Alternative Package Formats**
  - Snap: Concepts and usage
  - Flatpak and AppImage
EOF


# ==========================================
# PART IV: Text Processing and Shell Scripting
# ==========================================
DIR_NAME="004-Text-Processing-and-Shell-Scripting"
mkdir -p "$DIR_NAME"

# A. Text Processing
cat <<'EOF' > "$DIR_NAME/001-Powerful-Text-Processing-Utilities.md"
# Powerful Text Processing Utilities

- **Viewing and Combining Files**
  - `cat`, `tac`, `less`, `more`
  - `head`, `tail` (`-n` for lines, `-f` for following)
- **Searching and Filtering Text**
  - `grep`: The universal search tool (patterns, `-i`, `-v`, `-r`)
  - `find`: Searching for files and directories based on criteria
- **Transforming Text**
  - `sort`, `uniq` (`-c` for count)
  - `tr`: Translating or deleting characters
  - `cut`: Extracting sections from lines of files
  - `paste`: Merging lines of files
  - `wc`: Word, line, character, and byte count
  - `sed`: The stream editor for filtering and transforming text
  - `awk`: A powerful pattern scanning and processing language
- **File Manipulation**
  - `split`: Splitting a file into pieces
  - `join`: Joining lines of two files on a common field
  - `expand`, `unexpand`: Converting tabs to/from spaces
EOF

# B. Shell Programming
cat <<'EOF' > "$DIR_NAME/002-Shell-Programming-Scripting.md"
# Shell Programming (Scripting)

- **Scripting Fundamentals**
  - Creating and executing a shell script (shebang `#!/bin/bash`)
  - Literals and Variables (defining, referencing, quoting)
  - Command Substitution (`$(...)`)
  - Positional Parameters and Special Variables (`$1`, `$@`, `$#`, `$?`)
- **Control Flow**
  - Conditional Statements (`if`, `elif`, `else`, `case`)
  - Test conditions (`[ ... ]` and `[[ ... ]]`)
  - Loops (`for`, `while`, `until`)
- **Functions**
  - Defining and calling functions
  - Passing arguments and returning values
- **Debugging**
  - Using `set -x` for tracing execution
  - Linters like `shellcheck`
EOF


# ==========================================
# PART V: Networking & Troubleshooting
# ==========================================
DIR_NAME="005-Networking-and-Troubleshooting"
mkdir -p "$DIR_NAME"

# A. Networking Fundamentals
cat <<'EOF' > "$DIR_NAME/001-Networking-Fundamentals.md"
# Networking Fundamentals

- **Core Concepts**
  - TCP/IP Stack overview
  - IP Addresses, Subnetting, and Routing
  - DNS Resolution process
  - Common ports and services
- **Essential Networking Commands**
  - `ping`, `traceroute`: Connectivity and path diagnostics
  - `ip`, `ifconfig`: Viewing and configuring network interfaces
  - `netstat`, `ss`: Displaying network connections and statistics
  - `dig`, `nslookup`: DNS querying
- **Secure Connections and File Transfer**
  - `ssh`: Secure Shell for remote access
  - `scp`, `rsync`: Securely copying files between hosts
EOF

# B. System Troubleshooting
cat <<'EOF' > "$DIR_NAME/002-System-Troubleshooting.md"
# System Troubleshooting

- **Resource Monitoring**
  - `free`, `vmstat`: Checking available memory and swap
  - `df`, `du`: Checking disk space usage
  - `iostat`, `iotop`: Monitoring disk I/O
  - `uptime`: System load average
- **Logs and System Information**
  - Navigating `/var/log` for system and application logs
  - `dmesg`: Kernel ring buffer messages
  - Authentication logs (`/var/log/auth.log` or similar)
- **Booting and System Startup**
  - The Boot Process (BIOS/UEFI, Boot Loader/GRUB, Kernel, Init)
  - Troubleshooting boot issues
EOF


# ==========================================
# PART VI: Advanced Topics
# ==========================================
DIR_NAME="006-Advanced-Topics"
mkdir -p "$DIR_NAME"

# A. Disks and Filesystems
cat <<'EOF' > "$DIR_NAME/001-Disks-and-Filesystems.md"
# Disks and Filesystems

- **Filesystem Types** (ext4, XFS, Btrfs)
- **Partitioning and Mounting**
  - `fdisk`, `gdisk`, `parted`: Disk partitioning tools
  - `mkfs`: Creating a filesystem
  - `mount`, `umount`, and the `/etc/fstab` file
- **Logical Volume Management (LVM)**
  - Core concepts (Physical Volumes, Volume Groups, Logical Volumes)
  - Benefits of LVM (flexibility, resizing)
- **Advanced Storage**
  - RAID (Redundant Array of Independent Disks) concepts
  - Managing Swap space
  - Understanding Inodes
EOF

# B. Containerization
cat <<'EOF' > "$DIR_NAME/002-Containerization.md"
# Containerization

- **Introduction to Containers**
  - Containers vs. Virtual Machines
  - The role of the container runtime
- **Docker Fundamentals**
  - Images and Containers
  - The Dockerfile: Building custom images
  - `docker run`, `docker ps`, `docker exec`, `docker logs`
  - Docker Compose for multi-container applications
- **Resource Management**
  - `cgroups` (Control Groups) for resource limiting
  - `ulimits` for setting resource limits for processes
EOF

echo "Done! Hierarchy created inside '$ROOT_DIR'."


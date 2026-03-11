# Linux Complete Study Guide (Ideal / Angel Method)
## Part 1: Ideal Linux System — Kernel, Boot & Process Management

---

### 1. The Linux Kernel

#### 1.1 Kernel Architecture
- 1.1.1 Monolithic kernel with loadable modules — core design vs microkernel tradeoffs
- 1.1.2 Kernel space vs user space — privilege rings (0 = kernel, 3 = user)
- 1.1.3 System call interface — the contract between userspace and kernel
- 1.1.4 Kernel subsystems — process scheduler, VFS, memory manager, network stack, drivers
- 1.1.5 Loadable Kernel Modules (LKM) — `insmod`, `modprobe`, `lsmod`, `rmmod`
- 1.1.6 Kernel versioning — `uname -r`, `MAJOR.MINOR.PATCH-EXTRAVERSION`
- 1.1.7 Mainline vs LTS kernels — upstream Linus tree vs stable long-term support branches

#### 1.2 System Calls
- 1.2.1 What a syscall is — trap into kernel mode, `int 0x80` vs `syscall` instruction
- 1.2.2 Common syscalls — `read`, `write`, `open`, `close`, `fork`, `exec`, `mmap`, `ioctl`
- 1.2.3 `strace` — trace system calls of a running process
- 1.2.4 `ltrace` — trace library calls
- 1.2.5 VDSO (Virtual Dynamic Shared Object) — kernel-mapped page for fast syscalls
- 1.2.6 syscall table — architecture-specific, `arch/x86/entry/syscalls/syscall_64.tbl`

#### 1.3 Interrupts & Hardware Interaction
- 1.3.1 Interrupts vs exceptions — hardware-triggered vs software-triggered
- 1.3.2 IRQ (Interrupt Request) — hardware lines, `cat /proc/interrupts`
- 1.3.3 Interrupt handlers — top-half (minimal, in IRQ context) vs bottom-half (deferred)
- 1.3.4 Softirqs, tasklets, workqueues — deferred processing mechanisms
- 1.3.5 DMA (Direct Memory Access) — peripheral-to-memory without CPU involvement
- 1.3.6 IOMMU — hardware memory protection for DMA, used in virtualization

---

### 2. Boot Process

#### 2.1 BIOS/UEFI Stage
- 2.1.1 BIOS vs UEFI — legacy MBR boot vs UEFI with GPT, Secure Boot
- 2.1.2 POST (Power-On Self-Test) — hardware initialization and enumeration
- 2.1.3 Boot order — disk, network (PXE), USB, configurable in firmware
- 2.1.4 MBR (Master Boot Record) — 512-byte sector, partition table, stage 1 bootloader
- 2.1.5 GPT (GUID Partition Table) — modern, supports >2TB, protective MBR
- 2.1.6 Secure Boot — UEFI signature validation, shim for Linux, DBX revocations

#### 2.2 Bootloader (GRUB2)
- 2.2.1 GRUB2 stages — stage 1 (MBR/UEFI), stage 1.5 (core.img), stage 2 (full GRUB)
- 2.2.2 `grub.cfg` — boot menu configuration, kernel parameters, initrd specification
- 2.2.3 `grub-update` / `grub2-mkconfig` — regenerate config from `/etc/grub.d/`
- 2.2.4 GRUB rescue mode — broken config recovery, manual boot commands
- 2.2.5 GRUB kernel parameters — `quiet splash`, `ro`, `init=`, `nomodeset`, `single`
- 2.2.6 Alternative bootloaders — systemd-boot (EFI stub), syslinux, rEFInd

#### 2.3 Kernel Loading & initramfs
- 2.3.1 Kernel image types — `vmlinuz` (compressed), `bzImage`, EFI stub
- 2.3.2 initramfs — temporary root filesystem in RAM, contains drivers for real root mount
- 2.3.3 `dracut` / `mkinitrd` — tools to build initramfs image
- 2.3.4 Early userspace — initramfs runs `/init`, mounts real root, pivots to it
- 2.3.5 `rd.break` — drop into initramfs shell for recovery (systemd-based systems)
- 2.3.6 Kernel ring buffer — `dmesg`, early boot messages before syslog

#### 2.4 Init System
- 2.4.1 PID 1 — first process, parent of all, must not die
- 2.4.2 systemd — dominant modern init, parallel startup, unit files, journald
- 2.4.3 SysVinit — sequential, runlevels (0-6), `/etc/init.d/` scripts (legacy)
- 2.4.4 OpenRC — dependency-based, used by Gentoo, Alpine (non-musl)
- 2.4.5 runit — supervision tree, used by Void Linux, Docker base images
- 2.4.6 Boot targets (systemd) — `multi-user.target`, `graphical.target`, `rescue.target`

---

### 3. Process Management

#### 3.1 Process Concepts
- 3.1.1 Process vs thread — separate address space vs shared address space
- 3.1.2 Process states — running, sleeping (interruptible/uninterruptible), stopped, zombie
- 3.1.3 PID, PPID, PGID, SID — process, parent, group, session identifiers
- 3.1.4 PCB (Process Control Block) — kernel's `task_struct` data structure
- 3.1.5 Process lifecycle — `fork()` → `exec()` → `wait()` → `exit()`
- 3.1.6 Zombie processes — exited but not reaped by parent, `ps aux | grep Z`

#### 3.2 Signals
- 3.2.1 Signal overview — asynchronous notifications to processes
- 3.2.2 Common signals — `SIGHUP(1)`, `SIGINT(2)`, `SIGKILL(9)`, `SIGTERM(15)`, `SIGSTOP(19)`
- 3.2.3 `kill` command — `kill -SIGNAL PID`, `kill -l` lists signals
- 3.2.4 `killall` / `pkill` — signal by name, pattern, user
- 3.2.5 Signal handlers — `trap` in bash, `sigaction()` in C
- 3.2.6 `SIGKILL` and `SIGSTOP` — cannot be caught, blocked, or ignored

#### 3.3 CPU Scheduling
- 3.3.1 CFS (Completely Fair Scheduler) — red-black tree, virtual runtime, Linux default
- 3.3.2 Real-time scheduling — `SCHED_FIFO`, `SCHED_RR` — for latency-critical processes
- 3.3.3 Nice values — `-20` (highest priority) to `+19` (lowest), `nice`, `renice`
- 3.3.4 CPU affinity — `taskset`, bind process to specific CPU cores
- 3.3.5 Load average — 1/5/15 minute averages, `uptime`, `top`
- 3.3.6 Context switching — save/restore CPU state, cache flush cost

#### 3.4 Process Monitoring & Control
- 3.4.1 `ps aux` — snapshot of running processes
- 3.4.2 `top` / `htop` — interactive process viewer, CPU/mem/swap live
- 3.4.3 `pstree` — show process hierarchy
- 3.4.4 `lsof` — list open files, network connections, sockets per process
- 3.4.5 `/proc/PID/` — per-process kernel information (cmdline, maps, fd, status)
- 3.4.6 `systemd-cgls` / `systemd-cgtop` — cgroup hierarchy and resource usage

#### 3.5 Job Control
- 3.5.1 Foreground vs background — `&` suffix, `Ctrl+Z` suspend
- 3.5.2 `jobs` — list background jobs in current shell session
- 3.5.3 `fg` / `bg` — bring job to foreground or resume in background
- 3.5.4 `nohup` — run command immune to SIGHUP (terminal close)
- 3.5.5 `disown` — detach job from shell without nohup
- 3.5.6 `screen` / `tmux` — terminal multiplexers for persistent sessions

---

### 4. Memory Management

#### 4.1 Virtual Memory
- 4.1.1 Virtual address space layout — text, data, BSS, heap, stack, kernel space
- 4.1.2 Paging — virtual → physical address translation via page tables
- 4.1.3 TLB (Translation Lookaside Buffer) — hardware cache for page table entries
- 4.1.4 Huge pages — 2MB/1GB pages reduce TLB pressure, `hugepages` kernel param
- 4.1.5 Transparent Huge Pages (THP) — automatic huge page management
- 4.1.6 `/proc/meminfo` — MemTotal, MemFree, MemAvailable, Buffers, Cached, Swap

#### 4.2 Memory Allocation
- 4.2.1 `mmap()` syscall — map files or anonymous memory into address space
- 4.2.2 `brk()` / `sbrk()` — heap expansion (used by `malloc` internally)
- 4.2.3 Buddy allocator — kernel page allocator, power-of-2 free lists
- 4.2.4 Slab allocator — cache frequently-used kernel objects, reduce fragmentation
- 4.2.5 OOM killer — kills processes when system runs out of memory, `/proc/PID/oom_score`
- 4.2.6 `vm.overcommit_memory` — 0 (heuristic), 1 (always), 2 (never overcommit)

#### 4.3 Swap
- 4.3.1 Swap partition vs swap file — performance vs flexibility
- 4.3.2 `swapon` / `swapoff` — activate/deactivate swap
- 4.3.3 `vm.swappiness` — 0-100, tendency to swap vs reclaim page cache
- 4.3.4 `zswap` / `zram` — compressed in-memory swap, for low-RAM systems
- 4.3.5 Memory pressure — PSI (Pressure Stall Information), `/proc/pressure/memory`
- 4.3.6 Page cache — kernel caches file contents in RAM, `free -m` buffers/cache

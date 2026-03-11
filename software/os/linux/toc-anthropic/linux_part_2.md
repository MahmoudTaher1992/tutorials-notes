# Linux Complete Study Guide (Ideal / Angel Method)
## Part 2: Ideal Linux System — Filesystem, Storage & I/O

---

### 5. Filesystem Architecture

#### 5.1 VFS (Virtual Filesystem Switch)
- 5.1.1 VFS abstraction — unified interface for all filesystem types
- 5.1.2 VFS objects — superblock, inode, dentry, file
- 5.1.3 Filesystem types — ext4, xfs, btrfs, f2fs, tmpfs, proc, sysfs, devtmpfs
- 5.1.4 Mounting — `mount`, `umount`, bind mounts, `MS_BIND` flag
- 5.1.5 `/proc/mounts` vs `/etc/fstab` — runtime vs persistent mount config
- 5.1.6 Union filesystems — OverlayFS, layering used by Docker/containers

#### 5.2 Linux Filesystem Hierarchy Standard (FHS)
- 5.2.1 `/` — root, everything lives here
- 5.2.2 `/bin`, `/sbin` — essential user/system binaries (symlinks to `/usr/bin` on modern systems)
- 5.2.3 `/etc` — system-wide configuration files, text-based, editable
- 5.2.4 `/home` — user home directories, per-user data and config
- 5.2.5 `/var` — variable data (logs, spool, databases, runtime state)
- 5.2.6 `/tmp` — temporary files, cleared on reboot (or via tmpwatch)
- 5.2.7 `/proc` — virtual FS exposing kernel state, process info, tunable params
- 5.2.8 `/sys` — virtual FS for hardware/driver/kernel object tree (sysfs)
- 5.2.9 `/dev` — device files, managed by udev
- 5.2.10 `/run` — tmpfs, runtime data since last boot (replaces `/var/run`)
- 5.2.11 `/usr` — read-only user data (binaries, libraries, share, include)
- 5.2.12 `/lib`, `/lib64` — shared libraries for essential binaries

#### 5.3 Inodes & Links
- 5.3.1 Inode — metadata container (permissions, timestamps, size, data block pointers)
- 5.3.2 Hard links — multiple directory entries pointing to same inode
- 5.3.3 Symbolic links — pointer to a path, can cross filesystem boundaries
- 5.3.4 `stat` — show inode metadata for a file
- 5.3.5 Inode exhaustion — `df -i`, can run out of inodes while disk has space
- 5.3.6 `find -inum` — locate files by inode number

#### 5.4 Filesystem Types

##### ext4
- 5.4.1 Journaling — ordered, writeback, data modes — prevents corruption on crash
- 5.4.2 Extents — contiguous block ranges, reduces fragmentation vs block maps
- 5.4.3 `fsck.ext4` — filesystem check and repair
- 5.4.4 `tune2fs` — adjust ext4 parameters (mount count, journal, reserved blocks)
- 5.4.5 `e2label` / `e2fsck` — labeling and checking

##### XFS
- 5.4.6 XFS design — parallel I/O, large file optimized, B+ tree structures
- 5.4.7 `xfs_repair` — repair tool (cannot repair mounted filesystem)
- 5.4.8 `xfs_admin` — label, UUID management
- 5.4.9 Quota support — user, group, project quotas with xfs_quota

##### Btrfs
- 5.4.10 Copy-on-Write (CoW) — every write creates a new version, no in-place update
- 5.4.11 Subvolumes — lightweight filesystem namespaces within Btrfs
- 5.4.12 Snapshots — instant, space-efficient CoW snapshots of subvolumes
- 5.4.13 RAID modes — RAID 0/1/5/6/10 within single filesystem
- 5.4.14 `btrfs check`, `btrfs scrub` — integrity verification

---

### 6. Storage Management

#### 6.1 Block Devices & Partitioning
- 6.1.1 Block devices — `/dev/sda`, `/dev/nvme0n1`, `/dev/vda` naming
- 6.1.2 `lsblk` — tree view of block devices and partitions
- 6.1.3 `fdisk` — MBR partition editor
- 6.1.4 `gdisk` / `sgdisk` — GPT partition editor
- 6.1.5 `parted` — supports both MBR and GPT
- 6.1.6 Partition naming — `sda1`, `sda2`, `nvme0n1p1`

#### 6.2 LVM (Logical Volume Manager)
- 6.2.1 PV (Physical Volume) — raw disk or partition initialized with `pvcreate`
- 6.2.2 VG (Volume Group) — pool of PVs, `vgcreate`, `vgextend`
- 6.2.3 LV (Logical Volume) — virtual partition from VG, `lvcreate`
- 6.2.4 LVM snapshot — CoW point-in-time copy of an LV
- 6.2.5 LVM thin provisioning — overcommit storage, allocate on write
- 6.2.6 `pvdisplay`, `vgdisplay`, `lvdisplay` — inspect LVM state

#### 6.3 RAID
- 6.3.1 RAID 0 — striping, speed, no redundancy
- 6.3.2 RAID 1 — mirroring, full redundancy, 50% usable space
- 6.3.3 RAID 5 — striping + distributed parity, N-1 usable, 1 disk failure tolerated
- 6.3.4 RAID 6 — double parity, 2 disk failures tolerated
- 6.3.5 RAID 10 — mirroring + striping, performance + redundancy
- 6.3.6 `mdadm` — Linux software RAID management

#### 6.4 Disk Health & Performance
- 6.4.1 `smartctl` (smartmontools) — S.M.A.R.T. disk health monitoring
- 6.4.2 `iostat` — block device I/O statistics (from `sysstat` package)
- 6.4.3 `iotop` — I/O usage by process
- 6.4.4 `fio` — flexible I/O benchmark tool
- 6.4.5 `blktrace` / `blkparse` — low-level block I/O tracing
- 6.4.6 NVMe vs SATA — interface speed, queue depth, latency differences

---

### 7. File Permissions & Attributes

#### 7.1 Traditional Unix Permissions
- 7.1.1 Permission bits — read(4), write(2), execute(1) for owner/group/other
- 7.1.2 `chmod` — `chmod 755 file`, symbolic `chmod u+x,g-w file`
- 7.1.3 `chown` / `chgrp` — change ownership and group
- 7.1.4 `umask` — default permission mask, subtracted from `0666`/`0777`
- 7.1.5 Special bits — setuid (4000), setgid (2000), sticky (1000)
- 7.1.6 `ls -la` — long listing with permissions, ownership, size, timestamps

#### 7.2 ACLs (Access Control Lists)
- 7.2.1 POSIX ACLs — granular per-user/per-group permissions beyond owner/group/other
- 7.2.2 `getfacl` / `setfacl` — read and set ACL entries
- 7.2.3 Default ACLs on directories — inherited by newly created files
- 7.2.4 ACL mask — effective permission ceiling for ACL entries
- 7.2.5 Filesystem ACL support — ext4, xfs, btrfs support; requires `acl` mount option (older kernels)

#### 7.3 Extended Attributes & Capabilities
- 7.3.1 xattr — `getfattr`, `setfattr` — arbitrary key-value metadata on files
- 7.3.2 Linux capabilities — fine-grained privilege (`CAP_NET_BIND_SERVICE`, `CAP_SYS_ADMIN`)
- 7.3.3 `getcap` / `setcap` — view and set file capabilities
- 7.3.4 `chattr` / `lsattr` — immutable (`+i`), append-only (`+a`) file attributes
- 7.3.5 Immutable files — even root cannot modify without removing the attribute first

#### 7.4 File Search & Navigation
- 7.4.1 `find` — `find /path -name "*.log" -mtime -7 -exec rm {} \;`
- 7.4.2 `locate` / `updatedb` — indexed file search, faster but not real-time
- 7.4.3 `which` / `whereis` / `type` — locate executables in PATH
- 7.4.4 `tree` — visual directory tree output
- 7.4.5 `du` — disk usage per directory, `du -sh *` human-readable
- 7.4.6 `df` — filesystem space usage, `df -h` human-readable

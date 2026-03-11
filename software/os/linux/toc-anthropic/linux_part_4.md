# Linux Complete Study Guide (Ideal / Angel Method)
## Part 4: Ideal Linux System — Shell Mastery, Admin & Observability

---

### 10. Shell & Command Line

#### 10.1 Bash Fundamentals
- 10.1.1 Shell types — login, interactive, non-interactive, subshell
- 10.1.2 Startup files — `/etc/profile`, `~/.bash_profile`, `~/.bashrc`, `~/.bash_logout`
- 10.1.3 Variables — `VAR=value`, `export VAR`, `${VAR:-default}`, `${VAR:?error}`
- 10.1.4 Quoting — single (literal), double (interpolate), backtick/`$()` (subshell)
- 10.1.5 Special variables — `$0` script, `$1-$9` args, `$#` count, `$?` exit code, `$$` PID
- 10.1.6 Arrays — `arr=(a b c)`, `${arr[0]}`, `${arr[@]}`, `${#arr[@]}`

#### 10.2 Control Flow & Functions
- 10.2.1 `if/elif/else/fi` — `[[ ]]` preferred over `[ ]` for tests
- 10.2.2 `for` loop — `for f in *.log; do ...; done`; C-style `for ((i=0; i<10; i++))`
- 10.2.3 `while` / `until` loops — `while read line; do ...; done < file`
- 10.2.4 `case` statement — pattern matching, `;;`, `;&` fallthrough
- 10.2.5 Functions — `myfunc() { ...; }`, local variables with `local`
- 10.2.6 `set -euo pipefail` — strict mode: exit on error, unset var, pipe failure

#### 10.3 I/O Redirection & Pipes
- 10.3.1 stdout redirect — `>` overwrite, `>>` append
- 10.3.2 stderr redirect — `2>`, `2>>`, combine `2>&1`, discard `2>/dev/null`
- 10.3.3 stdin redirect — `< file`, here-doc `<<EOF`, here-string `<<<`
- 10.3.4 Pipes — `|`, `|&` (stdout+stderr), named pipes (`mkfifo`)
- 10.3.5 `tee` — write to stdout and file simultaneously
- 10.3.6 Process substitution — `diff <(cmd1) <(cmd2)`, `>(cmd)` as sink

#### 10.4 Text Processing Toolkit
- 10.4.1 `grep` — `grep -rn --include="*.py" pattern .`, `-E` POSIX ERE, `-P` PCRE
- 10.4.2 `sed` — stream editor, `sed 's/old/new/g'`, `-i` in-place, `/d` delete line
- 10.4.3 `awk` — field processing, `awk '{print $1, $3}'`, conditionals, built-in vars
- 10.4.4 `cut` — `cut -d: -f1 /etc/passwd`, extract columns from delimited input
- 10.4.5 `sort` — `sort -k2 -n -r`, `sort -u` unique, `sort -t: -k3 -n` delimited
- 10.4.6 `uniq` — remove adjacent duplicates, `-c` count, `-d` only duplicates
- 10.4.7 `tr` — translate/delete characters, `tr 'a-z' 'A-Z'`, `tr -d '\r'`
- 10.4.8 `wc` — word/line/char count, `wc -l file`
- 10.4.9 `xargs` — build command from stdin, `find . -name "*.tmp" | xargs rm`
- 10.4.10 `jq` — JSON processor, `jq '.items[] | .name'`

#### 10.5 Shell Productivity
- 10.5.1 History — `!!`, `!$`, `!string`, `Ctrl+R` reverse search, `HISTSIZE`
- 10.5.2 Aliases — `alias ll='ls -lahF'`, put in `~/.bashrc`
- 10.5.3 Tab completion — `bash-completion` package, programmable completions
- 10.5.4 `Ctrl+A/E` — move to beginning/end of line; `Alt+F/B` — word navigation
- 10.5.5 `set -x` / `set +x` — enable/disable xtrace for debugging scripts
- 10.5.6 `shellcheck` — static analysis for shell scripts

---

### 11. System Administration

#### 11.1 Package Management (Cross-distro concepts)
- 11.1.1 Package format — `.deb` (Debian/Ubuntu) vs `.rpm` (RHEL/Fedora)
- 11.1.2 Low-level tools — `dpkg`, `rpm` — install, query, verify individual packages
- 11.1.3 High-level tools — `apt`, `dnf`/`yum`, `zypper`, `pacman` — dependency resolution
- 11.1.4 Package queries — `dpkg -l | grep nginx`, `rpm -qa | grep httpd`
- 11.1.5 Repo management — `/etc/apt/sources.list`, `/etc/yum.repos.d/`
- 11.1.6 Snap / Flatpak / AppImage — universal distribution formats

#### 11.2 systemd
- 11.2.1 Unit types — `.service`, `.socket`, `.timer`, `.mount`, `.target`, `.slice`
- 11.2.2 `systemctl start|stop|restart|reload|enable|disable|status <unit>`
- 11.2.3 `journalctl` — `journalctl -u nginx -f`, `-n 100`, `--since "1 hour ago"`
- 11.2.4 Service unit file anatomy — `[Unit]`, `[Service]`, `[Install]` sections
- 11.2.5 `ExecStart`, `Restart`, `RestartSec`, `After`, `Wants`, `Requires` directives
- 11.2.6 `.timer` units — cron replacement, `OnCalendar=`, `OnBootSec=`
- 11.2.7 `systemd-analyze` — boot time breakdown, `blame`, `critical-chain`
- 11.2.8 Targets — dependency groups, `systemctl get-default`, `isolate`

#### 11.3 Cron & Task Scheduling
- 11.3.1 crontab format — `MIN HOUR DOM MON DOW CMD`
- 11.3.2 `crontab -e/-l/-r` — edit, list, remove user crontab
- 11.3.3 `/etc/cron.d/`, `/etc/cron.daily/` — system-wide cron drop-ins
- 11.3.4 `at` / `batch` — schedule one-time jobs
- 11.3.5 `anacron` — run missed cron jobs on next boot (for laptops/workstations)
- 11.3.6 systemd timers vs cron — timers have logging, dependencies, can be per-user

#### 11.4 Log Management
- 11.4.1 Traditional syslog — `/var/log/syslog`, `rsyslog`, `syslog-ng`
- 11.4.2 journald — binary journal, `journalctl`, volatile or persistent storage
- 11.4.3 Log rotation — `logrotate`, `/etc/logrotate.d/`, `rotate 7 compress daily`
- 11.4.4 `/var/log/` structure — `auth.log`, `kern.log`, `dmesg`, `apt/`, `nginx/`
- 11.4.5 Remote logging — forward to centralized syslog or ELK/Loki
- 11.4.6 `logger` command — write to syslog from scripts

---

### 12. Observability & Performance

#### 12.1 System Monitoring
- 12.1.1 `top` / `htop` / `btop` — CPU, memory, swap, process tree live view
- 12.1.2 `vmstat` — virtual memory statistics, CPU, I/O, context switches
- 12.1.3 `sar` (sysstat) — historical system activity, `sar -u 1 10`
- 12.1.4 `mpstat` — per-CPU statistics
- 12.1.5 `free -h` — memory and swap usage summary
- 12.1.6 `uptime` — load average, uptime since boot

#### 12.2 CPU & I/O Profiling
- 12.2.1 `perf` — hardware performance counters, CPU profiling, `perf top`, `perf record`
- 12.2.2 `perf stat` — count events for a command, cache misses, branch mispredictions
- 12.2.3 Flame graphs — Brendan Gregg's visualization of `perf` call stacks
- 12.2.4 `eBPF` / `bcc` / `bpftrace` — programmable kernel tracing without kernel patches
- 12.2.5 `pidstat` — per-process CPU, memory, I/O statistics
- 12.2.6 `dstat` — combined iostat + vmstat + ifstat replacement

#### 12.3 Network & Application Tracing
- 12.3.1 `strace` — trace system calls of a process, diagnose mysterious failures
- 12.3.2 `tcpdump` — packet-level network capture for debugging
- 12.3.3 `netstat -s` / `ss -s` — socket statistics summaries
- 12.3.4 `/proc/net/dev` — per-interface RX/TX byte counters
- 12.3.5 `conntrack` — NAT connection tracking table inspection
- 12.3.6 `bpftrace` one-liners — `bpftrace -e 'kprobe:do_sys_open { printf("%s\n", str(arg1)); }'`

#### 12.4 cgroups & Resource Control
- 12.4.1 cgroups v1 — hierarchy per controller (cpu, memory, blkio, net_cls)
- 12.4.2 cgroups v2 — unified hierarchy, all controllers under single tree
- 12.4.3 `systemctl set-property` — set cgroup limits for services
- 12.4.4 `systemd-cgtop` — resource usage by cgroup
- 12.4.5 `memory.limit_in_bytes` — hard memory cap per cgroup
- 12.4.6 CPU shares vs CPU quota — relative weight vs absolute cap

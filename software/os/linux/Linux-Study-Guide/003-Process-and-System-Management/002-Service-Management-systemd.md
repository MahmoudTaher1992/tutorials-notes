Here is a detailed explanation of **Part III, Section B: Service Management (systemd)**.

In modern Linux distributions (like Ubuntu, CentOS/RHEL, Debian, and Fedora), **systemd** is the software that handles the booting of the operating system and the management of background processes (services). Learning to control it is essential for any Linux administrator.

---

### 1. Introduction to systemd and Services

#### The Role of an Init System
When the Linux kernel boots up, it starts exactly one process: **PID 1**. Historically, this was a program called `init`. In modern systems, this program is **systemd**.
*   **Responsibility:** Systemd initializes the rest of the system. It mounts filesystems, configuring the network, and starts background services (like Web Servers, Database Servers, or SSH).
*   **Why systemd?** Unlike older systems (like SysVinit) which started services one by one (sequentially), systemd starts services in parallel, making boot times much faster. It also automatically resolves dependencies (e.g., "Don't start the Web Server until the Network is online").

#### Understanding Units
Systemd treats almost every resource as a **"Unit."** A unit is just a configuration file telling systemd how to handle a specific resource. The relevant types are:
*   **Service Units (`.service`):** The most common type. These control applications/daemons (e.g., `nginx.service`, `sshd.service`).
*   **Socket Units (`.socket`):** Used for "lazy loading." Systemd listens on a network port; if traffic arrives, it starts the corresponding service.
*   **Timer Units (`.timer`):** A modern replacement for Cron. These trigger services at specific times or intervals.
*   **Target Units (`.target`):** A group of units. For example, `multi-user.target` is equivalent to the old Runlevel 3 (boot to command line with networking).

---

### 2. Managing Services

The command-line tool used to control systemd is **`systemctl`**.

#### Basic Commands
*   **Starting and Stopping:** This affects the *current* session only. It does not change what happens when you reboot.
    ```bash
    sudo systemctl start nginx    # Start the web server now
    sudo systemctl stop nginx     # Stop the web server now
    ```
*   **Restarting vs. Reloading:**
    *   `restart`: Stops the process entirely and starts a fresh instance. (Process ID changes, connections drop).
    *   `reload`: Tells the service to re-read its configuration file without stopping. (Useful to apply config changes without disconnecting users).
    ```bash
    sudo systemctl restart nginx
    sudo systemctl reload nginx
    ```

#### Boot Persistence (Enable/Disable)
This is a common point of confusion. Controlling the "now" is different from controlling "boot time."
*   **Enable:** Creates a symbolic link on the disk so the service launches automatically when the computer turns on.
*   **Disable:** Removes the link; the service won't start on the next boot (but stays running now if it was already up).
    ```bash
    sudo systemctl enable nginx   # Start on boot
    sudo systemctl disable nginx  # Do not start on boot
    ```
    *Note: You can do both at once: `sudo systemctl enable --now nginx`.*

#### Checking Status
The `status` command is your dashboard. It tells you:
1.  **Loaded:** Is the unit file found?
2.  **Active:** Is it currently running, exited, or failed?
3.  **Logs:** The last few lines of output from the service.
    ```bash
    systemctl status nginx
    ```
    *Tip: If a service fails to start, this is the first command you run to see the error code.*

---

### 3. Logs and Diagnostics

Systemd includes its own logging system called **`journald`**. Unlike old logs stored in plain text files in `/var/log`, the journal is binary (fast and searchable/filterable).

#### The `journalctl` Command
*   **View all logs:** `journalctl` (usually too much info).
*   **Filter by Unit:** See logs *only* for a specific service.
    ```bash
    journalctl -u nginx
    ```
*   **Follow tail:** Watch logs in real-time (like `tail -f`).
    ```bash
    journalctl -u nginx -f
    ```
*   **Boot filter:** See logs only from the current boot session (hides history from yesterday).
    ```bash
    journalctl -b
    ```
*   **Time windows:**
    ```bash
    journalctl --since "1 hour ago"
    ```

---

### 4. Creating Custom Services

Sometimes you want to run your own script (e.g., a Python bot, a cleanup script) as a background service that automatically restarts if it crashes.

#### Writing a Unit File
System administrators place custom unit files in `/etc/systemd/system/`.

**Example: `my-script.service`**
```ini
[Unit]
Description=My Custom Python Script
After=network.target            # Wait for network before starting

[Service]
Type=simple
User=myuser                     # Run as a specific user, not root
ExecStart=/usr/bin/python3 /home/myuser/script.py
Restart=on-failure              # Auto-restart if it crashes

[Install]
WantedBy=multi-user.target      # Start when system enters multi-user mode
```

#### The Reload Process
Any time you create or edit a unit file on disk, you must tell systemd to scan the disk for changes:
1.  **Reload Daemon:** `sudo systemctl daemon-reload`
2.  **Start Service:** `sudo systemctl start my-script`
3.  **Enable Boot:** `sudo systemctl enable my-script`

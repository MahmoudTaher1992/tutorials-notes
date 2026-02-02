Everything in a Linux/Unix system runs as a **Process**. A process is simply an instance of a computer program that is being executed.

Here is a detailed breakdown of the **Process Monitoring** section of your study guide.

---

### 1. Listing Processes (`ps`, `pgrep`)
These commands provide a **static snapshot** of what is currently running on your system. Unlike `top` (which updates live), these commands act like a photo camera.

#### **`ps` (Process Status)**
The `ps` command is the standard tool for viewing processes. By itself, it only shows processes running in the current terminal. To be useful, it is usually run with specific flags.

*   **Common Usage:** `ps aux`
    *   **`a`**: Shows processes for **a**ll users.
    *   **`u`**: Displays the **u**ser/owner of the process and provides detailed info (CPU/RAM usage).
    *   **`x`**: Shows processes not attached to a terminal (background daemons).

**What the output columns mean:**
*   **PID:** Process ID. A unique number assigned to every process. You need this number to stop (kill) a specific process.
*   **%CPU / %MEM:** How much resource the process is using.
*   **COMMAND:** The command that sounded the process.

#### **`pgrep` (Process Grep)**
If you don't need all the details and just want to find the **PID** of a specific program by its name, use `pgrep`.

*   **Example:** `pgrep nginx`
    *   *Output:* `1054` (Just returns the ID).
*   **Usage with name:** `pgrep -l python` (Lists the PID and the name "python").

---

### 2. Real-time Monitoring (`top`, `htop`)
These tools provide a dynamic, updating dashboard of system health.

#### **`top`**
The classic, pre-installed monitor. It refreshes every few seconds.
*   **The Header:** Shows system uptime, load average (how busy the CPU is), total RAM, and swap usage.
*   **The List:** Shows processes sorted by CPU usage by default.
*   **Shortcuts inside `top`:**
    *   `M`: Sort by **M**emory usage.
    *   `P`: Sort by **P**rocessor (CPU) usage.
    *   `k`: Prompt to **k**ill a process (you must type the PID).
    *   `q`: **Q**uit.

#### **`htop`**
A visual, colorful, and user-friendly version of `top`. (Usually requires installation: `sudo apt install htop`).
*   **Advantages:** It supports scrolling with the mouse or arrow keys to see the full list of processes. It has a graphical bar chart for CPU/RAM at the top.
*   **Action Keys:** You can press F9 to kill a selected process without needing to type the PID manually.

---

### 3. Terminating Processes (`kill`, `killall`, `pkill`)
Stopping a process in Linux is technically called "Sending a Signal."

#### **The Signals**
Before using the commands, you must understand the two most common signals:
1.  **SIGTERM (Signal 15):** The "polite" kill. It asks the program to save data and stop. This is the default.
2.  **SIGKILL (Signal 9):** The "force" kill. It rips the process out of memory immediately. Use this only if the process is frozen/unresponsive.

#### **`kill`**
Terminates a process by its **PID**.
*   **Usage:** `kill 1234` (Send SIGTERM to PID 1234).
*   **Force Kill:** `kill -9 1234` (Forcefully kill PID 1234).

#### **`killall`**
Terminates processes by **Name**. CAUTION: This kills *every* instance of that program.
*   **Usage:** `killall firefox` (Closes all Firefox windows).

#### **`pkill`**
Similar to `killall` but allows for partial name matching (like `pgrep` but for killing).
*   **Usage:** `pkill fire` (Might kill Firefox, Firewalld, etc.).

---

### 4. Job Control (`&`, `fg`, `bg`, `jobs`)
In the shell, you can run programs in the **foreground** (you can't type anything else until it finishes) or the **background** (the program runs silently while you continue using the shell).

*   **`&` (Ampersand):** Put this at the end of a command to run it in the background immediately.
    *   Only useful for scripts or commands that take a long time.
    *   *Example:* `python long_script.py &`
*   **`Ctrl + Z`:** Pauses the program currently running in the foreground.
*   **`bg`:** Resumes the paused program in the **background**.
*   **`fg`:** Brings a background program back to the **foreground** (so you can interact with it).
*   **`jobs`:** Lists the programs currently running in the background of your current shell session.

**Scenario:**
1. You run `nano file.txt`.
2. You realize you need to check a file listing. You press `Ctrl+Z` (Nano minimizes/pauses).
3. You type `ls`.
4. You type `fg` to bring Nano back.

---

### 5. Process Priority (`nice`, `renice`)
The CPU has a scheduler that decides which process gets to run next. You can influence this using "Niceness."
*   **The Scale:** Ranges from **-20** (Highest priority, "not nice" to others) to **+19** (Lowest priority, very "nice" to others).
*   **Default:** 0.

#### **`nice`**
Used when **starting** a program to set its priority.
*   **Usage:** `nice -n 10 ./backup_script.sh`
    *   *Explanation:* This runs the backup script with low priority so it doesn't slow down the computer for the user.

#### **`renice`**
Used to change the priority of a process that is **already running**.
*   **Usage:** `renice -n -5 -p 1234`
    *   *Explanation:* This tells the scheduler to give PID 1234 higher priority (lower number = higher priority).
    *   *Note:* You usually need `sudo` to give a process higher priority (negative numbers). Normal users can only lower priority (make it nicer).

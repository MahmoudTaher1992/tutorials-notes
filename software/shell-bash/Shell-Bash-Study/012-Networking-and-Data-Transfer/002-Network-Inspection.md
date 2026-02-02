Here is a detailed explanation of **Part XII, Section B: Network Inspection**.

This section focuses on the ability to see what is happening "under the hood" of your computer's network stack. Just like poping the hood of a car to check oil levels or engine temperature, these tools let you see active connections, listening ports, and IP configurations.

There is a major historical shift in Linux networking commands that you must understand:
1.  **The Legacy Suite (`net-tools`):** Includes `ifconfig`, `netstat`, `route`, `arp`. These are deprecated (no longer actively developed) but are still found in many tutorials and older systems.
2.  **The Modern Suite (`iproute2`):** Includes `ip` and `ss`. These are faster, handle modern kernel features better, and are the standard on current Linux distributions.

---

### 1. Viewing Network Connections (`netstat` & `ss`)

These tools answer the questions: *Who is talking to my computer right now?* and *What services (ports) are waiting for connections?*

#### **A. `netstat` (Network Statistics) - Legacy**
Although old, you will likely encounter this tool. It prints network connections, routing tables, and interface statistics.

**The Golden Command:**
Most sysadmins memorize one specific set of flags for netstat:
```bash
netstat -tulpn
```

**Breakdown of the flags:**
*   `-t`: Show **TCP** connections.
*   `-u`: Show **UDP** connections.
*   `-l`: Show only **Listening** sockets (servers waiting for a connection).
*   `-p`: Show the **PID/Program name** that opened the socket (Requires `sudo`).
*   `-n`: Show **Numerical** addresses (don't try to resolve IPs to hostnames or ports to service names; e.g., show `80` instead of `http`).

**Example Output:**
```text
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      850/sshd
tcp6       0      0 :::80                   :::*                    LISTEN      1024/apache2
```
*In this example, SSH is listening on port 22, and Apache is listening on port 80.*

---

#### **B. `ss` (Socket Statistics) - Modern**
`ss` is the modern replacement for `netstat`. It is faster and retrieves information directly from the kernel space.

**The Command:**
Luckily, `ss` accepts almost the exact same flags as `netstat`.
```bash
ss -tulpn
```

**Why use `ss`?**
*   It displays more TCP state information.
*   It is significantly faster on systems with thousands of active connections (high-load servers).

---

### 2. Viewing & Configuring Network Interfaces (`ifconfig` & `ip`)

These tools answer the questions: *What is my IP address?* and *Is my network card turned on?*

#### **A. `ifconfig` (Interface Configuration) - Legacy**
This was the standard way to check IP addresses for decades. On many modern minimal Linux installs (like Arch or minimal Debian/CentOS), this command returns "command not found."

*   **Usage:** simply type `ifconfig`.
*   **Output:** Lists network cards (e.g., `eth0`, `wlan0`), IP addresses (`inet`), MAC addresses (`ether`), and RX/TX (download/upload) byte counts.

#### **B. `ip` - Modern**
The `ip` command is a powerhouse. It handles addressing, routing, manipulating network devices, and tunnels. It follows a `verb + object` syntax.

**1. Viewing IP Addresses:**
Instead of `ifconfig`, we use:
```bash
ip addr show
# OR the shorthand:
ip a
```
**What to look for in the output:**
*   **lo:** The "loopback" interface (127.0.0.1). Used for internal communication.
*   **eth0 / ens33 / enp3s0:** Your physical (or virtual) Ethernet connection.
*   **inet:** This is your IPv4 address (e.g., `192.168.1.50`).
*   **inet6:** This is your IPv6 address.
*   **UP/LOWER_UP:** Indicates the interface is active.

**2. Viewing Link Status (Is the cable plugged in?):**
```bash
ip link show
```
This shows the state of the hardware interfaces without clogging the screen with IP addresses.

**3. Viewing the Routing Table:**
This replaces the old `route` command. It tells the computer where to send traffic (e.g., "Send everything to the Router/Gateway at 192.168.1.1").
```bash
ip route show
# OR
ip r
```

---

### Summary Table: Legacy vs. Modern
If you are learning today, focus on the right-hand column, but recognize the left-hand column so you can understand older documentation.

| Action | Legacy Tool (`net-tools`) | Modern Tool (`iproute2`) |
| :--- | :--- | :--- |
| **Show IP/Interfaces** | `ifconfig -a` | `ip a` |
| **Enable Interface** | `ifconfig eth0 up` | `ip link set eth0 up` |
| **Show Routing Table** | `route -n` | `ip r` |
| **Show Connections** | `netstat` | `ss` |
| **Show Listening Ports**| `netstat -tulpn` | `ss -tulpn` |
| **Show ARP Table** | `arp -n` | `ip neigh` |

### Practical Scenarios

**Scenario 1: You just started a web server, but you can't access it.**
1.  Check if the process is actually running/listening:
    ```bash
    sudo ss -tulpn | grep :80
    ```
    *If nothing returns, your web server isn't running.*

**Scenario 2: You cannot ping google.com.**
1.  Check if you have an IP address:
    ```bash
    ip a
    ```
    *If you don't see an `inet` address on your main interface, you aren't connected to the local network.*
2.  Check if you have a default gateway (router):
    ```bash
    ip r
    ```
    *Look for the line starting with `default via ...`.*

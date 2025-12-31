Based on the study guide structure you provided, here is a detailed explanation of **Part III: File Transfer Protocols, Section A: File Transfer Protocol (FTP)**.

---

# Part III: File Transfer Protocols
## A. File Transfer Protocol (FTP)

### 1. Core Concepts and Purpose
**FTP** stands for **File Transfer Protocol**. It is one of the oldest standard network protocols used for the transfer of computer files between a client and server on a computer network.

*   **OSI Layer:** It operates at **Layer 7 (Application Layer)** of the OSI model.
*   **Architecture:** It uses a **Client-Server model**. The user runs an FTP Client (like FileZilla or command line) to connect to a remote computer running FTP Server software.
*   **The "Two-Channel" System:** Unlike HTTP, which typically handles data and control information in a single connection, FTP creates **two** separate connections:
    1.  **Command/Control Channel (Port 21):** Used for sending commands (log in, change directory, delete file). This connection stays open for the duration of the session.
    2.  **Data Channel (Port 20 or Random):** Used exclusively for transferring the actual file data or directory listings. This opens and closes as needed for each file transfer.

### 2. Active vs. Passive FTP
The distinction between Active and Passive FTP is the most complex part of the protocol. It dictates **who initiates the data connection**, which affects how the protocol behaves with Firewalls and Network Address Translation (NAT).

#### **Active FTP (The Original Way)**
In Active mode, the **client** initiates the command channel, but the **server** initiates the data connection back to the client.
1.  **Step 1:** The Client connects from a random port (e.g., 1024) to the Server's **Port 21** (Command).
2.  **Step 2:** The Client listens on port 1025 and sends the command `PORT 1025` to the Server. It is essentially saying, "I am ready for data; call me back on line 1025."
3.  **Step 3:** The Server connects from its **Port 20** (Data) to the Client's port 1025 to transfer the data.
*   **The Problem:** Client-side firewalls usually block incoming connections from the outside internet. Because the Server is trying to initiate a connection *to* the Client, the firewall often drops the packet, causing the transfer to fail.

#### **Passive FTP (The Firewall-Friendly Way)**
In Passive mode, the **client** initiates **both** the command and data connections. This solves the firewall issue.
1.  **Step 1:** The Client connects to the Server's **Port 21** (Command).
2.  **Step 2:** The Client sends the `PASV` command. It is saying, "I am behind a firewall; you open a port and I will call you."
3.  **Step 3:** The Server opens a random high port (e.g., 2024) and tells the Client via the Command channel.
4.  **Step 4:** The Client initiates the data connection from its random port to the Server's port 2024.
*   **The Benefit:** Since the Client initiates the connection, the client-side firewall allows the outgoing traffic, and the transfer succeeds.

### 3. FTP Commands
While modern users often use graphical interfaces (drag-and-drop), FTP relies on text-based commands sent over the Command Channel. There is a distinction between the command you type in a terminal (CLI) and the raw protocol command sent over the wire.

| Purpose | Common CLI Command | Raw Protocol Command | Description |
| :--- | :--- | :--- | :--- |
| **Login** | `user` / `pass` | `USER` / `PASS` | Sends username and password for authentication. |
| **Listing** | `ls` or `dir` | `LIST` or `NLST` | Requests a list of files in the current directory. |
| **Navigation** | `cd` | `CWD` | "Change Working Directory" - moves you into a different folder. |
| **Download** | `get` | `RETR` | "Retrieve" - Downloads a file from the server to the client. |
| **Upload** | `put` | `STOR` | "Store" - Uploads a file from the client to the server. |
| **Mode** | `passive` | `PASV` | Switches the connection to Passive mode. |
| **Type** | `binary` / `ascii` | `TYPE I` / `TYPE A` | Sets transfer mode. Binary is for images/programs; ASCII is for text files. |
| **Quit** | `bye` or `quit` | `QUIT` | Disconnects the session. |

### 4. Inherent Insecurity: Plain Text Data Transfer
The most critical thing to understand about standard FTP today is that it is **insecure by design**.

*   **No Encryption:** FTP was designed in 1971, before internet security was a major concern. It does not use SSL/TLS by default.
*   **Clear Text Credentials:** When you log in, your username and password are sent in **plain text**.
*   **The Risk:** If an attacker is on the same network as you (e.g., a public Wi-Fi cafe) and uses a packet sniffer tool (like Wireshark), they can see:
    1.  Your exact username.
    2.  Your exact password.
    3.   The contents of every file you upload or download.
*   **Modern Solution:** Because of this vulnerability, standard FTP is rarely used in professional environments anymore. It has been largely replaced by **SFTP** (FTP over SSH) or **FTPS** (FTP over SSL), which encrypt the entire session.

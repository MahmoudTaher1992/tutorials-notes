Based on the Table of Contents you provided, the section **"006-Appendices/002-Common-Port-Numbers.md"** is a reference guide intended to summarize specific numerical identifiers used in networking.

Here is a detailed explanation of what this section entails, the concept behind it, and the specific content usually found in such a document.

---

### 1. The Concept: What is a Port Number?

To understand this appendix, you must understand the relationship between an IP Address and a Port Number.

*   **IP Address:** Identifies a specific computer or device on a network (Analogy: The **Street Address** of an apartment building).
*   **Port Number:** Identifies a specific application or service running *on* that computer (Analogy: The specific **Apartment Number** inside that building).

When data arrives at your computer, the Network Layer (IP) gets it to your device, but the **Transport Layer (TCP/UDP)** uses the **Port Number** to decide if that data should go to your Web Browser, your Email Client, or your Spotify app.

### 2. Why "Common" or "Well-Known"?

There are 65,535 available ports. However, to make the internet work smoothly, the **IANA (Internet Assigned Numbers Authority)** has reserved ports **0 through 1023** for standard services.

For example, if you type `google.com` into your browser, your browser *automatically* knows to knock on **Port 443** (HTTPS) of Google's server. It doesn't have to guess. This appendix serves as a cheat sheet for these standardized numbers.

---

### 3. The Content: A Detailed Breakdown

Below is the standard list of ports that would be included in this appendix, mapped to the protocols mentioned in your Table of Contents.

#### A. Web Browsing (Part II, Sections B & C)
These are the most used ports on the internet.
*   **Port 80 (TCP) - HTTP:** Unsecured web traffic.
*   **Port 443 (TCP) - HTTPS:** Secured (Encrypted) web traffic using SSL/TLS. *Almost all modern web traffic uses this.*

#### B. File Transfer (Part III)
Used for moving files between computers.
*   **Port 20 & 21 (TCP) - FTP:**
    *   Port 21 is the "Command" port (used to log in and send commands).
    *   Port 20 is the "Data" port (used to actually transfer the file).
*   **Port 22 (TCP) - SFTP / SSH:** Secure File Transfer Protocol runs over SSH. It encrypts both commands and data.

#### C. Remote Access (Part II, Section C)
Used by administrators to manage servers remotely.
*   **Port 22 (TCP) - SSH (Secure Shell):** The standard for secure remote command-line access.
*   **Port 23 (TCP) - Telnet:** An old, obsolete protocol for remote access. *It sends data in plain text (insecure) and is rarely used today except for legacy equipment.*
*   **Port 3389 (TCP/UDP) - RDP (Remote Desktop Protocol):** Microsoft's protocol for visually controlling a computer remotely.

#### D. Email (Part IV)
Email is unique because it uses different ports for sending versus receiving.

**Sending Email:**
*   **Port 25 (TCP) - SMTP:** Used for server-to-server relay.
*   **Port 587 (TCP) - SMTP (Submission):** Used by email clients (like Outlook) to send mail to the server securely.

**Receiving Email:**
*   **Port 110 (TCP) - POP3:** Unsecured download of emails.
*   **Port 995 (TCP) - POP3S:** SSL/TLS secured POP3.
*   **Port 143 (TCP) - IMAP:** Unsecured syncing of emails.
*   **Port 993 (TCP) - IMAPS:** SSL/TLS secured IMAP.

#### E. Infrastructure & Network Management (Part II, Section A)
*   **Port 53 (UDP/TCP) - DNS:** The Domain Name System. UDP is used for standard lookups (finding an IP); TCP is used for zone transfers (syncing between servers).
*   **Port 67 & 68 (UDP) - DHCP:** Dynamic Host Configuration Protocol. Used to automatically assign IP addresses to devices when they join a network.

---

### 4. Summary Table (The "Cheat Sheet")

This is likely how the file is formatted visually:

| Port | Protocol | Layer 4 | Service / Description |
| :--- | :--- | :--- | :--- |
| **20** | FTP | TCP | File Transfer (Data) |
| **21** | FTP | TCP | File Transfer (Command/Control) |
| **22** | SSH / SFTP | TCP | Secure Shell / Secure File Transfer |
| **23** | Telnet | TCP | Unencrypted Remote Terminal (Obsolete) |
| **25** | SMTP | TCP | Simple Mail Transfer (Sending - Relay) |
| **53** | DNS | UDP/TCP | Domain Name System (Name Resolution) |
| **67/68**| DHCP | UDP | Assigning IP addresses |
| **80** | HTTP | TCP | World Wide Web (Unencrypted) |
| **110** | POP3 | TCP | Post Office Protocol (Receiving Email) |
| **143** | IMAP | TCP | Internet Message Access (Receiving Email) |
| **443** | HTTPS | TCP | Secure Web (SSL/TLS Encrypted) |
| **587** | SMTP | TCP | Email Submission (Sending - Client to Server) |
| **993** | IMAPS | TCP | Secure IMAP |
| **995** | POP3S | TCP | Secure POP3 |
| **3389** | RDP | TCP | Remote Desktop Protocol (Windows) |

### 5. Why is this Appendix Important? (Practical Application)

In **Part V (Network Security Concepts)** of your guide, you learn about Firewalls and Access Control Lists (ACLs). You cannot configure a firewall without this list.

**Example Scenario:**
You want to set up a Web Server, but you want to make sure hackers cannot access it via the command line.
1.  **Allow** traffic on **Port 80** and **Port 443** (so people can view the website).
2.  **Block** traffic on **Port 22** (so nobody can try to SSH/login to the server remotely).

This appendix provides the specific numbers required to write those security rules.

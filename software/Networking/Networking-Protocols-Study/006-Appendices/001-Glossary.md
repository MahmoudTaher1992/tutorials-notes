Based on the Table of Contents you provided, the file `006-Appendices/001-Glossary.md` is intended to be a **dictionary of terms** found throughout the study guide.

Since you are asking for the details of this specific part, I have generated the content that would go inside this file. It includes definitions for the acronyms and technical concepts mentioned in Parts I through V of your outline.

Here is the detailed content for **006-Appendices/001-Glossary.md**:

***

# Appendix: Glossary of Networking Terms

### A
*   **ACL (Access Control List):** A list of rules (permissions) attached to a network interface or firewall that filters traffic, allowing or denying packets based on IP addresses or protocols.
*   **Authoritative Name Server:** The final holder of the IP address for a specific domain. It provides the actual answer to a DNS query rather than a cached result.
*   **Asymmetric Encryption:** A cryptographic method that uses a pair of keys: a public key for encryption and a private key for decryption (used in SSH and SSL/TLS).

### C
*   **Certificate Authority (CA):** A trusted third-party entity that issues digital certificates (used in HTTPS/TLS) to verify the identity of a website or server.
*   **Circuit-Switching:** A networking method where a dedicated communication path is established between two nodes for the duration of a conversation (e.g., traditional telephone networks).
*   **Client-Server Model:** A distributed application structure that partitions tasks between the providers of a resource or service (servers) and service requesters (clients).

### D
*   **Decapsulation:** The process of removing headers and trailers from data as it moves *up* the OSI layers (from Physical to Application) at the receiving end.
*   **DKIM (DomainKeys Identified Mail):** An email authentication method that adds a cryptographic digital signature to emails, allowing the receiver to verify the email was actually sent by the owner of that domain.
*   **DMARC (Domain-based Message Authentication, Reporting, and Conformance):** An email security protocol that uses SPF and DKIM to determine the authenticity of an email message and specifies how to handle fake emails (e.g., reject them).
*   **DNS (Domain Name System):** The hierarchical system that translates human-readable domain names (like `example.com`) into IP addresses (like `192.0.2.1`).
*   **DNSSEC:** A suite of extensions to DNS that adds security by enabling DNS responses to be cryptographically signed.

### E
*   **Encapsulation:** The process of adding headers and trailers to data as it moves *down* the OSI layers (from Application to Physical) before transmission.

### F
*   **Firewall:** A network security device that monitors and filters incoming and outgoing network traffic based on an organization's security policies.
*   **FTP (File Transfer Protocol):** A standard network protocol used for the transfer of computer files between a client and server. It transmits data in plain text.

### G
*   **Greylisting:** An email spam prevention technique that temporarily rejects email from an unknown sender, expecting a legitimate server to retry sending (which spam servers often fail to do).

### H
*   **HTTP (Hypertext Transfer Protocol):** The application-layer protocol for transmitting hypermedia documents, such as HTML. It is the foundation of data communication for the World Wide Web.
*   **HTTPS:** HTTP Secure. An extension of HTTP that uses encryption (TLS/SSL) for secure communication.

### I
*   **IEEE (Institute of Electrical and Electronics Engineers):** A professional association that develops standards for networking hardware (e.g., Ethernet and Wi-Fi).
*   **IETF (Internet Engineering Task Force):** The body that develops and promotes voluntary Internet standards, particularly the standards that comprise the TCP/IP protocol suite (RFCs).
*   **IMAP (Internet Message Access Protocol):** An email retrieval protocol that keeps email on the server, allowing synchronization across multiple devices.
*   **IDS (Intrusion Detection System):** A device or software application that monitors a network or system for malicious activity or policy violations and reports it.
*   **IPS (Intrusion Prevention System):** Similar to an IDS, but capable of actively blocking or preventing the detected threats.

### O
*   **OSI Model (Open Systems Interconnection):** A conceptual framework used to describe the functions of a networking system, dividing it into seven layers (Physical, Data Link, Network, Transport, Session, Presentation, Application).

### P
*   **Packet-Switching:** A digital networking communications method that groups all transmitted data into suitably sized blocks, called packets, which are transmitted independently via different routes.
*   **Packet Sniffing:** The practice of capturing and inspecting data packets moving across a computer network (e.g., using Wireshark).
*   **POP3 (Post Office Protocol version 3):** An older email retrieval protocol that downloads emails to a local device and usually deletes them from the server.
*   **Port Forwarding:** A technique in SSH (and routing) that allows traffic destined for a specific port on one machine to be redirected to a different port or machine, often through an encrypted tunnel.

### R
*   **Recursive DNS Server:** A DNS server (usually provided by an ISP) that queries other servers on behalf of the client to find the IP address of a domain.

### S
*   **SFTP (Secure File Transfer Protocol):** A distinct protocol that facilitates file access, transfer, and management over a reliable data stream (SSH). It is not FTP run over SSL.
*   **SMTP (Simple Mail Transfer Protocol):** The standard protocol for *sending* emails across the Internet.
*   **SPF (Sender Policy Framework):** An email authentication method that allows domain owners to specify which mail servers are authorized to send email on behalf of their domain via DNS records.
*   **SSH (Secure Shell):** A cryptographic network protocol for operating network services securely over an unsecured network. Commonly used for remote command-line login.
*   **SSL (Secure Sockets Layer):** The predecessor to TLS. A cryptographic protocol designed to provide communications security. Now deprecated due to security vulnerabilities.
*   **Symmetric Encryption:** A type of encryption where the same key is used to both encrypt and decrypt data (faster than asymmetric).

### T
*   **TCP (Transmission Control Protocol):** A connection-oriented protocol that guarantees the delivery of data and ensures packets arrive in the correct order (Layer 4).
*   **TLS (Transport Layer Security):** The modern cryptographic protocol that provides end-to-end communication security over networks. It is the successor to SSL.
*   **TLD (Top-Level Domain):** The last segment of a domain name (e.g., `.com`, `.org`, `.gov`).

### U
*   **UDP (User Datagram Protocol):** A connectionless protocol that sends data without establishing a connection or guaranteeing delivery. Faster than TCP but less reliable (used for streaming/gaming).

### W
*   **Whitelisting:** The practice of explicitly allowing access to a specific list of entities (email addresses, IP addresses, or applications) while denying all others.

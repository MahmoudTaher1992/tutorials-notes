Based on the roadmap provided, this section (**Part X, Section C**) covers the pillars of keeping data and systems safe. It moves from mathematical foundations (Cryptography) to infrastructure (PKI/Network) and finally to specific vulnerabilities in code (Application Security).

Here is a detailed breakdown of each concept in that section:

---

### 1. Symmetric & Asymmetric Cryptography
Cryptography is the science of writing codes and ciphers to keep communication private.

*   **Symmetric Cryptography (Shared Secret):**
    *   **Concept:** The sender and receiver use the **same key** to encrypt and decrypt the message.
    *   **Analogy:** A house key. You lock the door with the key, and anyone who wants to open it needs a copy of that exact same key.
    *   **Pros/Cons:** It is extremely fast and efficient for large amounts of data. However, sharing the key is risky (if a hacker intercepts the key during sharing, the system is broken).
    *   **Examples:** AES (Advanced Encryption Standard), DES.

*   **Asymmetric Cryptography (Public-Key Cryptography):**
    *   **Concept:** Uses a pair of mathematically related keys: a **Public Key** (shared with everyone) and a **Private Key** (kept secret).
    *   **Mechanism:** If you encrypt data with the Public Key, only the Private Key can decrypt it (and vice versa).
    *   **Analogy:** A mailbox. Anyone can put a letter in the slot (Public), but only the person with the key can open the box and read the mail (Private).
    *   **Examples:** RSA, ECC (Elliptic Curve Cryptography), Diffie-Hellman Key Exchange.

### 2. Hashing Algorithms & Digital Signatures
These ensure **Integrity** (the data hasn't changed) and **Non-repudiation** (you can't deny sending it).

*   **Hashing:**
    *   **Concept:** A one-way mathematical function that takes an input of any size and turns it into a fixed-size string of characters (the "hash").
    *   **Properties:** It is irreversible (you can't turn the hash back into the file). If you change even one bit of the original file, the hash changes completely.
    *   **Usage:** Used to store passwords safely (never store plain text!) and check file integrity (checksums).
    *   **Examples:** SHA-256, MD5 (now considered insecure).

*   **Digital Signatures:**
    *   **Concept:** A mathematical scheme for verifying the authenticity of digital messages or documents.
    *   **How it works:** You create a "hash" of your document and encrypt that hash with your **Private Key**. The receiver uses your **Public Key** to decrypt it. If it works, it proves 100% that *you* generated it and the document wasn't altered.

### 3. Public Key Infrastructure (PKI) & Certificate Authorities
The internet relies on trust. How do you know "google.com" is actually Google and not a hacker?

*   **PKI (Public Key Infrastructure):** The set of roles, policies, software, and hardware needed to manage digital certificates and public-key encryption.
*   **Certificate Authorities (CA):** Trusted third-party organizations (like Let's Encrypt, DigiCert) that verify entities.
*   **How it works:**
    1.  Google creates a Public Key.
    2.  Google asks a CA to "sign" it.
    3.  The CA verifies Google owns the domain and issues a **Digital Certificate**.
    4.  Your browser (Chrome/Firefox) creates a "Chain of Trust." It trusts the CA, so it trusts the Certificate the CA signed.

### 4. Authentication & Authorization Mechanisms
These are often confused but distinct concepts (**AuthN** vs **AuthZ**).

*   **Authentication (AuthN):** *Who are you?*
    *   Verifying identity via:
        *   **Something you know:** Passwords, PINs.
        *   **Something you have:** Phone (SMS code), Hardware Key (YubiKey).
        *   **Something you are:** Biometrics (Fingerprint, FaceID).
    *   **MFA (Multi-Factor Authentication):** Combining two or more of these for safety.

*   **Authorization (AuthZ):** *What are you allowed to do?*
    *   Once logged in, can you delete the database? Or just read it?
    *   **mechanisms:**
        *   **RBAC (Role-Based Access Control):** "Admins" can delete; "Users" can only view.
        *   **JWT (JSON Web Tokens):** A standard way to securely transmit information between parties as a JSON object, used heavily in modern web login flows.

### 5. Network Security (TLS, SSH, VPNs, Firewall)
Protecting data as it travels across cables and Wi-Fi.

*   **TLS (Transport Layer Security):** The successor to SSL. It provides encryption between a client (browser) and a server. It turns HTTP into **HTTPS**. It prevents "Man-in-the-Middle" attacks where someone listens to your data in a coffee shop.
*   **SSH (Secure Shell):** A protocol used by administrators to securely log into remote computers/servers over an unsecured network. It sends commands encrypted.
*   **VPN (Virtual Private Network):** Creates an encrypted "tunnel" for your traffic. If you are on public Wi-Fi, a VPN encrypts everything so the network owner cannot see what websites you are visiting.
*   **Firewall:** A network security device (software or hardware) that monitors incoming and outgoing traffic and decides whether to allow or block strictly based on a set of security rules (e.g., "Block all connections from this country" or "Block port 80").

### 6. Application Security (XSS, CSRF, SQLi)
This deals with bugs in code that hackers exploit to steal data.

*   **SQL Injection (SQLi):**
    *   **The Hack:** Malicious SQL statements are inserted into entry fields (like a username box).
    *   **Example:** Typing `' OR 1=1 --` into a login box might trick the database into logging you in as Admin without a password.
*   **XSS (Cross-Site Scripting):**
    *   **The Hack:** An attacker injects malicious JavaScript into a website that other users view.
    *   **Result:** The script can steal the victim's session cookies, allowing the hacker to take over the victim's account.
*   **CSRF (Cross-Site Request Forgery):**
    *   **The Hack:** A malicious site tricks a user's browser into executing an unwanted action on a *different* site where the user is currently logged in (e.g., silently triggering a "Transfer Money" button on your bank tab while you are reading a blog).

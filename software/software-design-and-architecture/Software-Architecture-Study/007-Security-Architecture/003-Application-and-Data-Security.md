This section focuses on the tactical implementation of security within the software and the data it handles. While high-level security (Part A and B) deals with *who* can access the system, this section deals with **what happens if they get in** and **how to build the system so it is inherently resistant to attacks**.

As an architect, you aren't expected to be a penetration tester, but you **must** design systems that make successful attacks difficult and mitigate damage if a breach occurs.

Here is a detailed breakdown of **Part VII - C: Application and Data Security**.

---

### 1. OWASP Top 10 Vulnerabilities
The [Open Web Application Security Project (OWASP)](https://owasp.org/) Top 10 is a standard awareness document for developers and web application security. It acts as a checklist of the most critical security risks to web applications.

**Why an Architect Cares:**
You must choose frameworks, languages, and patterns that mitigate these risks *by default* rather than relying on individual developers to remember to write secure code.

**Key Vulnerabilities to Limit Architecturally:**
*   **Injection (SQL, NoSQL, OS Command):** Occurs when untrusted data is sent to an interpreter as part of a command.
    *   *Architectural solution:* Mandate the use of ORMs (Object-Relational Mappers like Hibernate or Entity Framework) or Prepared Statements. Ban raw SQL string concatenation.
*   **Broken Access Control:** Users acting outside of their intended permissions.
    *   *Architectural solution:* Centralize authorization logic (e.g., through a gateway or middleware) rather than checking permissions in every single API endpoint controller.
*   **Cryptographic Failures:** Previously known as "Sensitive Data Exposure."
    *   *Architectural solution:* Enforce HTTPS everywhere (HSTS) and ensure no sensitive data (PII) is written to logs.
*   **Security Misconfiguration:** Using default passwords, verbose error messages containing stack traces, or misconfigured cloud buckets.
    *   *Architectural solution:* Use Infrastructure as Code (IaC) to standardize configurations and disable default error pages in production.

---

### 2. Encryption (At-Rest and In-Transit)
Encryption is the process of encoding information so only authorized parties can access it.

#### A. Encryption In-Transit
Protecting data while it is moving (e.g., from the browser to the server, or from Service A to Service B).
*   **The Standard:** **TLS** (Transport Layer Security). SSL is the old name, but we still often say "SSL Certificates."
*   **Architectural Decisions:**
    *   **HTTPS Everywhere:** No HTTP allowed.
    *   **TLS Termination:** Where does the encryption stop? At the Load Balancer (for speed) or deep inside the application (Zero Trust)?
    *   **mTLS (Mutual TLS):** Used in Microservices. Not only does the Client verify the Server, but the Server also verifies the Client certificate. This prevents unauthorized services from talking to your backend.

#### B. Encryption At-Rest
Protecting data when it is stored on a disk (Database, Hard Drive, S3 Bucket). If a hacker physically steals the hard drive, they cannot read the data.
*   **Approaches:**
    *   **Full Disk Encryption (FDE):** Encrypting the entire volume (e.g., AWS EBS encryption).
    *   **Database Encryption (TDE):** The database engine encrypts the files on the disk (e.g., SQL Server TDE).
    *   **Application-Level Encryption:** The application encrypts the data *before* sending it to the database. This is the most secure but also the hardest to manage (you can't search/query encrypted data easily).

---

### 3. Hashing Algorithms & Key Management (PKI)

#### A. Hashing vs. Encryption represents
This is a critical distinction for architects.
*   **Encryption** is two-way. You lock it, you can unlock it with a key. (Used for credit cards, documents).
*   **Hashing** is one-way. You turn data into a string of characters (a fingerprint), and you *cannot* turn it back into the original data.
*   **Use Case:** **Passwords.** You never store user passwords in a database (even encrypted). You store the **Hash**. When a user logs in, you hash their input and compare it to the stored hash.
*   **Salting:** Adding a random string to the password before hashing it to prevent "Rainbow Table" attacks (pre-computed lists of hashes).
*   **Algorithms:**
    *   *Safe:* Argon2, Bcrypt, PBKDF2, SHA-256.
    *   *Unsafe (do not use):* MD5, SHA-1 (too easy to crack).

#### B. PKI (Public Key Infrastructure)
This refers to the management of digital certificates (like the lock icon in your browser).
*   **Asymmetric Encryption:** Uses a **Public Key** (everyone can see it) and a **Private Key** (only you have it).
    *   *Encryption:* I use your Public Key to lock a message; only your Private Key can open it.
    *   *Digital Signatures:* You sign a document with your Private key; I use your Public Key to verify it really came from you.
*   **Key Rotation:** Keys shouldn't live forever. Architects must design automated processes to rotate keys regularly so if a key is stolen, it becomes useless quickly.

---

### 4. Secrets Management
A "Secret" is any credential: API Keys, Database Passwords, Certificates, or Access Tokens.

**The Problem:**
Developers often hardcode secrets in source code (`const DB_PASS = "password123"`). If this code is pushed to GitHub, the system is compromised.

**The Architectural Solution:**
Use a **Secrets Vault** (e.g., HashiCorp Vault, AWS Secrets Manager, Azure Key Vault).

**How it works (The Pattern):**
1.  **No Secrets in Code:** The code contains no passwords.
2.  **Identity Bootstrap:** The application starts up and proves its identity to the Vault (using an IAM role or a platform token).
3.  **Fetch on Startup:** The application asks the Vault: "Give me the database password."
4.  **InMemory Only:** The app keeps the password in RAM, never writing it to disk or logs.
5.  **Dynamic Secrets (Advanced):** The Vault generates a *temporary* password for that specific app that expires in 30 minutes. This creates a moving target for attackers.

### Summary Checklist for this Section
*   [ ] Does the design mitigate the OWASP Top 10 by default?
*   [ ] Is data encrypted when moving (TLS) and when stored (At-Rest)?
*   [ ] Are passwords hashed using strong algorithms (Bcrypt/Argon2)?
*   [ ] Are API keys and DB passwords stored in a Vault, not in Git?

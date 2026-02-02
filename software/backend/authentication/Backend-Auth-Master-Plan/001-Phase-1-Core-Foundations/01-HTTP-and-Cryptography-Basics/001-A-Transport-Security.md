Based on the "Engineering Master Plan," **Transport Security** is the absolute starting point because no matter how strong your password hashing or token strategy is, if the "pipe" transmitting that data is transparent, your security is null and void.

Here is a detailed breakdown of **Phase 1, Section 1-A: Transport Security**.

---

### Concept Overview: The "Glass Envelope" vs. The "Armored Truck"
To understand Transport Security, imagine sending a letter.
*   **HTTP** is like sending a letter in a clear, glass envelope. Anyone handling the letter (ISP, WiFi router, Government, Hacker) can read the contents without opening it.
*   **HTTPS (TLS)** is like putting that letter inside a locked, armored truck. Only the sender and the recipient have the keys to open it.

---

### i. TLS/SSL Handshake (Why HTTPS is non-negotiable)

**TLS** stands for **Transport Layer Security**. It is the modern successor to **SSL** (Secure Sockets Layer), which is now deprecated and insecure. When we say "HTTPS," we actually mean "HTTP over TLS."

TLS provides three critical guarantees (The **CIA** Triad):
1.  **Encryption (Confidentiality):** Hides the data so no one can read it.
2.  **Integrity:** Ensures the data hasn't been changed/tampered with in transit.
3.  **Authentication:** Proves the server is who they claim to be (e.g., prove that `google.com` is actually Google).

#### How the "Handshake" Works (Simplified)
Before any data (passwords, HTML, JSON) is sent, the Browser (Client) and the Server perform a "Handshake" to agree on a secret code.

1.  **Client Hello:** The Browser sends a message: "Hello! I support TLS version 1.2 and 1.3, and I know these encryption algorithms (Cipher Suites). Which one do you want to use?"
2.  **Server Hello & Certificate:** The Server replies: "Hello! Let's use TLS 1.3. Here is my **Digital Certificate** (ID Card) to prove I am really `api.myapp.com`. This certificate includes my **Public Key**."
3.  **Verification:** The Browser looks at the Certificate. It checks with a trusted third party (Certificate Authority, like Let's Encrypt or DigiCert) to ensure the ID is valid and hasn't expired.
4.  **Key Exchange (The Magic):**
    *   The Browser uses the Server's **Public Key** to encrypt a generated "Pre-Master Secret."
    *   Only the Server can decrypt this because only the Server has the corresponding **Private Key**. *Measurement: Asymmetric Encryption (Slow/Expensive).*
5.  **Session Key Generation:** Both sides now have the "Pre-Master Secret." They use it to generate a **Symmetric Session Key**.
6.  **Secure Communication:** Now, they switch to **Symmetric Encryption** (faster) using that shared Session Key. The tunnel is established.

**Why is this non-negotiable?**
Without HTTPS, a user logging in sends their password in **Plaintext**. A hacker on the same coffee shop WiFi can run a "packet sniffer" (like Wireshark) and see:
`POST /login body: { "password": "superSecret123" }`.
With HTTPS, the hacker sees: `POST /login body: "a9df87s89f7s89f7..."`

---

### ii. Man-in-the-Middle (MitM) Attacks

A Man-in-the-Middle attack occurs when a perpetrator positions themselves in a conversation between a user and an application—either to eavesdrop or to impersonate one of the parties.

#### The Scenario (The Coffee Shop Attack)
1.  **The Setup:** You sit in a coffee shop. You connect to a WiFi spot named "Starbucks_Free_WiFi".
2.  **The Trap:** The hacker is actually sitting in the corner broadcasting that WiFi hotspot from their laptop.
3.  **The Intercept:** You try to visit `bank.com`.
    *   You send the request to the "Router" (the Hacker).
    *   The Hacker forwards your request to the real `bank.com`.
    *   `bank.com` replies to the Hacker.
    *   The Hacker reads the reply, maybe modifies it, and sends it to you.

#### How MitM Works without TLS (HTTP)
Because HTTP is plaintext, the hacker can insert a script into the webpage before sending it to you that records your keystrokes. They are an invisible relay.

#### How TLS Stops MitM
If you visit `https://bank.com`, the TLS Handshake saves you.

1.  **The Verification Fail:** When the Hacker tries to intercept the connection, the Browser asks for the Server's Certificate.
2.  **The Imposter:** The Hacker cannot produce a valid certificate for `bank.com` because they do not have `bank.com`'s **Private Key**.
3.  **The Warning:**
    *   If the Hacker presents *their own* certificate, the Browser says: "Warning! The certificate belongs to `HackerInc`, not `bank.com`."
    *   If the Hacker tries to forge a certificate, the Browser checks the signature against the Certificate Authority (e.g., Verisign) and sees it is fake.
4.  **The Block:** The browser shows a giant red warning: **"Your connection is not private."**

#### SSL Stripping (Advanced MitM)
Hackers developed a technique called SSL Stripping.
1.  User types `bank.com` (Browsers default to `http://` first).
2.  Hacker intercepts the HTTP request.
3.  Hacker communicates with the Bank via HTTPS (encrypted).
4.  Hacker communicates with the User via HTTP (plaintext).
5.  **The Fix:** **HSTS (HTTP Strict Transport Security)**. This is a header the server sends (`Strict-Transport-Security`) that tells the browser: "Never talk to me over HTTP again. Even if the user types http, force it to https automatically."

### Summary for your Master Plan
*   **Transport Security is Layer 0.** You cannot build AuthN/AuthZ without it.
*   **HTTPS** uses **TLS Handshakes** to exchange keys securely.
*   **Certificates** prevent **MitM attacks** by ensuring the server you are talking to is actually who they say they are.

Based on the outline you provided, here is a detailed explanation of section **4.C: The Future is Passwordless**.

This section addresses the industry-wide shift away from traditional passwords (which are easily phished, reused, and forgotten) toward methods that are significantly more secure and offer a better user experience.

---

### **Why go Passwordless?**
Traditional authentication relies on "Shared Secrets" (the password). The user knows it, and the server knows it (or a hash of it). If a hacker intercepts that secret or dumps the database, they can impersonate the user.

**Passwordless authentication** replaces "something you know" (a password) with:
1.  **Something you have** (access to an email inbox or a specific device).
2.  **Something you are** (biometrics like FaceID/TouchID).

Here are the details on the two mechanisms mentioned in your syllabus:

---

### **i. Magic Links**
This is the most common entry-point into passwordless auth. You see this heavily used by platforms like Slack, Medium, and Notion.

#### **How it Works**
1.  **The Request:** The user enters their email address on the login screen and clicks "Sign In." No password is asked.
2.  **Token Generation:** The backend server generates a unique, cryptographically signed token (usually a JWT or a random string stored in Redis). This token has a very short expiration time (e.g., 10 minutes).
3.  **The Delivery:** The server embeds this token into a URL (e.g., `https://app.com/verify?token=abc123xym`) and emails it to the user.
4.  **The Exchange:** The user opens their email and clicks the link.
5.  **Authorization:** The browser sends the token back to the server. The server verifies the signature and expiration. If valid, the server exchanges the "Magic Link token" for a standard long-lived session cookie or Access Token.

#### **Pros**
*   **User Experience (UX):** Users never have to remember or reset a password.
*   **Implementation:** Relatively easy to implement if you already have an email service.

#### **Cons / Risks**
*   **Email Security Dependency:** If a hacker compromises the user’s *email account*, they have access to *every* account protected by magic links.
*   **Cross-Device Friction:** If I try to log in on my Desktop, but I only have my email app on my Phone, clicking the link on the phone logs me in *on the phone*, not the desktop. This creates a confusing "context switching" flow.
*   **Not Phishing Resistant:** A user can still be tricked into forwarding a magic link or clicking a fake link.

---

### **ii. Passkeys (WebAuthn / FIDO2)**
This is the "Gold Standard" of modern authentication. It is a set of standards backed by the FIDO Alliance (Apple, Google, Microsoft).

When the outline mentions **"Phishing-resistant"** and **"Public-key cryptography,"** this is the core technical concept.

#### **How it Works (Asymmetric Cryptography)**
Unlike a password (where the server keeps a copy of your secret), Passkeys use a **Key Pair**:

1.  **Private Key:** Generated on the user's device (inside the Secure Enclave on iPhone, TPM on Windows, or Titan chip on Android). **This key never leaves the device.** It cannot be stolen by a server hack.
2.  **Public Key:** Sent to the server (the API/Website). It is public and useless without the private key.

#### **The Login Flow (The Challenge-Response Protocol)**
1.  **Challenge:** The user types their username. The server sends a random mathematical challenge (a "nonce") to the browser.
2.  **Verification (Biometrics):** The browser realizes this is a WebAuthn request. It asks the user to unlock the key using their local device security (FaceID, TouchID, or Windows Hello). **Note:** Your fingerprint is *never* sent to the server; it simply unlocks the Private Key locally.
3.  **Signing:** Once unlocked, the device uses the **Private Key** to "sign" the server's challenge.
4.  **Validation:** The signed challenge is sent back to the server. The server uses the stored **Public Key** to verify the signature. If it matches, the user is logged in.

#### **Why "Passkeys" specifically?**
Historically, this technology required a physical USB key (like a YubiKey).
**Passkeys** are an evolution where the Private Key is synced across your cloud account (i.e., iCloud Keychain or Google Password Manager).
*   If you lose your iPhone, your Private Key isn't gone; it restores to your new iPhone via iCloud.

#### **Why is it "Phishing Resistant"?**
This is the most critical feature. The WebAuthn protocol binds the key to the specific domain (origin).
*   If you create a Passkey for `google.com`, and a hacker creates a fake site `g00gle.com` (spoofing), your browser **will validly refuse** to present the credential.
*   The browser knows `g00gle.com` is not `google.com` and will simply say "No credentials found."
*   This kills the vast majority of modern phishing attacks.

### **Summary Comparison**

| Feature | Magic Links | Passkeys (WebAuthn) |
| :--- | :--- | :--- |
| **User Action** | Click link in email | Touch ID / Face ID |
| **Security Base** | Access to email inbox | Public/Private Key Cryptography |
| **Phishing Risk** | Susceptible (if email is compromised) | **Phishing Resistant** (Gold Standard) |
| **Implementation** | Easy | Complex (requires browser/device support) |

Based on the "Engineering Master Plan," here is a detailed explanation of **Phase 5, Section 11, Part B: Passkeys**.

---

# 11-B: Passkeys (The Evolution of WebAuthn)

To understand **Passkeys**, we first need to understand the limitation of the technology that came immediately before it: standard WebAuthn.

**The Pre-Passkey Problem:**
Historically, FIDO2/WebAuthn credentials were **device-bound**. If you registered your fingerprint on your MacBook to log in to a website, the private key was stored securely on that specific MacBook's security chip. If you lost your MacBook, you lost access to your account. This made it terrifying for general consumers to use as a primary login method.

**The Solution:**
**Passkeys** are essentially **Multi-Device FIDO2 Credentials**. They take the cryptographic security of WebAuthn but allow the private keys to sync securely across your devices via the cloud (iCloud Keychain, Google Password Manager, etc.).

Here is the detailed breakdown of the concepts listed in your Table of Contents:

### i. Syncing Private Keys across Ecosystems

The fundamental difference between a "Security Key" (like a YubiKey) and a "Passkey" is the concept of synchronization.

**1. The Cloud Vault Mechanism**
When a user generates a Passkey, the **Private Key** is not just stored on the device's hardware chip; it is wrapped in an encrypted bundle and synced to the platform vendor's cloud.
*   **Apple:** Synced via iCloud Keychain (End-to-End Encrypted).
*   **Google:** Synced via Google Password Manager.
*   **Microsoft/1Password/Dashlane:** Synced via their respective vaults.

**Why this matters for Engineering:**
*   **Availability:** If a user buys a new iPhone, their credentials are automatically restored. You (the backend developer) do not need to build complex "account recovery" flows for lost devices as often.
*   **User Experience:** The user registers once on their phone, and can immediately log in on their laptop if both are signed into the same cloud account.

**2. Cross-Device Authentication (The CIA - Hybrid Flow)**
What if an iPhone user wants to log in on a Windows PC? Since iCloud doesn't sync to Windows natively, Passkeys use a protocol called **FIDO Cross-Device Authentication (CDA)**, often involving a QR Code.

*   **The Flow:**
    1.  User visits your website on Windows and clicks "Login with Passkey."
    2.  Windows generates a QR code.
    3.  User scans the QR code with their iPhone camera.
    4.  **The Security Magic:** The devices establish a connection via **Bluetooth Low Energy (BLE)** to prove physical proximity (this ensures a hacker in Russia cannot ask you to scan a QR code to log them in).
    5.  Once connected, the phone performs the cryptographic signature (FaceID/TouchID) and sends the approval back to the Windows browser via a local tunnel.

---

### ii. Phishing Resistance (Domain Binding)

This is the single most important security feature of Passkeys and FIDO2. It eliminates the human error factor in phishing.

**The Scenario:**
Imagine a hacker creates a fake website: `my-bank-login.com` (which looks exactly like `my-bank.com`).

1.  **Password Scenario (Fail):** The user enters their password. The hacker records it. The account is stolen.
2.  **TOTP/SMS Scenario (Fail):** The user enters the code sent to their phone. The hacker relays it to the real site immediately. The account is stolen (Real-time Phishing).
3.  **Passkey Scenario (Success):**
    *   The browser (Chrome/Safari) holds the Passkey.
    *   When the Passkey was created, it was cryptographically bound to the origin `https://my-bank.com`.
    *   When the user visits `https://my-bank-login.com`, the **Browser** checks its vault.
    *   The Browser sees that the domain asking for the key (`my-bank-login.com`) does not match the key's bound domain (`my-bank.com`).
    *   **Result:** The browser *silently refuses* to even show the login prompt. The user *cannot* be phished because the browser manages the relationship, not the human.

---

### Summary for Backend Engineers

If you are implementing this in your backend (The "Engineering Master Plan" perspective), here is what changes:

1.  **Database:** You no longer store `password_hash` or `salt`. Instead, you store:
    *   `public_key`: The user's public key (retrieved during registration).
    *   `credential_id`: A handle to look up the key.
    *   `sign_count`: To detect cloned keys (though this is handled differently in Passkeys vs Hardware keys).
2.  **Challenge-Response:**
    *   **Registration:** Server sends a random challenge $\rightarrow$ Client signs with Private Key $\rightarrow$ Server verifies with Public Key $\rightarrow$ Server stores Public Key.
    *   **Login:** Server sends random challenge $\rightarrow$ Client signs with Private Key $\rightarrow$ Server verifies with stored Public Key.
3.  **User Handle:** You must assign a stable, random ID to the user (not an email address) so that if they change their email, the Passkey remains valid.

**In essence:** Passkeys move the industry from "Shared Secrets" (Passwords that both you and the server know) to "Asymmetric Cryptography" (You hold the Private key, the server holds the Public key), while solving the usability issue of key management via Cloud Syncing.

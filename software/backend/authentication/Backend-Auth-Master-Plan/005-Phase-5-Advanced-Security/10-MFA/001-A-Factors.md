Based on the `Table of Contents` you provided, here is a detailed engineering explanation of **Phase 5 (Advanced Security) → 10 (MFA) → A (Factors)**.

---

# 10. MFA (Multi-Factor Authentication)
## 001-A. The Core Factors

In security engineering, **authentication** is the process of verifying a user's identity. Traditional authentication relies on a single factor (usually a password). If that password is stolen, the account is compromised.

**Multi-Factor Authentication (MFA)** requires the user to present **two or more distinct pieces of evidence** (factors) from *different* categories to grant access. 

The security axiom is: **Auth = Something you [Know] + Something you [Have] + Something you [Are].**

Here is a deep dive into the three primary factors:

---

### 1. The Knowledge Factor ("Something You Know")
This is the most common and traditional form of authentication. It relies on information stored in the user's memory.

*   **Examples:**
    *   Passwords / Passphrases.
    *   PINs (Personal Identification Numbers).
    *   Security Questions (e.g., "What was your first pet's name?").

*   **Engineering Context:**
    *   This is usually the "first factor."
    *   **Vulnerability:** This is the weakest factor because it can be guessed, brute-forced, phished (social engineering), or stolen via keyloggers.
    *   **Implementation Requirement:** Knowledge factors must never be stored in plaintext. They require hashing and salting (as covered in Phase 1 of your plan).

---

### 2. The Possession Factor ("Something You Have")
This verifies that the user is in physical possession of a specific object or device. Even if an attacker knows the user's password, they cannot log in without stealing this physical item.

*   **Examples:**
    *   **Hardware Tokens:** Specific devices (like RSA SecurID) that display a constantly changing number.
    *   **Smartphones:** Receiving an OTP (One-Time Password) via an Authenticator App, SMS, or Push Notification.
    *   **Security Keys:** USB devices like YubiKeys (FIDO/U2F standards).
    *   **Smart Cards:** Badge cards often used in corporate physical access or government login.

*   **Engineering Context:**
    *   **The "Secret" Seed:** When a user sets up a TOTP app (like Google Authenticator), the server generates a secret key. The user scans this (Possession). From that point on, both the server and the phone can mathematically calculate the same 6-digit code at the same time.
    *   **Strength:** Much stronger than knowledge. Remote hackers cannot easily replicate a hardware key plugged into your USB port.
    *   **Weakness:** Physical devices can be lost, stolen, or broken. (SMS is a "Possession" factor because you own the SIM card, but it is considered "Weak Possession" due to SIM-swapping attacks).

---

### 3. The Inherence Factor ("Something You Are")
This utilizes unique biological characteristics of the user. This is the hardest factor to fake but also the hardest to change if compromised.

*   **Examples:**
    *   **Fingerprint Scanners** (TouchID).
    *   **Facial Recognition** (FaceID, Windows Hello).
    *   **Retina/Iris Scans.**
    *   **Voice Recognition.**

*   **Engineering Context:**
    *   **Storage:** You generally do **not** send raw biometric data (an image of a fingerprint) to the server. If a database of fingerprints is hacked, users cannot "change" their fingerprints.
    *   **The Enclave:** Instead, biometrics are usually processed locally on the device (in a Secure Enclave or TPM). The device verifies the user, then the device uses a cryptographic key (Possession) to tell the server "Trust me, the user is here."
    *   **False Positives/Negatives:** Unlike a password (which is strictly Right or Wrong), biometrics rely on probability/matching thresholds.

---

### Summary Table for Engineers

| Factor Type | Concept | Best Use Case | Engineering Risk |
| :--- | :--- | :--- | :--- |
| **Knowledge** | Memory | The initial barrier (Password). | Phishing, weak entropy (user chooses "123456"). |
| **Possession** | Physical Item | The 2nd Step (Phone, YubiKey). | Device loss, battery death, replication (if seed is stolen). |
| **Inherence** | Biology | Convenience (Unlocking the Possession factor). | Privacy concerns, cannot be reset if data is stolen. |

### The "Multi-Factor" Rule
For a system to be true **MFA**, the methods must come from **different categories**.

*   **❌ NOT MFA:** Requiring a Password (Knowledge) + Security Question (Knowledge). This is just "Two-Step Verification." If the user has a keylogger, the attacker gets both.
*   **✅ IS MFA:** Requiring a Password (Knowledge) + OTP Code from Phone (Possession).
*   **✅ IS MFA:** Requiring a FaceID scan (Inherence) to unlock a private key on a phone (Possession).

Based on the syllabus you provided, **Section 1.B (Cryptographic Primitives)** is the most critical theoretical foundation for backend security. If you get this section wrong, you might accidentally store passwords in a way that allows hackers to read them, or create tokens that users can fake.

Here is a detailed breakdown of **Cryptographic Primitives**.

---

# 1.B. Cryptographic Primitives

In cryptography, a "primitive" is a low-level algorithm used to build specific security protocols. You don't "invent" your own crypto; you combine these proven primitives like Lego blocks.

## i. Hashing vs. Encryption vs. Encoding
This involves understanding the difference between transforming data for **usability** vs. **secrecy** vs. **integrity**.

### 1. Encoding (Not Security)
Encoding is transforming data from one format to another so it can be safely consumed by a different system. **It provides zero security.**
*   **Mechanism:** Publicly known algorithms. No keys required.
*   **Reversibility:** Completely reversible by anyone.
*   **Example:** **Base64**.
    *   *Concept:* You want to send an image (binary data) inside a JSON text file. JSON crashes if it sees raw binary. So, you "Encode" the binary into text characters (A-Z, 0-9).
    *   *The Trap:* Junior engineers sometimes Base64 encode a password and put it in a database. If a hacker gets the database, they just decode it instantly.
    *   *Rule:* **Base64 is NOT Encryption.**

### 2. Encryption (Secrecy)
Encryption is transforming data so that it is unreadable to anyone without a specific secret (a key).
*   **Mechanism:** Algorithms that use mathematical keys.
*   **Reversibility:** Two-way. You can encrypt, and if you have the key, you can decrypt to get the original data back.
*   **Goal:** Confidentiality.
*   **Example:** Storing a user's credit card number or SSN in a database. You need to be able to read it later to process a payment, but you want it hidden if the DB is stolen.

### 3. Hashing (Integrity & Fingerprinting)
Hashing takes an input of any size and produces a fixed-size string of characters.
*   **Mechanism:** A mathematical "meat grinder."
*   **Reversibility:** **One-way.** You can turn a strawberry into a smoothie, but you cannot turn a smoothie back into a strawberry.
*   **Deterministic:** The same input *always* results in the same output.
*   **Avalanche Effect:** Changing one single letter in the input completely changes the output hash.
*   **Goal:** Integrity and Verification.
*   **Example:** **Passwords**. You never store the actual password. You store the hash. When a user logs in, you hash their input and compare it to the stored hash. If they match, the password is correct. You (the server admin) never theoretically know the user's real password.

| Feature | Encoding | Encryption | Hashing |
| :--- | :--- | :--- | :--- |
| **Input $\to$ Output** | Text $\to$ Text | Text $\to$ Scramble | Text $\to$ Scramble |
| **Reversible?** | **Yes** (Easily) | **Yes** (If you have the key) | **No** (One-way) |
| **Need a Key?** | No | Yes | No (usually) |
| **Primary Use** | Data Transfer/Formats | Secrecy/Confidentiality | Integrity/Verification |
| **Example** | Base64, Hex | AES, RSA | SHA-256, bcrypt |

---

## ii. Symmetric vs. Asymmetric Encryption
If you need to Encrypt (#2 above), you have two main ways to handle the keys.

### 1. Symmetric Encryption (Shared Secret)
Both the sender and the receiver use the **same key** to lock and unlock the data.
*   **Analogy:** A house key. You give your friend a copy of your key. You lock the door; they unlock it with the same key.
*   **Performance:** Very fast. High throughput.
*   **Algorithms:** AES-256 (Advanced Encryption Standard), ChaCha20.
*   **The Problem:** **Key Distribution.** How do I send you the key securely over the internet? If a hacker intercepts the key while I'm sending it to you, they can read all our messages.

### 2. Asymmetric Encryption (Public-Key Cryptography)
This uses a **Key Pair** (two mathematically linked keys).
1.  **Public Key:** Generally available to anyone. Can **only encrypt**.
2.  **Private Key:** Kept secret by the owner. Can **only decrypt**.
*   **Analogy:** A slightly magical mailbox. Anyone can put a letter in the slot (Public Key), but only the person with the mailbox key (Private Key) can take letters out/read them.
*   **Performance:** Slow and computationally expensive.
*   **Algorithms:** RSA, ECC (Elliptic Curve).
*   **The Solution:** This solves the Key Distribution problem. I can put my Public Key on my website. You use it to encrypt a message. Even if a hacker has my Public Key, they can't read your message—only my Private Key can decrypt it.

### **The Hybrid Approach (How TLS/SSL Works)**
Because Asymmetric is slow:
1.  Browser and Server use **Asymmetric Encryption** to introduce themselves and securely exchange a generated "Shared Key."
2.  Once they both have that "Shared Key," they switch to **Symmetric Encryption** (AES) for the rest of the conversation because it's faster.

---

## iii. Digital Signatures (Ensuring Integrity)
How do you prove a message came from YOU and hasn't been tampered with? This uses Asymmetric keys in **reverse**.

### How it works:
1.  **Signing (Sender):** You take your message (or a hash of it) and encrypt it using your **Private Key**. This output is the "Digital Signature."
2.  **Verifying (Receiver):** The receiver takes the signature and attempts to decrypt it using your **Public Key**.

### The Logic:
*   In standard Asymmetric encryption, Public locks and Private unlocks.
*   In Signatures, **Private signs (locks) and Public verifies (unlocks).**
*   If the signature successfully decrypts using your Public Key, it implies mathematically that it **must** have been created by the holder of the Private Key (You).

### Relevance to Backend Engineering: **JWTs (JSON Web Tokens)**
*   When a user logs in, the server creates a JSON file (Subject: UserID 123).
*   The server **Digitally Signs** that JSON with the server's Private Key.
*   The server gives that token to the user.
*   Later, the user sends the token back to request data.
*   The server checks the signature.
*   If a hacker tried to change "UserID 123" to "UserID 999" (Admin), the signature math would fail, and the server would reject the token.

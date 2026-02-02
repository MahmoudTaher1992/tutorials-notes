This section describes the absolute "Prime Directive" of backend engineering: **Never store user passwords in plain text.**

If your database is hacked (and you should assume it eventually will be), you must ensure that the attackers cannot read users' passwords. If they can, they can log into your site, and because users reuse passwords, they can likely log into the users' bank accounts and emails, too.

Here is a detailed breakdown of **Phase 1, Section 2-A: Storing Passwords Securely**.

---

### i. The Evolution of Password Storage
To understand *why* we use specific tools today, we have to look at how previous methods failed.

#### 1. Plaintext (The "Do Nothing" Era)
*   **Method:** Storing the password exactly as the user typed it.
    *   User enters: `monkey123`
    *   Database stores: `monkey123`
*   **The Flaw:** If an attacker dumps the database, they have everyone's password immediately. Internal employees can also see user passwords.
*   **Verdict:** ❌ Criminal negligence in modern engineering.

#### 2. Simple Hashing (MD5 / SHA-1)
*   **Method:** Using a cryptographic hash function to turn the password into a scrambled string.
    *   User enters: `monkey123`
    *   Database stores: `e10adc3949ba59abbe56e057f20f883e`
*   **The Concept:** Hashing is **one-way**. You cannot "decrypt" a hash. You can only hash the input again and compare the strings.
*   **The Flaw:** MD5 and SHA-1 are designed to be **fast**. A modern GPU (Graphics Card) can guess 100 billion MD5 hashes *per second*. An attacker can simply "brute force" every possible combination of letters and numbers until they find the match.
*   **Verdict:** ❌ Too fast to be secure.

#### 3. Salted Hashes (Preventing Pre-computation)
*   **The Problem:** Many users have the same password (e.g., "password123"). Without a salt, their hashes look identical in the database. Attackers use **Rainbow Tables** (pre-computed lists of common password hashes) to reverse-lookup passwords instantly.
*   **The Solution:** You generate a random string called a **Salt** for every user, append it to the password, *then* hash it.
    *   User A: `Hash("monkey123" + "RandomSaltA")`
    *   User B: `Hash("monkey123" + "RandomSaltB")`
*   **The Result:** Even though they have the same password, the database hash looks completely different. Rainbow tables are rendered useless.
*   **Verdict:** ✅ Essential, but not enough on its own anymore (due to GPU speed).

#### 4. Adaptive Algorithms (The Modern Era)
*   **Method:** Algorithms designed to be intentionally **slow** and expensive to compute.
*   **The Concept:** If it takes 0.5 seconds to verify a password on your server, the user doesn't mind. But for a hacker trying to guess 1 billion passwords, 0.5 seconds per guess makes the attack take centuries.
*   **Verdict:** ✅ The industry standard.

---

### ii. Modern Standards (The Toolbox)

These are the algorithms you should be using. They are "Work Factor" adjustable, meaning you can tune them to become slower as computers get faster in the future.

#### 1. Argon2id (The Gold Standard)
*   **Status:** Winner of the 2015 Password Hashing Competition.
*   **Why it is best:** It is **Memory-Hard**.
    *   Older algorithms (like SHA-256) only use CPU math. Hackers built specialized hardware (ASICs) and used GPUs to crack these instantly.
    *   Argon2 forces the computer to fill up a large amount of RAM (memory) to compute the hash. GPUs and ASICs are terrible at memory-heavy tasks.
*   **Recommendation:** Use this for all new projects.

#### 2. bcrypt
*   **Status:** The reliable industry veteran. Default in many frameworks (like Laravel, Spring Security).
*   **How it works:** It mimics the setup process of the Blowfish cipher. It is CPU-intensive but not significantly memory-intensive.
*   **Limitation:** It traditionally truncates passwords at 72 characters.
*   **Recommendation:** Still perfectly safe and acceptable to use.

#### 3. scrypt
*   **Status:** The predecessor to Argon2.
*   **How it works:** The first algorithm specifically designed to be memory-hard to defeat hardware attacks.
*   **Recommendation:** Good, but Argon2 offers better side-channel protection.

#### 4. PBKDF2 (Password-Based Key Derivation Function 2)
*   **Status:** The "NIST" standard.
*   **How it works:** It takes a basic hash (like SHA-256) and loops it thousands of times (e.g., 600,000 iterations).
*   **Weakness:** It is not memory-hard. GPUs can still attack it relatively efficiently compared to Argon2.
*   **Recommendation:** Use only if compliance/government regulations (FIPS) forbid newer algorithms.

---

### iii. Entropy & Salting (The Defense Mechanics)

This section explains the math and logic behind *why* the attacks happen.

#### 1. Entropy
*   **Definition:** Entropy is a measure of randomness or unpredictability.
*   **The Issue:** Humans are terrible at entropy. We pick passwords like `Summer2023!`.
*   **The Attack:** Because human passwords have "Low Entropy," attackers don't guess random characters (`x!9~b#`); they guess words from dictionaries ("Dictionary Attack").
*   **Defense:** We cannot force users to have high entropy (unless we force 20-character random passwords), so we rely on the **Slowness** of the hashing algorithm (Argon2/bcrypt) to make guessing those dictionary words too time-consuming.

#### 2. Salting vs. Rainbow Tables
A **Rainbow Table** is a massive cheat sheet.
*   Imagine a hacker computes the SHA-256 hash for every word in the English dictionary and saves it in a File.
*   They steal your DB. They see a hash: `5e8848...`
*   They `CTRL+F` in their cheat sheet. It matches "password". They are in.

**How Salting kills this:**
*   **Salt:** A random string (e.g., `xh5$91!`) generated specifically for **User A**.
*   **Storage:** The salt is stored *plainly* next to the hash in the database. It is not a secret key.
*   **The Math:** Total Hash = `Hash(Password + Salt)`.
*   **The Fix:** Because every user has a unique Salt, the hacker's cheat sheet (Rainbow Table) doesn't work. The hacker would have to generate a *new* cheat sheet specifically for *that one user's salt*. This forces them back to Brute Force, which is too slow to succeed against Argon2/bcrypt.

### Summary Checklist for Engineers
1.  **Never** write your own crypto.
2.  **Never** use MD5, SHA1, or SHA-256 for passwords.
3.  **Do** use a library that implements **Argon2id** (preferred) or **bcrypt**.
4.  Ensure the library handles **salting** automatically (modern libraries do this by default).

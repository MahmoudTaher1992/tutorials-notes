This section of the Engineering Master Plan focuses on **Active Defense**.

In section **2.A (Storing Passwords)**, you learned how to protect data *at rest* (encryption, hashing, salting). Section **2.B (Defensive Measures)** focuses on protecting the **Login Endpoint** itself.

Even if your hash algorithm (Argon2id) is perfect, it doesn't matter if an attacker simply guesses the password "Password123" because your API allowed them to try 10,000 times in a row.

Here is a detailed breakdown of **Defensive Measures**.

---

### i. Account Lockout Policies vs. Exponential Backoff

This looks at how you handle repeated failed login attempts. There is a massive tension here between **Security** (stopping hackers) and **User Experience/Availability** (stopping denial of service).

#### 1. Account Lockout (The "Old School" Way)
**The Policy:** "If a user fails to log in 5 times within 15 minutes, lock the account for 30 minutes."

*   **How it works:** You flag the user in the database as `locked_until: <timestamp>`.
*   **The Critical Flaw (The Denial of Service Vector):**
    *   This approach assumes the person typing the password is the legitimate owner.
    *   **The Attack:** If I am an attacker and I know your email address (which is public knowledge), I can intentionally write a script to send 5 wrong passwords to your account every 29 minutes.
    *   **The Result:** You, the legitimate user, are permanently locked out of your account. The attacker has successfully performed a DoS (Denial of Service) attack against a specific user.

#### 2. Exponential Backoff (The "Modern" Way)
**The Policy:** "Make the login process slower, not impossible."

*   **How it works:** You introduce a delay that increases exponentially with every failed attempt.
    *   Attempt 1 (Fail): Wait 0 seconds.
    *   Attempt 2 (Fail): Wait 2 seconds.
    *   Attempt 3 (Fail): Wait 4 seconds.
    *   Attempt 4 (Fail): Wait 8 seconds.
    *   Attempt 5 (Fail): Wait 16 seconds.
*   **The Engineering Logic:**
    *   A brute-force script relies on speed. If they can only try 5 passwords per minute instead of 5,000, the attack becomes mathematically unfeasible.
    *   **Implementation:** This is usually implemented using a fast key-value store like **Redis**.
    *   **Key:** `rate_limit:login:{user_ip}` or `rate_limit:login:{email}`.

#### 3. CAPTCHA / Proof of Work
If the backoff gets too high (e.g., after 5 attempts), do not lock the account. Instead, require a **CAPTCHA** (Cloudflare Turnstile, reCAPTCHA v3). This forces the attacker to spend money (on CAPTCHA solving farms) or CPU power, making the attack economically unviable.

---

### ii. Credential Stuffing Detection

Brute forcing is guessing "Password123". **Credential Stuffing** is entirely different and much more dangerous.

#### 1. What is Credential Stuffing?
Users are terrible at security. They use the same password for *LinkedIn* that they use for *YourBankingApp*.
1.  LinkedIn gets hacked (hypothetically). Hackers get a DB dump of emails and passwords.
2.  Hackers don't try to hack *YourBankingApp* directly. They take the LinkedIn list (millions of combos) and "stuff" them into your login endpoint.
3.  Because the users reused passwords, the hackers get in.

**The Engineering Challenge:** From your server's perspective, these logins look legitimate. The email is right, and the password is right.

#### 2. How to Detect & Defend

**A. IP Reputation & Velocity Checks (WAF Level)**
*   **Impossible Velocity:** If one IP address attempts to log in to 50 *different* user accounts in 1 minute, that is a bot. Block the IP.
*   **Impossible Travel:** If a user logs in from New York at 9:00 AM, and then logs in from Russia at 9:05 AM, flag the session.

**B. Credential Intelligence (The "Have I Been Pwned" Model)**
The gold standard for defense is checking if the password the user is trying to use has appeared in a known data breach.

*   **Integration:** You can use an API like "Have I Been Pwned" (HIBP).
*   **Security Concern:** You cannot send your user's password to an external API (HIBP). That violates privacy.
*   **The Solution: k-Anonymity (Prefix Search):**
    1.  User types: `monkey`.
    2.  You hash it (SHA-1 for HIBP standard): `7D6F3...`.
    3.  You take the **first 5 characters**: `7D6F3`.
    4.  You send `7D6F3` to the HIBP API.
    5.  HIBP returns *all* breached hashes that start with `7D6F3` (maybe 500 results).
    6.  **Your Backend** scans that list locally to see if the full hash matches.
    *   *Result:* HIBP never knows the user's password, but you know if it's compromised.

#### 3. Shadow Banning (Silent Failure)
If you detect a bot attack (Credential Stuffing), do not send back a standard "401 Unauthorized" immediately.
*   Bots read error codes to maximize speed.
*   **Defense:** Return a "200 OK" or a "Fake Error" with a randomized delay. Waste the bot's time. If the bot "thinks" it failed, but the server spun for 2 seconds, the attack becomes inefficient.

### Summary Comparison

| Attack Type | What they do | How to defend |
| :--- | :--- | :--- |
| **Brute Force** | Tries `admin` + `123`, `1234`, `12345` | **Exponential Backoff** (Slow them down). |
| **Credential Stuffing** | Tries `valid@email.com` + `valid_pass_from_other_site` | **IP Rate Limiting** & **Breached Password Checks**. |
| **Password Spraying** | Tries `Password123` on *every* user in your DB | **Global Lockout** (If 100 fails happen globally in 1 sec, trigger alert). |

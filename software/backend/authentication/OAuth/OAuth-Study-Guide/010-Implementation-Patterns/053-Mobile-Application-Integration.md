This section of the study guide focuses on the specific implementation details, security constraints, and best practices for implementing OAuth 2.0 and 2.1 in native mobile applications (iOS and Android).

Mobile apps are considered **Public Clients**, meaning they cannot securely store a `client_secret`. Therefore, the implementation relies heavily on the **Authorization Code Flow with PKCE** (Proof Key for Code Exchange) and specific Operating System APIs to handle security.

Here is a detailed breakdown of the concepts listed in Section 053.

---

### 1. The Core Principle: "External User-Agent"
Before diving into iOS/Android specifics, you must understand **RFC 8252 (OAuth 2.0 for Native Apps)**.
*   **Do Not Use Embedded WebViews:** In the past, developers opened an embedded browser inside the app to show the login screen. This is insecure because the app can spy on the user's keystrokes (stealing passwords) and creates a poor user experience (no shared cookies).
*   **Use the System Browser:** The standard mandates using the phone's default browser (Safari, Chrome) via a secure overlay. This ensures the app never sees the user's credentials, and if the user is already logged into the browser, they are automatically logged into the app (SSO).

---

### 2. iOS Implementation (ASWebAuthenticationSession)
On Apple devices, you should not just "open Safari." You must use the specialized API provided by the `AuthenticationServices` framework to manage the OAuth dance.

*   **ASWebAuthenticationSession (iOS 12+):**
    *   This API launches a modal browser window over your app.
    *   **Cookie Sharing:** It shares cookies with the standard Safari browser app. If the user is logged into Google/Facebook in Safari, they won't need to re-enter credentials in your app.
    *   **Context:** It allows the app to tell iOS, "I am doing a login flow."
    *   **Callback:** It listens strictly for the specific redirect URI (deep link) that indicates the login is finished.

**How it looks in code logic:**
1.  App generates PKCE keys (`code_verifier`, `code_challenge`).
2.  App initializes `ASWebAuthenticationSession` with the Auth Server URL.
3.  iOS shows a prompt: *"App wants to use 'example.com' to sign in."*
4.  User logs in.
5.  The browser redirects to `myapp://callback...`
6.  The Session captures this URL, closes the browser window automatically, and hands the URL (containing the `code`) back to the app code.

---

### 3. Android Implementation (Custom Tabs)
Android follows the same philosophy but uses a different toolset, primarily **Chrome Custom Tabs** (or simply "Custom Tabs" to support other browsers like Samsung Internet or Firefox).

*   **Custom Tabs:**
    *   Instead of switching the user entirely to the Chrome App, Custom Tabs launch a chrome-instance *inside* your app's activity stack.
    *   **UI Customization:** You can style the toolbar color to match your app, making it feel native.
    *   **Shared State:** Like iOS, it shares the cookie jar with the main Chrome browser application (enabling SSO).
*   **AppAuth-Android Library:**
    *   Implementing the raw Intent filters and Custom Tabs by hand is complex. The industry standard is to use the Google-maintained library called **AppAuth**. It automatically handles the PKCE generation, Custom Tab launching, and token exchange.

---

### 4. Deep Linking (Getting back to the App)
Once the Authorization Server has authenticated the user, it needs to send the `authorization_code` back to the native app. Mobile apps do not have static IP addresses or traditional domains, so they use Deep Linking.

*   **Custom URL Schemes:**
    *   Format: `myapp://callback` or `com.company.app:/callback`
    *   **Pros:** Easy to set up.
    *   **Cons:** Insecure on older OS versions. If a malicious app installs itself and registers the same `myapp://` scheme, it could intercept the login code.
*   **Universal Links (iOS) / App Links (Android):**
    *   Format: `https://www.myapp.com/login/callback`
    *   **Pros:** Highly secure. The operating system verifies that your app "owns" the domain `www.myapp.com` via digital asset link files hosted on the server.
    *   **Cons:** More confusing to configure implementation-wise.
    *   **Best Practice:** Use Universal/App Links whenever possible. If you must use Custom URL Schemes (e.g., for internal development), use a distinct naming convention like `com.company.app.auth://`.

---

### 5. Secure Token Storage (Keychain & Keystore)
Once the app exchanges the authorization code for an **Access Token** and a **Refresh Token**, you must store them safely.
*   **NEVER** store tokens in `UserDefaults` (iOS), `SharedPreferences` (Android), or local SQLite databases. These are often unencrypted files that can be read easily if the phone is jailbroken/rooted or via backup extraction tools.

**iOS: Keychain Services**
*   The **Keychain** is an encrypted database provided by iOS.
*   The data is hardware-encrypted (using the device's Secure Enclave).
*   You can set controls so data is only accessible when the device is unlocked.

**Android: EncryptedSharedPreferences (Keystore)**
*   The **Android Keystore System** stores cryptographic keys in hardware (TEE/StrongBox) to make them difficult to extract.
*   **EncryptedSharedPreferences** (part of Jetpack Security) wraps this complexity, allowing you to store key-value pairs where the keys and values are automatically encrypted using keys managed by the Keystore.

---

### 6. Biometric Protection
For high-security apps (banking, health), storing the Refresh Token securely isn't enough. You want to ensure the *current user* is the owner of the device before using that token to get data.

*   **The Flow:**
    1.  User opens the app after 6 hours.
    2.  Access token is expired.
    3.  App tries to use the Refresh Token to get a new one.
    4.  **STOP:** Before reading the Refresh Token from the secure storage, prompt for biometrics.

*   **Implementation:**
    *   **iOS (LocalAuthentication):** You can store a keychain item with a specific flag (`kSecAccessControlUserPresence`). When the app tries to read this item, iOS *automatically* prompts the user for FaceID/TouchID. The app never gets the token unless the face matches.
    *   **Android (BiometricPrompt):** You configure the Keystore key such that it requires user authentication. When you try to decrypt the token, the operation fails unless you successfully invoke the `BiometricPrompt` API.

This ensures that even if a thief steals the physical phone (unlocked), they simply cannot perform actions that require a fresh access token unless they also have the user's biometric data.

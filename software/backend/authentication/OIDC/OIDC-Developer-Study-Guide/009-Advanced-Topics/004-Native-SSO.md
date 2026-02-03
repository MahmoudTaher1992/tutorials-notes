Based on the Table of Contents you provided, specifically **item 34 under Part 9 (Advanced Topics)**, here is a detailed explanation of **Native SSO**.

---

# Native SSO (Single Sign-On)

### The Core Problem: The Sandbox
To understand Native SSO, you must first understand the problem it solves. On the web, SSO is relatively easy because web browsers share a "cookie jar." If you log into google.com in one tab, the cookie is saved. When you open youtube.com in another tab, the browser checks the cookie jar, sees you are logged in, and SSO happens automatically.

**Native mobile apps (iOS/Android) are different.**
Mobile operating systems use a security concept called **Sandboxing**.
*   App A (e.g., Spotify) accesses its own isolated storage.
*   App B (e.g., Slack) has its own isolated storage.
*   App A generally cannot read the cookies or tokens stored by App B.

Therefore, historically, if a user installed 5 different apps from the same company, they had to type their username and password 5 separate times. **Native SSO** is the set of patterns and technologies used to bridge this gap so a user logs in once on their device and gains access to all authorized apps.

---

### 1. Cross-App SSO on Mobile

The modern standard for achieving SSO across native apps relies on moving the authentication session **out of the app and into the system browser**.

#### The "App Browser" vs. "System Browser"
In the past, developers used "WebViews" (embedded browsers inside the app) to show login screens. This isolated the session.
*   **The Modern Solution:** iOS (via `ASWebAuthenticationSession`) and Android (via `Chrome Custom Tabs`) now allow apps to open a secure overlay of the **system's default browser** (e.g., Safari or Chrome).

#### How it works:
1.  **User opens App A.**
2.  App A triggers an OIDC login flow. It does **not** open a WebView; it launches the system browser overlay to the Identity Provider (IdP).
3.  **User logs in.** The IdP drops a session cookie **in the System Browser's cookie jar**, not the App's private storage.
4.  App A receives the tokens and the user is logged in.
5.  **User opens App B.**
6.  App B triggers an OIDC login flow using the **same** system browser overlay.
7.  The system browser loads the IdP page. It detects the cookie (set during step 3).
8.  **Magic:** The user is not asked for credentials. The browser immediately redirects back to App B with a code/token.

**Technologies involved:**
*   **iOS:** `ASWebAuthenticationSession` / `SFAuthenticationSession`.
*   **Android:** Chrome Custom Tabs.
*   **PKCE:** Essential here because native apps are "Public Clients" and cannot keep secrets safe.

---

### 2. Device SSO (The "Broker" Approach)

While the browser method is great, large enterprises (like Microsoft or Google) often use a **Broker App** pattern for an even smoother experience.

#### What is a Broker App?
A specific app is designated as the "Authenticator." Examples include the **Microsoft Authenticator** app or the **Google** app on Android.

#### How it works:
1.  You install the **Broker App** and log in there. This app stores your Master Refresh Token (strictly secured, often using hardware-backed encryption like the Secure Enclave).
2.  You open a corporate app (e.g., Outlook Mobile).
3.  Outlook detects that the Microsoft Authenticator is installed.
4.  Instead of opening a browser, Outlook sends a request to the Authenticator app via Inter-App Communication (Deep linking or extensive system APIs).
5.  The Authenticator app verifies the request, checks its internal Master Token, and issues a token specifically for Outlook.
6.  Outlook is logged in without the user ever seeing a password screen or a browser.

**Shared Keychains (iOS):**
On iOS, apps released by the *same* developer (signed with the same certificate) can share a specific slice of secure storage called the **Shared Keychain**. If an organization releases 5 apps, App B can simply look into the Keychain to see if App A already stored a Refresh Token.

---

### 3. Token Exchange

This is the advanced backend logic often required to support Native and Broker-based SSO. It helps answer the question: *"I have a token for App A, but I need to access API B, or I need to log into App C."*

Based on **RFC 8693 (OAuth 2.0 Token Exchange)**, this flow allows a client to exchange one token for another.

#### The Scenario:
Imagine the **Broker App** mentioned above. It holds a high-privilege "ID Token" or "Refresh Token" representing the user's identity on the device.
1.  **App A** asks the Broker for access.
2.  The **Broker** contacts the Identity Provider (IdP).
3.  The Broker performs a **Token Exchange Request**:
    *   *Subject Token:* "Here is the user's Master Token proving they are authenticated on this device."
    *   *Audience:* "I need a token specifically for **App A**."
4.  The IdP verifies the Master Token and issues an Access Token scoped strictly for App A.

#### Why is this necessary?
It implements **Least Privilege**. You don't want to copy the "Master Token" into App A, because if App A is hacked, the attacker gets access to everything. Instead, Token Exchange ensures App A only gets a token that works for App A, keeping the "keys to the kingdom" safely inside the Broker or System.

---

### Summary Checklist for Native SSO

If you are implementing Native SSO, you are likely looking at one of these three implementation tiers:

1.  **Shared Keychain (Simplest, Limited):**
    *   *Scope:* Only works for apps from the *exact same* developer team.
    *   *Mechanism:* iOS Keychain Sharing / Android Shared Preferences (deprecated/risky).

2.  **System Browser (Standard OIDC):**
    *   *Scope:* Works for any app using the same Identity Provider.
    *   *Mechanism:* `ASWebAuthenticationSession` (iOS) / Custom Tabs (Android).
    *   *Experience:* User sees a browser window pop up and close instantly.

3.  **Broker / Token Exchange (Enterprise/Advanced):**
    *   *Scope:* High security, complex ecosystems.
    *   *Mechanism:* A dedicated "Authenticator" app facilitates login for other apps via custom URI schemes and RFC 8693 Token Exchange.

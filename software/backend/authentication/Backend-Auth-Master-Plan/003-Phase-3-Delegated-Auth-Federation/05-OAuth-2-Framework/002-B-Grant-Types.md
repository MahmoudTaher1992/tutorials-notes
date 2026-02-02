Based on the Table of Contents you provided, here is a detailed explanation of **Phase 3, Section 5-B: Grant Types (The Flows)**.

---

# 003-Phase-3-Delegated-Auth-Federation / 05-OAuth-2-Framework / 002-B-Grant-Types.md

## What is a "Grant Type"?
In OAuth 2.0, a **Grant Type** is simply the method an application uses to exchange "credentials" for an **Access Token**.

Think of the Access Token as a hotel key card. The "Grant Type" is the process you go through at the front desk to get that card.
1.  **Guest (User):** You show your ID and credit card (Authorization Code Flow).
2.  **Janitor (Service):** You show your employee badge (Client Credentials Flow).

Choosing the wrong Grant Type is the most common security vulnerability in OAuth implementations.

---

### i. Authorization Code Flow with PKCE (The Gold Standard)

This is the absolute most important flow to understand. It is the standard for **Mobile Apps**, **Single Page Apps (SPAs like React/Angular)**, and **Traditional Web Apps**.

#### The Problem it Solves
In the past, we had separate flows for servers (which can keep secrets) and mobile apps (which cannot keep secrets because anyone can reverse-engineer the code).
*   **The Auth Code Flow with PKCE** (Proof Key for Code Exchange) unifies this. It allows apps that reside on public devices (User's phone/browser) to safely get tokens without storing a "Client Secret" inside the app code.

#### How the Flow Works (Step-by-Step)
1.  **Preparation (The PKCE Magic):**
    *   The Client App generates a random high-entropy string called the **`code_verifier`**.
    *   The App hashes this string (usually SHA-256) to create the **`code_challenge`**.
2.  **The Redirect:**
    *   The User clicks "Login".
    *   The App redirects the browser to the Auth Server, sending the **`code_challenge`** along with the request.
3.  **Authentication:**
    *   The User logs in (username/password, MFA, etc.) on the Auth Server's page.
4.  **The Code:**
    *   The Auth Server redirects the user *back* to the Client App with a temporary **Authorization Code** in the URL.
5.  **The Exchange (The Verification):**
    *   The Client App takes that Code *and* the original secret **`code_verifier`** (from step 1) and sends them to the Auth Server's API.
6.  **Validation:**
    *   The Auth Server remembers the `code_challenge` from step 2.
    *   It takes the `code_verifier` just received, hashes it, and compares it to the saved `code_challenge`.
    *   **If they match:** The Auth Server knows the device asking for the token is the *exact same device* that started the login flow.
7.  **Success:**
    *   The Auth Server issues the Access Token (and ID Token/Refresh Token).

#### Why is this secure?
It prevents **Authorization Code Interception Attacks**. If a hacker has malicious software on your phone and steals the "Authorization Code" (Step 4), they cannot trade it for a token because they don't have the `code_verifier` (which is stored in the memory of the legitimate app).

---

### ii. Client Credentials Flow (Machine-to-Machine)

This flow is strictly for **Server-to-Server** communication where **no human user is present**.

#### Use Cases
*   A Cron job running every night to clean a database.
*   Microservice A calling Microservice B.
*   A daemon script analyzing logs.

#### How the Flow Works
1.  **Request:**
    *   The Client Application (Service A) sends its `client_id` and `client_secret` (similar to a username/password for the app) to the Auth Server.
2.  **Validation:**
    *   The Auth Server verifies the credentials.
3.  **Success:**
    *   The Auth Server returns an Access Token.

#### Key Characteristics
*   **No User Context:** The token represents the *System*, not a specific user (e.g., "Service A has permission to read logs", not "John Doe has permission").
*   **High Trust:** This flow requires the Client App to hold a `client_secret` securely. You never use this in a mobile app or frontend JavaScript.

---

### iii. Deprecated Flows (Why they are insecure)

These flows exist in the documentation and legacy systems, but you should **never** implement them in a new project.

#### 1. Implicit Flow
*   **How it worked:** The user logged in, and the Auth Server sent the Access Token *directly back in the Redirect URL* (e.g., `myapp.com/callback#access_token=xyz...`).
*   **The Vulnerability:**
    *   **URL Leaks:** URLs are logged in browser history, proxy logs, and `Referer` headers. Anyone seeing the log sees the token.
    *   **No Verification:** There was no second step to verify the app received the token.
    *   **Replacement:** Use **Auth Code Flow with PKCE**.

#### 2. Resource Owner Password Credentials (ROPC) Grant
*   **How it worked:** The application presents a standard login form. The user types their username/password directly into the App. The App sends these credentials to the Auth Server to get a token.
*   **The Vulnerability:**
    *   **Broken Trust:** The fundamental promise of OAuth is "I don't have to give my password to this 3rd party app." ROPC forces the user to give the password to the app.
    *   **Phishing:** Users get trained to type passwords into random app screens.
    *   **No MFA:** It is extremely difficult to implement Multi-Factor Authentication with this flow.
    *   **Replacement:** Use **Auth Code Flow**. The user should always be redirected to the Auth Server (e.g., Google, Okta, Auth0) to type their password, never into the app itself.

---

### Summary: Which one do I pick?

| Application Type | Is it a "Public" Client? | Recommended Flow |
| :--- | :--- | :--- |
| **Single Page App (React/Vue)** | Yes (Code is visible in browser) | **Auth Code + PKCE** |
| **Mobile App (iOS/Android)** | Yes (Binary can be decompiled) | **Auth Code + PKCE** |
| **Traditional Server Web App** | No (Can keep secrets on server) | **Auth Code (+ PKCE is still good practice)** |
| **Microservice / Cron Job** | N/A (No User involved) | **Client Credentials** |

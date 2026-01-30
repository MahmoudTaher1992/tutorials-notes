Based on the study plan and table of contents you provided, here is a detailed explanation of section **003-Delegated-Authority-Federated-Identity / 001-OAuth-2.0.md**.

This section focuses on **OAuth 2.0**, which is industry-standard protocol for authorization.

---

### The Big Picture: What is "Delegated Authority"?

Before understanding OAuth, you must understand the problem it solves.

Imagine you want to use a new app called "PhotoPrinter." You want PhotoPrinter to import your photos from **Google Photos** so you can print them.
*   **The Old Way (Insecure):** You give PhotoPrinter your Google username and Password. PhotoPrinter logs in as you.
*   ** The Risk:** PhotoPrinter now has total control. They can read your emails, delete your calendar, and change your password. Only you should have your password.
*   **The OAuth Way (Delegated Authority):** You tell Google, *"Please give PhotoPrinter a 'key' that **only** allows them to look at my photos, but nothing else."*

**OAuth 2.0 is the framework that manages the creation and handing over of that specific "key" (the token).**

---

### i. Core Purpose: Delegated Authorization vs. Authentication

Your notes specifically mention: *"Delegated Authorization (granting permission), NOT authentication."* This is the most common interview question regarding OAuth.

*   **Authentication (AuthN):** Who are you?
    *   *Example:* Showing your passport at the border. The agent confirms you are Mr. Smith.
*   **Authorization (AuthZ):** What are you allowed to do?
    *   *Example:* Holding a concert ticket. The ticket doesn't prove who you are (anyone could hold it), but it grants **access** to enter the venue.

**OAuth is for Authorization.**
OAuth creates an **Access Token** (the concert ticket). It allows an application to access specific resources. It does *not* inherently prove who the human user is to the application (though it is often used as a stepping stone for that via OIDC).

---

### ii. Key Roles

To implement OAuth, there are four distinct actors involved in the process:

#### 1. Resource Owner (The User)
*   **Who:** You. The human sitting at the keyboard.
*   **Role:** You own the data (the "Resource") and you are the only one who can grant permission to access it.

#### 2. Client (The Application)
*   **Who:** The third-party app trying to get access (e.g., "PhotoPrinter" or "Spotify").
*   **Role:** It requests access to your data.
*   *Note:* It is called the "Client" even if it is a large server-side web application, because it is a "client" of the API.

#### 3. Authorization Server (The Gatekeeper)
*   **Who:** The system that holds your credentials (e.g., Google, Facebook, Okta, Auth0).
*   **Role:** It verifies your identity (asks for your password), asks for your consent ("Do you want to allow PhotoPrinter to see your photos?"), and **minter of the tokens**.

#### 4. Resource Server (The API)
*   **Who:** The server where the data actually lives (e.g., Google Photos API).
*   **Role:** It accepts the Access Token from the Client, verifies it, and releases the data.

---

### iii. The Flow (How it works conceptually)

This represents the "dance" required to get the token securely without sharing the password.

1.  **The Request:** The **Client** (PhotoPrinter) sends the **Resource Owner** (You) to the **Authorization Server** (Google).
2.  **The Login & Consent:** You log in to Google (PhotoPrinter cannot see this). Google asks: *"PhotoPrinter wants to Read your Photos. Allow?"*
3.  **The Authorization Code:** If you click "Yes," Google redirects you back to PhotoPrinter with a temporary code.
4.  **The Exchange:** PhotoPrinter sends that code *directly* to Google (server-to-server) to prove it is really them.
5.  **The Token:** Google replies with an **Access Token**.
6.  **The Access:** PhotoPrinter sends the Access Token to the **Resource Server** (Google Photos API) to download your pictures.

---

### iv. Critical Terminology from your notes

*   **Access Token:** A credential (usually a string of characters) used to access protected resources. It has a limited lifespan and specific permissions (Scopes).
*   **Scopes:** The specific permissions granted.
    *   *Example:* `photos.read` is a scope. `email.delete` is a different scope. OAuth allows you to grant `read` without granting `delete`.
*   **Grant Types:** Methods for getting a token.
    *   The most common for web apps is the **Authorization Code Flow**.
    *   Server-to-server communication uses **Client Credentials Flow**.

### Summary for your Study Plan:
OAuth 2.0 is the **"Valet Key"** of the internet. You (the owner) give the valet (the app) a special key (the token) that allows them to start the car (access data), but does not allow them to open the glovebox or the trunk (scopes), and definitely is not your master key (password).

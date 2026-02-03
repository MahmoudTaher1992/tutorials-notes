# OAuth Foundations

## Authentication vs. Authorization

* **Authentication:**
    *   Verifying the identity of a user.
* **Authorization:**
    *   Granting permission to access resources.

---
## The Problem OAuth Solves

*   Before OAuth, if you want appA to access appB, you have to give appA the credentials of appB
*   This is the **Password Anti-Pattern**.
*   you will not be able to revoke appA access without changing the credentials !!
*   A solution is to give appA a token and revoke it when needed

---
## Versions

*   **OAuth 1.0**
    *   difficult to implement
    *   required complex cryptographic signing for every single API request
*   **OAuth 2.0**
    *   current standard
    *   shifted the complexity from the client developer to the Authorization Server and relies on HTTPS (TLS) for security rather than complex signing
*   **OAuth 2.1**
    *   upcoming cleanup of OAuth 2.0.
    *   doesn't add new features
    *   removes insecure "bad practices"
    *   mandates security best practices (like PKCE).

---
## OAuth 2.0 Overview

### What is OAuth 2.0?
*   open standard authorization framework
*   enables applications to obtain limited access to user accounts on an HTTP service
*   works by delegating user authentication to the service that hosts the user account and authorizing third-party applications to access the user account

### OAuth 2.0 vs. API Keys vs. Basic Auth
* **Basic Auth:**
    *   Sending username:password in the header in each single request
* **API Keys:**
    *   identifies the Application, not the User
    *   sent in each request
* **OAuth 2.0:**
    *   identify both the App and the User
    *   uses tokens that are temp, can be revoked without changing credentials

### Specification Documents
*   documents with details specs about everything
*   i.e.
    *   RFC 6749
    *   RFC 6750

---
## OAuth 2.0 Terminology

### The Actors (Roles)
* **Resource Owner (RO):**
    *   The User
    *   Entity capable of granting access to a protected resource

* **Client:**
    *   The Application
    *   Software making protected resource requests on behalf of the Resource Owner

* **Authorization Server (AS):**
    *   The Guard
    *   Server that verifies the user's identity and issues access tokens to the Client

* **Resource Server (RS):**
    *   The API
    *   Server hosting the protected resources (data)
    *   accepts and validates Access Tokens

### Concept Definitions

* **Protected Resource:**
    *   The data the Client wants to access

* **Redirect URI (Callback URL):**
    *   A pre-registered URL on the Client app
    *   After the user logs in at the Authorization Server, the AS redirects the browser back to this URL with the temporary code or token

* **Scope:**
    *   A parameter that limits the access granted. It defines the "size" of the permission.
    *   Example: `openid`, `profile`, `email`, `read:orders`, `write:database`

* **Grant (Grant Type):**
    *   The method (flow) the Client uses to get the Access Token
    *   Different scenarios need different grants:

* **Token:**
    *   **Access Token:** The key used to access the API. Usually short-lived (e.g., 1 hour).
    *   **Refresh Token:** A long-lived credential used to get a *new* Access Token without prompting the user to log in again.
    
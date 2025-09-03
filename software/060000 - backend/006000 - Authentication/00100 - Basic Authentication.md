# Basic Authentication

*   **Core Concept**: 
    *   The simplest form of authentication
    *   **username** and **password** are sent with every single request to a server (to prove their identity).

## How It Works:

*   **No Credentials**
    *   The client send the request without credentials
    *   The server replies with **`401 Unauthorized`**
    *   The server can respond with a header that indicates the **Authentication Mechanisms**
        *   i.e.
            *   `WWW-Authenticate: Basic realm="Access to protected area"`

*   **With Credentials**
    *   **Client Side**
        *   Preparation
            *   Combine credentials (`username:password`)
            *   **Encode** it using **Base64**
                *   this is not Encrypting, and no security is added
                *   it a way that represents binary data in text chars
                *   can be easily reversed
    *   **Server side**:
        *   the server receives the request
        *   decodes the credentials
        *   checks username and password
        *   replies the requested resource
        *   this is done with each request

## Key Characteristics

*   **Pros**
    *   **Simplicity**
    *   **Stateless**: Simple to scale
*   **Cons**
    *   **Fundamentally Insecure**:
        *   Anyone who intercepts your request can easily decode the credentials
        *   high risk due to high exposure, because credentials are sent with **every single request**
        *   Must be used with HTTPS protocol, otherwise it is totally vulnerable
            * even with HTTPs, more secure methods should be used
    *   **No Logout Mechanism**, you have to change the password to prevent the access.
    *   **Vulnerable to Replay Attacks**:
        *   **Replay attack**
            *   A hacker intercepts the request
            *   At a later time he sends it as it is, he doesn't need to get the password
            *   The request will be processed easily
            *   How to prevent it
                *   attache Nonces (Random numbers that are used once and issued by the server, the server will remember them and don't let them be used any more times)
                *   Use token-based authentication


## Core Differences: Basic vs. Token-Based Authentication

| Feature | Basic Authentication | Token-Based Authentication |
| :--- | :--- | :--- |
| **What's Sent** | Username & Password (on every request) | A temporary Token (on every request) |
| **State** | Stateless | Stateless (self-contained token) |
| **Security** | **Low** (exposes credentials repeatedly) | **High** (password sent only once) |
| **Expiration** | None | Yes (tokens are short-lived) |
| **Logout** | Difficult / No standard mechanism | Easy (delete the token) |
| **Data in "Proof"**| Just username/password | Can carry extra user data (roles, etc.)|
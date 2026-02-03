# Grant types
*   Grant is the flow that is implemented to get the token
*   There are different grant for different scenarios

---

#### Authorization Code Grant

*   often considered the "gold standard" of OAuth 2.0 flows
*   the most common grant type used because it provides the highest level of security
*   Designed for **Confidential Clients** (server side applications whom can securly store the credentials)
*   e.g.
    *   a service in the BE that needs to access a resource server
*   **Flow**
    1.  **Client** redirects the **User** to the **AS**.
    2.  **User** logs in and consents to scopes (permissions).
    3.  **AS** redirects the **User** back to the **Client** with a temporary **Code**.
    4.  **Client** takes that **Code** + its **Client Secret** and sends them to the **AS** (behind the scenes).
    5.  **AS** validates the Code and Secret, then returns the **Access Token**.
*   **Security Considerations**
    *   step 4 is required to prevent the token being stolen from the browser

---
#### Authorization Code Grant with PKCE

---
#### Implicit Grant *(Deprecated)*

---
#### Resource Owner Password Credentials Grant (ROPC)

---
#### Client Credentials Grant

---
#### Refresh Token Grant

---
#### Device Authorization Grant (RFC 8628)

---
#### Token Exchange Grant (RFC 8693)

---
#### JWT Bearer Assertion Grant (RFC 7523)

---
#### SAML 2.0 Bearer Assertion Grant (RFC 7522)
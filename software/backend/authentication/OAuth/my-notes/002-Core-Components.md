# Core Components

---

## Client Types
*   Client is the application that acts on behalf of the user to access resources

#### Confidential Clients
*   an application that is capable of maintaining the confidentiality of its credentials (password/secret)
*   No user or external entity can access the application's private storage
*   Lives in Server-side environments
*   Credentials are client id and client secret
*   Credentials are sent to the authorization server without high risk
*   **Typical Flows**
    *   Authorization Code Grant
    *   Client Credentials Grant

#### Public clients
*   an application that cannot keep a secret securely
*   If you put a "Client Secret" inside a public client, it is considered leaked immediately
*   the user will have access to the source code or binary
*   **Where it lives**
    *   Single Page Applications (SPAs)
    *   Native Mobile Apps
    *   Desktop Apps
*   **Authentication**
    *   cannot use a password to prove its identity
    *   it relies on **PKCE (Proof Key for Code Exchange)**.
        *   PKCE creates a temporary, dynamic secret for that one specific session, ensuring that the app starting the login flow is the same one finishing it.

#### Credentialed Clients
*   introduced mainly in the OAuth 2.1 draft
*   more details are in the ai notes

#### First-Party vs. Third-Party Clients
*   **First-Party Clients**
    *   These apps are owned by the same organization that controls the API (Resource server)
    *   Highly trusted
*   **Third-Party Clients**
    *   These apps are built by external developers and needs access to the API (Resource server)
    *   Low trust

#### Client Profiles
*   OAuth spec maps specific implementation patterns to the Client Types
---

## Client Registration

*   Before the client can ask the AS for authorization, it must introduce itself, in a process called **Client Registration**

#### Static Registration (Manual)
*   most common method
*   A developer logs into the administration console of the Authorization Server
*   developer manually fills out a form providing the app's name, logo, and allowed callback URLs
*   The server generates the credentials, the developer securly saves it and uses it in the client env variables
*   **Use cases**
    *   First-party applications
    *   when the number of clients is small and manageable

#### Dynamic Registration
*   applications register themselves programmatically via an API.
*   the client will send the required data and recieve the results via API instead of the form
*   a client can crud it's details using Dynamic Client Management (API calls also)
*   **Use cases**
    *   In complex ecosystems (like Open Banking or large SaaS federations)
    *   when manually registering thousands of clients is impossible (the clients will use the API to register themselves)

#### Registration Metadata
*   specific metadata describes how the client intends to behave.
*   e.g.
    *   **`client_name`**
    *   **`grant_types`**
    *   **`response_types`**
    *   **`token_endpoint_auth_method`**
    *   **`logo_uri`** / **`policy_uri`**

#### Client ID & Client Secret
*   credentials resulting from registration.
    *   **Client ID**
    *   **Client Secret**
        *   password
        *   should be stored securely
        *   should not be given to public clients (they can not keep secrets)

#### Redirect URI Registration
*    the location where the Authorization Server sends the user (and the sensitive codes/tokens) after they log in
*    during registration, the developer MUST tell the server exactly which URLs are allowed
*   When a standard OAuth flow starts, the client sends a `redirect_uri` parameter. The Authorization Server checks this against the pre-registered list.
*   **Why?** This prevents **Open Redirect Attacks**. Without pre-registration, an attacker could trick the flow into sending the user's access token to `https://evil-hacker.com/callback`.

---

## Tokens
*   tokens are digital keys that grant access to specific resources
*   They replace the user's actual username and password
    *   making it easy to revoke them without the need to change credentials
    *   they expire
    *   allow it to be shared

#### Access token
*   most critical component in OAuth 2.0.
*   it is the credential used by the Client to access a Protected Resource
*   the resource server checks this token to decide whether to let the request through.
*   **Characteristics**
    *   **Short lived**
        *   Usually valid for a short time
    *   **Scoped**
        *   represents a specific set of permissions (scopes) granted by the user (e.g., read:email).

#### Refresh token
*   If Access Tokens expire every 15 minutes, the user would have to log in and approve the app 4 times an hour. This is bad UX.
*   The Client uses the Refresh Token to get a new Access Token when the old one expires, without involving the user
*   **Characteristics**
    *   Never sent to the Resource Server
    *   Long-lived
    *   Strict Storage
        *   Because they are powerful and long-lived, they must be stored very securely

#### Token Types

*   **Bearer**
    *   Give access to the bearer of this token
*   **PoP (Proof of Possession):**
    *   The token is mathematically bound to a cryptographic key held by the Client
    *   The client must open it with it's private key
*   **DPoP (Demonstrating Proof of Possession):**
    *   It prevents **Token Replay Attacks** (where a stolen token is reused by an attacker).
 

#### Token Formats (Opaque vs. Structured)

*   **Opaque Tokens**
    *   The string means nothing to the API holding the data.
    *   The API must send it to the AS to validate it
    *   Good for security, it can be revoked easily
    *   Bad for performance, each request needs the AS approval

*   **Structured Tokens (JWT)**
    *   Usually a JSON Web Token (JWT)
    *   Long, encoded string containing data (claims)
    *   The token contains the data inside itself
    *   The API verifies the digital signature of the token locally using a public key
    *   Good for performance
    *   Bad for security 
        *   Hard to revoke
        *   Needs blacklist and short lived lifetime span


#### Token Lifetime & Expiration
*   Tokens do not last forever for security reasons.
*   **Access Token Lifetime**
    *   Kept short (seconds to minutes)
*   **Refresh Token Lifetime**
    *   Kept long (days to months)
        *   involves Rotation
            *   in some cases
                *   Every time a Refresh Token is used, the server issues a brand new Refresh Token and invalidates the old one
                *   If an attacker tries to use an old Refresh Token, the server detects theft and revokes everything.
*   When a token is issued, the response usually includes expires_in (seconds), allowing the client to calculate exactly when to ask for a new one.


#### Token Metadata
*   has some other info about the token
*   e.g.
    *   **token_type**
    *   **expires_in**
    *   **refresh_token**
    *   **scope**

---

## Scopes

*   mechanism used to limit an application's access to a user's account
*   They are the realization of the Principle of Least Privilege ensuring that an app only has the access it needs to perform its function, and nothing more.

    
#### What are Scopes?

*   scope is a parameter that defines the specific permissions or access rights a Client application is requesting from the Resource Owner
*   When an application asks to connect to your Google or Facebook account, it doesn't usually get the "keys to the castle" (full administrative control). Instead, it asks for specific permissions


#### Scope Design Patterns
*   **Resource-Based (Granular)**
    *   This pattern combines an action with a resource
    *   e.g.
        *   `read:orders` (View order history)
        *   `write:orders` (Create a new order)
        *   `delete:orders` (Cancel an order)
*   **Service-Based (Broad)**
    *   This gives access to a whole functional area or service
    *   e.g.
        *   `calendar` (Full access to the calendar)
        *   `drive` (Full access to file storage)

*   **Role-Based (Administrative)**
    *   e.g.
        *   `admin`
        *   `moderator`


#### Scope Naming Conventions
*   There is no strict rule in the RFC regarding naming, but consistency is vital for security and developer experience.
*   **Common Formats**
    *   **Colon-separated**
        *   e.g.
            *   `read:user`
            *   `write:database`
    *   **Dot-separated**
        *   e.g.
            *   `read.user`
            *   `write.database`
    *   **Simple Strings**
        *   e.g.
            *   `email`
            *   `profile`
    *   **URIs (Common in Enterprise)**
        *   e.g.
            *   `https://graph.microsoft.com/User.Read`
            *   `https://graph.microsoft.com/User.Database`


#### Requesting Scopes
*   When the Client initiates the authorization flow, it includes a scope query parameter in the URL sent to the Authorization Server.
*   The scopes are a space-delimited list. In the URL above, %20 represents the space



#### Scope Consent
*   Once the server receives the request above, it authenticates the user and presents a Consent Screen.
*   the final scope is what the user accepted



#### Downscoping
*   Downscoping is the process of exchanging an existing token for a new token that has fewer permissions
*   you will do it if you want to limit the privileges of existing tokens



#### Upscoping
*   is the process of exchanging an existing token for a new token that has higher permissions





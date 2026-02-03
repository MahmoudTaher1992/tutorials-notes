# Client Authentication
*   is the process where the **Client Application** (not the user) proves its identity to the Authorization Server.
*   happens at the **Token Endpoint** when exchanging an Authorization Code for an Access Token.


---

### The Methods (Detailed Breakdown)

#### `none` (Public Clients)
#### `client_secret_basic` (The Standard)
*   uses standard HTTP Basic Authentication.

#### `client_secret_post`
*   credentials are sent in the body of the request rather than the header.

#### `client_secret_jwt` (RFC 7523)
*   This method allows the client to use a shared secret without sending the actual secret over the wire.
*   the client creates a JWT and signs it with the client secret, the server can verify the signiture and authenticate the client

#### `private_key_jwt` (RFC 7523) - **High Security**

#### `tls_client_auth` (Mutual TLS / mTLS - RFC 8705)

#### `self_signed_tls_client_auth` (RFC 8705)


---

### Choosing Authentication Methods
*   This decision relies on the "Client Profile" (where the code runs) and the security requirements of the data being accessed.


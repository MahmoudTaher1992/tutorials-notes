# Authorization Server Endpoints
*   endpoints that are used to communicate with the authorization server

---

### Authorization Endpoint

*   the "front door" of the OAuth 2.0 flow
*   the URL where the Client Application sends the user (Resource Owner) to log in and grant permissions.
*   other API endpoints can be on http (from server to server), but this needs to be https because it is send to the browser
*   accessed via the User Agent (Browser).


#### Purpose & Behavior
*   The primary purpose of this endpoint is to separate the Client from the User's credentials, instead of the User typing their password into the Client App, they are redirected to the Authorization Server


#### Response Modes
*   **Query Mode (Default for `response_type=code`)**
*   **Fragment Mode (Default for `response_type=token`)**
*   **Form Post Mode (`response_mode=form_post`)**


#### User Interaction & Consent
*   here the user enters the password and accept the consents


#### Error responses
*   If the request fails, the Authorization Server usually redirects back to the redirect_uri with an error parameter in the query string.


---

### The Token Endpoint

*   backend engine room of OAuth
*   Token Endpoint involves a direct, machine-to-machine exchange between the Client Application and the Authorization Server.

...



---

### Redirect URI / Callback Endpoint

*   Redirect URI often referred to as the Callback URL
*   serves as the bridge that safely transports the User (Resource Owner) back from the Authorization Server to the Client Application after authentication is complete

...



---

### Revocation Endpoint

*   tokens (Access Tokens and Refresh Tokens) have a set lifetime
*   there are scenarios where permission needs to be removed immediately before the natural expiration time
*   The Revocation Endpoint allows a Client to notify the Authorization Server that a specific token is no longer needed and should be invalidated.



...



---

### Introspection Endpoint

*   allows a Resource Server (API) or a client to query the Authorization Server to determine the active state of an OAuth 2.0 token and to determine its meta-information.
*   Opaque Tokens (random strings) must be validated by asking the server that issued them

...



---

### Device Authorization Endpoint

*   addresses a specific problem: Input-Constrained Devices
*   smart devices lack a browser or a keyboard (e.g., Smart TVs, Gaming Consoles, IoT devices, Printers, or Command Line Interface (CLI) tools).
*   This endpoint allows the device to initiate an authorization request without launching a browser
*   it instructs the user to use a secondary device (like a smartphone or laptop) to complete the login process.

...



---

### Pushed Authorization Request (PAR) Endpoint

*   In standard OAuth 2.0 flows (like the Authorization Code Grant), the client application starts the process by constructing a URL with many query parameters (`scope`, `response_type`, `redirect_uri`, `state`, etc.) and redirecting the user's browser to that URL.
*   **The Pushed Authorization Request (PAR) Endpoint** changes this approach. Instead of sending these parameters via the browser URL (the Front Channel), the Client sends them directly to the Authorization Server via an HTTP POST request (the Back Channel).
*   In exchange, the Authorization Server gives the Client a short reference code (called a `request_uri`). The Client then redirects the user to the Authorization Server using *only* that reference code.
*   **why**
    *   URL Length Limitations
    *   Security & Privacy (Data Leakage)
    *   Integrity
    *   

...

---

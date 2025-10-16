# Cookie-Based Authentication

*   **Core Concept**:
    *   **stateful** authentication method
    *   the server creates and maintains a user's session after they log in
    *   uses an HTTP cookie to identify that session on subsequent requests

## The Step-by-Step Flow

*   **1. User Login** using his credentials
*   **2. Server Verification & Session Creation**
    *   The server validates credentials
    *   The server creates a **unique session** for that user
    *   The server uses **Session Storage** to save the session info in
        *   server memory
        *   database
        *   In memory database, Redis
*   **3. Cookie Response**
    *   The server sends a response back with
        *   `Set-Cookie` directive, which tells the browser to store a cookie
        *   The Cookie  contains the session id
*   **4. Subsequent Requests**
    *   For every future request the user makes to the same website, the browser **automatically** attaches the session cookie to the request header.
*   **5. Server-Side Validation**
    *   The server validates the cookie on it's measures (expiry, validity, ...), and replies accordingly.
*   **6. User Logout**
    *   sending a request to the server
    *   The server **destroys the session** from its session store
    *   The server sends a response to the browser with a `Set-Cookie` header that effectively tells the browser to delete the cookie.

## Security

We will focus on how to control the browser's behavior with the cookie, because it is the one controlling it.

*   **HttpOnly Flag**
    *   `HttpOnly` flag on a cookie will make the browser not give the cookie to any javascript code, even the programmer can't access it from the code.
    *   If a malicious JavaScript code is injected into the website **[Cross-Site Scripting (XSS)]**, the script won't be able to read the cookie
*   **Secure Flag**
    *   The browser is guided to not send the cookie over http, it sends it only though https
    *   prevents it being intercepted in an unencrypted traffic.
*   **SameSite Attribute**
    *   Prevents the browser from sending the cookie if another website running on the client sends a request to the targeted server
    *   **Cross-Site Request Forgery (CSRF)**
        *   happens when a foreign website sends a request to a targeted website
        *   the browser sends the cookie with it
    *   **Options:**
        *   `SameSite=Strict`: 
            *   The cookie is only sent if the request originates from the exact same site. 
            *   This is the most secure but can break some navigation links.
        *   `SameSite=Lax`: [A good balance. The cookie is sent on top-level navigation (e.g., clicking a link to go to the site) but not on sub-requests (like loading images or submitting forms) from other sites.]
            *   Happens when you navigate to the targeted website
                *   In this action, the request is originated from the foreign site
                *   If you set `SameSite=Strict`, the cookie won't be sent
                *   `SameSite=Lax` lets you pass this small step
        *   `SameSite=None`
            *   The cookie will be sent with every request, no matter where it came from.


## Pros and Cons

*   **Pros**
    *   Automatic & Simple
    *   **Server Control**:
        *   The server can invalidate a session at any time
    *   **Small Request Size**:
        *   The cookie contains the session id only
        *   The server will get all the info from the session storage
*   **Cons**
    *   **Stateful Scalability Issues**: [In a distributed system with multiple servers, every server needs access to the session store. This requires either "sticky sessions" (always sending a user to the same server) or a centralized session database (like Redis), which adds complexity.]
        *   If you have multiple backend servers and you store the sessions on the server itself
            *   Server A will not know about sessions stored in Server B
            *   **Solution**
                *   Shared storage
                *   Sticky sessions, where a router will route the request the server that holds it's session info
    *   **CSRF Vulnerability**: If `SameSite=None`
    *   **Not Ideal for Non-Browser Clients**:
        *   Mobile apps and other non-browser services don't have a built-in "cookie jar." While they can be made to work with cookies

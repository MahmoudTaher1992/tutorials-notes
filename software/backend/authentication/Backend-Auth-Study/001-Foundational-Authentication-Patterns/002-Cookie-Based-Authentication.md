Based on the study plan provided, here is a detailed explanation of **Files 001/002: Cookie-Based Authentication**.

This pattern is the traditional way authentication was handled on the web for decades. To understand it, you must understand the concept of **"Stateful"** authentication.

---

### **1. How It Works (The "Stateful" Workflow)**

In this model, the "truth" about who is logged in is stored on the **Server**, not the device.

Here is the step-by-step flow:

1.  **Login:** The user sends their credentials (username/password) to the server.
2.  **Session Creation:** If the credentials are correct, the server creates a **Session Record** in its memory or database.
    *   *Example:* The server writes down: "Session ID `abc-123` belongs to User `John Doe`."
3.  **The Cookie:** The server responds to the browser with a specific HTTP Header: `Set-Cookie: session_id=abc-123`.
4.  **Browser Storage:** The browser receives this header and automatically stores the cookie.
5.  **Subsequent Requests:** For **every** future request the user makes to that website (e.g., clicking "Profile" or "Feed"), the browser **automatically** actively attaches that cookie to the request headers.
6.  **Validation:** The server reads the cookie, looks up `abc-123` in its database, finds it belongs to John Doe, and authorizes the request.

#### **The "Coat Check" Analogy**
Think of a coat check at a museum:
*   **You give your coat (Credentials):** The attendant takes it and hangs it up in a back room (The Server Database).
*   **You get a ticket (The Cookie):** The ticket has a number on it (Session ID). The ticket itself is plastic; it has no value other than matching the number on the coat hanger.
*   **Retrieval:** When you want your coat, you hand over the ticket. The attendant looks up the number and gives you the coat.

---

### **2. Use Case: Traditional Monolithic Applications**

Cookie-based authentication is the default for "Monoliths." Without getting too technical, a **Monolith** is an application where the Frontend (what you see) and the Backend (logic/database) are hosted in the same codebase (e.g., WordPress, Django, Ruby on Rails, older Java Spring apps).

**Why it is used here:**
*   **Simplicity:** Browsers handle cookies automatically. The developer doesn't have to write JavaScript code to store or send the token; the browser just does it.
*   **Server Control:** Because the "State" is stored on the server, the server has total control. If an admin wants to ban a user, they simply delete the session from the database. The user is instantly logged out (the cookie becomes useless immediately).

---

### **3. Security Focus: The "Flags"**

Because cookies are sent automatically by the browser, they are vulnerable to specific attacks. To secure them, developers must set specific **Flags** (attributes) on the cookie.

The study plan highlights four critical security concepts:

#### **A. HttpOnly (Protection against XSS)**
*   **The Attack:** Cross-Site Scripting (XSS). If a hacker manages to inject malicious JavaScript into your site, that script could read `document.cookie` and steal the user's Session ID.
*   **The Defense:** Setting the `HttpOnly` flag tells the browser: *"Do **not** allow JavaScript to read this cookie. Only send it in HTTP requests to the server."*
*   **Result:** Even if a hacker injects a script, they cannot steal the session cookie.

#### **B. Secure (Protection against Sniffing)**
*   **The Attack:** Man-in-the-Middle. If a user is on public WiFi and logs in over plain HTTP (not HTTPS), a hacker can intercept the traffic and see the cookie.
*   **The Defense:** Setting the `Secure` flag tells the browser: *"Only send this cookie if the connection is encrypted (HTTPS)."*

#### **C. SameSite (Protection against CSRF)**
*   **The Attack:** Cross-Site Request Forgery (CSRF). 
    *   Imagine you are logged into your bank (Bank.com). The bank uses cookies.
    *   You visit a malicious site (Evil.com).
    *   Evil.com has a hidden button that sends a POST request to `Bank.com/transfer-money`.
    *   Because your browser automatically sends cookies to Bank.com, the request succeeds, and you lose money.
*   **The Defense:** The `SameSite` flag (set to `Lax` or `Strict`).
*   **Result:** This tells the browser: *"Do not send this cookie if the request is coming from a different website (like Evil.com)."*

---

### **Summary of Pros and Cons**

| Feature | Cookie-Based (Stateful) |
| :--- | :--- |
| **State** | **Stateful:** Server remembers active users. |
| **Complexity** | **Low:** Browsers handle the heavy lifting. |
| **Revocation** | **Easy:** Server simply deletes the session data; user is logged out instantly. |
| **Scalability** | **Harder:** If you have 5 servers, they all need to share the session data (usually requires Redis). |
| **Mobile Apps** | **Difficult:** Mobile apps don't handle cookies as natively as browsers; tokens are preferred. |

Based on the Table of Contents you provided, here is a detailed explanation of **Part II, Section B: Hypertext Transfer Protocol (HTTP)**.

---

# B. Hypertext Transfer Protocol (HTTP)

## 1. Foundation of the World Wide Web
HTTP is the underlying protocol used by the World Wide Web. It defines how messages are formatted and transmitted, and what actions Web servers and browsers should take in response to various commands.
*   **Concept:** If the Internet is the physical infrastructure (roads), HTTP is the set of traffic rules and trucking system that moves the cargo (websites, images, videos) from one place to another.
*   **Usage:** Whenever you type `http://` or `https://` in your browser, you are commanding your computer to speak this specific language.

## 2. Client-Server Model and Request-Response Cycle
HTTP functions on a request-response model. It involves two distinct parties:
*   **The Client (User Agent):** Usually a web browser (Chrome, Firefox) or a mobile app. The client **initiates** the conversation.
*   **The Server:** A powerful computer storing the website files (HTML, CSS, Database data). The server **listens** and waits for requests.

**The Cycle:**
1.  **Request:** The Client sends a message saying, "I want to see the home page of google.com."
2.  **Processing:** The Server receives the request, finds the necessary files, and runs any necessary logic.
3.  **Response:** The Server sends a message back containing the data (the webpage) or an error message.

## 3. HTTP Methods (The Verbs)
When a client makes a request, it must tell the server *what* it wants to do with the resource. These are called "Methods" or "Verbs."
*   **GET:** Used to **retrieve** data. (e.g., Opening a webpage, viewing an image). This is the most common method. It should not change any data on the server.
*   **POST:** Used to **submit** data to be processed to a specified resource. (e.g., Submitting a signup form, uploading a file). This changes the state of the server (new database entry).
*   **PUT:** Used to **update** or replace a current resource with uploaded content.
*   **DELETE:** Used to **remove** a specific resource.
*   **HEAD:** Same as GET, but asks the server to return only the headers (meta-info), not the actual body content. Useful for checking if a link is broken without downloading the whole page.

## 4. HTTP Status Codes
Every time a server responds to a client, it includes a 3-digit number indicating the result of the request.
*   **1xx (Informational):** "Request received, continuing process." (Rarely seen by users).
*   **2xx (Success):** The action was successfully received and understood.
    *   **200 OK:** The standard response for successful HTTP requests.
*   **3xx (Redirection):** Further action must be taken to complete the request.
    *   **301 Moved Permanently:** The page has moved to a new URL forever.
*   **4xx (Client Error):** The request contains bad syntax or cannot be fulfilled.
    *   **400 Bad Request:** The server didn't understand what you sent.
    *   **403 Forbidden:** You are not allowed to view this.
    *   **404 Not Found:** The resource you asked for doesn't exist.
*   **5xx (Server Error):** The server failed to fulfill an apparently valid request.
    *   **500 Internal Server Error:** Generic "server crashed" message.
    *   **502 Bad Gateway:** One server received an invalid response from another upstream server.

## 5. HTTP Headers: Metadata
Headers are key-value pairs sent at the beginning of a request or response. They provide "metadata" (data about the data). They are invisible to the user looking at the webpage but vital for the browser.
*   **Request Headers (Client to Server):**
    *   `User-Agent`: Tells the server what browser/OS you are using.
    *   `Accept-Language`: Tells the server you prefer English/Spanish/etc.
    *   `Host`: Specifies the domain name (e.g., www.example.com).
*   **Response Headers (Server to Client):**
    *   `Content-Type`: Tells the browser what kind of file is coming (e.g., `text/html` or `application/json`).
    *   `Server`: Info about the server software (e.g., Apache, Nginx).
    *   `Set-Cookie`: Tells the browser to save a cookie.

## 6. Stateless Nature and the Role of Cookies
**HTTP is "Stateless":** This means the server treats every single request as a brand new transaction, completely independent of previous requests. The server has no memory.
*   *The Problem:* If you log in to Facebook, then click "Messages," the server doesn't remember you just logged in. It would ask you to log in again for every single click.

**The Solution (Cookies):** To create a "stateful" experience (keeping you logged in), we use Cookies.
1.  You log in.
2.  The server verifies you and sends a response header (`Set-Cookie`) containing a unique ID (Session ID).
3.  Your browser saves this small text file.
4.  **Crucial Step:** For *every* subsequent request you make to that site, your browser automatically sends that Cookie back to the server.
5.  The server reads the Cookie, recognizes the ID, and knows "Ah, this is the user who logged in 5 minutes ago."

## 7. Evolution: HTTP/1.1 vs HTTP/2 vs HTTP/3
The protocol has evolved to make the web faster.

*   **HTTP/1.1 (1997):**
    *   **Text-based:** Humans can read the raw commands.
    *   **Sequential:** It loads resources one by one. If one large image gets stuck, everything behind it waits (Head-of-Line Blocking).
*   **HTTP/2 (2015):**
    *   **Binary:** Transfers data in binary code (1s and 0s) rather than text, making it more efficient for computers to parse.
    *   **Multiplexing:** It can send multiple files (HTML, CSS, JS, Images) simultaneously over a *single* connection. It solves the "Head-of-Line Blocking" issue found in 1.1.
    *   **Server Push:** The server can send files the browser hasn't asked for yet but will need soon (e.g., sending the CSS file along with the HTML).
*   **HTTP/3 (Recent/Current):**
    *   **QUIC Protocol:** Instead of using TCP (which is reliable but heavy), HTTP/3 runs over **UDP** (which is fast).
    *   **Better for Mobile:** It handles switching networks (like moving from Wi-Fi to 5G) much better than previous versions without dropping connections.
    *   **Reduced Latency:** Faster handshake times to establish a secure connection.

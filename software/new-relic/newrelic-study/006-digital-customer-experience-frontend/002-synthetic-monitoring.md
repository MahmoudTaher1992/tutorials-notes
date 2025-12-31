This section falls under **Digital Customer Experience (Frontend)** because, unlike APM (which monitors the backend server code), **Synthetic Monitoring** simulates the user's experience from the "outside in."

While Browser Monitoring (RUM) tracks *actual* humans visiting your site, **Synthetics** creates *robot* users that visit your site at scheduled intervals to ensure everything is working, even at 3 AM when no real users are online.

Here is a detailed breakdown of each concept in section **VI.B**:

---

### 1. Ping Monitors (Availability)
This is the simplest and cheapest form of monitoring.
*   **What it does:** It sends a simple request (usually an HTTP `HEAD` or `GET` request) to a specific URL.
*   **The Check:** It simply asks, "Is this server responding with a `200 OK` success code?"
*   **Use Case:** Ideal for simple "Uptime" checks. It answers: *Is my website down completely?*
*   **Limitation:** A page might return a `200 OK` status but display a completely blank white screen due to a JavaScript error. A Ping monitor will say everything is fine, even though the site is broken for users.

### 2. Simple Browser Monitors
A step up from Ping monitors.
*   **What it does:** Instead of just pinging the server, New Relic spins up a real Google Chrome browser instance and actually loads the URL.
*   **The Check:** It measures the full page load time. It executes the HTML, CSS, and basic JavaScript.
*   **Use Case:** checking the performance of a specific landing page.
*   **Advantage:** It gives you better metrics than Ping (like "First Paint" or "Page Load Time") but doesn't interact with elements on the page.

### 3. Scripted Browser Monitors (Selenium/WebDriver JS)
This is the most powerful tool in the Synthetics arsenal. It tests **Functionality** and **Critical Business Paths**.
*   **The Technology:** It uses **Selenium WebDriver** running in a Node.js environment. You write a script in JavaScript.
*   **What it does:** It simulates a complex user flow. The script instructs the browser to:
    1.  Go to `login.php`.
    2.  Find the username box and type "TestUser".
    3.  Find the password box and type the password.
    4.  Click the "Submit" button.
    5.  Wait for the dashboard to load.
    6.  Verify that the text "Welcome, TestUser" exists.
*   **Use Case:** E-commerce checkouts, Login portals, and Sign-up forms. If your checkout button is broken, a Ping monitor won't catch it, but a Scripted Browser monitor will fail and alert you immediately.

### 4. API Tests
Sometimes you don't need to test the visual UI (HTML/CSS), but you need to ensure your backend API is working.
*   **What it does:** It uses a Node.js script (using libraries like `got` or `http-request`) to hit your API endpoints directly.
*   **The Check:** It sends JSON payloads to your API and validates the JSON response.
    *   *Example:* Send `{ "id": 1 }` to `/api/get-user`. Assert that the response contains `"name": "Alice"`.
*   **Use Case:** Testing microservices, validating 3rd party integrations, or checking mobile app backends. These run much faster than Browser monitors because they don't have to load images or render CSS.

### 5. Secure Credentials in Scripts
When writing **Scripted Browser** or **API Tests**, you often need to log in.
*   **The Problem:** You should never hardcode passwords or API keys in your script text (e.g., `const password = "SuperSecretPassword123"`). If someone with "Read-Only" access views your script in New Relic, they would see your secrets.
*   **The Solution:** New Relic provides a **Secure Credentials** store.
    1.  You save the password in the Secure Credentials UI and give it a key (e.g., `TEST_USER_PASSWORD`).
    2.  New Relic encrypts it.
    3.  In your script, you reference it using `$secure.TEST_USER_PASSWORD`.
*   **Result:** The script runs successfully, but no human can see the actual password string.

### 6. Private Minions (Private Locations)
By default, New Relic Synthetics run from "Public Locations" (New Relic servers located in AWS/GCP regions like US-East, London, Tokyo, etc.).
*   **The Problem:** What if you want to test an internal employee portal (Intranet) that is behind a corporate firewall? Or a Staging environment that isn't accessible to the public internet? Public New Relic servers cannot reach these URLs.
*   **The Solution:** **Private Minions**.
*   **How it works:**
    1.  You download a **Containerized Private Minion (CPM)** (a Docker image).
    2.  You run this Docker container on a server *inside* your own private network/intranet.
    3.  This Minion reaches out to New Relic and asks, "Do you have any jobs for me?"
    4.  New Relic sends the script to your Minion.
    5.  The Minion runs the test inside your private network and sends the results back to New Relic.
*   **Use Case:** Testing pre-production environments (QA/Staging) or internal tools.

---

### Summary Table

| Monitor Type | Checks For... | Complexity | Example |
| :--- | :--- | :--- | :--- |
| **Ping** | Availability (Is it online?) | Low | Is `google.com` up? |
| **Simple Browser** | Page Load Performance | Medium | How long does the Homepage take to load? |
| **Scripted Browser** | Functionality (User flows) | High | Can a user successfully buy a t-shirt? |
| **API Test** | Data/Backend logic | Medium/High | Does the `/login` API return the correct token? |

### Why is this important?
If you only use **RUM (Real User Monitoring)**, you only know your site is broken when a *real* user complains or leaves. **Synthetics** allows you to be **Proactive**—you (the engineer) find out the checkout is broken at 4:00 AM via an alert, and you fix it before the customers wake up at 8:00 AM.

Based on the Table of Contents provided, here is a detailed explanation of **Part VI, Section C: Mobile Monitoring**.

---

# Part VI - C: Mobile Monitoring

In the context of New Relic, **Mobile Monitoring** is the practice of embedding a New Relic "Agent" (SDK) into your iOS, Android, or Hybrid (React Native, Flutter, Xamarin) applications.

Unlike server-side code (APM) where you control the environment, mobile code runs on thousands of different devices, OS versions, and network conditions that you do not control. This section focuses on how to gain visibility into that chaotic environment.

Here is the breakdown of the three key pillars listed in your TOC:

---

### 1. Crash Analysis and Interaction Tracing

This is usually the first reason developers install New Relic Mobile.

#### Crash Analysis
A "Crash" occurs when the application encounters a fatal error and the Operating System (iOS/Android) kills the process. This is the worst possible user experience.

*   **Crash Occurrences:** New Relic tracks how many times the app crashed and affects the "Crash-Free Session Rate" (a key KPI for mobile teams).
*   **Stack Traces:** When a crash happens, New Relic captures the code path.
    *   *Key Concept - Symbolication:* Mobile code is often obfuscated (minified) to protect IP and reduce size. A raw crash log looks like gibberish (`0x00045f`). **Symbolication** (uploading dSYM files for iOS or ProGuard/R8 maps for Android) is the process New Relic uses to translate that gibberish back into readable file names and line numbers (`LoginController.swift: line 42`).
*   **Impact Analysis:** You can see if a crash is specific to:
    *   A specific device (e.g., "Only happens on iPhone 14 Pro").
    *   A specific OS version (e.g., "Only on Android 13").
    *   A specific App version (e.g., "Did we break this in v2.1?").

#### Interaction Tracing
If "Crash Analysis" tells you when the app dies, **Interaction Tracing** tells you why the app is **slow**.

*   **The "Why":** Mobile apps are event-driven (User taps button -> App does work -> Screen updates). If that process takes too long, the UI freezes (ANR - Application Not Responding).
*   **The Trace:** An Interaction Trace automatically instruments the start and end of a user action.
    *   *Example:* A user taps "Checkout." The trace records:
        1.  The UI thread handling the tap.
        2.  The application logic execution.
        3.  The database read on the phone.
        4.  The network call to Stripe/PayPal.
        5.  The UI updating with "Success."
*   **Optimization:** This allows you to see exactly which method or network call is freezing the UI.

---

### 2. HTTP Requests and Network Errors

Mobile apps are rarely standalone; they almost always talk to a backend server. This section monitors the health of those connections.

#### HTTP Requests (The "Happy" Path & Server Errors)
New Relic intercepts network calls (using libraries like `OkHttp` on Android or `URLSession` on iOS).
*   **Response Time:** How long did the user wait for the API to reply?
*   **Throughput:** How many calls are being made? (Are you accidentally DDoS-ing your own server with a retry loop?)
*   **Status Codes:** Tracking 4xx (Client Errors) and 5xx (Server Errors).
*   **Backend Correlation:** If you also have New Relic APM on your backend, New Relic adds a header (`W3C Trace Context`) to the mobile request. This allows you to click a slow request in the *Mobile* view and jump directly to the *Backend* trace to see why the server was slow.

#### Network Errors (The "Unhappy" Path)
This is distinct from HTTP 500 errors. A Network Error means the request **never reached the server** or the connection failed.
*   **DNS Failures:** The phone couldn't resolve the domain name.
*   **TCP/Connection Failures:** The signal dropped, or the user went into an elevator.
*   **Secure Connection Failures:** SSL/TLS handshake issues (common when certificates expire).

---

### 3. Handled Exceptions vs. Crashes

Understanding the difference between these two is vital for triage.

#### Crashes (Fatal)
*   **Definition:** The app stops working entirely. The user is kicked to the home screen.
*   **Detection:** The New Relic agent catches this automatically via OS hooks.
*   **Severity:** Critical.

#### Handled Exceptions (Non-Fatal)
*   **Definition:** The app encounters an error, but the developer wrote a `try/catch` block to handle it. The app continues running, but perhaps a feature didn't work (e.g., the user tried to upload a photo, it failed, and the app showed a "Try Again" toast message).
*   **Detection:** These are **not** captured automatically by default because the app didn't crash. You must manually add code to send these to New Relic.
*   **Implementation:**
    *   *Android:* `NewRelic.recordHandledException(Exception e)`
    *   *iOS:* `NewRelic.recordError(error)`
*   **Why Monitor This?** Even though the app didn't crash, a spike in handled exceptions usually means a feature is broken. If 100% of "Photo Uploads" are failing but handled gracefully, your users are still frustrated even if the app hasn't "crashed."

---

### Summary NRQL Context
In **Part V** of your study path, you will learn NRQL. To tie this back to Mobile, here is how the data looks in the database:

*   `MobileCrash`: Contains data about fatal crashes.
*   `MobileRequest`: Contains data about every HTTP call (URL, duration, status code).
*   `Mobile`: Contains session data and interaction traces.
*   `MobileHandledException`: Contains the non-fatal errors.

**Example Query:**
*"Show me the breakdown of crashes by Device Type for the last week."*
```sql
SELECT count(*) FROM MobileCrash FACET deviceName SINCE 1 week ago
```

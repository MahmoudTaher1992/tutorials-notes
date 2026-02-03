Here is a detailed explanation of **Section 25: Pushed Authorization Request Endpoint (RFC 9126)** based on your study guide table of contents.

---

# 025. Pushed Authorization Request (PAR) Endpoint

## 1. What is the PAR Endpoint?

In standard OAuth 2.0 flows (like the Authorization Code Grant), the client application starts the process by constructing a URL with many query parameters (`scope`, `response_type`, `redirect_uri`, `state`, etc.) and redirecting the user's browser to that URL.

**The Pushed Authorization Request (PAR) Endpoint** changes this approach. Instead of sending these parameters via the browser URL (the Front Channel), the Client sends them directly to the Authorization Server via an HTTP POST request (the Back Channel).

In exchange, the Authorization Server gives the Client a short reference code (called a `request_uri`). The Client then redirects the user to the Authorization Server using *only* that reference code.

### The Real-World Analogy
Think of the standard OAuth flow like walking onto an airplane carrying all your luggage (parameters) in your hands. It’s heavy, people can see what you are carrying, and you might drop something.

**PAR** is like the "Check-in Desk." You hand your luggage to the airline agent *before* you go to the gate. They give you a **Bag Tag** (the `request_uri`). When you walk to the gate (the redirect), you only carry your boarding pass and the bag tag.

---

## 2. Why was PAR created? (The Problems it Solves)

The traditional method of putting authorization parameters in the URL query string has several major flaws:

1.  **URL Length Limitations:** Browsers and servers have limits on how long a URL can be (often around 2048 characters). If a client needs to request detailed scopes, fine-grained permissions (RAR), or specific ID Token claims, the URL might be too long and get truncated.
2.  **Security & Privacy (Data Leakage):** Parameters stuck in the URL are visible in browser history, proxy logs, and `Referer` headers. PII (Personally Identifiable Information) inside a request could be exposed.
3.  **Integrity:** A malicious user could technically tamper with the URL parameters in the browser address bar before hitting enter (e.g., removing a scope or changing the redirect URI).
4.  **Delayed Validation:** In the standard flow, the Authorization Server doesn't see the request parameters until the user lands on the login page. If the configuration is wrong (bad Redirect URI), the user sees an error *after* the redirect.

PAR solves all of these by moving the data to a secure back-channel HTTPS POST.

---

## 3. How the PAR Flow Works

Here is the step-by-step interaction:

### Step A: The Client "Pushes" the Request
Instead of redirecting the user immediately, the Client makes a direct HTTP POST request to the **PAR Endpoint**. This request is authenticated (if the client is confidential).

**Request Example:**
```http
POST /as/par HTTP/1.1
Host: authorization-server.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW (Client Credentials)

client_id=s6BhdRkqt3
&response_type=code
&redirect_uri=https://client.example.com/cb
&scope=openid email profile
&state=af0ifjsldkj
&code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM
&code_challenge_method=S256
```

### Step B: The Server Validates and Responds
The Authorization Server authenticates the client and validates the parameters immediately. If everything looks good, it stores the parameters and issues a `request_uri` (a reference key) and an expiration time (usually short, e.g., 60 seconds).

**Response Example:**
```json
HTTP/1.1 201 Created
Content-Type: application/json

{
  "request_uri": "urn:ietf:params:oauth:request_uri:6c38w5b7-7756-4293-87a4-56943a884357",
  "expires_in": 60
}
```

### Step C: The Client Redirects the User
Now the client redirects the user's browser to the **Authorization Endpoint**, but the URL is now very clean.

**Redirect URL:**
```http
https://authorization-server.com/authorize?client_id=s6BhdRkqt3&request_uri=urn:ietf:params:oauth:request_uri:6c38w5b7-7756-4293-87a4-56943a884357
```

The Authorization Server looks up the saved parameters using the `request_uri` and proceeds with the login/consent screen as usual.

---

## 4. Key Benefits Details

### 1. Integrity / Anti-Tampering
Because the parameters are sent directly from the Client's backend to the Auth Server's backend over HTTPS, the user (transiting via the browser) cannot tamper with the `scope` or `redirect_uri` in the middle of the flow. This essentially provides the benefits of Signed Requests (JAR) without the complexity of managing JWT signatures.

### 2. Early Client Authentication
In the standard flow, the Auth Server doesn't know *who* the client is until the Token Exchange step (usually). With PAR, the client authenticates immediately during the POST request. If the credentials are bad, the flow stops before the user is even disrupted.

### 3. Support for Complex Scopes (RAR)
With the introduction of **Rich Authorization Requests (RAR)**, authorization data is becoming complex JSON objects rather than simple space-separated strings. PAR handles these large payloads easily because HTTP POST bodies have no practical size limit, unlike URLs.

---

## 5. Security Considerations & Best Practices

1.  **Short Expiration:** The `request_uri` should be short-lived (e.g., 60 seconds). It is intended for immediate use.
2.  **One-Time Use:** Ideally, the Authorization Server should invalidate the `request_uri` as soon as it is used.
3.  **Binding:** The `request_uri` is bound to the `client_id` that created it. No other client should be able to use that URI.
4.  **Mandatory for Security Profiles:** High-security profiles, such as **FAPI (Financial-grade API)**, often mandate the use of PAR to prevent authorization request tampering.

## Summary Comparison

| Feature | Standard Authorization Request | Pushed Authorization Request (PAR) |
| :--- | :--- | :--- |
| **Data Transport** | Front Channel (Browser URL Query Params) | Back Channel (HTTP POST body) |
| **Limit** | ~2048 characters (URL length limit) | Unlimited (Body size) |
| **Privacy** | Parameters visible in logs/history | Parameters hidden between servers |
| **Integrity** | Vulnerable to user tampering in URL | Tamper-proof (sent server-to-server) |
| **Validation** | Validated after user redirect | Validated immediately |
| **Complexity** | Low | Medium (requires extra HTTP call) |

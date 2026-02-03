Here is a detailed explanation of **Section 067: Testing OAuth Implementations**.

Testing OAuth is notoriously difficult because it involves complex redirects, external system dependencies (Google, Okta, etc.), time-sensitive data (token expiration), and strict security requirements.

This section covers how to break down testing into manageable layers to ensure your OAuth integration is robust, secure, and user-friendly.

---

## 1. Unit Testing Strategies

Unit tests focus on the smallest pieces of logic within your application, isolated from the network or external providers.

### **What to Unit Test:**
Since you cannot hit the actual OAuth endpoints in a unit test, you test the **logic** responsible for handling the flow:

*   **State Generation & Validation:**
    *   *Test:* verify that your state generator produces a random string of sufficient length.
    *   *Test:* verify that the logic checks the returned `state` parameter against the stored state and throws an error if they mismatch (CSRF protection).
*   **PKCE (Proof Key for Code Exchange) Logic:**
    *   *Test:* Verify that the `code_verifier` is hashed correctly (using SHA-256) to produce the `code_challenge`.
    *   *Test:* Ensure the `code_challenge` matches the Base64URL-encoding standard (e.g., replacing `+` with `-` and `/` with `_`).
*   **Token Parsing:**
    *   If using JWTs, strictly test the *parsing* logic (extracting the payload) separately from signature verification.
    *   *Test:* Provide a malformed token string and ensure the app handles the error gracefully without crashing.
*   **Scope Logic:**
    *   *Test:* Functions that check permissions (e.g., `hasScope('admin')`) should be tested with tokens containing various scope combinations.

### **Technique: Dependency Injection**
To unit test the code that normally makes HTTP requests (like exchanging the code for a token), inject a "Mock HTTP Client" that returns a pre-defined JSON response (e.g., `{ "access_token": "mock-token" }`) instead of making a real network call.

---

## 2. Integration Testing

Integration tests verify that different modules of your application start working together correctly. This often involves the browser (or a browser emulator) and the interaction between your frontend and backend.

### **The Challenge:**
Standard integration tests struggle with OAuth because **you cannot automate logging into a real provider** (like Google or Facebook) easily. They have CAPTCHAs, 2FA, and bot detection.

### **Integration Scenarios to Cover:**
1.  **The Happy Path:**
    *   User clicks "Login".
    *   App redirects to the correct URL (verify the `client_id`, `scope`, and `redirect_uri` parameters in the constructed URL).
    *   App accepts a callback (simulated) with a valid code.
    *   App successfully establishes a session.
2.  **The Sad Paths (Error Handling):**
    *   **Access Denied:** Simulate the user clicking "Cancel" on the consent screen. The provider returns `error=access_denied`. Does your app show a polite error message or crash?
    *   **Network Failure:** What happens if the token endpoint is down? To test this, you simulate a network timeout when the app tries to exchange the authorization code.
3.  **Token Refresh Logic:**
    *   This is the most critical integration test.
    *   *Setup:* Manually inject an access token into the system that expires in 1 second.
    *   *Action:* Make an API call.
    *   *Expectation:* The system should catch the 401 error, use the Refresh Token to get a new Access Token, retry the request, and succeed—all invisible to the user.

---

## 3. Mocking Authorization Servers

To run end-to-end (E2E) tests in a CI/CD pipeline (like Jenkins or GitHub Actions), you cannot rely on production identity providers. You need a fake server that behaves like an OAuth provider.

### **Why Mock?**
*   **Speed:** Real providers introduce network latency.
*   **Cost/Limits:** providers throttle requests; running 1,000 tests might block your IP.
*   **Determinism:** You need to force specific scenarios (e.g., "return an expired token now") which you can't control on a real provider like Google.

### **Approaches to Mocking:**

#### **A. Network-Level Mocking (e.g., Nock, WireMock, MSW)**
You intercept the outgoing HTTP requests at the network layer.
*   *Setup:* "If the app calls `POST https://auth.provider.com/token`, return `{...}` immediately."
*   *Pros:* Extremely fast.
*   *Cons:* Doesn't test the actual browser redirect mechanics.

#### **B. Containerized Mock Servers**
You spin up a lightweight Docker container that acts as a real OIDC/OAuth provider.
*   **Common Tools:**
    *   **Keycloak (Docker):** Full-featured but heavy.
    *   **Hydra (Ory):** Good for testing standard flows.
    *   **Mock implementations:** Simple Node.js/Python scripts that listen on port 3000 and implement the minimal endpoints (`/authorize` and `/token`).
*   HOW IT WORKS:
    1.  The test suite configures the app to use `http://localhost:3000` (the mock) instead of `https://accounts.google.com`.
    2.  The mock server is configured to auto-approve requests (skip the consent screen).
    3.  Selenium/Cypress drives the browser to click "Login", the redirect hits localhost, returns instantly, and the test continues.

---

## 4. Conformance Testing

Conformance testing is mostly relevant if you are building **servers**, **libraries**, or highly complex **gateways**, rather than just consuming an API.

### **What is it?**
It is a formal process to prove that an implementation strictly adheres to the RFC standards (RFC 6749, OpenID Connect Core, etc.).

### **Why is it important?**
*   **Interoperability:** Ensures your library works with *any* compliant provider, not just the one you tested firmly.
*   **Security:** Conformance suites run specific "negative tests" (e.g., sending an authorization code twice, sending mix-matched redirect URIs) to ensure your server rejects them.

### **Tools:**
*   **OpenID Foundation Conformance Suite:** The gold standard. It acts as a "Test Client" or "Test Provider" and bombards your implementation with hundreds of test cases (e.g., checking if you enforce SSL, checking if you strip whitespace from scopes).
*   **OIDC Certification:** If you pass the suite, you can officially certify your product.

---

### **Summary Checklist for Developers**

If you are implementing OAuth in an app, verify this list before shipping:

1.  **Unit Tests:** Validate state generation and PKCE hashing.
2.  **Mock Tests:** Use `nock` or `MSW` to test how your app handles 401s and token refreshes.
3.  **E2E Tests:** Use Cypress/Playwright with a mock provider to ensure the login redirect loop works for the user.
4.  **Security Check:** Manually verify that changing the `redirect_uri` in the browser URL bar causes the server to reject the request.

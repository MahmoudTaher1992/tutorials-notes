Based on the file path (`001-Foundations/002-OAuth-2.0-Overview.md`) and the content provided, this text represents a **comprehensive curriculum or syllabus** for a developer to master OAuth 2.0 and its successor, OAuth 2.1.

This is not just a definition list; it is a structured **learning roadmap**. It takes a bottom-up approach, starting with definitions and ending with operational maintenance.

Here is a detailed breakdown of what this study guide covers, organized by the logical phases of learning:

### Phase 1: The "What" and "Why" (Parts 1 & 2)
The guide begins by laying the groundwork. It assumes the reader might confuse "Authorization" (what you are allowed to do) with "Authentication" (who you are).
*   **Key Concept:** It differentiates OAuth 2.0 (the standard framework) from OAuth 2.1 (a cleanup of the standard that removes insecure patterns).
*   **Roles:** It defines the four main players in any OAuth flow:
    *   **Resource Owner:** The user.
    *   **Client:** The app the user is using.
    *   **Auth Server:** The system checking the password (e.g., Google, Auth0).
    *   **Resource Server:** The API having the data (e.g., Gmail API).

### Phase 2: The Core Mechanics (Parts 3, 4, 5, 6)
This section explains the nuts and bolts of how data moves.
*   **Grants (Flows):** This is the most critical part for developers. It details *how* an app gets permission.
    *   **The Gold Standard:** **Authorization Code Flow with PKCE** (Proof Key for Code Exchange). This is now the recommended flow for almost all applications (Mobile, SPA, Web).
    *   **The Deprecated:** It explicitly marks **Implicit Grant** and **Password Grant** as "Deprecated." This indicates the guide follows modern security best practices (you should not use these anymore).
    *   **Machines & IoT:** It covers **Client Credentials** (backend-to-backend) and **Device Flow** (Smart TVs).
*   **Endpoints:** It explains the specific URLs applications must hit (e.g., the `authorize` endpoint to log in, the `token` endpoint to get the access key).

### Phase 3: Security & OAuth 2.1 (Parts 7 & 8)
This is the modern "value add" of this study guide. It moves beyond the original 2012 specification (RFC 6749) and addresses modern threats.
*   **Threat Model:** It explains common attacks like CSRF (Cross-Site Request Forgery), token leakage, and interception.
*   **OAuth 2.1:** It dedicates a section to the new OAuth 2.1 spec. The main takeaway here is **consolidation**. OAuth 2.1 doesn't add radical new features; it takes best practices (like mandatory PKCE and removing Implicit Grant) and makes them the strict standard.

### Phase 4: Advanced Scenarios (Part 9)
This covers high-security requirements, often needed in Banking (Open Banking) or Healthcare.
*   **FAPI (Financial-grade API):** Higher security standards for financial data.
*   **mTLS (Mutual TLS):** Binding a token to a specific client certificate so stolen tokens cannot be reused by hackers.
*   **DPoP (Demonstrating Proof of Possession):** A newer method to ensure the person using the token is the same person to whom it was issued (preventing token replay attacks).

### Phase 5: Architecture & Implementation (Parts 10, 11, 12, 13)
This shifts from "theory" to "engineering." It explains how to actually code this.
*   **Client Side:** How to handle tokens in React/Angular (SPAs), iOS/Android (Mobile), and CLI tools.
*   **Server Side:** How to build an Authorization Server (if you are crazy enough to build your own) or a Resource Server (API) that validates tokens.
*   **Storage:** Where to keep tokens securely (e.g., `ASWebAuthenticationSession` on iOS, verify signatures vs. introspection).

### Phase 6: Operations (Parts 14 & 15)
The lifecycle of OAuth in production.
*   **Key Rotation:** How to change signing keys without breaking user logins.
*   **Revocation:** How to ban a specific user or token instanty.
*   **Compliance:** SOC 2, GDPR, and audit logging.

### Summary of What You Will Learn
If you study this full document, you will understand:
1.  **How to choose the right flow:** (e.g., "I'm building a Mobile App, so I must use Auth Code with PKCE").
2.  **How to secure your API:** Validating JWTs and handling scopes.
3.  **Modern Standards:** Why you should stop using the Implicit Grant and how to migrate to OAuth 2.1 terms.
4.  **Security Risks:** How to prevent hackers from stealing Access Tokens or Refesh Tokens.

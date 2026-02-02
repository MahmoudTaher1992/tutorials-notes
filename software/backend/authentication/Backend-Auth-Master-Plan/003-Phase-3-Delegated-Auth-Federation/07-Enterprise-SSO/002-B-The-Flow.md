Based on the content of **Section 7 (Enterprise SSO)** in your Engineering Master Plan, here is a detailed explanation of **002-B: The Flow**.

This section defines the actual mechanics of how a user logs into a third-party application (like Slack or Salesforce) using their corporate credentials (like Active Directory or Okta) via the SAML 2.0 protocol.

---

# 07-Enterprise-SSO / 002-B-The-Flow

In the world of Enterprise Identity, "The Flow" refers to the sequence of HTTP requests and redirects that pass between the user, the application they want to access, and the system that holds their password.

SAML (Security Assertion Markup Language) is unique because the **Server (SP)** and the **Identity Provider (IdP)** never talk to each other directly. They talk *through* the user's browser using redirects.

### The Actors (Recap)
Before looking at the steps, remember the roles:
1.  **User (Principal):** The employee using a browser.
2.  **Service Provider (SP):** The app (e.g., AWS, Jira, Salesforce).
3.  **Identity Provider (IdP):** The source of truth (e.g., Okta, Entra ID/Azure AD).

There are two distinct ways this flow can start.

---

## 1. SP-Initiated SSO (The "Pull" Model)
**This is the most common and secure method.**
*Analogy:* You walk up to a nightclub (SP). The bouncer stops you and says, "Go to the front office (IdP), show your ID, and bring me back a stamped ticket."

### The Pattern:
The user tries to access the application *first*, without being logged in.

### Step-by-Step Visualization:

1.  **Access Attempt:** The User attempts to access a protected resource (e.g., `https://jira.corp-domain.com`).
2.  **Redirect to IdP:** The SP detects the user is not logged in. It generates a **SAML Request** (an XML document asking "Who is this person?"). The SP redirects the user's browser to the IdP, carrying this request (usually encoded in the URL).
3.  **Authentication:** The User hits the IdP login page.
    *   *Note:* If the user is already logged into the IdP (e.g., they logged into email 5 minutes ago), this step happens silently in the background.
    *   If not, they type their username/password/MFA here.
4.  **The Assertion:** The IdP verifies the credentials. It generates a **SAML Response** (containing the **SAML Assertion**).
    *   The IdP **digitally signs** this XML with its **Private Key**.
5.  **Redirect to SP:** The IdP passes this giant XML string back to the user's browser, usually via an auto-submitting HTML form (POST request), targeting the SP's "Assertion Consumer Service" (ACS) URL.
6.  **Verification:** The SP receives the POST request. It extracts the XML, validates the signature using the IdP's **Public Key** (which it stored previously), and logs the user in.

### Why use this?
*   It supports "Deep Linking." If a user clicks a link to a specific Jira ticket in an email, SP-Initiated SSO ensures they land on that specific ticket after logging in, rather than the generic homepage.

---

## 2. IdP-Initiated SSO (The "Push" Model)
**This is often used for Corporate Dashboards.**
*Analogy:* You start at the front office (IdP), show your ID, get a stamped ticket, and then walk over to the nightclub (SP) and hand them the ticket to get in.

### The Pattern:
The user logs into their corporate portal first, looks at a list of icons (Zoom, Slack, AWS), and clicks one.

### Step-by-Step Visualization:

1.  **Login to Dashboard:** The User logs into the IdP (e.g., `my.okta.com`).
2.  **Click App:** The User clicks the "Salesforce" icon on the dashboard.
3.  **Generation:** The IdP immediately generates a **SAML Assertion** for Salesforce. (Notice: Salesforce never asked for it).
4.  **Redirect:** The IdP redirects the user's browser to Salesforce (SP) via HTTP POST, carrying the Assertion.
5.  **Verification:** Salesforce receives the Assertion, validates the signature, and creates a session for the user.

### The Risks (Why is this controversial?)
IdP-Initiated SSO is generally considered **less secure** due to the risk of **Man-in-the-Middle (MitM) / Session Fixation attacks**.

*   Since the SP never asked for the login (it didn't generate a request ID), it is harder for the SP to verify that the login flow started recently or legitimately.
*   An attacker could theoretically capture a stolen SAML assertion and "force" a user into a session controlled by the attacker (though modern Short-Lived Tokens mitigate this).
*   *Note:* Historically, the `InResponseTo` field in the SAML XML is used to match a Response to a Request. In IdP-Initiated flows, this field is empty (or ignored), removing one layer of validation checks.

---

## Summary Comparison

| Feature | SP-Initiated | IdP-Initiated |
| :--- | :--- | :--- |
| **Starting Point** | The Application (e.g., Slack.com) | The Corp Dashboard (e.g., Okta) |
| **SAML Request?** | Yes, SP sends a request XML. | No, IdP sends unsolicited response. |
| **Deep Linking** | Supported (User lands on specific page). | Not naturally supported (User lands on homepage). |
| **Security** | High (Request/Response ID matching). | Lower (No Request ID to validate). |
| **Use Case** | Daily workflow (Bookmarks, Email links). | "I need to find a tool I rarely use." |

### Engineering Takeaway
When implementing SAML in your backend:
1.  **Always prefer SP-Initiated.**
2.  If you *must* support IdP-Initiated (because clients demand it), ensure you have strict validation on the standard `RelayState` parameter and strictly enforce timestamp expiration (`NotOnOrAfter` conditions) in the XML to prevent replay attacks.

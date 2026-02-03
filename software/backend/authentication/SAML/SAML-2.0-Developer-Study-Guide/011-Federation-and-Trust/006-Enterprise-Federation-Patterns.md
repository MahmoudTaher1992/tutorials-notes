Based on **Part 11: Federation & Trust** of your Table of Contents, here is a detailed explanation of section **71. Enterprise Federation Patterns**.

This section moves beyond the raw protocol (SAML XML) and focuses on the **architectural strategies** enterprises use to solve specific business problems using Identity Federation.

---

# 71. Enterprise Federation Patterns

In an enterprise context, federation is not "one size fits all." The architecture changes depending on *who* is logging in (Employees? Customers? Partners?) and *where* they are logging into.

Here are the four primary patterns detailed:

## 1. Partner Federation (B2B)
**Scenario:** Two distinct organizations need to share resources. For example, a Supply Chain company (Organization A) needs access to a restocking portal hosted by a Manufacturing company (Organization B).

*   **The Architecture:**
    *   **Trust Relationship:** A bilateral (direct) trust is established between Org A and Org B.
    *   **IdP:** Org A (The Partner) acts as the Identity Provider. They manage their own users.
    *   **SP:** Org B (The Resource Owner) acts as the Service Provider.
*   **Key Characteristics:**
    *   **Lifecycle Delegation:** Org B does not generate usernames/passwords for Org A's employees. If an employee leaves Org A, Org A disables their account, and access to Org B is immediately revoked.
    *   **Attribute Mapping:** Org A might send an attribute `role="Senior_Buyer"`. Org B must map this to its internal permission `group="Inventory_Manager"`.
*   **SAML Specifics:**
    *   Includes specific **AudienceRestrictions** to ensure assertions meant for the restocking portal aren't used elsewhere.
    *   Often utilizes **Just-In-Time (JIT) Provisioning** to create accounts in Org B's system the first time a user logs in.

## 2. Customer Identity Federation (B2C / CIAM)
**Scenario:** A company provides a service to public consumers (e.g., a bank, a utility company, or a healthcare provider) and wants to let them log in using an external identity (like a government ID or a social login).

*   **The Architecture:**
    *   **IdP:** Often a Government ID provider (e.g., Gov.UK Verify, SingPass) or a Social Identity Provider (Google, Facebook - though these usually use OIDC, they can be bridged to SAML).
    *   **SP:** The Enterprise Application.
*   **Key Characteristics:**
    *   **Scale:** This pattern must handle millions of users, unlike B2B or B2E.
    *   **Privacy & Consent:** The federation flow must often include specific screens asking the user for permission to share specific attributes (e.g., "Do you allow the IdP to send your Social Security Number to this Service?").
    *   **Security Assurance:** In banking/gov scenarios, the SAML Assertion often contains an **AuthnContextClassRef** indicating a high "Level of Assurance" (LoA), proving the user used MFA or hardware tokens.

## 3. Workforce Federation (B2E - Business to Employee)
**Scenario:** The most common pattern. Employees log in to a central dashboard (Okta, Azure AD, Ping) to access dozens of third-party SaaS applications (Salesforce, Slack, Zoom, Workday).

*   **The Architecture:**
    *   **Hub-and-Spoke Model:**
        *   **Hub (IdP):** The Corporate Directory (e.g., Microsoft Entra ID).
        *   **Spokes (SP):** The external SaaS applications.
*   **Key Characteristics:**
    *   **Centralized Control:** The enterprise wants a "Kill Switch." If an employee is fired, the admin disables them in one place (the IdP), and they lose access to all 50 SaaS apps instantly.
    *   **SSO Experience:** The goal is friction reduction. Users sign in once at the start of the day and access all apps without seeing login screens again.
*   **SAML Specifics:**
    *   Heavily relies on **IdP-Initiated SSO** (User clicks an icon on their corporate dashboard) and **SP-Initiated SSO** (User goes directly to Slack.com, enters email, and gets redirected to corporate login).

## 4. Multi-Tenant SaaS Federation
**Scenario:** You are a software vendor (e.g., you built a project management tool). You want to sell your software to large enterprises (Customer A, Customer B, Customer C), and *each* customer wants to log in using their *own* corporate IdP.

*   **The Architecture:**
    *   **SP:** Your Application (The SaaS).
    *   **IdPs:** Customer A's AD, Customer B's Okta, Customer C's Shibboleth.
*   **Key Challenges:**
    *   **Realm Discovery (The "NASCAR Problem"):** When a user arrives at your login page, you don't know who they work for. You cannot show "Log in with Google" next to "Log in with Customer A."
        *   *Solution:* The user enters their email first (`alice@customer-a.com`). Your app detects the domain `@customer-a.com`, looks up the specific SAML configuration for Customer A, and redirects them to Customer A’s IdP.
    *   **Tenant Isolation:** You must ensure that an Assertion signed by Customer A's IdP never grants access to Customer B's data within your app.
    *   **Metadata Management:** The SaaS provider must manage dynamic metadata for thousands of different IdP connections simultaneously.

---

### Summary Table

| Pattern | Primary Actor | IdP Role | SP Role | Primary Goal |
| :--- | :--- | :--- | :--- | :--- |
| **Partner (B2B)** | Business Partner | The Partner Org | The Resource Owner | Resource sharing without managing external passwords. |
| **Customer (B2C)** | Public User | Social or Gov ID | The Enterprise | Ease of access and high-volume identity verification. |
| **Workforce (B2E)** | Employee | Corporate Directory | 3rd Party SaaS | Centralized security, "Kill Switch," and User Experience. |
| **Multi-Tenant SaaS** | SaaS Vendor | The Client's Corporate IT | The Vendor's Software | Selling software to enterprises that demand SSO. |

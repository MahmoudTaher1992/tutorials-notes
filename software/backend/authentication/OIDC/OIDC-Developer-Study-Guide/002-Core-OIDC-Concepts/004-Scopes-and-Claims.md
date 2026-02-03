Based on your Table of Contents, here is a detailed explanation of **Section 7: Scopes & Claims**. This is a fundamental concept in OpenID Connect because it controls **what data** an application is allowed to access about a user.

---

# 002-Core-OIDC-Concepts / 004-Scopes-and-Claims

To understand this section, we first need to distinguish between the two terms:

1.  **Scopes:** These are **permissions** or "groupings" of data. The Client *requests* Scopes.
2.  **Claims:** These are the **actual pieces of information** (attributes) about the user (e.g., email, first name, User ID). The Provider *returns* Claims.

**The Golden Rule:** You request **Scopes** to get **Claims**.

---

## 1. OIDC Standard Scopes

In standard OAuth 2.0, scopes are arbitrary strings defined by the API (e.g., `read:photos`). However, OIDC standardizes specific scopes so that all Identity Providers (Google, Okta, Auth0, etc.) behave largely the same way.

There are 5 standard OIDC scopes:

### A. The `openid` Scope (Mandatory)
*   **Purpose:** This is the switch that turns OAuth 2.0 into OpenID Connect.
*   **Effect:** If you do not include `scope=openid` in your authorization request, the server will treat it as a standard OAuth request and **will not** issue an ID Token.
*   **Claims Returned:** Usually just the `sub` (Subject/User ID).

### B. The `profile` Scope
*   **Purpose:** Requests access to the user's default profile information.
*   **Claims Returned:** `name`, `family_name`, `given_name`, `middle_name`, `nickname`, `preferred_username`, `profile` (url), `picture`, `website`, `gender`, `birthdate`, `zoneinfo`, `locale`, and `updated_at`.

### C. The `email` Scope
*   **Purpose:** Requests access to the user's email address and verification status.
*   **Claims Returned:** `email`, `email_verified`.

### D. The `address` Scope
*   **Purpose:** Requests access to the user's physical postal address.
*   **Claims Returned:** `address` (which is a JSON object containing street, locality, region, postal code, country).

### E. The `phone` Scope
*   **Purpose:** Requests access to the user's telephone number.
*   **Claims Returned:** `phone_number`, `phone_number_verified`.

---

## 2. Scope to Claims Mapping

One of the most important concepts for a developer is knowing *where* these details appear.

When you request a scope (e.g., `scope=openid profile email`), the Identity Provider (IdP) looks at that list and decides which claims to release.

**Mapping Table:**

| Scope Requested | Claims typically released |
| :--- | :--- |
| **openid** | `sub` (Subject ID), `iss` (Issuer), `aud` (Audience), `exp`, `iat` |
| **profile** | `name`, `given_name`, `family_name`, `picture`, `nickname`, etc. |
| **email** | `email`, `email_verified` |
| **phone** | `phone_number`, `phone_number_verified` |
| **address** | `formatted`, `street_address`, `locality`, `region`, `postal_code`, `country` |

### Important Implementation Detail (ID Token vs. UserInfo)
To keep the **ID Token** small, Identity Providers often do not put *all* the claims inside the token itself.

1.  **Minimalist Approach:** The IdP puts the `sub` (User ID) in the ID Token.
2.  **Retrieval:** The Client app then uses the **Access Token** to call the **UserInfo Endpoint**.
3.  **Result:** The UserInfo Endpoint looks at the scopes the user approved and returns the full JSON of claims (email, picture, address, etc.).

---

## 3. Requesting Specific Claims (The Standard Way)

The standard way to request claims is simply by adding space-separated strings to your authorization URL.

**Example Request URL:**
```http
GET /authorize?
  response_type=code
  &client_id=my-client-id
  &redirect_uri=https://my-app.com/callback
  &scope=openid profile email
```

In this example, the Client is asking for:
1.  OIDC functionality (`openid`)
2.  Profile data (`profile`)
3.  Email address (`email`)

---

## 4. The `claims` Parameter (Advanced)

Sometimes, the standard scopes aren't precise enough. You might want to:
1.  Request a specific claim that doesn't belong to a standard scope.
2.  Mark a claim as **essential** (meaning the login should fail or prompt the user specifically if that data isn't available).

OIDC allows you to pass a JSON object in a query parameter called `claims`.

**Structure of the `claims` parameter:**
You can target claims to appear specifically in the **ID Token** or the **UserInfo** response.

**Example JSON to encode:**
```json
{
  "id_token": {
    "auth_time": { "essential": true }
  },
  "userinfo": {
    "email": { "essential": true },
    "custom_claim_membership_level": { "value": "gold" }
  }
}
```

*   **Essential:** Tells the IdP, "I really need the user's email; please ask the user for it if they haven't provided it."
*   **Value:** Can act as a filter (e.g., "I only want to authenticate users who have 'gold' membership").

*Note: Not all Identity Providers support the granular `claims` parameter. Standard scopes are supported by everyone; the `claims` parameter is an advanced feature primarily used in complex enterprise or banking (FAPI) scenarios.*

---

## Summary of Section 7

*   **Scopes** are the keys you use to ask for data categories.
*   **Claims** are the user data values you get back.
*   **`openid`** is the mandatory scope for OIDC.
*   The **standard scopes** (`profile`, `email`, `address`, `phone`) map to specific sets of standard claims.
*   For complex requirements, developers can use the **`claims` request parameter** to ask for specific data or mark fields as essential.

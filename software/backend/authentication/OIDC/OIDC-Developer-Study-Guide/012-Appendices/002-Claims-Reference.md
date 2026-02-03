Based on the Table of Contents you provided, **Appendix B: Complete Claims Reference** is designed to be a dictionary or "cheat sheet" regarding the specific data fields (key-value pairs) inside an ID Token or UserInfo response.

In OpenID Connect (OIDC), a **"Claim"** is simply a piece of information asserted about an entity (usually the user).

Here is a detailed explanation of what is contained in that reference section, categorized by how they are used.

---

### 1. Registered Claims (Token Metadata)
These claims are technical fields required by the OIDC and JWT (JSON Web Token) specifications. They tell your application **how to handle the token itself**, rather than telling you about the user.

| Claim | Full Name | Type | Description |
| :--- | :--- | :--- | :--- |
| **`iss`** | Issuer | String (URL) | The URL of the Identity Provider that created the token (e.g., `https://accounts.google.com`). Your app **must** verify this matches your configuration. |
| **`sub`** | Subject | String | **The most important claim.** This is the unique User ID. It is intended for machines, not humans (e.g., `auth0|5f7c3...`). It is unique within the Issuer. |
| **`aud`** | Audience | String (Array) | Who this token is intended for. This usually contains your application's `client_id`. |
| **`exp`** | Expiration Time | Number | Unix timestamp. After this time, the token must be rejected. |
| **`iat`** | Issued At | Number | Unix timestamp of when the token was created. |
| **`nonce`**| Number Used Once | String | A random string sent by your client during the request and returned in the token to prevent replay attacks. |
| **`azp`** | Authorized Party | String | Used when the Client ID is different from the Audience. |
| **`auth_time`**| Auth Time | Number | When the user actually performed the login action (useful for sensitive apps that require recent re-authentication). |

---

### 2. Standard User Attributes (Profile Scope)
When your application requests the `profile` scope, the Identity Provider returns these standard claims about the user.

| Claim | Type | Description |
| :--- | :--- | :--- |
| **`name`** | String | Full name in displayable form (e.g., "Jane Doe"). |
| **`given_name`** | String | First name (e.g., "Jane"). |
| **`family_name`** | String | Last name / Surname (e.g., "Doe"). |
| **`middle_name`** | String | Middle name(s). |
| **`nickname`** | String | Casual name. |
| **`preferred_username`** | String | Shorthand name used for login (e.g., "jdoe99"). **Note:** Do not use this as a primary key; use `sub` instead. |
| **`profile`** | String (URL) | URL to the user's profile page. |
| **`picture`** | String (URL) | URL to the user's avatar image. |
| **`website`** | String (URL) | Web page or blog URL. |
| **`gender`** | String | End-user's gender. |
| **`birthdate`** | String | ISO 8601 format (YYYY-MM-DD) or just year (0000-YYYY). |
| **`zoneinfo`** | String | Time zone string (e.g., `America/Los_Angeles`). |
| **`locale`** | String | Locale string (e.g., `en-US`, `fr-CA`). |
| **`updated_at`** | Number | Timestamp of when the user's information was last changed. |

---

### 3. Contact Claims (Email & Phone Scopes)
These are returned when requesting `email` or `phone` scopes.

| Claim | Scope | Type | Description |
| :--- | :--- | :--- | :--- |
| **`email`** | `email` | String | The user's email address. |
| **`email_verified`** | `email` | Boolean | `true` if the IDP has verified this email belongs to the user. **Crucial for security** if you are linking accounts. |
| **`phone_number`** | `phone` | String | Recommended E.164 format (e.g., `+1 (425) 555-1212`). |
| **`phone_number_verified`** | `phone` | Boolean | `true` if the phone number has been verified. |

---

### 4. Address Claim (Address Scope)
The `address` claim is unique because it is a **JSON Object**, not just a string.

**Claim:** `address`
**Internal Structure:**
*   `formatted`: Full mailing address formatted for display.
*   `street_address`: Street info.
*   `locality`: City or locality.
*   `region`: State, province, or region.
*   `postal_code`: Zip code.
*   `country`: Country name.

---

### 5. Context & Assurance Claims (Advanced)
These claims refer to the *context* of the login, not the user attributes.

*   **`acr` (Authentication Context Class Reference):** Indicates how securely the user authenticated. For example, a value of `0` might mean "anonymous", while `2` might mean "two-factor authentication was used."
*   **`amr` (Authentication Methods References):** An array listing specific methods used, e.g., `["pwd", "otp", "face"]` (Password, One Time Password, Face ID).

---

### Example: What a Decoded ID Token Looks Like
If you looked at this Appendix in the guide, it would likely conclude with a full JSON example combining these claims:

```json
{
  "iss": "https://server.example.com",
  "sub": "24400320",
  "aud": "s6BhdRkqt3",
  "nonce": "n-0S6_WzA2Mj",
  "exp": 1311281970,
  "iat": 1311280970,
  "auth_time": 1311280969,
  "acr": "urn:mace:incommon:iap:silver",
  
  "name": "Jane Doe",
  "given_name": "Jane",
  "family_name": "Doe",
  "email": "janedoe@example.com",
  "email_verified": true,
  "picture": "https://example.com/jdoe/me.jpg"
}
```

### Why developers need this Appendix?
1.  **Mapping:** When setting up a database, developers need to know exactly which fields (like `given_name` vs `name`) the OIDC Provider sends so they can map them to their user tables.
2.  **Validation:** Developers need to know the data types (Boolean vs String) to prevent parsing errors.
3.  **Security:** Understanding `email_verified` and `sub` is critical to prevent account takeover vulnerabilities.

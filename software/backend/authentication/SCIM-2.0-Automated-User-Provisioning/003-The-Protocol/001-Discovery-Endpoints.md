Based on the content structure you provided, here is a detailed, engineering-focused explanation of **Section 3.A: Discovery Endpoints (The Handshake)**.

***

# 3.A. Discovery Endpoints (The Handshake)

In the SCIM protocol, before an Identity Provider (like Okta, Azure AD, or OneLogin) attempts to create or update a user in your application, it performs a **"Handshake."**

It does not assume your API supports every feature of the massive SCIM specification. Instead, it queries these three "Discovery Endpoints" to learn the rules of engagement.

> **Engineering Tip:** If you are building a SCIM server, these endpoints are often static JSON responses. You generally just hardcode them, but they **must** exist, or the IdP will refuse to connect.

Here is the breakdown of the three critical endpoints:

---

## i. `/ServiceProviderConfig` (The Capabilities Flag)

**Purpose:** This tells the IdP what features your API supports. It acts like a feature-flag configuration file.

When the Client checks this endpoint, it dictates the logic the Client uses for future requests.

### Key Attributes Defined Here:
1.  **PATCH Support (`patch`):**
    *   *Question:* "Can I send partial updates?"
    *   *Impact:* If you return `true`, when a user's department changes, the IdP sends a small JSON patch. If `false`, the IdP must send the *entire* User object again via `PUT` to update one field.
2.  **Bulk Support (`bulk`):**
    *   *Question:* "Can I send 1,000 users in a single HTTP request?"
    *   *Impact:* Essential for initial onboarding. If you support this, you must define `maxOperations` (e.g., "Don't send more than 100 at a time") and `maxPayloadSize`.
3.  **Filter/Sort (`filter` and `sort`):**
    *   *Question:* "Can I search for users by email (`filter`)? Can I ask for the list alphabetically (`sort`)?"
    *   *Impact:* If you don't support filtering, reconciliation is almost impossible because the IdP cannot check if a user already exists before trying to create them.

**Example Response Snippet:**
```json
{
  "patch": {
    "supported": true
  },
  "bulk": {
    "supported": false,
    "maxOperations": 0,
    "maxPayloadSize": 0
  },
  "filter": {
    "supported": true,
    "maxResults": 200
  },
  "authenticationSchemes": [
    {
      "name": "OAuth Bearer Token",
      "description": "Authentication using Bearer Header",
      "type": "oauthbearertoken"
    }
  ]
}
```

---

## ii. `/ResourceTypes` & `/Schemas` (The Data Structure)

These two endpoints work together to define **Discovery of Data**.

### 1. `/ResourceTypes` (The Map)
This serves as the high-level routing map. It tells the IdP exactly which API endpoints map to which SCIM definitions.

*   **What it says:** "I have a resource called **User**. You can find it at endpoint `/Users`, and the definition of a User is found in the Schema ID `urn:ietf:params:scim:schemas:core:2.0:User`."
*   **Why it helps:** If your API uses a different endpoint naming convention (rare, but allowed), this is where you declare it.

### 2. `/Schemas` (The Blueprint)
This is the low-level dictionary. It defines every single attribute available for a resource, valid data types, and mutability.

*   **Attributes defined per field:**
    *   **`type`**: String, Boolean, Integer, Binary, etc.
    *   **`mutability`**:
        *   *readOnly:* The IdP can see it but not change it (e.g., `id`, `meta.created`).
        *   *readWrite:* Standard fields (e.g., `nickName`).
        *   *writeOnly:* Explicitly used for things like `password`.
    *   **`required`**: Whether the request fails if this is missing.
    *   **`uniqueness`**: Must this be unique across the system? (e.g., `userName`).

**Why is `/Schemas` powerful?**
Some generic SCIM clients (like "Generic SCIM" in Okta) are capable of **Dynamic UI Generation**. If you add a custom attribute in your `/Schemas` response called `favoriteColor`, the IdP can read that schema and automatically generate a "Favorite Color" text box in their admin panel for you to map data into without any code changes on their side.

---

## Summary of the Flow

When an Admin clicks "Connect" on the IdP side, the traffic flow usually looks like this:

1.  **GET /ServiceProviderConfig**: "Do you support PATCH and Bulk? Also, how many results can I request at once?"
2.  **GET /ResourceTypes**: "Where do I POST users to?" (Answer: `/Users`)
3.  **GET /Schemas**: " What fields does a User have? Is 'Department' required?"
4.  **GET /Users?filter=userName eq "alice"**: "Does Alice already exist?" (Based on the config saying Filter is supported).
5.  **POST /Users**: "Okay, Alice doesn't exist. Here is the create request."

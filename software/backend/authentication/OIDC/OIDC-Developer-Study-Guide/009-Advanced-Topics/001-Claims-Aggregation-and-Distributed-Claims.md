Based on Part 9, Item 31 of your Table of Contents, here is a detailed explanation of **Claims Aggregation and Distributed Claims** in OpenID Connect (OIDC).

---

# Advanced Topics: Claims Aggregation and Distributed Claims

In a standard OIDC flow, the OpenID Provider (OP) holds all the user's data (email, name, profile picture) and sends it to the Relying Party (RP/Client) inside an ID Token or via the UserInfo endpoint.

However, in complex real-world scenarios—such as banking, healthcare, or government ecosystems—a single Identity Provider usually does not have *all* the data about a user. For example, a bank (the OP) knows your name, but an external Credit Bureau implies your credit score.

OIDC solves this using **Claims Aggregation** and **Distributed Claims**. These allow an OP to point the Client to data strictly held by third parties (called **Claims Providers** or Attribute Providers).

## The Mechanism: `_claim_names` and `_claim_sources`

Before looking at the two specific types, you must understand how OIDC signals that claims are coming from elsewhere. It uses two special JSON fields in the UserInfo response or ID Token:

1.  **`_claim_names`**: A map that tells the Client: *"I returned this claim, but look in the sources section to find the actual value."*
2.  **`_claim_sources`**: A map defining where to find the data or the actual signed data packet.

---

## 1. Aggregated Claims

In the **Aggregated Claims** model, the OpenID Provider (OP) acts as a specialized courier. It fetches the data from the external source, but it does **not** claim to own it. It passes the data specifically signed by the third party to the Client.

### How it works:
1.  **Collection:** The OP receives a signed JSON Web Token (JWT) from an external Claims Provider (e.g., a Credit Bureau).
2.  **Embedding:** The OP embeds this signed JWT inside the ID Token (or UserInfo response) it sends to the Client.
3.  **Verification:** The Client receives the token. It trusts the **OP** for the user's identity, but it verifies the signature of the **Claims Provider** to trust the specific data (e.g., credit score).

### The JSON Structure
Here is what the Client sees in the payload:

```json
{
  "iss": "https://my-bank.com",
  "sub": "user-123",
  
  // 1. "credit_score" maps to source "src1"
  "_claim_names": {
    "credit_score": "src1"
  },

  // 2. "src1" contains the data
  "_claim_sources": {
    "src1": {
      // This is a JWT signed by the Credit Bureau, NOT the Bank
      "JWT": "eyJhbGciOiJSUzI1Ni... (signed content: {"credit_score": 750}) ..."
    }
  }
}
```

### Use Case
You verify your identity with a Government ID portal. The portal also wants to assert your "Driver's License Status," which is held by the DMV authentication server. The Government Portal grabs a signed token from the DMV and hands it to the requestor so the requestor knows the data came authentically from the DMV.

---

## 2. Distributed Claims

In the **Distributed Claims** model, the OpenID Provider (OP) acts as a directory service. It does not touch the data at all. Instead, it tells the Client: *"I don't have this data, but here is a URL where you can get it, and here is an Access Token to unlock it."*

### How it works:
1.  **Reference:** The OP returns the endpoint URL and an Access Token to the Client.
2.  **Fetch:** The Client makes a separate HTTP request to that URL (the Claims Provider) using the provided token.
3.  **Response:** The Claims Provider returns the data directly to the Client.

### The JSON Structure
Here is what the Client sees in the initial response from the OP:

```json
{
  "iss": "https://my-bank.com",
  "sub": "user-123",
  
  // 1. "shipping_address" maps to source "src2"
  "_claim_names": {
    "shipping_address": "src2"
  },

  // 2. "src2" tells the Client where to go
  "_claim_sources": {
    "src2": {
      "endpoint": "https://shipping-provider.com/user/claims",
      "access_token": "298374209384029384..."
    }
  }
}
```

*Note: The Client must now perform a `GET` request to `https://shipping-provider.com/user/claims` with the Bearer token provided.*

### Use Case
**Large Datasets or Privacy:** A healthcare app logs you in. The ID Token shouldn't contain your entire medical history (it would be too large and violate privacy if leaked). Instead, the OP gives the app a distributed claim pointing to the Hospital API. The app only fetches the medical record if and when the user opens that specific page.

---

## Comparison Summary

| Feature | Aggregated Claims | Distributed Claims |
| :--- | :--- | :--- |
| **Data Flow** | External Source -> OP -> Client | OP links Client -> External Source |
| **Responsibility** | OP delivers the data. | OP introduces the data source; Client fetches it. |
| **Trust** | Client must verify the External Source's signature. | Client establishes a direct connection (TLS) with the source. |
| **Latency** | Data comes immediately in the first response. | Requires an extra HTTP round-trip by the Client. |
| **Best For** | Small pieces of verified data (Scores, Statuses). | Large data, highly sensitive data, or frequently changing data. |

## Why is this an "Advanced Topic"?

Implementing this is complex because:
1.  **Trust Chains:** The Client (RP) needs to handle keys and validation for multiple parties (the OP *and* the Claims Providers).
2.  **Standardization:** While defined in the OIDC Core spec, many commercial OIDC providers (like generic Auth0 or Okta setups) do not expose these features by default; they are mostly used in specialized Federation or Banking/Gov Identity setups.

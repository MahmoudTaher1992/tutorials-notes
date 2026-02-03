Based on the Table of Contents you provided, here is a detailed explanation of **Section 8: Schemas** from the "Core Concepts" part of the SCIM 2.0 Developer Study Guide.

---

# 002-Core-Concepts/004-Schemas.md

In the SCIM (System for Cross-domain Identity Management) ecosystem, a **Schema** is the blueprint for data. Because SCIM is designed to allow different systems (like Azure AD and Slack) to talk to each other, they must agree on exactly what a "User" or a "Group" looks like.

Here is the breakdown of the concepts within this section:

## 1. Schema Definition
A Schema in SCIM is a formal document (represented as a JSON object) that defines a collection of attributes. It acts as a contract between the Service Provider (the app) and the Client (the identity provider).

It answers questions like:
*   What fields exist for this resource? (e.g., `userName`, `email`)
*   What data types are they? (String, Boolean, Integer)
*   Are they required or optional?
*   Are they mutable (can they be changed) or read-only?

Without a schema, a JSON payload is just unstructured data. With a schema, the server knows exactly how to validate and store that data.

## 2. Schema URIs
To prevent naming collisions between different systems, SCIM uses **URNs** (Uniform Resource Names) to uniquely identify every schema. These look like long URLs but are actually unique identifiers.

*   **Format:** `urn:ietf:params:scim:schemas:<type>:<version>:<name>`
*   **Example:** `urn:ietf:params:scim:schemas:core:2.0:User`

When a client sends data to a server, it includes these URIs in the payload so the server knows exactly which definitions to apply to the data.

## 3. Core Schemas
The SCIM specification (RFC 7643) defines a set of "Core" schemas that every SCIM-compliant application **must** support. This ensures basic interoperability. If you claim to support SCIM, you cannot invent your own way of describing a username; you must use the Core schema.

The two primary Core Schemas are:
1.  **User Schema:** (`...:core:2.0:User`)
    *   Contains standard attributes like `userName`, `name` (family, given), `emails`, `phoneNumbers`, and `active`.
2.  **Group Schema:** (`...:core:2.0:Group`)
    *   Contains `displayName` and a list of `members`.

## 4. Extension Schemas
The Core schema cannot cover every possible use case for every company. To solve this, SCIM allows **Extensions**. These are "add-on" buckets of attributes that get attached to a Core resource.

*   **The Enterprise Extension:** SCIM defines one standard extension called the Enterprise User Extension (`urn:ietf:params:scim:schemas:extension:enterprise:2.0:User`). It includes business-specific fields that aren't strictly personal, such as `employeeNumber`, `costCenter`, `organization`, and `manager`.
*   **Custom Extensions:** Vendors can create their own extensions. For example, Zoom might create a schema for `videoQualitySettings`, or a custom HR app might create a schema for `parkingSpaceID`.

## 5. Schema Discovery
How does an Identity Provider (like Okta) know that your specific application supports the "Enterprise Extension" or a custom "Favorite Color" field?

This is done through **Schema Discovery** via the `/Schemas` endpoint.
*   The Client sends a `GET /Schemas` request to the Service Provider.
*   The Service Provider replies with a list of every Schema it supports, including every attribute, data type, and validation rule.
*   This allows the Client to dynamically build a UI (e.g., showing a text box for "Cost Center" only if the application tells the client it supports that schema).

## 6. Schema Composition
In SCIM, a single Resource (like a user account) is composed of **one Core schema** plus **zero or more Extension schemas**.

When you look at a SCIM JSON payload, you will see a `schemas` attribute at the top. This array lists every schema currently being used to describe that object.

**Example of Composition:**
*   This user has data from the **Core User** schema (username).
*   This user *also* has data from the **Enterprise User** extension (employeeNumber).

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User",
    "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"
  ],
  "userName": "bjensen",
  "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
    "employeeNumber": "701984"
  }
}
```

### Summary
*   **Core Schemas** provide the standard basics (Common Denominator).
*   **Extension Schemas** allow for flexibility and custom data.
*   **URIs** prevent naming conflicts.
*   **Discovery** allows systems to learn each other's capabilities automatically.

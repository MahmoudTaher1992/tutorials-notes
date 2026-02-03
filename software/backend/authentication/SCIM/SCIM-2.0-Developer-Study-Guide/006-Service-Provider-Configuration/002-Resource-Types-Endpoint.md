Based on the Table of Contents you provided, specifically **Part 6 (Service Provider Configuration), Section 30**, here is a detailed explanation of the **Resource Types Endpoint**.

---

# 006-Service-Provider-Configuration / 002 - Resource Types Endpoint

In the world of SCIM 2.0, the **Resource Types Endpoint** (`/ResourceTypes`) acts as a discovery mechanism. Typically, a SCIM Client (like Okta, Azure AD, or a custom script) knows generic things about SCIM, but it doesn't know exactly what *your* specific application (the Service Provider) supports.

Think of the Service Provider as a restaurant. The `/ResourceTypes` endpoint is the **Menu**. It tells the Client exactly what "items" (resources) they are allowed to order, create, or update.

## 1. The Purpose of the Endpoint
The `/ResourceTypes` endpoint allows the Client to discover:
*   Which objects exist (e.g., specific support for Users and Groups).
*   Where to find them (the specific URL/route).
*   Which data schemas define them (what attributes they have).
*   Which extensions are attached (e.g., does the User have Enterprise attributes?).

## 2. The HTTP Request
The Client retrieves this configuration using a standard HTTP GET request.

**Request:**
```http
GET /ResourceTypes HTTP/1.1
Host: api.example.com
Authorization: Bearer <token>
```

## 3. The Resource Type Definition
When the server responds, it returns a list of JSON objects. Each object represents a **Resource Type**. Let's break down the specific attributes that define a Resource Type based on the SCIM specification.

### A. Core Attributes

1.  **`id`**
    *   The unique identifier for the resource type.
    *   *Example:* `"User"`, `"Group"`, `"Device"`.
2.  **`name`**
    *   The human-readable name of the resource type. This is often used by IDPs to display the object type in their UI.
    *   *Example:* `"User"`, `"Group"`.
3.  **`description`**
    *   A string describing what this resource is.
    *   *Example:* `"User Account"`.
4.  **`endpoint`**
    *   **Crucial:** This tells the Client the relative path to use for CRUD operations on this resource.
    *   *Example:* If the endpoint is `/Users`, the Client knows to POST to `https://api.example.com/scim/v2/Users` to create a new user.
5.  **`schema`**
    *   The URI of the **Primary Schema** that defines this resource's core attributes.
    *   *Example:* `urn:ietf:params:scim:schemas:core:2.0:User`.
6.  **`schemaExtensions`**
    *   A list of additional schemas that extend the primary schema. Use this to tell the Client, "This is a User, but we also support Enterprise fields like 'Manager' and 'Department'."
    *   It includes a boolean flag `required` to indicate if the extension must be present.

## 4. Example Response using `/ResourceTypes`
Here is a JSON example of what the server returns. It defines two resources: the standard **User** and a custom **Group**.

```json
{
  "totalResults": 2,
  "itemsPerPage": 2,
  "startIndex": 1,
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:ListResponse"],
  "Resources": [
    {
      "schemas": ["urn:ietf:params:scim:schemas:core:2.0:ResourceType"],
      "id": "User",
      "name": "User",
      "endpoint": "/Users",
      "description": "User Account",
      "schema": "urn:ietf:params:scim:schemas:core:2.0:User",
      "schemaExtensions": [
        {
          "schema": "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User",
          "required": true
        }
      ],
      "meta": {
        "location": "https://api.example.com/scim/v2/ResourceTypes/User",
        "resourceType": "ResourceType"
      }
    },
    {
      "schemas": ["urn:ietf:params:scim:schemas:core:2.0:ResourceType"],
      "id": "Group",
      "name": "Group",
      "endpoint": "/Groups",
      "description": "User Group",
      "schema": "urn:ietf:params:scim:schemas:core:2.0:Group",
      "schemaExtensions": []
    }
  ]
}
```

## 5. Custom Resource Type Registration
One of the most powerful features of SCIM 2.0 is the ability to define **Custom Resources**. Note item 14 and 68 in your Table of Contents—this endpoint is where those custom resources become visible.

If your application isn't managing humans, but rather IoT devices, you might create a custom resource.

**How it appears in `/ResourceTypes`:**
*   **id:** `Device`
*   **endpoint:** `/Devices`
*   **schema:** `urn:com:example:schemas:Device:1.0` (A custom URI defined by your organization)

Once the Client sees this in the `/ResourceTypes` response, it knows it can send a GET request to `/Schemas/urn:com:example:schemas:Device:1.0` to learn exactly what attributes a "Device" has (e.g., `serialNumber`, `macAddress`).

## 6. Implementation Summary for Developers

If you are building a **Service Provider** (the API):
*   You must implement `GET /ResourceTypes`.
*   It is usually a static JSON response (it rarely changes while the app is running).
*   It must verify that the `endpoint` paths matches your actual router configuration (e.g., if you say `/Users`, your API router better handle `/Users`).

If you are building a **Client** (the Provisioner):
*   On initialization, call `/ResourceTypes`.
*   Don't hardcode endpoints (like `/Users`). Instead, read the `endpoint` property from the response. This makes your client dynamic and compatible with any SCIM implementation.
*   Check `schemaExtensions` to see if you should send extra data (like Enterprise attributes).

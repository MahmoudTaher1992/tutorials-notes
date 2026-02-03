Based on **Item 68** of the provided Table of Contents, here is a detailed explanation of **Custom Resource Types** in SCIM 2.0.

---

# Detailed Explanation: Custom Resource Types

In SCIM 2.0, the standard explicitly defines two core resources: **User** and **Group**. However, real-world identity management often requires managing objects that do not fit neatly into these two categories.

**Custom Resource Types** allow you to extend the SCIM protocol to manage *any* type of entity (Devices, Licenses, Roles, Organizations) using the same standardized RESTful API interactions used for Users and Groups.

## 1. When to use a Custom Resource Type vs. an Extension
Before creating a custom resource, it is crucial to understand the difference between *extending* a resource and creating a *new* one.

*   **Schema Extension (Item 15/67):** Use this when you want to add data to an **existing** User or Group.
    *   *Example:* Adding a `badgeNumber` to a User. The User is still the main entity.
*   **Custom Resource Type (Item 68):** Use this when the entity has its own lifecycle **independent** of a User or Group.
    *   *Example:* A `Device` (laptop/phone). A device exists even if no user is assigned to it. It can be created, updated, and deleted separately from a user.

## 2. The Three Pillars of a Custom Resource
To implement a Custom Resource Type, you must define three specific components:

### A. The Schema Definition
You must define the structure of the data. This involves creating a new Schema JSON that defines the attributes (fields) your resource will have.
*   **URN:** You must assign a unique URN (Uniform Resource Name) to identify this schema.
    *   *Format:* `urn:ietf:params:scim:schemas:extension:enterprise:2.0:User` (Standard) vs `urn:com:example:scim:schemas:Device:1.0` (Custom).

### B. The Resource Type Definition
This is the "glue" that tells the SCIM client how to interact with your new schema. It maps the schema to a specific URL endpoint.
*   It is exposed via the standard `/ResourceTypes` endpoint.

### C. The API Endpoint
You must implement a specific API route (e.g., `/Devices`) that handles the standard SCIM HTTP methods (POST, GET, PUT, PATCH, DELETE) for this new object.

---

## 3. Practical Example: The "Device" Resource

Let's imagine we need to manage IT assets (Tablets, Laptops) via SCIM. We will create a **Device** resource.

### Step 1: Defining the Schema
First, we define what a "Device" looks like. We create a Schema definition that the Service Provider will return when queried at `/Schemas`.

**Schema URN:** `urn:com:example:scim:schemas:Device:1.0`

**Attributes:**
*   `serialNumber` (string, required)
*   `deviceType` (string: Laptop, Mobile, Tablet)
*   `assignedUser` (reference to a User resource)

### Step 2: Defining the Resource Type
Next, we define the metadata for the resource itself. This is what the Service Provider returns when a client calls `GET /ResourceTypes`.

**JSON Representation:**
```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:ResourceType"],
  "id": "Device",
  "name": "Device",
  "endpoint": "/Devices",
  "description": "A physical computing device",
  "schema": "urn:com:example:scim:schemas:Device:1.0",
  "schemaExtensions": []
}
```

*   **id:** The internal name of the resource.
*   **endpoint:** The relative URL where CRUD operations will happen (e.g., `https://api.example.com/scim/v2/Devices`).
*   **schema:** Links back to the Schema URN defined in Step 1.

### Step 3: Using the Custom Resource
Once configured, a SCIM Client can interact with the custom resource exactly like it does with Users.

**Create a Device (POST):**
To create a new device, the client sends a request to the creating endpoint defined in the Resource Type.

```http
POST /scim/v2/Devices
Content-Type: application/scim+json

{
  "schemas": ["urn:com:example:scim:schemas:Device:1.0"],
  "serialNumber": "SN-99887766",
  "deviceType": "Laptop",
  "active": true
}
```

**Response (201 Created):**
```json
{
  "schemas": ["urn:com:example:scim:schemas:Device:1.0"],
  "id": "b1c2d3e4",
  "serialNumber": "SN-99887766",
  "deviceType": "Laptop",
  "meta": {
    "resourceType": "Device",
    "location": "https://api.example.com/scim/v2/Devices/b1c2d3e4"
  }
}
```

---

## 4. Discovery Mechanisms & Interoperability
How does a generic SCIM client (like Okta, Azure AD, or SailPoint) know that you have invented a "Device" resource?

They rely on **Schema Discovery** (Items 30 & 31 in your TOC).

1.  **Initial Handshake:** When the client connects to your Service Provider, it performs a `GET /ResourceTypes`.
2.  **Detection:** It sees "User", "Group", and your new "Device" entry.
3.  **Analysis:** It reads the `schema` field from the "Device" entry, then calls `GET /Schemas` to learn what attributes (serialNumber, etc.) exist for the Device.
4.  **UI Generation:** Advanced Identity Management systems can essentially "Auto-generate" a UI for creating Devices based solely on these definitions, without custom code.

## 5. Common Use Cases (from Item 68)

*   **Devices:** Managing IoT, mobile phones, or hardware tokens.
*   **Licenses/Entitlements:** Managing software seats (e.g., "Adobe Photoshop License") as a distinct object that can be assigned to users.
*   **Roles:** While `groups` are often used for permissions, sometimes complex RBAC systems require a distinct `Role` resource with attributes like `clearanceLevel` or `departmentScope`.
*   **Organizations/Tenants:** In B2B scenarios, creating an `Organization` resource to represent a customer account.

## Summary Checklist for Implementation
If you are building this (Item 44 - Service Provider Implementation):
1.  [ ] Create a valid JSON Schema for the object.
2.  [ ] Register the Schema URN.
3.  [ ] Add the new type to the `/ResourceTypes` endpoint configuration.
4.  [ ] Add the schema details to the `/Schemas` endpoint.
5.  [ ] Implement the Controller/Logic for the new URL endpoint (e.g., /Devices).
6.  [ ] Ensure standard Database mapping for the new attributes.

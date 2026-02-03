Based on the Table of Contents provided, **Section 14: Custom Resources** covers how to extend SCIM 2.0 beyond the standard User and Group definitions to manage other types of data entities.

Here is a detailed explanation of the concepts covered in this section.

---

# Detailed Explanation: 005 - Custom Resources

In SCIM 2.0 (RFC 7643), the standard defines two core resources: **User** and **Group**. However, most modern applications manage more than just people and lists of people. They manage Devices, Roles, Licenses, Organizational Units, or Applications.

**Custom Resources** allow you to use the standard SCIM protocol (endpoints, filtering, patching, bulk operations) to manage these non-standard entities.

## 1. Defining Custom Resource Types

To create a Custom Resource, you must strictly define what that resource looks like so SCIM clients (like Okta, Azure AD, or your own scripts) understand how to interact with it.

Defining a custom resource involves three main steps:

1.  **Create the Schema:** The "blueprint" containing the attributes (fields) the resource possesses.
2.  **Define the Resource Type:** A metadata definition that maps the Schema to a specific API Endpoint.
3.  **Implement the Endpoint:** Setting up the actual URL route (e.g., `/Devices`).

### Comparison: Core vs. Custom
*   **Core Resource:** A User is defined by the standard schema (`...:core:2.0:User`) and lives at `/Users`.
*   **Custom Resource:** A "Device" might be defined by a custom schema (`...:acme:2.0:Device`) and lives at `/Devices`.

## 2. Custom Schema URIs

SCIM uses URNs (Uniform Resource Names) to uniquely identify schemas. When you create a custom resource, you cannot use the standard IETF namespace. You must create a namespaced URI that is unique to your organization or application to avoid collisions.

### The Naming Convention
The standard format generally follows this pattern:
`urn:ietf:params:scim:schemas:extension:[OrganizationName]:2.0:[ResourceName]`

### Example
If a company named "Acme Corp" wants to manage **IoT Devices**, their Schema URI might look like this:
`urn:ietf:params:scim:schemas:extension:acme:2.0:Device`

**Why this matters:** When a client sends a JSON payload to create a device, it includes this URI in the `schemas` attribute. This tells the server, "Validate the following data against the 'Acme Device' blueprint."

## 3. JSON Example (Payload)

Here is what a POST request to create a custom "Device" resource might look like:

**POST /Devices**
```json
{
  "schemas": ["urn:ietf:params:scim:schemas:extension:acme:2.0:Device"],
  "serialNumber": "SN-12345678",
  "deviceType": "Laptop",
  "assignedTo": "739324-an324-23423",
  "active": true
}
```

## 4. Registration Considerations

Simply coding the API endpoint isn't enough. For a SCIM 2.0 compliant Identity Provider (IdP) to discover and use your custom resource, it must be "registered" via the **Discovery Endpoints**.

### The `/ResourceTypes` Endpoint
You must update your server's `/ResourceTypes` endpoint to list the new resource. This tells clients: "I support Users, Groups, AND Devices."

**Response excerpt from `/ResourceTypes`:**
```json
{
  "id": "Device",
  "name": "Device",
  "endpoint": "/Devices",
  "description": "Acme Corp IoT Devices",
  "schema": "urn:ietf:params:scim:schemas:extension:acme:2.0:Device"
}
```

### The `/Schemas` Endpoint
You must also provide the detailed attribute definitions (is `serialNumber` a string? is it required?) at the `/Schemas` endpoint.

## 5. Use Cases for Custom Resources

When should you create a Custom Resource versus just adding a field to the User object (Schema Extension)?

### Rule of Thumb:
*   **Use Schema Extension:** If the data belongs *to* a user (e.g., `user.shirtSize`, `user.costCenter`).
*   **Use Custom Resource:** If the data exists *independently* of a user, has its own lifecycle, or can be assigned to multiple users.

### Common Examples:
1.  **Devices:** Laptops, Mobile Phones, YubiKeys. These exist even if no user is assigned to them.
2.  **Roles/Permissions:** If your application has complex Roles (e.g., "Admin", "Editor") that have their own descriptions and permission sets, they should be a resource.
3.  **Tenants/Organizations:** In B2B SaaS, you might want to provision "Organizations" before you provision the Users inside them.
4.  **Realms/Projects:** Assigning users to specific projects within an application.

## Summary Checklist for Implementation

If you are implementing this section of the guide, you are essentially building a new API route that mimics the behavior of `/Users` but for a different object.

1.  **Endpoint:** Create `/MyCustomObject`.
2.  **URI:** Define `urn:ietf...:MyCustomObject`.
3.  **Discovery:** Expose it in `/ResourceTypes` and `/Schemas`.
4.  **Logic:** Implement GET, POST, PUT, PATCH, DELETE using standard SCIM JSON formats.

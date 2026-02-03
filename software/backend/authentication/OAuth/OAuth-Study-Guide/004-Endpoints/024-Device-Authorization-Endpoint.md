Based on the Table of Contents provided, **Section 24: Device Authorization Endpoint** focuses on a specific mechanism defined in **RFC 8628**. This endpoint is the starting point for the "Device Code Flow."

Here is a detailed explanation of what this endpoint is, how it works, and the structure of its requests and responses.

---

# 024 - Device Authorization Endpoint (RFC 8628)

## 1. Purpose & Behavior

The **Device Authorization Endpoint** addresses a specific problem: **Input-Constrained Devices**.
Standard OAuth flows (like Authorization Code) require the user to interact with a web browser on the application device to log in. However, many smart devices lack a browser or a keyboard (e.g., Smart TVs, Gaming Consoles, IoT devices, Printers, or Command Line Interface (CLI) tools).

**The Solution:**
This endpoint allows the device to initiate an authorization request **without** launching a browser. Instead, it instructs the user to use a *secondary device* (like a smartphone or laptop) to complete the login process.

**The Workflow:**
1. The Device (Client) POSTs to this endpoint.
2. The endpoint returns a set of codes (`device_code` and `user_code`).
3. The Device displays the `user_code` and a URL to the user.
4. The Device begins "polling" the Token Endpoint (checking over and over) to see if the user has finished logging in on their secondary device.

## 2. Request Structure

The device acts as the Client. It sends a standard HTTP `POST` request to the authorization server's device authorization endpoint.

**HTTP Method:** `POST`
**Content-Type:** `application/x-www-form-urlencoded`

**Parameters:**

*   **`client_id`** (Required): The identifier given to the client application.
*   **`scope`** (Optional): A space-delimited list of access scopes requested (e.g., `read write`).
*   **`client_secret`** (Dependent): If the device is a "Confidential Client" (can keep secrets safely), it typically includes the secret via Basic Auth headers or the request body. However, most device clients (like CLI tools or TV apps) are "Public Clients" and do not use a secret here.

**Example Request:**
```http
POST /device/authorize HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded

client_id=my-smart-tv-app&scope=read_user_profile%20watch_history
```

## 3. Response Structure

If the request is valid, the Authorization Server returns a JSON object containing the data the device needs to instruct the user and to start polling for a token.

**Key Response Parameters:**

1.  **`device_code`**:
    *   A long, random string.
    *   **Purpose:** Used by the *Client* (Device) to identify this specific session when polling the Token Endpoint later.
    *   *Security:* This should be kept secret by the device.

2.  **`user_code`**:
    *   A shorter string (e.g., `BCDF-GHJK`).
    *   **Purpose:** Displayed to the *User*. The user types this code into their smartphone/laptop.
    *   *UX:* It usually has low entropy (simple characters) to make it easy to type.

3.  **`verification_uri`**:
    *   The URL the user must visit on their secondary device (e.g., `https://example.com/device`).

4.  **`verification_uri_complete`** (Optional):
    *   The verification URL with the user code already embedded (e.g., `https://example.com/device?user_code=BCDF-GHJK`).
    *   **Purpose:** This allows the client to generate a **QR Code**. If the user scans the QR code, they don't have to type the code manually.

5.  **`expires_in`**:
    *   The lifetime (in seconds) of the `device_code` and `user_code`. If the user doesn't log in within this time (e.g., 1800 seconds), the codes become invalid.

6.  **`interval`** (Optional):
    *   The minimum amount of time (in seconds) the client should wait between polling requests to the Token Endpoint (e.g., 5 seconds). This prevents the device from flooding the server with requests.

**Example Response:**
```json
{
  "device_code": "GmRhmhcxhwAzkoEqiMEg_DnyEysNkuNhszIyTheG",
  "user_code": "WDJB-MJHT",
  "verification_uri": "https://example.com/device",
  "verification_uri_complete": "https://example.com/device?user_code=WDJB-MJHT",
  "expires_in": 1800,
  "interval": 5
}
```

## 4. User Code Display & Interaction

This is a critical part of the endpoint's design philosophy involving User Experience (UX).

After receiving the response above, the device (e.g., the Smart TV) must UI similar to this:

> **Connect your account**
>
> 1. On your phone or computer, go to: **example.com/device**
> 2. Enter this code:
>
> # **WDJB - MJHT**
>
> *(Or scan this QR Code)*

**While this screen is displayed:**
The user grabs their phone, goes to the URL, logs in, and types the code.
Simultaneously, the Smart TV (Client) takes the `device_code` (which is hidden from the user) and starts sending requests to the **Token Endpoint** every 5 seconds (the `interval`) asking: *"Is the user done yet?"*

## Summary of Role within the Architecture

*   **It separates the Device from the User:** The device handles the `device_code`, while the human handles the `user_code`.
*   **It enables "Air-Gapped" Auth:** The device and the user's phone do not need to be on the same network (e.g., The TV is on home Wi-Fi, the phone is on 5G).
*   **It replaces the Authorization Redirect:** In standard web flows, the browser redirects users. In this flow, the `verification_uri` displayed on the screen replaces that redirect.

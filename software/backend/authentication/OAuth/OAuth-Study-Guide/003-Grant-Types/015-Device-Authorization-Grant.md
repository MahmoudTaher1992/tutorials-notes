Based on the Table of Contents you provided, here is a detailed explanation of **Section 15: Device Authorization Grant**, which corresponds to **RFC 8628**.

---

# 15. Device Authorization Grant (RFC 8628)

## 1. Overview & Use Cases
The **Device Authorization Grant** (often called the "Device Flow") is designed for devices that have an internet connection but **lack a browser** or have **limited input capabilities** (no keyboard/mouse).

In standard OAuth (like Authorization Code flow), the user is redirected to a browser on the device to log in. Usage of this flow is impossible if the device doesn't have a browser or if typing a password on it is painful.

### **Common Use Cases:**
*   **Smart TVs / Streaming Boxes:** (e.g., logging into the YouTube or Netflix app on a TV).
*   **IoT Devices:** (e.g., a smart printer or a smart thermostat).
*   **CLI Tools:** (e.g., the GitHub CLI or Azure CLI running in a terminal).
*   **Console-based Applications.**

---

## 2. High-Level Concept
Since the user cannot log in directly on the device (e.g., the Smart TV), the flow separates the **client** (the TV) from the **user interaction** (a smartphone or laptop).

1.  **The Device** asks the Authorization Server for a code.
2.  **The Device** displays a URL and a short Code to the user.
3.  **The User** switches to a different device (phone/laptop), goes to the URL, and enters the Code.
4.  **The Device** waits (polls) until the user completes this step, then receives the token.

---

## 3. The Flow Steps (Technical Deep Dive)

This flow involves two distinct communication channels: the **Device Channel** (Device talking to Auth Server) and the **Browser Channel** (User talking to Auth Server).

### Step A: Device Requests Authorization
The client (device) makes a POST request to a specific endpoint (usually `/device/code` or `/device_authorization`).

```http
POST /device_authorization HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded

client_id=my-smart-tv-app&scope=read_user
```

### Step B: Authorization Server Responds
The server returns JSON containing critical information:

```json
{
  "device_code": "GmRhmhcxhwAzkoEqiMEg_DnyEysNkuNhszIySk9eS",
  "user_code": "WDJB-MJHT",
  "verification_uri": "https://example.com/device",
  "verification_uri_complete": "https://example.com/device?user_code=WDJB-MJHT",
  "expires_in": 1800,
  "interval": 5
}
```

*   **`device_code`**: A long, random string. The device keeps this secret. It acts like a handle for the session.
*   **`user_code`**: A short string (usually 6-9 characters) designed for humans to type easily (high readability).
*   **`verification_uri`**: The URL the user must visit.
*   **`interval`**: The number of seconds the device should wait between polling requests.

### Step C: Device Displays Instructions
The device shows a screen saying:
> *"Please go to **example.com/device** and enter the code: **WDJB-MJHT**"*

*(Ideally, the device also generates a QR code for `verification_uri_complete` so the user can just scan it).*

### Step D: The Polling Mechanism
While the user is fumbling for their phone, the device starts **polling** the Token Endpoint. It sends a request every 5 seconds (based on the `interval` received in Step B).

**Request:**
```http
POST /token HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:device_code
&client_id=my-smart-tv-app
&device_code=GmRhmhcxhwAzkoEqiMEg_DnyEysNkuNhszIySk9eS
```

**Response (Scenario 1: User hasn't finished yet):**
The server returns an error indicating the user is still busy.
```json
{ "error": "authorization_pending" }
```
*The device receives this, waits 5 seconds, and tries again.*

### Step E: User Interaction (Secondary Device)
The user opens their browser on their phone, types the URL, and enters the `user_code`. The Authorization Server validates the code and prompts the user to log in and consent ("Do you allow Smart TV to access your account?").

### Step F: Final Polling Response
Once the user clicks "Allow" on their phone, the *next* time the device polls the token endpoint:

**Response (Scenario 2: Success):**
```json
{
  "access_token": "AyM1SysPpbyDfgZld3umj87HFdah8Fa...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "jiYu986dag8..."
}
```
The device now has the access token and is logged in.

---

## 4. Key Parameters & Security

### Device Code vs. User Code
*   **Device Code:** High entropy (very random). Used by the machine to identify the session securely.
*   **User Code:** Low entropy (limited characters). Used by the human.
    *   *Security Note:* Because `user_code` is short (easy to guess), the generic authorization page must be rate-limited to prevent brute-force guessing attacks.

### Polling Errors
The device must handle specific errors during polling:
1.  `authorization_pending`: Keep waiting, user hasn't finished.
2.  `slow_down`: You are polling too fast! Increase the wait interval by 5 seconds.
3.  `expired_token`: The user took too long (the `expires_in` time from Step B passed). The device must restart the flow.
4.  `access_denied`: The user clicked "Cancel" or "Deny" on their phone.

### Comparison to Other Grants
| Feature | Authorization Code | Device Flow |
| :--- | :--- | :--- |
| **Browser on Client** | Required | **Not Required** |
| **User Interaction** | On the same device | On a **secondary** device |
| **Delivery Method** | Browser Redirect | **Polling** |
| **Client Type** | Web/Mobile/Native | IoT/TV/CLI |

## 5. User Experience (UX) Considerations
To implement this well:
1.  **QR Codes:** Always render the `verification_uri_complete` as a QR code. Typing codes on a TV remote is frustrating; scanning is fast.
2.  **Clear Instructions:** Clearly tell the user to check their *phone or computer*.
3.  **Visual Feedback:** While polling, show a spinner or "Waiting for login..." on the TV screen so the user knows the device is active.

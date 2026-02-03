Here is a detailed explanation of generic topic **42. Rich Authorization Requests (RAR)** from the Developer Study Guide.

This topic covers **RFC 9396**, which solves a major limitation in standard OAuth 2.0 regarding how permissions are requested.

---

# 42. Rich Authorization Requests (RAR)

### 1. The Problem: The Limitation of "Scopes"
In standard OAuth 2.0, permissions are requested using the `scope` parameter. Scopes are simple, space-separated text strings (e.g., `read_email`, `write_profile`, `photos`).

This works well for coarse-grained access (e.g., "Let this app access my photos"), but it fails when the authorization needs to be specific or complex.

**The Scenario:**
Imagine a banking app. You want to authorize a third-party application to **send $50.00 to Alice**.
*   **Using Standard Scopes:** You might request a scope called `make_payment`.
*   **The Risk:** Giving an app the generic `make_payment` scope grants it permission to pay *anyone*, *any amount*. It is too broad.
*   **The Hacky Workaround:** Developers previously tried creating dynamic scopes like `make_payment_50_alice`, which is impossible to manage, or smuggling JSON data into the scope string, which breaks the standard.

### 2. The Solution: RFC 9396
**Rich Authorization Requests (RAR)** introduces a new standard parameter called `authorization_details`.

Instead of a simple string, the client sends a structured **JSON object** describing exactly what it wants to do. This allows for fine-grained, transactional authorization.

### 3. Anatomy of `authorization_details`
The `authorization_details` parameter is passed in the Authorization Request. It is a JSON array containing one or more objects. Each object represents a specific permission request.

**Common Fields in the Object:**
1.  **`type` (Required):** A string identifier indicating the type of authorization data (e.g., `payment_initiation`, `electronic_signature`, `account_information`).
2.  **`locations` (Optional):** An array of URIs indicating where the resource resides (which API endpoint or server).
3.  **`actions` (Optional):** What actions are being requested (e.g., `read`, `write`).
4.  **`identifier` (Optional):** An ID for a specific resource (e.g., `account_id`).
5.  **Custom Fields:** The most important part. You can add any business-specific data fields required for the transaction (e.g., `amount`, `currency`, `creditorName`).

### 4. Implementation Example: A Banking Transaction

Let's look at how a client requests permission to transfer money.

**The Authorization Request (HTTP GET):**
```http
GET /authorize?
    response_type=code
    &client_id=my-banking-app
    &authorization_details=[
      {
        "type": "payment_initiation",
        "actions": ["transfer"],
        "locations": ["https://api.bank.com/payments"],
        "payment_amount": {
          "currency": "USD",
          "value": "50.00"
        },
        "creditor": {
          "name": "Alice Smith",
          "account": "12345678"
        }
      }
    ]
    &state=xyz...
```

### 5. The User Experience (Consent)
This is where RAR shines. Because the Authorization Server receives structured data, it can render a **Rich Consent Screen**.

Instead of asking:
> *"Do you want to allow this app to make payments?"*

The Authorization Server can ask:
> *"Do you want to allow this app to send **$50.00 USD** to **Alice Smith**?"*

This drastically increases security and user trust because the user knows exactly what they are agreeing to.

### 6. The Token Response
If the user approves the request, the Authorization Server issues an Access Token. Use of RAR creates a specific binding:

1.  **The Token:** The Access Token issued acts as the proof of this specific consent.
2.  **Introspection:** When the Resource Server (the API) receives the token, it can ask the Authorization Server (via Introspection), "What is this token good for?" The AS will return the JSON object (the $50 transfer details).
3.  **Self-Contained (JWT):** If using JWTs, the `authorization_details` are included directly inside the token payload.

### 7. Comparison: Scopes vs. RAR

| Feature | Scopes (`scope`) | RAR (`authorization_details`) |
| :--- | :--- | :--- |
| **Data Format** | Simple Strings (`read:data`) | Structured JSON Objects |
| **Granularity** | Coarse-grained (Categories) | Fine-grained (Specific Transactions) |
| **Dynamic Data** | No (Static strings) | Yes (Amounts, IDs, Dates) |
| **Use Case** | Profile access, Login | Payments, eHealth, eSignatures |
| **User Consent** | "Access your profile" | "Pay $50 to Alice" |

### 8. Use Cases beyond Banking
While Open Banking (PSD2) was the primary driver for this spec, it is useful elsewhere:

*   **eHealth:** Requesting access to *specific* medical records (e.g., "Read lab results for Patient ID 999 from Jan 2023").
*   **eSignatures:** Requesting permission to sign a *specific document* identified by a hash or ID.
*   **IoT:** Granting permission to open a *specific* lock at a *specific* time.

### Summary
**Rich Authorization Requests (RAR)** allow OAuth 2.0 to move beyond simple "access passes" to complex "work orders." It enables clients to explain exactly *what* they want to do, allows users to consent to *specific* details (like amounts and payees), and allows APIs to enforce these strict limits.

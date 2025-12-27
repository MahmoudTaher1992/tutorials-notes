Based on the syllabus you provided, here is a detailed explanation of section **010-Security-Multi-Tenancy / 003-Data-Privacy**.

This section addresses a critical challenge in distributed tracing: **Observability vs. Privacy**. While developers need detailed data to debug errors, that same data often contains Personally Identifiable Information (PII), creating compliance risks (GDPR, HIPAA, CCPA).

---

# 010-Security-Multi-Tenancy / 003-Data-Privacy

## 1. The Core Problem: Accidental Leaks
Distributed tracing tools like Jaeger capture "the story of a request." Unfortunately, that story often includes sensitive details.

Common places where PII (Personally Identifiable Information) leaks into traces include:
*   **Database Statements:** `SELECT * FROM users WHERE email='john.doe@gmail.com'`
*   **HTTP URLs/Query Params:** `GET /reset-password?token=XYZ-SECRET-TOKEN`
*   **HTTP Headers:** `Authorization: Bearer <Real-JWT>`, `Cookie: session_id=...`
*   **Log Payloads:** An error log inside a span saying: *"Failed to process payment for Credit Card 4242-..."*
*   **Custom Tags:** Developers tagging a span with `user.id` or `user.email` for easier searching.

## 2. Data Scrubbing & Sanitization (PII in Tags/Logs)
Data scrubbing is the process of removing, masking, or hashing sensitive data **before** it is permanently stored in the tracing backend. This can happen at the source (Instrumentation) or the pipeline (Collector).

### A. Strategies for Sanitization
There are three main approaches to handling sensitive data in tags and logs:

1.  **Redaction (Deletion):** Completely removing the field.
    *   *Example:* Removing the `Authorization` header entirely.
    *   *Result:* The tag does not exist in Jaeger.
2.  **Masking:** Replacing part of the data with asterisks or fixed characters.
    *   *Example:* Changing a credit card number to `XXXX-XXXX-XXXX-1234`.
    *   *Result:* Developers can verify the format was correct, but cannot see the secret.
3.  **Hashing:** One-way encryption of the data.
    *   *Example:* Converting `user.email=bob@company.com` to `user.email.hash=a1b2c3d4...`.
    *   *Result:* Useful for **Correlation**. You can't see who the user is, but you can search for "all traces belonging to user hash X" to debug a specific user's problem without knowing their identity.

### B. Handling SQL Sanitization
Raw SQL is the biggest offender in data leaks.
*   **Bad:** `SELECT * FROM orders WHERE ssn = '123-45-678'`
*   **Good:** `SELECT * FROM orders WHERE ssn = ?`

Most auto-instrumentation agents (Java, Python, etc.) attempt to sanitize SQL by default, capturing only the *structure* of the query, not the *parameters*. However, if developers write raw SQL strings instead of using prepared statements, leaks will happen.

---

## 3. Obfuscation Strategies in the OpenTelemetry Collector
In the modern Jaeger architecture (Jaeger v2 / OpenTelemetry), the **OpenTelemetry (OTel) Collector** acts as a data pipeline between your application and the Jaeger storage. This is the **ideal place** to enforce privacy policies centrally, rather than relying on every individual developer to write safe code.

The OTel Collector uses **Processors** to modify data as it flows through.

### A. The `attributes` Processor
This processor allows you to modify the attributes (tags) of a span.

**Scenario:** You want to ensure no `authorization` tokens or `user.password` fields ever reach Jaeger.

**Configuration Example (YAML):**
```yaml
processors:
  attributes/privacy:
    actions:
      # 1. Delete the password tag entirely
      - key: user.password
        action: delete
      
      # 2. Update the key name (e.g., standardizing naming)
      - key: old.user.id
        action: insert
        value: user.id
        from_attribute: old.user.id
```

### B. The `redaction` (or `transform`) Processor
For more complex scenarios, specifically locating patterns inside text (like an email hidden inside a long error message), you use processors that support Regular Expressions (Regex).

**Scenario:** You want to mask emails inside *any* span attribute or log body.

**Configuration Logic:**
1.  Define a Regex for email: `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}`
2.  Apply a replacement string: `[REDACTED_EMAIL]`

**OTel Collector Transform Processor Example:**
```yaml
processors:
  transform:
    error_mode: ignore
    trace_statements:
      - context: span
        statements:
          # If the db.statement contains an email, replace it with ***
          - replace_pattern(attributes["db.statement"], "([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})", "***")
```

### C. Allowlist vs. Blocklist
*   **Blocklisting (Deny List):** "Send everything, but remove `password` and `token`."
    *   *Risk:* A developer creates a new tag called `user_secret` which isn't on your blocklist, and it leaks.
*   **Allowlisting (Safe List):** "Remove everything, except `http.status`, `duration`, and `service.name`."
    *   *Risk:* Hard to maintain; useful debugging info gets lost constantly.
    *   *Best Practice:* Use Blocklisting for obvious PII, and strict code review for everything else.

## Summary Comparison

| Strategy | Where it happens | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **Code-Level** | Inside the App logic | Best performance (data never leaves memory). | Relies on developers; human error prone. |
| **Instrumentation** | The SDK/Agent | Automated SQL masking. | Can't catch custom logic leaks. |
| **Collector (OTel)** | The Pipeline | **Centralized control.** SecOps teams can enforce rules across all apps. | Adds CPU overhead to the Collector processing. |

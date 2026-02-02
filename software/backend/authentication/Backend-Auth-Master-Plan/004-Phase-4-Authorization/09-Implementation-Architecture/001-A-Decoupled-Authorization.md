Based on your Table of Contents, you are looking at **Phase 4 (Authorization)**, specifically the concept of **Decoupled Authorization**.

This is one of the most critical architectural shifts in modern software development, specifically when moving from Monoliths to Microservices.

Here is a detailed explanation of `004-Phase-4-Authorization/09-Implementation-Architecture/001-A-Decoupled-Authorization.md`.

---

# 9. Implementation Architecture: A. Decoupled Authorization

## 1. The Core Concept: Moving Logic Out of Code
To understand **Decoupled Authorization**, we must first look at its opposite: **Coupled (or Embedded) Authorization**.

### The "Old Way" (Coupled)
In traditional applications, developers write authorization rules directly inside the business logic code (controllers, API endpoints, or services).

**Example (Node.js/Express):**
```javascript
app.delete('/api/reports/:id', (req, res) => {
  const user = req.user;
  const report = db.getReport(req.params.id);

  // ❌ Hardcoded Authorization Logic
  if (user.role === 'admin' || (user.role === 'editor' && report.ownerId === user.id)) {
     db.deleteReport(report.id);
     res.send("Deleted");
  } else {
     res.status(403).send("Forbidden");
  }
});
```

**The Problem with the Old Way:**
1.  **Hard to Change:** If the business decides that "Managers" can now also delete reports, you have to find every file where you wrote this `if` statement, modify the code, re-test, and **re-deploy** the entire application.
2.  **Inconsistent:** In a microservices architecture, you might have a Python service and a Go service. You have to rewrite the same logic in two different languages. It is very easy to make a mistake in one, leading to security holes.
3.  **Audit Nightmares:** If an auditor asks, "Who has permission to delete reports?", you have to grep through thousands of lines of source code to find the answer.

### The "New Way" (Decoupled)
**Decoupled Authorization** removes the `if/else` logic from your application code and offloads it to a specialized **Policy Engine**.

The application code becomes "dumb." It simply asks a question:
> *"Hey Policy Engine, here is User Bob, and he wants to DELETE Report #123. Is he allowed?"*

The Policy Engine replies:
> *"Yes"* or *"No".*

**The Application Code now looks like this:**
```javascript
app.delete('/api/reports/:id', async (req, res) => {
  // ✅ Ask the central authority
  const allowed = await policyEngine.check(req.user, 'delete', 'report');

  if (allowed) {
     db.deleteReport(req.params.id);
  } else {
     res.status(403).send("Forbidden");
  }
});
```

**The Benefits:**
*   **Centralized Logic:** All rules live in one place.
*   **Hot Swapping:** You can change a policy (e.g., "Ban all users from region X") instantly without redeploying your application code.
*   **Language Agnostic:** Your Python, Go, and Node apps all query the same engine.

---

## 2. OPA (Open Policy Agent) & Rego
The industry standard tool for implementing Decoupled Authorization is **OPA** (pronounced "Oh-pa").

### What is OPA?
OPA is a general-purpose policy engine. It usually runs as a "sidecar" (a small process running next to your main application container) or as a standalone service.

It works on the principle of **JSON in, JSON out**.
1.  **Input:** Your app sends a JSON with the user context (who) and the resource (what).
2.  **Processing:** OPA runs the JSON against its rules.
3.  **Output:** OPA returns a JSON decision (usually `allow: true` or `allow: false`).

### What is Rego?
Rego is the query language used by OPA to write these policies. It is **Declarative**, meaning you describe *what* the result should be, not *how* to calculate it step-by-step.

**Example Rego Policy (policy.rego):**
*This file lives inside OPA, not your application code.*

```rego
package app.authz

# By default, deny access
default allow = false

# Rule 1: Allow creates if the user is an admin
allow {
    input.method == "POST"
    input.user.role == "admin"
}

# Rule 2: Allow reads if the user is accessing their own data
allow {
    input.method == "GET"
    input.user.id == input.resource.owner_id
}
```

### The Architecture Workflow
Here is how the flow works in a decoupled system:

1.  **The Request:** A user sends an HTTP request to your API Gateway or Microservice.
2.  **Enforcement Point:** The Service receives the request. Before processing logic, it gathers data (User ID, Role, Method, Resource ID).
3.  **The Query:** The Service sends a generic POST request to the OPA sidecar (e.g., `localhost:8181/v1/data/app/authz`).
    *   *Payload:* `{ "input": { "user": "Bob", "role": "editor", "method": "DELETE" } }`
4.  **Evaluation:** OPA checks the `input` against the **Rego** files it has loaded.
5.  **The Decision:** OPA returns `{ "result": { "allow": false } }`.
6.  **Action:** The Service sees `allow: false`, stops processing, and returns HTTP 403 to the user.

## Summary Checklist
If you are implementing this section of your master plan, you need to:

1.  **Stop writing complex authorization logic in code.** Use code only to enforce the decision.
2.  **Spin up an OPA instance** (via Docker is easiest).
3.  **Learn basic Rego syntax** to write policies that define *who* can do *what*.
4.  **Configure your app** to query OPA for every sensitive request.

This architecture scales effectively because as your company grows, you hire "Policy Authors" (Security Engineers) to manage the Rego files, while "App Developers" focus purely on building features, knowing the security is handled externally.

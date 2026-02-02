Based on the roadmap you provided, **Part IX - Section G: Security Practices in Software** focuses on shifting security from being an "afterthought" to being a fundamental part of the creation process.

In modern software engineering, you cannot simply build an app and "add security" at the end. It must be baked in from the start. Here is a detailed explanation of the three main pillars listed in that section.

---

### 1. Secure Development Life Cycle (SDLC)

The **SDLC** is the standard process used to build software (Planning → analysis → Design → Implementation → Testing → Maintenance). The **Secure SDLC** (often referred to as **DevSecOps** in modern contexts) implies that security activities happen at *every* stage, not just during testing.

*   **Requirements Phase:** Instead of just defining features (e.g., "Users can log in"), you define **Security Requirements** (e.g., "Passwords must be hashed using bcrypt" or "Data must be encrypted at rest").
*   **Design Phase:** Architects review the design for security flaws before code is written. They look at the "attack surface"—the sum of all points where an unauthorized user can try to enter data or extract data.
*   **Coding Phase:** Developers use secure coding standards and perform peer code reviews specifically looking for security flaws.
*   **Testing Phase:** Security teams run automated scans and manual tests to break the application before it goes live.
*   **Deployment/Maintenance:** Ensuring the server is patched, secrets (API keys) are managed securely, and logs are monitored for suspicious activity.

### 2. Threat Modeling & Secure Coding

These are the proactive measures developers take to prevent bugs.

#### **Threat Modeling**
This is a brainstorming exercise usually performed during the Design phase. It asks: *"What are we building, what could go wrong, and what are we going to do about it?"*

*   **The Process:** You draw a diagram of how data flows through your system (e.g., User → Web Server → Database).
*   **Identifying Threats:** You look at every connection and ask, "Can a hacker intercept this?", "Can someone spoof this user?", or "Can someone shut this server down?"
*   **STRIDE Model:** A common framework used for this assessment:
    *   **S**poofing (Pretending to be someone else).
    *   **T**ampering (Changing data on disk or network).
    *   **R**epudiation (Claiming you didn't do something).
    *   **I**nformation Disclosure (Leaking private data).
    *   **D**enial of Service (Crashing the system).
    *   **E**levation of Privilege (A regular user gaining admin rights).

#### **Secure Coding**
This refers to writing code in a way that inherently protects against vulnerabilities. It involves specific habits, such as:
*   **Input Validation:** Never trusting data sent by the user. If a field asks for an age, the code must verify it is a number, not a script.
*   **Parametrization:** Using specific database functions to prevent **SQL Injection** (where a hacker inputs SQL commands into a login box to delete or steal a database).
*   **Principle of Least Privilege:** Writing code so that the application only asks for the permissions it absolutely needs (e.g., a photo editor app shouldn't need access to your contacts).

### 3. Vulnerability Testing (OWASP Top 10)

This section deals with verifying that the security measures actually work.

#### **Vulnerability Testing**
*   **SAST (Static Application Security Testing):** Tools that scan your source code (text files) to find patterns that look like security bugs before the code is even run.
*   **DAST (Dynamic Application Security Testing):** Tools that attack the running application from the outside, just like a hacker would, to see if they can break in.
*   **Penetration Testing:** Hiring ethical hackers to manually try to break into the system.

#### **The OWASP Top 10**
**OWASP** (Open Web Application Security Project) is a global non-profit foundation. Every few years, they publish a list of the **Top 10 most critical web application security risks**. Knowing these is mandatory for any software engineer.

Common items usually found on this list include:
1.  **Injection:** (e.g., SQL Injection) Sending code to the server that the server accidentally executes.
2.  **Broken Authentication:** Weak session management allowing hackers to steal user identities.
3.  **Sensitive Data Exposure:** Failing to encrypt data (like credit card numbers) in transit or at rest.
4.  **XML External Entities (XXE):** Attacking an application that processes XML data.
5.  **Broken Access Control:** Allowing a standard user to access admin pages by simply guessing the URL.
6.  **Security Misconfiguration:** Leaving default passwords (like "admin/admin") active or leaving debug mode on in production.
7.  **Cross-Site Scripting (XSS):** Letting a user post a script (like JavaScript) on a webpage that then runs in *other* users' browsers (stealing their cookies).
8.  **Insecure Deserialization:** A complex attack involving manipulating data objects sent between systems.
9.  **Using Components with Known Vulnerabilities:** Using an old version of a library (e.g., an old version of Log4j) that has known security holes.
10. **Insufficient Logging:** Not keeping track of errors or login attempts, making it impossible to know if you are being hacked.

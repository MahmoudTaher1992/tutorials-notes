# Dynamic Secrets: Stop Hardcoding Database Passwords

**Tone:** Serious / Educational
**Duration:** ~60 seconds

| Sentence | Type |
|----------|------|
| Every hardcoded database password is a breach waiting to happen. | Hook |
| This is dynamic secrets with Vault in 60 seconds. | Title Reveal |
| Static credentials that never rotate stay valid after they leak. | Introduction |
| Dynamic secrets work differently — your app requests a credential at startup. | Body – Point 1 |
| Vault creates a real database user with a short expiry, say one hour. | Body – Point 1 |
| When the TTL expires, Vault drops that database user automatically. | Body – Point 2 |
| A stolen credential is now worthless before an attacker can use it. | Body – Point 2 |
| Each app instance gets unique credentials, so blast radius stays small. | Body – Point 3 |
| One compromised lease can be revoked without touching anything else. | Body – Point 3 |
| Long-lived passwords are a design choice — and it's the wrong one. | Conclusion |
| Find one hardcoded credential in your stack and start there. | CTA |

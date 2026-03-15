# Dynamic Secrets: Stop Hardcoding Database Passwords

**Category**: Security
**Difficulty**: Intermediate
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: software/secret-management/toc.md

---

## Introduction

Most applications connect to databases with a long-lived username and password that never changes — a hardcoded credential that, once leaked, grants permanent access. HashiCorp Vault's dynamic secrets engine solves this by generating a unique, short-lived database credential on demand for each application instance, and revoking it automatically when it expires.

---

## Body

### Key Points to Cover
1. The problem with static secrets: a credential that never rotates is a standing invitation for attackers. Once it leaks — through a log, a git commit, or a breach — it stays valid indefinitely.
2. What dynamic secrets are: instead of storing a password, the application asks Vault for one at startup. Vault creates a real database user with a TTL (e.g., 1 hour) and returns the credentials.
3. Automatic revocation: when the TTL expires, Vault drops the database user entirely. Even a stolen credential becomes useless after its lease ends.
4. The blast radius reduction: because each instance gets unique credentials, a compromised credential can be traced to a specific workload and revoked without disrupting other services.

### Suggested Code Examples / Demos
- Show a Vault policy that allows an app role to request PostgreSQL credentials.
- Show the `vault read database/creds/my-role` command returning a one-time username/password with a lease duration.
- Show the credential automatically absent from PostgreSQL after lease expiry.

### Common Pitfalls / Misconceptions
- Not handling credential renewal: if the app doesn't renew the lease before expiry, its database connection dies mid-request.
- Over-provisioning TTLs: setting a 24-hour TTL on a dynamic secret defeats most of the benefit.
- Forgetting to configure Vault HA: if Vault is a single point of failure, it becomes more dangerous than the problem it solves.
- Treating dynamic secrets as a complete solution without also revoking compromised leases manually during an incident.

---

## Conclusion / Footer

Key takeaway: dynamic secrets shrink the window of exposure from "forever" to minutes. Viewer challenge: find one long-lived database credential in your stack and ask whether it could be replaced with a dynamic secret.

---

## Notes for Production
- Thumbnail idea: a clock counting down next to a database lock icon.
- Related videos: secret sprawl, Kubernetes secrets management, BOLA vulnerability.
- HashiCorp Vault database secrets engine supports PostgreSQL, MySQL, MongoDB, and more.

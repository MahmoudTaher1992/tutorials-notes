Here is the detailed content for **Section 34: Security Audit Profiling**.

---

# 34. Security Audit Profiling

Security features are often enabled without considering their performance impact. Encryption, rigorous authentication, and granular auditing all consume resources (CPU cycles, I/O bandwidth, and latency). Security audit profiling focuses on measuring this overhead to ensure that compliance requirements do not render the database unusable.

## 34.1 Authentication Profiling

Authentication is the gateway to the database. Profiling the "login handshake" is critical because a slow authentication process can cause connection timeouts and application startup failures.

### 34.1.1 Authentication attempt metrics
*   **34.1.1.1 Success rate:** Profiling the ratio of successful logins. A sudden drop often indicates a configuration change (e.g., expired SSL certificate or rotated service account password).
*   **34.1.1.2 Failure rate:** High failure rates consume significant CPU. The database must perform expensive cryptographic hashing on the password *before* rejecting it.
*   **34.1.1.3 Failure reasons:** Categorizing failures (e.g., "Bad Password" vs. "User Not Found" vs. "Source IP Denied"). Profiling these distinctions helps differentiate between user error and attack vectors.

### 34.1.2 Authentication latency
*   **Connect Time:** Measuring the time from TCP SYN to the "Ready for Query" packet.
*   **Profiling Check:** If `Connect Time` >> `Query Time`, connection pooling is misconfigured or the authentication mechanism is too slow.

### 34.1.3 Authentication method analysis
Different auth backends have vastly different performance profiles.
*   **34.1.3.1 Password authentication:** Relying on internal hashing algorithms (e.g., SCRAM-SHA-256, bcrypt). Profiling CPU usage per new connection is vital here, as strong hashing is intentionally CPU-expensive to thwart cracking.
*   **34.1.3.2 Certificate authentication:** Profiling the TLS handshake overhead. Client certificate validation requires the DB to check revocation lists (CRLs or OCSP), which can introduce network latency if the CA is external.
*   **34.1.3.3 LDAP/AD integration overhead:** When the DB delegates auth to Active Directory. Profiling the network latency between the DB node and the Domain Controller. If the DC is slow or unreachable, DB logins hang.
*   **34.1.3.4 Kerberos authentication:** Generally fast (ticket-based), but profiling requires monitoring "Clock Skew" errors and Ticket Granting Service (TGS) response times.
*   **34.1.3.5 OAuth/OIDC integration:** Profiling the token validation step. Does the DB cache the public keys (JWKS), or does it fetch them on every login? The latter is a severe performance bottleneck.

### 34.1.4 Brute force detection
*   **Pattern Profiling:** Detecting spikes in `auth_failed` from a single IP address.
*   **Resource Impact:** A brute force attack is effectively a Denial of Service (DoS) attack on the CPU due to the cost of password hashing.

### 34.1.5 Account lockout patterns
*   **Cascading Failures:** If a service account is locked out (due to a bad password update script), profiling will show massive connection storming as the application retries indefinitely.

## 34.2 Authorization Profiling

Once logged in, the database checks permissions for every single object accessed. This is the "Authorization" phase.

### 34.2.1 Permission check overhead
*   **System Cache Hit Ratio:** Databases cache permission metadata (e.g., the Data Dictionary or System Catalog). Profiling the hit ratio of this cache is critical. If the DB has to read disk to verify if User X can read Table Y, query latency skyrockets.

### 34.2.2 Role evaluation complexity
*   **Nested Roles:** In systems with deep role inheritance (Role A inherits Role B inherits Role C...), the database must traverse the graph to verify privileges. Profiling the depth of role nesting vs. login time.

### 34.2.3 Row-level security (RLS) impact
*   **Hidden Predicates:** RLS automatically appends a `WHERE` clause (e.g., `WHERE user_id = current_user`) to every query.
*   **Plan Regression:** Profiling execution plans for RLS-enabled tables. The "hidden" predicate can sometimes prevent index usage or force suboptimal join orders.
*   **CPU Overhead:** Complex RLS policies (e.g., checking a session variable vs. a lookup table) add CPU overhead to every row scan.

### 34.2.4 Column-level security impact
*   **Projection Cost:** Profiling queries accessing restricted columns. The database must physically retrieve the row but then mask or nullify specific fields before sending it to the client, adding CPU cycles without adding value to the result set.

### 34.2.5 Dynamic data masking overhead
*   **On-the-fly Obfuscation:** Masking (e.g., showing `XXX-XX-1234` for SSN) happens at query time. Profiling string manipulation overhead. Heavy use of regex-based masking on large result sets dramatically increases CPU usage.

### 34.2.6 Policy evaluation caching
*   **Deterministic vs. Non-Deterministic:** Profiling whether security policies are cached per session or evaluated per row. Non-deterministic policies (e.g., based on `sysdate`) cannot be easily cached.

## 34.3 Audit Log Profiling

Auditing is the "Observer Effect" of databases. Recording what happened takes resources.

### 34.3.1 Audit log generation overhead
*   **Synchronous vs. Asynchronous:** Does the transaction commit wait for the audit record to be written to disk?
    *   *Synchronous:* Safer for compliance, but adds disk latency to every commit.
    *   *Asynchronous:* Faster, but risks losing audit trails during a crash.
*   **CPU Cost:** Formatting the audit string (JSON/XML) takes CPU.

### 34.3.2 Audit log volume analysis
*   **Bytes per Transaction:** Profiling the size of audit records. Capturing "bind variables" or "full SQL text" can explode log volume from MBs to TBs per day.
*   **Network Saturation:** If shipping logs to a remote SIEM (Splunk, ELK) via Syslog, profiling network bandwidth is essential to prevent packet loss.

### 34.3.3 Audit log storage requirements
*   **Disk I/O Contention:** Storing audit logs on the same physical disk as transaction logs (WAL/Redo) is a major anti-pattern. Profiling I/O wait times on the audit directory.
*   **Retention Policy:** Profiling the cost of keeping logs online vs. archiving to cold storage.

### 34.3.4 Audit granularity trade-offs
*   **34.3.4.1 Statement-level auditing:** Logging every SQL statement. High overhead. Profiling usually suggests restricting this to DDL (Data Definition Language) and DCL (Data Control Language) only.
*   **34.3.4.2 Object-level auditing:** Logging access to specific sensitive tables (e.g., `salaries`). Moderate overhead.
*   **34.3.4.3 Row-level auditing:** Logging the *before* and *after* values of every changed row. Extreme overhead (can slow throughput by 50%+).

### 34.3.5 Audit log query performance
*   **The "Audit Trail" Query:** Compliance officers often run heavy analytical queries on the audit data. If audit data is stored in the database itself (e.g., `sys.aud$`), profiling these queries is necessary to ensure they don't lock production tables.

## 34.4 Compliance Profiling

Profiling user behavior to detect anomalies and satisfy regulatory requirements (GDPR, HIPAA, SOX).

### 34.4.1 Data access pattern analysis
*   **Baseline Establishment:** Profiling "normal" read volumes per user.
*   **Anomaly Detection:** Detecting deviations (e.g., a marketing user suddenly reading 50,000 rows from the HR table).

### 34.4.2 Sensitive data access tracking
*   **PII Hotspots:** Identifying which tables contain Personally Identifiable Information (PII) and profiling who accesses them and how often. This helps in index tuning for security monitoring.

### 34.4.3 Privilege usage analysis
*   **The "Use It or Lose It" Profile:** Comparing granted privileges vs. used privileges. Profiling helps identify over-privileged accounts that represent a security risk but have zero performance impact until compromised.

### 34.4.4 Data export/extraction monitoring
*   **Bulk Read Profiling:** Detecting `mysqldump`, `pg_dump`, or `COPY TO` commands. These appear in profiles as long-running transactions with high network egress and sequential read patterns.

### 34.4.5 Compliance report generation
*   **Resource Scheduling:** Compliance reports often scan massive amounts of historical data. Profiling ensures these reports are scheduled during maintenance windows or run on read-replicas to avoid impacting OLTP performance.
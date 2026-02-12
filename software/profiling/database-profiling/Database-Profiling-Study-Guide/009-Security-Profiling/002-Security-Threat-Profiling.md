Here is the detailed content for **Section 35: Security Threat Profiling**.

---

# 35. Security Threat Profiling

Security Threat Profiling turns standard database performance metrics into security intelligence. While performance profiling asks "Why is this slow?", security profiling asks "Why is this happening at all?" It relies on the principle that malicious activity almost always creates a statistical anomaly in resource usage, network traffic, or query structure.

## 35.1 Anomaly Detection in Database Access

The foundation of threat profiling is establishing what "normal" looks like so that deviations stand out.

### 35.1.1 Baseline access patterns
*   **Behavioral Fingerprinting:** Creating a profile for every user and application. For example, "App_Service_A" typically executes 5 specific stored procedures and reads from the `Orders` table.
*   **Deviation Metrics:** Profiling deviation scores. If "App_Service_A" suddenly reads from the `Users` table or executes dynamic SQL, the deviation score spikes, triggering an alert.

### 35.1.2 Unusual query patterns
*   **35.1.2.1 Query frequency anomalies:** Automated tools (scrapers, brute-force scripts) execute queries faster than humans but often slower/more regular than valid applications. Profiling inter-arrival times of queries can identify robotic behavior.
*   **35.1.2.2 Query timing anomalies:**
    *   **Time-Based Blind SQL Injection:** Profiling queries that suddenly take exactly 5 or 10 seconds (e.g., `SLEEP(5)` or `pg_sleep(10)`). These are injected to verify vulnerabilities.
    *   **System Slowdown:** A massive spike in CPU or I/O without a corresponding increase in throughput often indicates a Denial of Service (DoS) attempt via resource-intensive queries.
*   **35.1.2.3 Query source anomalies:**
    *   **IP Reputation:** Profiling connection origins. A database connection from a country where the company has no employees is a primary anomaly.
    *   **Application ID Spoofing:** Profiling the mismatch between the connection source IP and the claimed Application Name.

### 35.1.3 Data volume anomalies
*   **35.1.3.1 Large data extraction:** Standard applications typically paginate data (e.g., 50 rows at a time). Profiling queries returning >10,000 rows or >100MB payloads suggests a "dump" operation or a scraper.
*   **35.1.3.2 Bulk modification detection:**
    *   **Ransomware Activity:** Profiling high-velocity updates that encrypt columns (high entropy data) or drop tables.
    *   **Mass Deletion:** A `DELETE` statement without a `WHERE` clause, or a `TRUNCATE` command issued by a non-admin account.

### 35.1.4 Connection pattern anomalies
*   **Port Scanning:** Profiling a high volume of TCP connection attempts that immediately disconnect or fail the handshake phase.
*   **Connection Storms:** A sudden flood of connections from distributed IPs (DDoS) attempting to exhaust the `max_connections` pool.

### 35.1.5 Privilege escalation detection
*   **Grant Monitoring:** Profiling the usage of DCL (Data Control Language) commands like `GRANT`, `REVOKE`, or `CREATE ROLE`. In a stable production environment, these commands should be extremely rare.
*   **Sudo-like Behavior:** Profiling the use of `SET ROLE` or `SET SESSION AUTHORIZATION` to switch identities mid-session.

## 35.2 SQL Injection Detection

SQL Injection (SQLi) changes the logic of a query. Profiling focuses on detecting changes in the *structure* of executed SQL.

### 35.2.1 Query pattern analysis
*   **Syntax Tree Changes:** Profiling the Abstract Syntax Tree (AST) of queries. If a known query ID suddenly parses into a different tree structure (e.g., an added `OR` condition or a `UNION`), it is likely an injection.
*   **Comment Injection:** Profiling the appearance of SQL comment characters (`--`, `#`, `/*`) in the middle of query parameters, used to truncate the original query logic.

### 35.2.2 Parameter type anomalies
*   **Type Mismatch:** Profiling input validation at the database level. If a parameter typically receiving an `INTEGER` suddenly receives a `STRING` containing special characters (`' ; "`), it indicates a bypass attempt.

### 35.2.3 Error message analysis
*   **Error Rate Spikes:** Attackers often use "Error-Based SQLi" which intentionally breaks queries to extract info via error messages. Profiling a spike in SQL syntax errors (e.g., ORA-00933, PG syntax error) is a strong indicator of an active probe.

### 35.2.4 Query normalization for detection
*   **Digest Mismatch:** Databases generate a "Digest" or "Fingerprint" for unique queries (stripping out literals). Profiling new digests appearing in the system. An attack often generates thousands of unique digests (due to random injection strings) rather than reusing prepared statements.

### 35.2.5 WAF integration metrics
*   **Correlation:** Profiling the timestamp correlation between Web Application Firewall (WAF) blocks and database errors. A WAF alert followed immediately by a database syntax error indicates the WAF rules were bypassed.

## 35.3 Data Exfiltration Profiling

Data exfiltration is the act of moving data *out* of the database. Profiling network traffic and result sets is key.

### 35.3.1 Large result set detection
*   **Row Count vs. Byte Count:** Profiling queries that return few rows but massive bytes (e.g., extracting BLOBs/images) versus queries returning millions of rows (dumping customer lists).
*   **Protocol Analysis:** Monitoring the database wire protocol for "result set" packets that exceed standard thresholds.

### 35.3.2 Unusual export operations
*   **Native Tools:** Profiling the execution of `SELECT ... INTO OUTFILE` (MySQL) or `COPY TO` (PostgreSQL). These commands write data directly to the file system and are favorite tools for attackers to stage data for exfiltration.
*   **Utility Usage:** Profiling the connection signatures of bulk tools like `pg_dump`, `mysqldump`, or `expdp` triggered from non-backup servers.

### 35.3.3 Backup access monitoring
*   **Access Logs:** Profiling access to the storage location of backups (S3 buckets, NFS mounts). Attackers often find it easier to steal a backup file than to query the live database.

### 35.3.4 Replication abuse detection
*   **Rogue Replicas:** Profiling the list of connected replication slaves. An attacker may attach a rogue database instance as a replica to sync all data out.
*   **Binlog Downloading:** Profiling requests to download binary logs/transaction logs, which contain the history of all data changes.

### 35.3.5 Network traffic analysis
*   **Egress Spikes:** Profiling outbound bandwidth from the database server. A database is usually a data *sink* (receiving writes) or sends data to app servers (internal). Sustained outbound traffic to an unknown external IP is a critical alert.
*   **Tunneling Detection:** Profiling DNS traffic on the DB server. Attackers may tunnel data out via DNS queries (DNS Exfiltration) if direct internet access is blocked.

## 35.4 Insider Threat Profiling

Insider threats involve valid credentials used maliciously. These are the hardest to detect because the access is technically "authorized."

### 35.4.1 User behavior analytics (UBA)
*   **Statistical Baselines:** Profiling the standard deviation of a user's activity.
    *   *Volume:* User accesses 500 records/day normally, but 50,000 today.
    *   *Variety:* User typically accesses 3 tables, but today accessed 20.

### 35.4.2 Access pattern deviation
*   **Horizontal Access:** A user viewing their own department's data is normal. Profiling a user sequentially accessing data across *all* departments (e.g., searching for "salary" or "password" across all schemas).
*   **Semantic Anomalies:** Profiling access to tables unrelated to the user's job function (e.g., an Engineer querying the `HR_Benefits` table).

### 35.4.3 Off-hours access analysis
*   **Temporal Profiling:** Profiling logins occurring outside of standard business hours or shift patterns. While on-call work happens, a login at 3 AM from a user who is not on-call is suspicious.

### 35.4.4 Dormant account usage
*   **Zombie Accounts:** Profiling activity on accounts that have been inactive for >30 days.
*   **Service Account Interactive Use:** Profiling service accounts (which should only run automated scripts) executing interactive, ad-hoc queries.

### 35.4.5 Privilege abuse indicators
*   **The "God Mode" Query:** Profiling the usage of superuser privileges to bypass row-level security or audit triggers.
*   **Trace Enabling:** Profiling users enabling "debug" or "trace" modes on other users' sessions to capture their data or passwords.
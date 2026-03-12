# Databases Complete Study Guide - Part 9: Security & Backup/Recovery

## 19.0 Database Security

### 19.1 Authentication & Authorization
#### 19.1.1 Authentication Mechanisms
- 19.1.1.1 Password authentication — hashed credentials — SCRAM-SHA-256 (PostgreSQL) — salted
  - 19.1.1.1.1 SCRAM — challenge-response — server never sees plaintext — replay-safe
  - 19.1.1.1.2 MD5 auth — deprecated — vulnerable to offline attack — avoid
- 19.1.1.2 Certificate-based auth — mutual TLS — client cert verified by CA — passwordless
  - 19.1.1.2.1 CN in cert = username — map certificate to DB user — no password in config
- 19.1.1.3 IAM-based auth — cloud DBs — AWS RDS IAM / GCP Cloud SQL IAM — token-based
  - 19.1.1.3.1 Short-lived token — 15-min TTL — fetched via AWS SDK — no static password
  - 19.1.1.3.2 Instance-attached service account — no credentials in code — metadata server

#### 19.1.2 Authorization & Privileges
- 19.1.2.1 Role-based access control (RBAC) — grant privileges to roles — assign roles to users
  - 19.1.2.1.1 GRANT SELECT ON table TO role — column-level grants — fine-grained
  - 19.1.2.1.2 REVOKE — remove privileges — cascades if WITH GRANT OPTION
  - 19.1.2.1.3 Row-level security (RLS) — PostgreSQL — policy filter appended to query
- 19.1.2.2 Principle of least privilege — app user — only DML on required tables — no DDL
  - 19.1.2.2.1 Read-only replica user — SELECT only — analytics + reporting — no write risk
  - 19.1.2.2.2 Separate migration user — DDL privileges — used only during schema changes

### 19.2 Encryption
#### 19.2.1 Encryption at Rest
- 19.2.1.1 Transparent Data Encryption (TDE) — encrypt data files — key in key store — AES-256
  - 19.2.1.1.1 Data key encrypted by master key — key rotation = re-encrypt data key only
  - 19.2.1.1.2 Tablespace-level encryption — PostgreSQL pgcrypto / MySQL TDE / SQL Server TDE
- 19.2.1.2 Cloud-managed encryption — AWS KMS / GCP CMEK — envelope encryption
  - 19.2.1.2.1 Customer-managed keys — CMEK — revoke key = instant data inaccessibility
  - 19.2.1.2.2 Key rotation policy — automatic annual rotation — no re-encryption of data

#### 19.2.2 Encryption in Transit
- 19.2.2.1 TLS for all client connections — enforce ssl_mode=require — no plaintext allowed
  - 19.2.2.1.1 SSL certificates — CA cert on client — server cert verification — prevent MITM
  - 19.2.2.1.2 TLS 1.3 — forward secrecy — ephemeral key per session — ECDHE key exchange
- 19.2.2.2 Replication encryption — SSL between primary and replica — WAL encrypted in transit

### 19.3 Auditing & Compliance
#### 19.3.1 Audit Logging
- 19.3.1.1 Statement audit — log all DDL + DML — who / what / when — compliance requirement
  - 19.3.1.1.1 pgaudit (PostgreSQL) — log class=DDL,DML,ROLE — structured audit trail
  - 19.3.1.1.2 MySQL general log — every statement — high overhead — use only when needed
- 19.3.1.2 Object-level audit — audit specific table access — reduce log volume
  - 19.3.1.2.1 Audit sensitive tables — PII / financial — not entire DB — targeted monitoring
- 19.3.1.3 Data masking — dynamic masking — return XXX for non-privileged users — PII safe
  - 19.3.1.3.1 Static masking — copy + redact — for dev/test environments — GDPR safe

---

## 20.0 Backup, Recovery & PITR

### 20.1 Backup Strategies
#### 20.1.1 Backup Types
- 20.1.1.1 Full backup — complete copy — baseline — slowest — largest — weekly
  - 20.1.1.1.1 pg_basebackup — stream base + WAL — online — no lock — PostgreSQL
  - 20.1.1.1.2 mysqldump — logical export — SQL statements — portable — slow for large DBs
- 20.1.1.2 Incremental backup — only changed blocks since last backup — faster — smaller
  - 20.1.1.2.1 WAL archiving — ship WAL files to S3/GCS — base + WAL = full restore
  - 20.1.1.2.2 Block-level incremental — changed pages only — pgBackRest / Barman
- 20.1.1.3 Differential backup — changes since last full — faster restore than incremental chain
  - 20.1.1.3.1 Restore = full + last differential — simpler than incremental chain

#### 20.1.2 Logical vs Physical Backup
- 20.1.2.1 Logical backup — SQL dump — human readable — portable across versions
  - 20.1.2.1.1 pg_dump — custom format (-Fc) — parallel restore (-j) — table-level granularity
  - 20.1.2.1.2 Slow restore — replay all INSERT/DDL — not suitable for multi-TB databases
- 20.1.2.2 Physical backup — binary copy of data files — fast restore — version-specific
  - 20.1.2.2.1 File system snapshot — LVM / EBS snapshot — instant — no DB quiesce needed
  - 20.1.2.2.2 Consistent snapshot — freeze + snapshot + thaw — or use crash-consistent + replay WAL

### 20.2 Point-in-Time Recovery (PITR)
#### 20.2.1 WAL-Based PITR
- 20.2.1.1 Continuous WAL archiving — copy WAL segments to archive — as they complete
  - 20.2.1.1.1 archive_command — shell command — cp %p s3://bucket/%f — PostgreSQL
  - 20.2.1.1.2 archive_status — ready/done — track segments — avoid gap in archive
- 20.2.1.2 Recovery to target — restore base backup → replay WAL → stop at target time/LSN/XID
  - 20.2.1.2.1 recovery_target_time — ISO timestamp — stop replay at that moment
  - 20.2.1.2.2 recovery_target_lsn — exact LSN — surgical restore — post-incident
  - 20.2.1.2.3 Pause at target — recovery_target_action=pause — verify before promoting

#### 20.2.2 RTO & RPO
- 20.2.2.1 RPO (Recovery Point Objective) — max acceptable data loss — how old can restore be
  - 20.2.2.1.1 WAL shipping RPO — archive lag — typically < 5 min with streaming replication
  - 20.2.2.1.2 Synchronous replication — RPO = 0 — zero data loss — at write latency cost
- 20.2.2.2 RTO (Recovery Time Objective) — max acceptable downtime — how fast can restore
  - 20.2.2.2.1 Warm standby — replica already running — promote = seconds — low RTO
  - 20.2.2.2.2 Cold restore — copy from S3 + replay WAL — hours for TB-scale — high RTO
  - 20.2.2.2.3 Test restores — regular fire drills — validate backup integrity — critical
- 20.2.2.3 Backup retention — 30-day minimum — daily + weekly snapshots — tiered storage
  - 20.2.2.3.1 S3 lifecycle policy — move to Glacier after 30 days — cost optimization
  - 20.2.2.3.2 Cross-region replication — backup in second region — disaster recovery

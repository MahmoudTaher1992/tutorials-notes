Here is the detailed content for **Section 36: Encryption Profiling**.

---

# 36. Encryption Profiling

Encryption converts data into unreadable ciphertext, a mathematical process that trades CPU cycles and I/O latency for security. Profiling encryption ensures that this "security tax" remains acceptable and does not become the primary bottleneck of the database system.

## 36.1 Encryption at Rest Profiling

"Encryption at Rest" typically refers to Transparent Data Encryption (TDE) or filesystem-level encryption (e.g., LUKS, dm-crypt). The database engine or OS encrypts data as it is written to disk and decrypts it as it is read into memory.

### 36.1.1 Transparent data encryption (TDE) overhead
*   **The I/O Tax:** TDE adds latency to every physical read and write.
*   **Profiling Read/Write Latency:** Compare `Physical Read Time` metrics with and without TDE. On modern hardware with AES-NI support, the overhead is typically 3-5%, but on legacy hardware or during high-concurrency bursts, it can spike to 10-15%.
*   **Buffer Pool Impact:** Data in the buffer pool (RAM) is usually decrypted. Profiling memory usage is generally unaffected, but the *process* of filling the buffer pool (reading from disk) becomes more CPU-intensive.

### 36.1.2 Encryption/decryption CPU impact
*   **AES-NI Utilization:** Modern CPUs have native instructions for AES encryption.
*   **Profiling Context:** Monitor "System CPU" usage. If the kernel or database process spends excessive time in cryptographic libraries (e.g., `openssl` calls), it indicates that the hardware acceleration is either disabled or saturated.
*   **Throughput Correlation:** Correlate CPU spikes with I/O throughput. If CPU hits 100% at only 500MB/s of disk throughput on an NVMe drive capable of 3GB/s, encryption is the bottleneck.

### 36.1.3 Key management latency
*   **Master Key Access:** TDE relies on a master key stored in an external Key Management Service (KMS) or Hardware Security Module (HSM).
*   **Startup Latency:** Profiling the database startup time. The database must contact the KMS to unwrap the Data Encryption Key (DEK). Network latency or KMS unavailability here causes the database to hang or fail to mount.
*   **Rotation Pauses:** Profiling performance during key rotation events. Re-encrypting the key hierarchy should be instantaneous, but some implementations force a checkpoint.

### 36.1.4 Encrypted backup performance
*   **Compression Defeat:** Encrypted data looks like random noise and is mathematically incompressible.
*   **Profiling Storage Impact:** If backups are compressed *after* encryption, the compression ratio will drop to near 1:1, drastically increasing backup storage costs and I/O time.
*   **Profiling CPU:** If backups are compressed *before* encryption (by the DB engine), profiling the combined CPU load of Compression + Encryption is critical to prevent starving production workloads.

### 36.1.5 Index operations on encrypted data
*   **Page-Level Encryption:** TDE encrypts the *page* on disk, not the logical value. Therefore, indexes work normally in memory.
*   **Logically Encrypted Columns:** If using column-level encryption features (not TDE), range scans become impossible (indexes cannot sort ciphertext). Profiling will show execution plans reverting to "Full Table Scans" instead of "Index Range Scans."

## 36.2 Encryption in Transit Profiling

This covers TLS/SSL connections between the client and the database. The overhead consists of the initial handshake (latency) and the bulk data encryption (throughput).

### 36.2.1 TLS/SSL handshake overhead
*   **Asymmetric Cryptography:** The handshake involves RSA or ECC math, which is computationally expensive.
*   **Profiling "Time to First Byte" (TTFB):** Measure the time from TCP connection establishment to the first data packet. In high-connection-churn environments (e.g., PHP apps without pooling), the cumulative CPU cost of thousands of handshakes per second can cripple the server.

### 36.2.2 Cipher suite selection impact
*   **Algorithm Efficiency:** Not all ciphers are equal. AES-GCM is highly optimized on modern CPUs. Older ciphers (like 3DES or RC4) or software-only ciphers (ChaCha20 without AVX-512) are significantly slower.
*   **Profiling Throughput per CPU Cycle:** Analyzing which cipher suite is negotiated. Forcing a specific high-performance suite in the database configuration can reduce CPU usage by 20-30%.

### 36.2.3 Certificate validation latency
*   **CRL/OCSP Blocking:** The database or client may attempt to verify certificate revocation status.
*   **Network Dependencies:** Profiling login times. If logins randomly take 10+ seconds, it is often due to a timeout trying to reach an external OCSP responder (Certificate Authority) to validate the cert.

### 36.2.4 Connection pooling with TLS
*   **Amortization:** Connection pooling is the primary mitigation for TLS overhead.
*   **Profiling Connection Lifespan:** Ensuring that connections are reused. If the "New Connections per Second" metric is high on a TLS-enabled database, the profiling recommendation is immediate implementation of client-side pooling or a proxy (e.g., PgBouncer).

### 36.2.5 Throughput impact of encryption
*   **Frame Overhead:** TLS adds framing and MAC (Message Authentication Code) overhead to packets.
*   **Bandwidth Cap:** On ultra-high-speed networks (25Gbps+), a single CPU core may not be able to encrypt traffic fast enough to saturate the link. Profiling "ksoftirqd" (kernel soft interrupt) usage helps identify if network encryption is CPU-bound.

## 36.3 Application-Level Encryption Profiling

In this model, the application encrypts data *before* sending it to the database. The database stores "blobs" of ciphertext. This provides the highest security (separation of duties) but the worst database performance.

### 36.3.1 Column-level encryption overhead
*   **Storage Bloat:** Ciphertext is larger than plaintext due to Initialization Vectors (IVs), padding, and base64 encoding. Profiling table size growth (often 30-50% larger) is necessary for capacity planning.
*   **Data Type impact:** An `INTEGER` becomes a `VARCHAR` or `BLOB`. Profiling memory usage shows lower data density in the buffer pool.

### 36.3.2 Client-side encryption impact
*   **Validation Bypass:** The database cannot enforce constraints (e.g., `CHECK (age > 0)`) or referential integrity on encrypted data. Profiling shifts to the application layer to measure validation latency.
*   **Offloading:** Profiling server CPU usually shows a *decrease* in load (since the DB acts as a dumb store), while application server CPU usage increases.

### 36.3.3 Searchable encryption trade-offs
*   **Determinism:** To search for a user, the app must encrypt the search term. This requires deterministic encryption (same input = same output), which weakens security.
*   **No Range Scans:** You cannot index `WHERE salary > 50000` if the salary is `x8f9a...`. Profiling reveals that all analytical queries devolve into full table scans, pulling all data to the application for filtering.
*   **Blind Indexing:** Profiling the maintenance cost of separate "Blind Index" tables used solely for lookups.

### 36.3.4 Key rotation impact
*   **The "Re-Write the World" Problem:** If an application key is compromised or expires, *every row* encrypted with that key must be read, decrypted, re-encrypted, and written back.
*   **Profiling the Migration:** This operation generates massive transaction log volume (WAL/Redo). Profiling disk I/O and replication lag during key rotation is critical to avoid bringing down production.
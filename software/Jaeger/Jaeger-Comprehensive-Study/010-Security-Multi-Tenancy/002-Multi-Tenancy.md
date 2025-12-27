Based on the Table of Contents you provided, here is a detailed explanation of **Part X: Security & Multi-Tenancy — B. Multi-Tenancy**.

In the context of Jaeger (and observability in general), **Multi-Tenancy** refers to the ability to support multiple distinct teams, departments, or customers (tenants) using a single Jaeger installation, while ensuring that **Tenant A cannot see Tenant B's data.**

Since Jaeger does not have a built-in "User Management" or "Tenant Management" system in the Open Source binaries, Multi-Tenancy is achieved through **Architecture** (how you set up the components) rather than a simple configuration setting.

Here is the breakdown of the specific points listed in your ToC:

---

### 1. Passing `x-scope-orgid` Headers (via Reverse Proxy or OTel)

This point addresses **how to identify who the data belongs to** as it enters the system.

Since Jaeger doesn't natively know that "Trace 123" belongs to "Team Finance" and "Trace 456" belongs to "Team Marketing," we have to tag the traffic.

*   **The Concept:** We use a standardized HTTP header, often named `x-scope-orgid` (borrowed from the Cortex/Mimir/Tempo ecosystem), to label the data.
*   **The Role of the Reverse Proxy:** You typically place a Reverse Proxy (like Nginx, Envoy, or Apache) in front of the Jaeger Collector.
    1.  The Application sends traces to the Proxy.
    2.  The Proxy authenticates the request (e.g., via an API Key).
    3.  Based on the API Key, the Proxy identifies the tenant (e.g., "Tenant-A").
    4.  The Proxy injects the header `x-scope-orgid: Tenant-A` into the request and forwards it to the Jaeger Collector.
*   **The Role of OpenTelemetry (OTel):** Alternatively, if you are using the OpenTelemetry Collector, you can configure it to add this attribute or header automatically based on where the data is coming from before sending it to the storage backend.

### 2. Separating Indices per Tenant in Elasticsearch

This point addresses **how to store the data separately** so it doesn't get mixed up.

This is the most common implementation of Multi-Tenancy in Jaeger. Jaeger relies heavily on **Elasticsearch** (or OpenSearch) as its production storage backend. By default, Jaeger creates indices named like this:
`jaeger-span-2023-10-27`

If you have multiple tenants, you cannot put everyone's data in that one index. You need **Index Prefixes**.

*   **How it works:**
    *   You configure the Jaeger Collector (often running a separate Collector instance per tenant, or using dynamic routing) to append a prefix to the index name.
    *   **Tenant A's data** goes to: `tenantA-jaeger-span-2023-10-27`
    *   **Tenant B's data** goes to: `tenantB-jaeger-span-2023-10-27`
*   **The Benefit:**
    *   **Security:** At the database level, you can create permissions so that the "Tenant A User" can only read indices starting with `tenantA-*`.
    *   **Lifecycle Management:** If Tenant A cancels their subscription, you can simply delete all `tenantA-*` indices without affecting Tenant B.

### 3. Data Segregation Strategies

This point discusses the different **architectural approaches** to keeping data apart. There are usually two main strategies:

#### A. Logical Segregation (Shared Infrastructure)
*   **Setup:** Everyone uses the same Jaeger Collector and the same Elasticsearch Cluster.
*   **Mechanism:** Separation is done via the **Index Prefixes** described above.
*   **Pros:** Very cost-effective. You only pay for one cluster.
*   **Cons:** "Noisy Neighbor" problem. If Tenant A sends 1 million spans per second and crashes the Elasticsearch cluster, Tenant B is also unable to see their traces.
*   **Security:** Relies heavily on the configuration of the Reverse Proxy and Elasticsearch Roles. If a configuration mistake happens, data might leak.

#### B. Physical Segregation (Isolated Infrastructure)
*   **Setup:** Every tenant gets their own Jaeger Collector and potentially their own storage (or at least their own Namespaces in Kubernetes).
*   **Mechanism:** You spin up a full Jaeger stack for Tenant A and a completely different stack for Tenant B.
*   **Pros:** Maximum security and performance isolation. Tenant A cannot crash Tenant B's system.
*   **Cons:** Very expensive and harder to maintain (more operational overhead).

---

### Summary: The Life of a Multi-Tenant Trace

To visualize how this section works in practice, here is the flow:

1.  **Ingestion:** The Microservice sends a trace to an **Auth Proxy**.
2.  **Tagging:** The Proxy validates the API key, determines this is **Tenant-A**, adds a header `X-Tenant: A`, and forwards it to the **Jaeger Collector**.
3.  **Storage:** The Jaeger Collector reads the header and writes the trace to an Elasticsearch index named `tenant-a-spans-DATE`.
4.  **Querying (The UI):** When a user logs into the Jaeger UI, they go through an **Auth Proxy** again.
5.  **Filtering:** The Proxy sees the user belongs to Tenant-A. It restricts the Jaeger Query service to only look at Elasticsearch indices starting with `tenant-a-*`.
6.  **Result:** The user sees only their own traces.

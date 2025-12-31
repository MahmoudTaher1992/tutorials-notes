Based on the Table of Contents you provided, here is a detailed explanation of **Part VII: Production Deployment & Kubernetes**, specifically section **A. Kubernetes Integration**.

This section moves away from running Jaeger on a laptop (Docker) and focuses on how to run it reliably, securely, and at scale inside a Kubernetes (K8s) cluster.

---

### 1. The Jaeger Operator: Managing Lifecycle via CRDs
In Kubernetes, managing complex applications manually (writing individual YAML files for Deployments, Services, ConfigMaps, and Secrets) is difficult and error-prone. The **Jaeger Operator** is a tool designed to automate this.

*   **What is it?** It is a custom controller that runs inside your cluster. It watches for specific configuration files and automatically builds the Jaeger infrastructure for you.
*   **CRDs (Custom Resource Definitions):** The Operator introduces a new "kind" of resource to Kubernetes called `Jaeger`. Instead of configuring low-level pods, you write a high-level configuration.
*   **Deployment Strategies:** The Operator supports three main modes, which you define in the CRD:
    1.  **`allInOne`:** (Dev/Test) Deploys everything in a single Pod with in-memory storage. Not for production.
    2.  **`production`:** (High Availability) Deploys the Collector and Query service separately. It expects an external storage cluster (like Elasticsearch or Cassandra) to already exist or be provisioned. It allows you to scale Collectors independently of the Query UI.
    3.  **`streaming`:** (Massive Scale) Deploys the Collector, Ingester, and Query, expecting a Kafka cluster in the middle to buffer traffic.

**Example of how simple it becomes:**
```yaml
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: my-prod-jaeger
spec:
  strategy: production
  storage:
    type: elasticsearch
    options:
      es:
        server-urls: http://elasticsearch:9200
```

### 2. Sidecar vs. DaemonSet Deployment for Agents
The **Jaeger Agent** is the component that your application sends traces to via UDP (usually port 6831). The Agent then pushes those traces to the Collector. In Kubernetes, there are two ways to deploy this Agent:

#### Option A: Sidecar (The Default/Preferred Way)
*   **How it works:** A Jaeger Agent container runs inside the **same Pod** as your application container. They share the generic network space (localhost).
*   **Pros:**
    *   **Networking is simple:** Your app sends traces to `localhost:6831`. No DNS or service discovery is needed.
    *   **Multi-tenancy:** You can configure the Agent with specific tags for that specific application.
*   **Cons:**
    *   **Resource Overhead:** If you have 1,000 pods, you have 1,000 agents running. This consumes more CPU/Memory across the cluster.
*   **Automatic Injection:** The Jaeger Operator can automatically "inject" this sidecar into your pods if you add the annotation `sidecar.jaegertracing.io/inject: "true"` to your application deployment.

#### Option B: DaemonSet
*   **How it works:** One Jaeger Agent runs on **every Node** (physical/virtual machine) in the cluster.
*   **Pros:**
    *   **Efficiency:** If a node hosts 20 app pods, they all share 1 Agent. Much lighter on resources.
*   **Cons:**
    *   **Networking Complexity:** Your app cannot use `localhost`. It must send traces to the IP address of the Node it is currently running on. You have to configure the Kubernetes Downward API to pass the Node IP to the application.
    *   **Noisy Neighbor:** If one app floods the node's Agent, other apps on that node might lose traces.

### 3. Security Contexts and Resource Limits
Running in production means you must adhere to security and stability best practices.

*   **Resource Limits & Requests:**
    *   Jaeger components (especially the Collector and Java-based Elasticsearch) can be memory-hungry.
    *   You must define **Requests** (guaranteed RAM/CPU) so Kubernetes schedules them on appropriate nodes.
    *   You must define **Limits** (max RAM/CPU) so that if a Collector goes haywire, K8s kills it before it crashes the entire Node.
*   **Security Context:**
    *   **Non-Root:** You should ensure Jaeger images do not run as the `root` user.
    *   **Read-Only Filesystem:** For security, mount the container's root filesystem as read-only, using generic ephemeral volumes only for temp data.
    *   **Privilege Escalation:** Ensure `allowPrivilegeEscalation` is set to false in the YAML to prevent attackers from breaking out of the container.

### 4. Ingress Configuration for UI and Collector
Finally, you need to expose Jaeger to the outside world (or internal network).

*   **The Jaeger UI:**
    *   You need to create a Kubernetes **Ingress** resource (using Nginx, Traefik, ALB, etc.).
    *   This maps a URL (e.g., `https://tracing.company.com`) to the internal Jaeger Query service (port 16686).
    *   **Production Tip:** This is where you attach TLS/SSL certificates and enforce Authentication (OAuth/SSO) so random internet users can't see your system architecture.
*   **The Collector (Optional External Access):**
    *   Usually, Collectors are only accessed internally by Agents or the Cluster.
    *   However, if you have mobile apps or external clients sending traces, you might need to expose the Collector via a LoadBalancer or Ingress on HTTP/gRPC ports (14268/14250).

### Summary of this Section
This part of the study guide teaches you to stop treating Jaeger as a binary you run in a terminal and start treating it as a **Cloud-Native Infrastructure**. It emphasizes using the **Operator** to manage complexity, choosing the right **Agent strategy** (Sidecar vs. DaemonSet) based on your resource budget, and securing the deployment for a multi-tenant environment.

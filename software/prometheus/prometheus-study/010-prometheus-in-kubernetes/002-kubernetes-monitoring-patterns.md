Based on the Table of Contents you provided, **Part X, Section B: Kubernetes Monitoring Patterns** focuses on the specific strategies and architectures used to effectively monitor a Kubernetes cluster and the applications running inside it.

Unlike a traditional monolithic server where you just install an agent, Kubernetes is distributed and ephemeral. This requires specific "design patterns" to ensure you capture everything from the hardware up to the application logic.

Here is a detailed explanation of the three core pillars listed in that section.

---

### 1. Monitoring the Control Plane (Infrastructure Layer)
Before you monitor your applications, you must ensure the "brain" of Kubernetes is healthy. If the Control Plane fails, you lose the ability to schedule pods, scale, or manage the cluster.

*   **The API Server:** This is the entry point for all REST commands. You monitor it to track request latency, error rates (HTTP 4xx/5xx), and saturation (is it handling too many requests?).
*   **etcd:** The source of truth (database) for the cluster. Monitoring disk sync duration and leadership changes is critical. If etcd is slow, the whole cluster becomes slow.
*   **The Scheduler:** Decides where pods go. You monitor this to see if there are "unschedulable pods" (pending) due to lack of resources.
*   **Kube-Controller-Manager:** Runs the control loops (like checking if the number of replicas matches the deployment spec).

**The Pattern:**
Since these components (in managed clouds like EKS/GKE/AKS) are often managed by the provider, you typically scrape the **metrics endpoints** they expose. In a self-hosted cluster (kubeadm), you treat them as static targets or discover them via Kubernetes Service Discovery.

---

### 2. Monitoring Workloads (Sidecars vs. Exporters)
This section deals with how you get metrics out of specific applications. There are two main patterns here depending on whether you can modify the application code or not.

#### A. The "Sidecar" Pattern (For Legacy/Blackbox Apps)
Imagine you are running Nginx or a Java app that doesn't have a Prometheus library built-in.
*   **How it works:** You define a Kubernetes Pod with **two containers** inside it.
    1.  **Main Container:** Your application (e.g., Nginx).
    2.  **Sidecar Container:** A Prometheus Exporter (e.g., `nginx-prometheus-exporter`).
*   **The Logic:** The Exporter talks to the Main App via `localhost` (since they share the same network namespace in the Pod), converts the stats to Prometheus format, and exposes port 9113 for Prometheus to scrape.
*   **Pros:** Tightly coupled; if the app dies, the metrics die (which is good for accuracy).
*   **Cons:** Increases resource usage (CPU/RAM) for *every* pod you deploy.

#### B. The "Native Instrumentation" Pattern (Whitebox)
This is the modern standard. You write code using the Prometheus client library (Go, Python, Java).
*   **How it works:** Your application code has an HTTP handler `/metrics` built right into it.
*   **The Pattern:** You simply define a `Service` or `PodMonitor` configuration. Prometheus scrapes the pod directly. No sidecar is needed.

#### C. The "DaemonSet" Pattern (Node Monitoring)
For metrics that belong to the *Node* rather than a specific *App* (like CPU, Disk usage, Network bandwidth), you don't run a sidecar.
*   **How it works:** You use a **DaemonSet** to ensure exactly one instance of the **Node Exporter** runs on every single node in the cluster.

---

### 3. Resource Metrics vs. Custom Metrics API (HPA Integration)
This is where monitoring turns into **automation**. Kubernetes creates a distinction between "keeping the lights on" metrics and "scaling" metrics.

#### A. Resource Metrics (The "Metrics Server")
*   **What it is:** Basic CPU and Memory usage.
*   **Tooling:** A lightweight component called `metrics-server` runs in the cluster. It grabs stats from the Kubelet.
*   **Use Case:** The standard Horizontal Pod Autoscaler (HPA) uses this.
    *   *Example:* "If CPU > 80%, add more pods."
*   **Limitation:** It is not historical (only real-time) and it doesn't know about application logic (like queue depth or HTTP hits).

#### B. The Custom Metrics API (Prometheus Adapter)
This is the advanced pattern. You want to scale based on business logic, not just CPU.
*   **The Problem:** The Kubernetes HPA controller doesn't speak "PromQL". It only speaks the Kubernetes API.
*   **The Solution:** You install the **Prometheus Adapter**.
*   **How it works:**
    1.  The Adapter acts as a translator.
    2.  You write a PromQL query (e.g., `sum(rate(http_requests_total[2m]))`).
    3.  The Adapter exposes this to Kubernetes as a "Custom Metric."
    4.  You configure your HPA to scale based on that custom metric.
*   **Real World Example:** "If the number of items in the RabbitMQ queue > 100, scale up the worker pods," regardless of whether CPU is high or low.

### Summary of this Section
This chapter of your study plan is teaching you that **Kubernetes monitoring is not one-size-fits-all**.
1.  Use **DaemonSets** for hardware/node metrics.
2.  Use **Sidecars** for legacy apps that can't be modified.
3.  Use **Native Instrumentation** for modern microservices.
4.  Use the **Custom Metrics API** to connect Prometheus data to Kubernetes Autoscaling (HPA).

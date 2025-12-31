This section of the syllabus, **Part II, Section A: Host and Container Monitoring**, is the foundation of infrastructure observability. Before you can monitor complex applications (APM) or logs, you must understand the health of the underlying machinery (Servers, VMs, Containers, and Orchestrators).

Here is a detailed breakdown of each concept within this module.

---

### 1. The Host Map & Infrastructure List
This covers how Datadog visualizes the inventory of all the servers (hosts) running the Datadog Agent.

*   **The Host Map:**
    *   **What it is:** A high-level visualization where every host is represented as a hexagon.
    *   **Function:** It allows you to visualize thousands of hosts on one screen. You can **group** hosts by tags (e.g., group by `region` or `availability-zone`) and **fill** the color of the hexagons based on a metric (e.g., "Color by CPU utilization").
    *   **Use Case:** Spotting outliers. If you have 100 servers and 99 are green (low CPU) but one is bright red (high CPU), you can visually identify the problem instantly without reading logs.
*   **The Infrastructure List:**
    *   **What it is:** A tabular, searchable list of all hosts.
    *   **Function:** It provides columns for tags, status (up/down), and key metrics. This is where you go to check if a specific server is reporting or to filter the list to a specific fleet (e.g., `env:production`).

### 2. System Metrics (CPU, Mem, Disk, I/O)
Once the Agent is installed on a host (Linux, Windows, or macOS), it immediately begins sending "System" metrics without any extra configuration. These are the vital signs of a computer.

*   **CPU:** Measured in usage breakdown (User, System, Iowait, Idle, Steal). High "Steal" usually means a "Noisy Neighbor" problem in cloud environments.
*   **Memory:** Usable vs. Available memory. It is crucial to monitor Swap usage; if a Linux box starts swapping to disk, performance crashes.
*   **Disk:** Monitoring free space (to prevent disk full outages) and Inode usage.
*   **I/O (Input/Output):** Read and Write operations per second. High I/O wait times indicate the disk cannot keep up with the application.

### 3. Container Monitoring (Docker, Containerd)
Modern infrastructure rarely runs applications directly on the OS; they run in containers. The Datadog Agent understands this distinction.

*   **The Shift:** Traditional monitoring looks at the *Host*. Container monitoring looks at the *runtime* (Docker or Containerd).
*   **Collection Method:** The Datadog Agent connects to the Docker Socket (typically `/var/run/docker.sock`) or the Containerd API.
*   **Visibility:** This allows Datadog to separate metrics. You can see that Host A has high CPU usage, and specifically, that *Container X* inside Host A is the culprit.
*   **Lifecycle:** Containers are ephemeral (they live and die quickly). Datadog tracks short-lived containers differently than long-lived hosts to avoid cluttering your dashboard with "dead" entities.

### 4. Kubernetes (K8s) Deep Dive
This is usually the most complex and critical part of modern infrastructure monitoring. Kubernetes introduces a layer of abstraction that requires specific Datadog components.

#### **A. The Cluster Agent vs. Node Agent**
*   **The Node Agent (DaemonSet):** This is the standard Agent running on *every* worker node. It monitors the metrics of that specific node and the pods running on it (CPU, Mem, Network).
*   **The Cluster Agent (DCA):** This is a special, centralized agent (usually 1 or 2 replicas per cluster). It does **not** monitor a specific node. Instead, it talks to the **Kubernetes API Server**.
    *   *Why do we need it?* To gather cluster-wide data (e.g., "How many pods are pending?", "Is the scheduler healthy?", "Events like `OOMKilled`"). It also acts as a proxy to reduce traffic to the K8s API server.

#### **B. DaemonSets and Helm Charts**
*   **Deployment:** You rarely install the Agent manually (SSH) on K8s. You use **Helm** (a package manager for K8s).
*   **DaemonSet:** The Helm chart configures the Node Agent as a *DaemonSet*. In K8s, a DaemonSet ensures that exactly one copy of the Agent pod runs on every single Node in the cluster, even as you auto-scale and add new nodes.

#### **C. Autodiscovery (Annotations vs. Labels)**
*   **The Problem:** In K8s, pods move around. If a Redis pod moves from Node A to Node B, the IP changes. You cannot write a static configuration file saying "Monitor Redis at IP 10.0.0.5."
*   **The Solution (Autodiscovery):** The Datadog Agent listens to K8s events. When a container starts, the Agent checks the container's metadata for instructions on how to monitor it.
*   **How it works:** You add specific **Annotations** to your Pod YAML.
    *   *Example:* You add an annotation to your Redis pod that says:
        ```yaml
        ad.datadoghq.com/redis.check_names: '["redisdb"]'
        ad.datadoghq.com/redis.init_configs: '[{}]'
        ad.datadoghq.com/redis.instances: '[{"host": "%%host%%", "port": "6379"}]'
        ```
    *   When the Agent sees this pod start, it reads these annotations, replaces `%%host%%` with the container's actual IP, and dynamically starts monitoring Redis.

#### **D. Kube State Metrics (KSM)**
*   **What it is:** A service that listens to the K8s API server and generates metrics about the state of objects.
*   **The Data:** KSM doesn't measure performance (CPU/RAM); it measures **state**.
    *   *Examples:* "Number of replicas desired vs. available," "Number of pod restarts," "Deployment status."
*   **Integration:** The Datadog Cluster Agent connects to KSM to visualize the health of your deployments and services, not just the raw hardware usage.

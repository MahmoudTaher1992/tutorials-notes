# Cloud Design Patterns: A Comprehensive Study Guide

## Part I: Availability

### A. Core Concepts and Principles
-   **High Availability (HA) vs. Disaster Recovery (DR):** Understanding the distinction and relationship between ensuring continuous operation and recovering from catastrophic failures.
-   **Key Performance Indicators (KPIs):** Defining and measuring Service Level Agreements (SLAs), Service Level Objectives (SLOs), and Service Level Indicators (SLIs).
-   **Redundancy and Failover:** Exploring strategies for duplicating components and automatically switching to a redundant system in case of failure.

### B. Resiliency and Fault Tolerance Patterns
-   **Retry Pattern:** A strategy that enables an application to handle temporary failures by re-issuing a failed operation.
-   **Circuit Breaker Pattern:** A mechanism to prevent an application from repeatedly trying to execute an operation that is likely to fail.
-   **Bulkhead Pattern:** A method of isolating application elements into pools so that if one fails, others can continue to function.
-   **Leader Election Pattern:** A technique for coordinating actions among a collection of instances by electing one as the leader.
-   **Health Endpoint Monitoring:** The practice of exposing a specific endpoint that external tools can use to check the health of an application.

### C. Scalability and Load Management Patterns
-   **Load Balancing:** The distribution of network or application traffic across multiple servers to ensure no single server becomes overwhelmed.
-   **Throttling Pattern:** A method for controlling the consumption of resources by an application to prevent overuse.
-   **Queue-Based Load Leveling:** The use of a queue to buffer requests between a task and a service, smoothing out heavy loads.

## Part II: Data Management

### A. Foundational Data Patterns
-   **Cache-Aside Pattern:** A caching strategy where data is loaded into the cache on demand from the data store.
-   **Sharding Pattern:** The division of a large database into smaller, more manageable parts called shards.
-   **Event Sourcing Pattern:** A pattern where all changes to an application's state are stored as a sequence of events.

### B. Advanced Data Strategies
-   **CQRS (Command Query Responsibility Segregation) Pattern:** The separation of read and write operations for a data store.
-   **Materialized View Pattern:** The pre-computation and storage of data in a format that is optimized for specific query needs.
-   **Index Table Pattern:** The creation of indexes over fields in a data store that are frequently accessed by queries.
-   **Saga Pattern:** A way to manage data consistency across microservices in distributed transaction scenarios.

### C. Data Architecture Models
-   **Data Lake:** A centralized repository that allows for the storage of all structured and unstructured data at any scale.
-   **Data Warehouse:** A system used for reporting and data analysis, considered a core component of business intelligence.
-   **Data Mesh:** A decentralized approach to data architecture where data is treated as a product and owned by the teams that know it best.
-   **Data Fabric:** An architecture that enables seamless data integration and access across various environments.

## Part III: Design and Implementation

### A. Architectural Patterns
-   **Microservices Architecture:** An architectural style that structures an application as a collection of small, autonomous services.
-   **Serverless Architecture:** A cloud-native development model that allows developers to build and run applications without having to manage servers.
-   **Event-Driven Architecture:** A software architecture paradigm promoting the production, detection, consumption of, and reaction to events.

### B. Gateway and Communication Patterns
-   **API Gateway Pattern:** The use of a single entry point for all client requests, which then routes requests to the appropriate microservice.
-   **Gateway Routing Pattern:** The routing of requests to multiple services using a single endpoint.
-   **Gateway Aggregation Pattern:** The use of a gateway to aggregate multiple individual requests into a single request.
-   **Gateway Offloading Pattern:** The offloading of shared or specialized service functionality to a gateway proxy.

### C. Service and Integration Patterns
-   **Sidecar Pattern:** The deployment of application components into a separate process or container to provide isolation and encapsulation.
-   **Ambassador Pattern:** The creation of helper services that send network requests on behalf of a consumer service or application.
-   **Anti-Corruption Layer Pattern:** The implementation of a façade or adapter layer between a modern application and a legacy system to prevent the leakage of the legacy design into the modern application.
-   **Strangler Fig Pattern:** A method for incrementally migrating a legacy system by gradually replacing specific pieces of functionality with new applications and services.

## Part IV: Management and Monitoring

### A. Configuration and Deployment Patterns
-   **External Configuration Store Pattern:** The practice of moving application configuration information to a centralized location outside of the application.
-   **Blue-Green Deployment:** A release strategy that involves running two identical production environments to minimize downtime and risk.
-   **Canary Release:** A technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users.

### B. Monitoring and Observability
-   **Infrastructure Monitoring:** The process of collecting and analyzing data on the performance of infrastructure components.
-   **Application Performance Monitoring (APM):** The tracking of key software application performance metrics to identify and diagnose issues.
-   **Log Management:** The collective processes and policies used to administer and facilitate the generation, transmission, analysis, storage, and disposal of log data.

### C. Security Patterns
-   **Federated Identity Pattern:** The delegation of authentication to an external identity provider.
-   **Gatekeeper Pattern:** A pattern that centralizes request validation and sanitation to protect an application.
-   **Valet Key Pattern:** A security approach where clients use a token or key to get restricted access to specific resources or services.
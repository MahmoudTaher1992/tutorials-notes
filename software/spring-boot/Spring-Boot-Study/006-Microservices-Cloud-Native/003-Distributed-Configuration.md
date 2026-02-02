Below is a detailed explanation of **Part VI (Microservices & Cloud-Native Development), Section C: Distributed Configuration**.

---

# Part VI.C: Distributed Configuration

In a monolithic application, you typically store configuration files (like `application.properties` or `application.yml`) inside the project folder. You build the application, and the configuration is "baked" into the JAR file.

**The Problem in Microservices:**
Imagine you have 50 microservices. Each service has a `Dev`, `Test`, `Staging`, and `Production` environment. That is 200 different configurations to manage.
*   If you need to change a database password or a timeout setting, you have to go to the specific project code, change the file, rebuild the JAR, and redeploy the service.
*   This is slow, error-prone, and violates the **Cloud Native** principle of separating *config* from *code*.

**The Solution:**
**Distributed Configuration**. You move all configuration files out of the application code and into a central location (like a Git repository). A dedicated server manages these configurations and serves them to microservices at startup.

---

### 1. Spring Cloud Config Server and Client

Spring Cloud Config is the standard way to handle this in the Spring ecosystem. It consists of two parts:

#### A. The Config Server
This is a standalone Spring Boot application. Its only job is to talk to a backend storage (usually Git) and expose those configuration files via a REST API.

*   **Backend Storage:** The Config Server connects to a Github/GitLab repository where your YAML/Properties files live.
*   **The Structure:** Files in the Git repo are usually named by service and profile.
    *   `payment-service.yml` (Default config for Payment Service)
    *   `payment-service-dev.yml` (Dev specific overrides)
    *   `payment-service-prod.yml` (Prod specific overrides)

**How to set up a Config Server:**
1.  Add `spring-cloud-config-server` dependency.
2.  Annotate your main class with `@EnableConfigServer`.
3.  Point it to your Git repo in `application.properties`:
    ```properties
    spring.cloud.config.server.git.uri=https://github.com/my-org/config-repo
    server.port=8888
    ```

#### B. The Config Client
These are your actual microservices (e.g., User Service, Product Service). When they start up, they don't look inside their own JAR for config first; they call the Config Server.

**How to set up a Client:**
1.  Add `spring-cloud-starter-config` dependency.
2.  Tell the client where the Config Server is (usually in `application.properties` or `bootstrap.properties`):
    ```properties
    spring.application.name=payment-service
    spring.config.import=optional:configserver:http://localhost:8888
    ```

**The Flow:**
1.  Payment Service boots up.
2.  It contacts `http://localhost:8888`.
3.  It asks: "I am `payment-service` in the `dev` profile. Give me my config."
4.  Server reads `payment-service-dev.yml` from Git and sends it back as JSON.
5.  Payment Service applies the settings and finishes starting up.

---

### 2. Capabilities of Distributed Config

#### Hot Reloading (Refresh Scope)
One of the most powerful features is changing configuration **without restarting** the microservice.

*   **Scenario:** You have a feature flag `feature.new-ui.enabled=false`. You want to turn it `true` in Production instantly.
*   **The Fix:** You update the file in the Git Repo.
*   **The Action:** You send a `POST` request to the microservice's actuator endpoint (`/actuator/refresh`) or use **Spring Cloud Bus** (RabbitMQ/Kafka) to broadcast the change to all instances.
*   **The Code:** In your Java code, you use the `@RefreshScope` annotation on beans that need to update dynamically.

```java
@RestController
@RefreshScope // This bean reloads when config changes!
public class PaymentController {

    @Value("${payment.timeout}")
    private int timeout;

    // ...
}
```

---

### 3. Centralized Secrets Management

storing configuration in Git is great, but **never store passwords, API keys, or secrets in plain text in Git.** If your Git repo is compromised, your database is compromised.

Distributed Configuration handles this in two ways:

#### A. Encryption/Decryption (Built-in)
Spring Cloud Config Server can handle encryption keys.
1.  You encrypt the password using the CLI.
2.  You put the encrypted string in Git:
    ```yaml
    spring.datasource.password: '{cipher}FKZA234F98...'
    ```
3.  When the Server reads this file, it decrypts it effectively in memory before sending it to the Client (or sends it encrypted, and the Client decrypts it, depending on setup). The plain text password never exists in the Git repo.

#### B. HashiCorp Vault Integration
For enterprise-grade security, companies use **Vault**.
*   Vault is a dedicated tool for storing secrets securely.
*   Spring Cloud Config can be configured to read from Vault instead of (or alongside) Git.
*   This allows automatic rotation of database credentials (changing passwords every hour automatically) without the developer ever knowing the actual password.

---

### Summary Diagram

```text
[ Developer ] --push changes--> [ Git Repository (Configs) ]
                                         |
                                         v
                                [ Spring Cloud Config Server ]
                                (Reads Git, decrypts secrets)
                                         |
                                         v
       -------------------------------------------------------------
       |                               |                           |
[ Order Service ]             [ Payment Service ]           [ Inventory Service ]
(Config Client)               (Config Client)               (Config Client)
```

**Why learn this?**
If you mention "Microservices" in an interview, you **will** be asked how you handle configuration changes across 50 services without 50 restarts. This module is the answer.

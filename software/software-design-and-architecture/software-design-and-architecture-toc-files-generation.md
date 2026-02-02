#!/bin/bash

# Define the root directory name
ROOT_DIR="Software-Design-Architecture-Study"

# Create Root Directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# Function to create a file with content
create_file() {
    local dir_name="$1"
    local file_name="$2"
    local title="$3"
    local content="$4"

    # Create the directory if it doesn't exist
    mkdir -p "$dir_name"

    # Write content to the file using heredoc
    cat <<EOF > "$dir_name/$file_name"
# $title

$content

## Notes
- 
EOF
}

# ==============================================================================
# Part I: The Foundation – Principles of Quality Software
# ==============================================================================
DIR_01="001-The-Foundation-Principles-of-Quality-Software"

create_file "$DIR_01" "001-Introduction-to-Software-Design-and-Architecture.md" "Introduction to Software Design & Architecture" \
"- The \"Why\": The Cost of Poor Architecture (Complexity, Rigidity, Fragility)
- Design vs. Architecture: Scope and Abstraction Levels
- Key Goals of Good Architecture: Maintainability, Scalability, Reliability, Evolvability
- The Role of the Software Architect
- The Inevitability of Trade-offs (e.g., Consistency vs. Availability, Performance vs. Cost)"

create_file "$DIR_01" "002-Core-Principles-of-Clean-Code.md" "Core Principles of Clean Code" \
"- The Philosophy: Code as Communication
- Naming Conventions: Intent-Revealing Names
- Functions & Methods: Single Responsibility, Small Size, Command-Query Separation
- Comments: The Art of Not Needing Them (Code as Documentation)
- Formatting & Style: Consistency and Readability
- Error Handling: Exceptions vs. Return Codes, Graceful Failure
- Simplicity and Refactoring: The Boy Scout Rule (Leave the codebase cleaner than you found it)"

create_file "$DIR_01" "003-Fundamental-Quality-Metrics.md" "Fundamental Quality Metrics" \
"- **Cohesion**: The degree to which elements inside a module belong together (High Cohesion is good)
- **Coupling**: The measure of dependency between modules (Low Coupling is good)
- Connascence: A Deeper Look at Coupling (Name, Type, Value, Position, etc.)
- Cyclomatic Complexity: Measuring Code Complexity and Testability"

# ==============================================================================
# Part II: Programming Paradigms – The Building Blocks of Thought
# ==============================================================================
DIR_02="002-Programming-Paradigms"

create_file "$DIR_02" "001-OOP-Deep-Dive.md" "Object-Oriented Programming (OOP) Deep Dive" \
"- The Four Pillars:
  - **Encapsulation**: Bundling data and methods, information hiding
  - **Abstraction**: Hiding complex reality while exposing essential parts
  - **Inheritance**: Creating new classes from existing ones (is-a relationship)
  - **Polymorphism**: A single interface for entities of different types
- Classes vs. Objects, Abstract Classes vs. Interfaces
- The Diamond Problem and its solutions"

create_file "$DIR_02" "002-Functional-Programming-for-Architects.md" "Functional Programming (FP) for Architects" \
"- Core Concepts: Immutability, Pure Functions, First-Class Functions
- Side Effects and how to manage them
- Declarative vs. Imperative Programming Style
- Benefits in Modern Systems: Concurrency, Predictability, Testability
- Hybrid Approaches: Using FP concepts in OO languages"

create_file "$DIR_02" "003-Other-Paradigms.md" "Other Paradigms" \
"- Structured Programming: The foundation (Sequence, Selection, Iteration)
- Aspect-Oriented Programming (AOP): Cross-cutting concerns (logging, security)"

# ==============================================================================
# Part III: Design Principles – The Rules for Good Structure
# ==============================================================================
DIR_03="003-Design-Principles"

create_file "$DIR_03" "001-The-SOLID-Principles.md" "The SOLID Principles" \
"- **S** - Single Responsibility Principle (SRP): A class should have one reason to change.
- **O** - Open/Closed Principle (OCP): Open for extension, closed for modification.
- **L** - Liskov Substitution Principle (LSP): Subtypes must be substitutable for their base types.
- **I** - Interface Segregation Principle (ISP): Many client-specific interfaces are better than one general-purpose interface.
- **D** - Dependency Inversion Principle (DIP): Depend on abstractions, not concretions."

create_file "$DIR_03" "002-Other-Key-Design-Principles.md" "Other Key Design Principles" \
"- **DRY**: Don't Repeat Yourself
- **KISS**: Keep It Simple, Stupid
- **YAGNI**: You Ain't Gonna Need It
- Composition over Inheritance: Favoring flexibility (has-a over is-a)
- Law of Demeter (Principle of Least Knowledge): Talk only to your immediate friends.
- Tell, Don't Ask: Don't query an object for state and then act on it; tell the object what to do."

# ==============================================================================
# Part IV: Design Patterns – Reusable Solutions
# ==============================================================================
DIR_04="004-Design-Patterns"

create_file "$DIR_04" "001-Gang-of-Four-Patterns.md" "Gang of Four (GoF) Patterns" \
"- **Creational Patterns**: Abstracting object instantiation
  - Singleton, Factory Method, Abstract Factory, Builder, Prototype
- **Structural Patterns**: Composing objects into larger structures
  - Adapter, Decorator, Facade, Proxy, Composite, Bridge
- **Behavioral Patterns**: Managing algorithms and responsibilities
  - Strategy, Observer, Command, Template Method, Iterator, State, Chain of Responsibility"

create_file "$DIR_04" "002-Enterprise-and-Application-Level-Patterns.md" "Enterprise & Application-Level Patterns" \
"- Patterns of Enterprise Application Architecture (PoEAA - Fowler)
- Domain Logic Patterns: Transaction Script, Domain Model, Table Module
- Data Source Patterns: Repository, Data Mapper, Active Record, Unit of Work
- Presentation Patterns: Model-View-Controller (MVC), Model-View-Presenter (MVP), Model-View-ViewModel (MVVM)"

create_file "$DIR_04" "003-Anti-Patterns-to-Avoid.md" "Anti-Patterns to Avoid" \
"- God Object, Spaghetti Code, Magic Numbers, Leaky Abstractions, Premature Optimization"

# ==============================================================================
# Part V: Architectural Styles – The High-Level Blueprints
# ==============================================================================
DIR_05="005-Architectural-Styles"

create_file "$DIR_05" "001-Monolithic-Architectures.md" "Monolithic Architectures" \
"- Layered Architecture (N-Tier): Presentation, Business, Persistence, Database
- Modular Monolith: Benefits of modularity within a single deployment unit
- Pros, Cons, and When to Use"

create_file "$DIR_05" "002-Distributed-Architectures.md" "Distributed Architectures" \
"- Client-Server & Peer-to-Peer
- Service-Oriented Architecture (SOA): The philosophy and principles
- Microservices Architecture: Bounded Contexts, Decentralized Governance, Single Responsibility
- Serverless Architecture & Function-as-a-Service (FaaS)
- Space-Based Architecture"

create_file "$DIR_05" "003-Event-Driven-and-Messaging-Architectures.md" "Event-Driven & Messaging Architectures" \
"- The Core Idea: Decoupling via asynchronous events
- Publish-Subscribe (Pub/Sub) Pattern
- Event Streaming (e.g., Kafka, Pulsar)
- Event Notification vs. Event-Carried State Transfer"

# ==============================================================================
# Part VI: Architectural Patterns – Implementing the Blueprints
# ==============================================================================
DIR_06="006-Architectural-Patterns"

create_file "$DIR_06" "001-Patterns-for-Microservices.md" "Patterns for Microservices & Distributed Systems" \
"- API Gateway
- Service Discovery
- Centralized Configuration
- Circuit Breaker
- Saga Pattern for distributed transactions
- Sidecar Pattern"

create_file "$DIR_06" "002-Data-Centric-Architectural-Patterns.md" "Data-Centric Architectural Patterns" \
"- **CQRS** (Command Query Responsibility Segregation): Separating read and write models
- **Event Sourcing**: Storing the state as a sequence of events
- Blackboard Pattern (for AI/complex problem-solving)
- Master-Slave & Master-Master Replication"

create_file "$DIR_06" "003-Domain-Driven-Design.md" "Domain-Driven Design (DDD)" \
"- Strategic Design: Bounded Context, Ubiquitous Language, Context Mapping
- Tactical Design: Aggregate, Entity, Value Object, Repository, Factory, Domain Events"

# ==============================================================================
# Part VII: Architectural "ilities" – Cross-Cutting Concerns
# ==============================================================================
DIR_07="007-Architectural-Ilities"

create_file "$DIR_07" "001-Scalability-and-Performance.md" "Scalability & Performance" \
"- Horizontal vs. Vertical Scaling
- Caching Strategies (In-memory, Distributed, CDN)
- Load Balancing
- Database Scaling: Sharding, Replication, Connection Pooling"

create_file "$DIR_07" "002-Reliability-and-Resilience.md" "Reliability & Resilience" \
"- High Availability (HA) and Fault Tolerance
- Disaster Recovery (DR)
- Redundancy and Failover
- Patterns: Retry, Bulkhead, Timeouts"

create_file "$DIR_07" "003-Security.md" "Security" \
"- Threat Modeling
- Defense in Depth
- Authentication vs. Authorization (OAuth, OpenID Connect, JWT)
- Principle of Least Privilege
- DevSecOps: Integrating security into the development lifecycle"

create_file "$DIR_07" "004-Observability.md" "Observability" \
"- The Three Pillars: Logs, Metrics, Traces
- Centralized Logging (ELK Stack, Loki)
- Monitoring and Alerting (Prometheus, Grafana)
- Distributed Tracing (Jaeger, OpenTelemetry)"

# ==============================================================================
# Part VIII: The Practice of Architecture – Process & Communication
# ==============================================================================
DIR_08="008-The-Practice-of-Architecture"

create_file "$DIR_08" "001-Documentation-and-Diagrams.md" "Documentation & Diagrams" \
"- **The C4 Model**: Context, Containers, Components, and Code
- UML Diagrams (Sequence, Class, Component)
- **Architecture Decision Records (ADRs)**: Documenting \"why\"
- API Documentation: OpenAPI (Swagger), AsyncAPI"

create_file "$DIR_08" "002-Architectural-Decision-Making.md" "Architectural Decision-Making" \
"- The Trade-off Analysis: Using decision matrices
- Request for Comments (RFC) process
- Prototyping and Proof of Concepts (PoCs)"

create_file "$DIR_08" "003-Evolutionary-Architecture.md" "Evolutionary Architecture" \
"- The concept of an architecture that supports incremental, guided change
- Fitness Functions: Automating architectural conformance
- Conway's Law: How team structure shapes architecture"

# ==============================================================================
# Part IX: Modern and Cloud-Native Architecture
# ==============================================================================
DIR_09="009-Modern-and-Cloud-Native-Architecture"

create_file "$DIR_09" "001-Containerization-and-Orchestration.md" "Containerization & Orchestration" \
"- Docker Fundamentals
- Kubernetes (K8s): Pods, Services, Deployments, Ingress
- Service Mesh (e.g., Istio, Linkerd): The \"why\" and \"how\""

create_file "$DIR_09" "002-API-Design-and-Communication-Protocols.md" "API Design & Communication Protocols" \
"- REST vs. GraphQL vs. gRPC
- Synchronous vs. Asynchronous Communication
- WebSockets for real-time communication"

create_file "$DIR_09" "003-Data-Architecture.md" "Data Architecture" \
"- Relational (SQL) vs. NoSQL Databases (Key-Value, Document, Columnar, Graph)
- CAP Theorem (Consistency, Availability, Partition Tolerance)
- Data Warehouses, Data Lakes, and the Lakehouse pattern
- Data Pipelines and ETL/ELT processes"

# ==============================================================================
# Part X: Tooling & Workflow
# ==============================================================================
DIR_10="010-Tooling-and-Workflow"

create_file "$DIR_10" "001-Infrastructure-as-Code.md" "Infrastructure as Code (IaC)" \
"- Terraform, Pulumi, AWS CloudFormation
- Configuration Management: Ansible, Puppet, Chef"

create_file "$DIR_10" "002-CICD-for-Architects.md" "CI/CD for Architects" \
"- Designing deployment pipelines
- Strategies: Canary Releases, Blue-Green Deployments, Feature Flags"

create_file "$DIR_10" "003-Modeling-and-Diagramming-Tools.md" "Modeling & Diagramming Tools" \
"- diagrams.net (draw.io), PlantUML, Structurizr, Miro"

echo "Directory structure created successfully in $(pwd)"

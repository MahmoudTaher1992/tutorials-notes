Here is the bash script to generate the folder structure and files for your gRPC study guide.

### How to use this script:
1.  Copy the code block below.
2.  Open your terminal in Ubuntu.
3.  Create a new file: `nano setup_grpc_study.sh`
4.  Paste the code.
5.  Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).
6.  Make the script executable: `chmod +x setup_grpc_study.sh`
7.  Run it: `./setup_grpc_study.sh`

```bash
#!/bin/bash

# Root directory name
ROOT_DIR="gRPC-API-Study"

# Create root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure for: $ROOT_DIR"

# ==========================================
# PART I: Fundamentals of gRPC & Modern RPC
# ==========================================
DIR_NAME="001-Fundamentals-of-gRPC-and-Modern-RPC"
mkdir -p "$DIR_NAME"

# A. Introduction to RPC and Service-Oriented APIs
cat <<EOF > "$DIR_NAME/001-Introduction-to-RPC-and-Service-Oriented-APIs.md"
# Introduction to RPC and Service-Oriented APIs

* The Evolution from Local to Remote Procedure Calls (RPC)
* What is a Service-Oriented API?
* HTTP/2 as a Transport Protocol
    * Binary Framing, Multiplexing, and Header Compression
    * How gRPC leverages HTTP/2
* Core gRPC Concepts & Principles
    * Services, not Resources
    * Strongly-Typed Contracts
    * High Performance
    * Language Agnostic
EOF

# B. Defining gRPC (gRPC Remote Procedure Call)
cat <<EOF > "$DIR_NAME/002-Defining-gRPC.md"
# Defining gRPC (gRPC Remote Procedure Call)

* History, Philosophy, and Motivation (Google's "Stubby")
* The Core Components of gRPC
    * Protocol Buffers (IDL)
    * Service Definitions
    * Channels, Stubs, and Skeletons
EOF

# C. The Four gRPC Communication Patterns
cat <<EOF > "$DIR_NAME/003-The-Four-gRPC-Communication-Patterns.md"
# The Four gRPC Communication Patterns

* Unary RPC (Simple Request/Response)
* Server Streaming RPC (Request, Stream of Responses)
* Client Streaming RPC (Stream of Requests, Single Response)
* Bidirectional Streaming RPC (Concurrent Streams)
EOF

# D. Comparison with Other API Styles
cat <<EOF > "$DIR_NAME/004-Comparison-with-Other-API-Styles.md"
# Comparison with Other API Styles

* gRPC vs. REST (Performance, Contract, Streaming)
* gRPC vs. SOAP (Complexity, Performance, IDL)
* gRPC vs. GraphQL (Use Case, Data Fetching Paradigm)
EOF


# ====================================================
# PART II: API Design & Modeling with Protocol Buffers
# ====================================================
DIR_NAME="002-API-Design-and-Modeling-with-Protocol-Buffers"
mkdir -p "$DIR_NAME"

# A. Design Methodology and Strategy
cat <<EOF > "$DIR_NAME/001-Design-Methodology-and-Strategy.md"
# Design Methodology and Strategy

* Consumer-Oriented & Service-Oriented Design
* Contract-First Development (The .proto is the source of truth)
* Code Generation as a Core Workflow
* Prototyping with Reflection and CLI Tools
EOF

# B. Service and Message Modeling
cat <<EOF > "$DIR_NAME/002-Service-and-Message-Modeling.md"
# Service and Message Modeling

* Identifying Services from Domain Verbs/Capabilities
* Designing RPC Methods (Procedures)
* Message Granularity and Composition
* Common Design Patterns (e.g., Request/Response Wrappers)
EOF

# C. Defining Services with Protocol Buffers (.proto files)
cat <<EOF > "$DIR_NAME/003-Defining-Services-with-Protocol-Buffers.md"
# Defining Services with Protocol Buffers (.proto files)

* .proto File Structure and Syntax (proto3)
* Scalar Value Types (int32, string, bool, etc.)
* Defining message Types
* Enumerations (enum)
* Using oneof, map, and repeated
* Packages and Imports for Modularity
* "Well-Known Types" (Timestamp, Duration, etc.)
EOF

# D. API Schema Management
cat <<EOF > "$DIR_NAME/004-API-Schema-Management.md"
# API Schema Management

* Buf (Build tool for Protobuf)
* Protobuf Linters and Breaking Change Detection
* Schema Registries
EOF


# ====================================================
# PART III: Communication Patterns & Interaction Design
# ====================================================
DIR_NAME="003-Communication-Patterns-and-Interaction-Design"
mkdir -p "$DIR_NAME"

# A. Interaction Design with RPCs
cat <<EOF > "$DIR_NAME/001-Interaction-Design-with-RPCs.md"
# Interaction Design with RPCs

* RPC Types in Practice
    * Unary: The workhorse for simple interactions
    * Server Streaming: For notifications, logs, or large dataset delivery
    * Client Streaming: For data uploads, metric collection, or batch processing
    * Bi-directional Streaming: For chat, real-time control, or interactive sessions
* Idempotency in gRPC
    * Designing Idempotent RPCs vs. Non-Idempotent RPCs
    * Client-generated idempotency keys
EOF

# B. Error Handling and Status Codes
cat <<EOF > "$DIR_NAME/002-Error-Handling-and-Status-Codes.md"
# Error Handling and Status Codes

* Standard gRPC Status Codes (OK, CANCELLED, NOT_FOUND, INVALID_ARGUMENT, UNAUTHENTICATED, INTERNAL)
* Returning Rich Error Details (google.rpc.Status and ErrorInfo)
* Propagating Errors Across Services
EOF

# C. Sending Metadata (Headers)
cat <<EOF > "$DIR_NAME/003-Sending-Metadata-Headers.md"
# Sending Metadata (Headers)

* What is Metadata? (Key-Value pairs)
* Client-side: Attaching Metadata to a Call
* Server-side: Reading Metadata from a Request
* Use Cases: Authentication tokens, tracing IDs, routing information
EOF

# D. Deadlines, Timeouts, and Cancellation
cat <<EOF > "$DIR_NAME/004-Deadlines-Timeouts-and-Cancellation.md"
# Deadlines, Timeouts, and Cancellation

* Core Concepts: Fail-Fast and Resource Management
* Setting Deadlines on the Client
* Checking for Cancellation on the Server
* Deadline Propagation in a chain of gRPC calls
EOF


# ===================
# PART IV: Security
# ===================
DIR_NAME="004-Security"
mkdir -p "$DIR_NAME"

# A. Core Concepts
cat <<EOF > "$DIR_NAME/001-Core-Concepts.md"
# Core Concepts

* Authentication (Who is calling?) vs. Authorization (What can they call?)
* Transport Security vs. Per-Call Security
EOF

# B. Channel Authentication (Transport Security)
cat <<EOF > "$DIR_NAME/002-Channel-Authentication.md"
# Channel Authentication (Transport Security)

* TLS/SSL for Encryption and Server Authentication
* Mutual TLS (mTLS) for Client and Server Authentication
EOF

# C. Call Authentication (Per-RPC Credentials)
cat <<EOF > "$DIR_NAME/003-Call-Authentication.md"
# Call Authentication (Per-RPC Credentials)

* Token-Based Authentication (JWT, OAuth 2.0 Tokens)
* Passing Tokens via Metadata
* API Keys
* Interceptors/Middleware for authentication logic
EOF

# D. Authorization Strategies
cat <<EOF > "$DIR_NAME/004-Authorization-Strategies.md"
# Authorization Strategies

* Role-Based Access Control (RBAC)
* Attribute-Based Access Control (ABAC)
* Implementing Authorization in Server-Side Interceptors
EOF


# ==================================
# PART V: Performance & Scalability
# ==================================
DIR_NAME="005-Performance-and-Scalability"
mkdir -p "$DIR_NAME"

# A. Connection & Resource Management
cat <<EOF > "$DIR_NAME/001-Connection-and-Resource-Management.md"
# Connection & Resource Management

* Channels and Connection Pooling
* Client-Side & Server-Side Load Balancing (Round Robin, etc.)
* Keepalives and Connection Health
EOF

# B. Payload & Bandwidth Optimization
cat <<EOF > "$DIR_NAME/002-Payload-and-Bandwidth-Optimization.md"
# Payload & Bandwidth Optimization

* The Efficiency of Binary Protocol Buffers
* Streaming for Large Payloads
* Compression (Gzip)
EOF

# C. Scalability Patterns
cat <<EOF > "$DIR_NAME/003-Scalability-Patterns.md"
# Scalability Patterns

* Rate Limiting and Throttling (often at the proxy/gateway/mesh level)
* Designing for Asynchronous Operations with Long-Running Operation APIs
* Retries and Backoff Policies
EOF


# ====================================================
# PART VI: API Lifecycle, Management & Implementation
# ====================================================
DIR_NAME="006-API-Lifecycle-Management-and-Implementation"
mkdir -p "$DIR_NAME"

# A. Versioning and Evolution
cat <<EOF > "$DIR_NAME/001-Versioning-and-Evolution.md"
# Versioning and Evolution

* Why and When to Version a gRPC API
* Backward and Forward Compatibility Rules for Protocol Buffers
* Versioning Strategies: Using Packages (v1, v2), Adding New Services/RPCs
* Managing Breaking Changes
EOF

# B. Implementation
cat <<EOF > "$DIR_NAME/002-Implementation.md"
# Implementation

* Code Generation: Stubs (Client) and Skeletons (Server)
* Frameworks & Libraries (gRPC-Java, gRPC-Go, gRPC-dotnet, etc.)
* Interceptors (Middleware) for Cross-Cutting Concerns (Logging, Metrics, Auth)
EOF

# C. Testing Strategies
cat <<EOF > "$DIR_NAME/003-Testing-Strategies.md"
# Testing Strategies

* Unit Testing Service Logic
* Integration Testing with In-Process Servers or real clients/servers
* Tooling: grpcurl, grpc-cli for manual testing and scripting
EOF

# D. Documentation and Developer Experience (DevEx)
cat <<EOF > "$DIR_NAME/004-Documentation-and-Developer-Experience.md"
# Documentation and Developer Experience (DevEx)

* Generating Documentation from .proto files
* Providing Client Libraries in Multiple Languages (via code generation)
* Developer Portals and Onboarding
EOF

# E. Deployment and Operations
cat <<EOF > "$DIR_NAME/005-Deployment-and-Operations.md"
# Deployment and Operations

* Proxies and Service Meshes (Istio, Linkerd, Envoy)
* Observability: Logging, Metrics (Prometheus), and Tracing (OpenTelemetry)
* Health Checks (grpc-health-probe)
EOF


# =======================================
# PART VII: Advanced & Emerging Topics
# =======================================
DIR_NAME="007-Advanced-and-Emerging-Topics"
mkdir -p "$DIR_NAME"

# A. Interoperability & Ecosystem
cat <<EOF > "$DIR_NAME/001-Interoperability-and-Ecosystem.md"
# Interoperability & Ecosystem

* gRPC-Web: Enabling gRPC in Browser Applications
* gRPC-Gateway: Exposing a REST/JSON frontend for a gRPC service
* Transcoding and Protocol Translation
EOF

# B. Broader Architectural Context
cat <<EOF > "$DIR_NAME/002-Broader-Architectural-Context.md"
# Broader Architectural Context

* gRPC as the "Service-to-Service" Communication Backbone in Microservices
* Serverless gRPC Backends
EOF

# C. Specialized Topics
cat <<EOF > "$DIR_NAME/003-Specialized-Topics.md"
# Specialized Topics

* Server Reflection for Dynamic Clients and Discovery
* Customizing Code Generation with Protobuf Plugins
* Integrating with Message Queues and Event-Driven Architectures
EOF

echo "Done! Hierarchy created in $ROOT_DIR"
```

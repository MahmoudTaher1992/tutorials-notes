Here is the bash script to generate your Nginx study guide structure.

This script creates a root directory named `Nginx-Study-Guide`, creates the numbered directories for each Part, and creates the numbered `.md` files for each Section including the bullet points from your TOC.

### Instructions:
1.  Save the code below to a file, e.g., `create_nginx_study.sh`.
2.  Make the script executable: `chmod +x create_nginx_study.sh`.
3.  Run the script: `./create_nginx_study.sh`.

```bash
#!/bin/bash

# Define the Root Directory Name
ROOT_DIR="Nginx-Study-Guide"

# Create Root Directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"

# ==========================================
# PART I: Nginx Fundamentals & Core Principles
# ==========================================
PART_DIR="$ROOT_DIR/001-Nginx-Fundamentals-Core-Principles"
mkdir -p "$PART_DIR"

# A. Introduction to Nginx
cat <<EOF > "$PART_DIR/001-Introduction-to-Nginx.md"
# Introduction to Nginx

* **What is Nginx?**: Role as a high-performance web server, reverse proxy, load balancer, and HTTP cache.
* **Core Philosophy**: Event-driven, asynchronous, non-blocking architecture.
* **Key Features**:
    * High concurrency with low memory usage.
    * Serving static content efficiently.
    * Scalability and reliability.
* **Nginx vs. Apache**: Key differences in architecture and performance.
* **Common Use Cases**: Web serving, reverse proxying, load balancing, API gateway, and more.
EOF

# B. Installation and Setup
cat <<EOF > "$PART_DIR/002-Installation-and-Setup.md"
# Installation and Setup

* **Installation Methods**:
    * Using package managers (apt, yum, etc.).
    * Compiling from source for custom modules.
* **Directory Structure**: Understanding the layout of Nginx files and directories (\`/etc/nginx\`, \`nginx.conf\`, \`sites-available\`, \`sites-enabled\`).
* **Basic Commands**: Starting, stopping, and reloading Nginx.
* **Initial Configuration**: Setting up a basic web server.
EOF

# ==========================================
# PART II: Nginx Configuration Deep Dive
# ==========================================
PART_DIR="$ROOT_DIR/002-Nginx-Configuration-Deep-Dive"
mkdir -p "$PART_DIR"

# A. Configuration File Syntax
cat <<EOF > "$PART_DIR/001-Configuration-File-Syntax.md"
# Configuration File Syntax

* **Directives and Contexts**: Simple directives, block directives, and contexts (\`main\`, \`events\`, \`http\`, \`server\`, \`location\`).
* **Variables**: Using and understanding Nginx variables.
* **Includes**: Organizing configuration with include files.
* **Comments**: Proper use of comments for maintainability.
EOF

# B. The http Context
cat <<EOF > "$PART_DIR/002-The-http-Context.md"
# The http Context

* **Core HTTP Settings**: \`worker_processes\`, \`worker_connections\`, \`error_log\`, \`access_log\`.
* **MIME Types**: Configuring \`mime.types\` for correct content handling.
* **Buffers and Timeouts**: Optimizing client and server communication.
* **Gzip Compression**: Compressing responses to save bandwidth.
EOF

# C. Server Blocks (Virtual Hosts)
cat <<EOF > "$PART_DIR/003-Server-Blocks-Virtual-Hosts.md"
# Server Blocks (Virtual Hosts)

* **Defining Server Blocks**: \`server\` directive.
* **Listening on Ports**: The \`listen\` directive for HTTP and HTTPS.
* **Server Names**: \`server_name\` for name-based virtual hosts.
* **Serving Static Files**:
    * The \`root\` and \`alias\` directives.
    * Setting index files.
EOF

# D. Location Blocks
cat <<EOF > "$PART_DIR/004-Location-Blocks.md"
# Location Blocks

* **Matching Requests**: \`location\` directive syntax and modifiers (\`=\`, \`~\`, \`~*\`, \`^~\`).
* **\`try_files\` Directive**: Handling file existence and fallbacks.
* **Rewrites and Redirects**:
    * \`return\` for simple redirects.
    * \`rewrite\` for more complex URL manipulations.
* **Internal Redirects**: Using \`internal\` and named locations.
EOF

# ==========================================
# PART III: Nginx as a Reverse Proxy and Load Balancer
# ==========================================
PART_DIR="$ROOT_DIR/003-Nginx-Reverse-Proxy-Load-Balancer"
mkdir -p "$PART_DIR"

# A. Reverse Proxy Fundamentals
cat <<EOF > "$PART_DIR/001-Reverse-Proxy-Fundamentals.md"
# Reverse Proxy Fundamentals

* **What is a Reverse Proxy?**: Core concepts and benefits.
* **The \`proxy_pass\` Directive**: Forwarding requests to backend servers.
* **Passing Headers**: \`proxy_set_header\` to send client information to the backend.
* **Proxy Buffering**: Managing responses from the backend.
EOF

# B. Load Balancing
cat <<EOF > "$PART_DIR/002-Load-Balancing.md"
# Load Balancing

* **The \`upstream\` Module**: Defining a pool of backend servers.
* **Load Balancing Algorithms**:
    * Round Robin.
    * Least Connections.
    * IP Hash.
* **Server Weights and Health Checks**: Distributing traffic and handling failed servers.
* **Session Persistence**: Using \`ip_hash\` for sticky sessions.
EOF

# ==========================================
# PART IV: Security and SSL/TLS
# ==========================================
PART_DIR="$ROOT_DIR/004-Security-and-SSL-TLS"
mkdir -p "$PART_DIR"

# A. Securing Nginx
cat <<EOF > "$PART_DIR/001-Securing-Nginx.md"
# Securing Nginx

* **Running Nginx as a Non-Root User**.
* **Disabling Unwanted Modules**.
* **Limiting Request Methods**.
* **Protecting Against Common Attacks**:
    * Clickjacking (\`X-Frame-Options\`).
    * MIME-sniffing (\`X-Content-Type-Options\`).
    * Cross-site scripting (XSS) protection (\`X-XSS-Protection\`).
EOF

# B. SSL/TLS Termination
cat <<EOF > "$PART_DIR/002-SSL-TLS-Termination.md"
# SSL/TLS Termination

* **Enabling HTTPS**: The \`ssl_certificate\` and \`ssl_certificate_key\` directives.
* **Configuring SSL Protocols and Ciphers**: Hardening SSL/TLS for better security.
* **HTTP Strict Transport Security (HSTS)**.
* **SSL Passthrough**.
* **Let's Encrypt**: Automating SSL certificate issuance and renewal.
EOF

# C. Access Control
cat <<EOF > "$PART_DIR/003-Access-Control.md"
# Access Control

* **IP-Based Access Control**: \`allow\` and \`deny\` directives.
* **HTTP Basic Authentication**.
* **Rate Limiting**: \`limit_req_zone\` and \`limit_req\` to prevent abuse.
EOF

# ==========================================
# PART V: Performance and Optimization
# ==========================================
PART_DIR="$ROOT_DIR/005-Performance-and-Optimization"
mkdir -p "$PART_DIR"

# A. Performance Tuning
cat <<EOF > "$PART_DIR/001-Performance-Tuning.md"
# Performance Tuning

* **Worker Processes and Connections**: Optimizing for your hardware.
* **Keepalive Connections**: Reducing connection overhead.
* **Buffers**: Adjusting buffer sizes for optimal memory usage and performance.
* **Caching**:
    * **Static File Caching**: Leveraging browser caching with \`expires\` headers.
    * **Proxy Caching**: Caching responses from backend servers.
EOF

# B. Content Delivery
cat <<EOF > "$PART_DIR/002-Content-Delivery.md"
# Content Delivery

* **Gzip Compression**: In-depth configuration for different content types.
* **Serving Pre-compressed Files**: Using the \`gzip_static\` module.
* **HTTP/2 and HTTP/3**: Enabling modern protocols for improved performance.
* **Large File Delivery**: \`sendfile\` and \`tcp_nopush\` directives.
EOF

# ==========================================
# PART VI: Logging and Monitoring
# ==========================================
PART_DIR="$ROOT_DIR/006-Logging-and-Monitoring"
mkdir -p "$PART_DIR"

# A. Logging
cat <<EOF > "$PART_DIR/001-Logging.md"
# Logging

* **Access Logs**: Customizing log formats.
* **Error Logs**: Configuring logging levels for debugging.
* **Conditional Logging**: Logging specific requests.
EOF

# B. Monitoring
cat <<EOF > "$PART_DIR/002-Monitoring.md"
# Monitoring

* **\`stub_status\` Module**: Real-time server statistics.
* **Third-Party Monitoring Tools**: Integrating with tools like Prometheus and Grafana.
* **Log Analysis**: Using tools like \`goaccess\` or the ELK stack.
EOF

# ==========================================
# PART VII: Nginx Modules and Extensibility
# ==========================================
PART_DIR="$ROOT_DIR/007-Nginx-Modules-and-Extensibility"
mkdir -p "$PART_DIR"

# A. Core and Optional Modules
cat <<EOF > "$PART_DIR/001-Core-and-Optional-Modules.md"
# Core and Optional Modules

* **Understanding Nginx Modules**: Core vs. dynamic modules.
* **Commonly Used Modules**:
    * \`ngx_http_rewrite_module\`.
    * \`ngx_http_headers_module\`.
    * \`ngx_http_ssl_module\`.
* **Enabling and Disabling Modules**.
EOF

# B. Third-Party Modules
cat <<EOF > "$PART_DIR/002-Third-Party-Modules.md"
# Third-Party Modules

* **Finding and Installing Third-Party Modules**.
* **Popular Third-Party Modules**:
    * \`ngx_brotli\` for Brotli compression.
    * \`ngx_pagespeed\` for automatic web performance optimization.
EOF

# C. Scripting with Nginx
cat <<EOF > "$PART_DIR/003-Scripting-with-Nginx.md"
# Scripting with Nginx

* **Nginx JavaScript Module (njs)**: Extending Nginx with JavaScript.
* **Lua with OpenResty**: Advanced scripting capabilities.
EOF

# ==========================================
# PART VIII: Advanced Topics and Real-World Scenarios
# ==========================================
PART_DIR="$ROOT_DIR/008-Advanced-Topics-Real-World-Scenarios"
mkdir -p "$PART_DIR"

# A. Nginx as an API Gateway
cat <<EOF > "$PART_DIR/001-Nginx-as-an-API-Gateway.md"
# Nginx as an API Gateway

* **Request Routing**: Path-based and host-based routing.
* **API Authentication and Authorization**.
* **Rate Limiting and Throttling**.
EOF

# B. Microservices Architectures
cat <<EOF > "$PART_DIR/002-Microservices-Architectures.md"
# Microservices Architectures

* **Nginx as a Gateway for Microservices**.
* **Service Discovery Integration**.
* **Canary and Blue-Green Deployments**.
EOF

# C. Containerization and Orchestration
cat <<EOF > "$PART_DIR/003-Containerization-and-Orchestration.md"
# Containerization and Orchestration

* **Running Nginx in Docker**.
* **Nginx as an Ingress Controller for Kubernetes**.
* **Nginx in a Service Mesh**.
EOF

# ==========================================
# PART IX: Troubleshooting and Best Practices
# ==========================================
PART_DIR="$ROOT_DIR/009-Troubleshooting-and-Best-Practices"
mkdir -p "$PART_DIR"

# A. Common Issues and Solutions
cat <<EOF > "$PART_DIR/001-Common-Issues-and-Solutions.md"
# Common Issues and Solutions

* **Understanding Nginx Error Messages**.
* **Debugging Configuration Errors**.
* **Common Pitfalls**: \`502 Bad Gateway\`, \`404 Not Found\`, etc.
EOF

# B. Best Practices
cat <<EOF > "$PART_DIR/002-Best-Practices.md"
# Best Practices

* **Configuration Management**: Keeping your configurations clean and modular.
* **Testing Configurations Before Reloading**.
* **Regularly Updating Nginx**.
EOF

# ==========================================
# Appendices
# ==========================================
PART_DIR="$ROOT_DIR/010-Appendices"
mkdir -p "$PART_DIR"

# References, Glossary, and Cookbook
cat <<EOF > "$PART_DIR/001-Resources-and-References.md"
# Appendices

* **References and Further Reading**.
* **Glossary of Common Nginx Terms**.
* **Nginx Cookbook: Common Recipes and Snippets**.
EOF

echo "Done! Nginx study structure created in $ROOT_DIR"
```

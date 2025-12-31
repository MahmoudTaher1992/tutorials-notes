Here is the bash script to generate the directory and file structure for your Apache Web Server study guide.

It creates a root directory named `Apache-Web-Server-Study`, creates numbered subdirectories for each Part, and creates numbered Markdown files for each Section, pre-filled with the bullet points from your TOC.

### How to use this script:
1.  Copy the code block below.
2.  Open your terminal in Ubuntu.
3.  Create a new file: `nano create_apache_course.sh`
4.  Paste the code.
5.  Save and exit (Ctrl+O, Enter, Ctrl+X).
6.  Make it executable: `chmod +x create_apache_course.sh`
7.  Run it: `./create_apache_course.sh`

```bash
#!/bin/bash

# Define Root Directory Name
ROOT_DIR="Apache-Web-Server-Study"

# Create Root Directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

echo "Creating Apache Web Server study structure..."

# ==============================================================================
# Part I: Apache Fundamentals & Core Principles
# ==============================================================================
DIR="001-Apache-Fundamentals-Core-Principles"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Introduction-to-Apache.md"
# Introduction to Apache

* History and Philosophy of the Apache HTTP Server
* The Role of a Web Server in the Modern Web Stack
* Core Features: Modularity, Flexibility, and Performance
* Apache vs. Other Web Servers (Nginx, LiteSpeed, etc.)
* Understanding Apache's Process Model
EOF

cat <<EOF > "$DIR/002-Installation-and-Initial-Setup.md"
# Installation and Initial Setup

* System Prerequisites and Pre-installation Checks
* Installation on Linux Distributions (Ubuntu/Debian, CentOS/RHEL)
* Installation on Windows and macOS
* Verifying the Installation and Basic Service Management (start, stop, restart)
* Understanding the Default Directory Structure and Key Configuration Files
EOF

# ==============================================================================
# Part II: Core Configuration & Directives
# ==============================================================================
DIR="002-Core-Configuration-Directives"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Main-Configuration-Files.md"
# Main Configuration Files

* \`httpd.conf\` / \`apache2.conf\`: The Global Configuration File
* \`ports.conf\`: Managing Listening Ports
* Directory Structure: \`sites-available\` vs. \`sites-enabled\`
* Anatomy of a Configuration File: Directives, Contexts, and Syntax
EOF

cat <<EOF > "$DIR/002-Fundamental-Directives.md"
# Fundamental Directives

* \`ServerRoot\`: Defining the Server's Home
* \`Listen\`: Specifying IP Addresses and Ports
* \`DocumentRoot\`: Setting the Default Web Content Directory
* \`ServerAdmin\` and \`ServerName\`: Identifying the Server
* User and Group Directives for Security
EOF

cat <<EOF > "$DIR/003-Directory-Level-Configuration.md"
# Directory-Level Configuration

* The \`<Directory>\` Block for Defining Directory-Specific Settings
* \`.htaccess\` Files: Enabling and Using for Overrides
* \`AllowOverride\`: Controlling \`.htaccess\` Permissions
* Performance Implications of Using \`.htaccess\`
EOF

# ==============================================================================
# Part III: Modules & Extensibility
# ==============================================================================
DIR="003-Modules-Extensibility"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-The-Modular-Architecture.md"
# The Modular Architecture

* Understanding Apache's Modular Design
* Static vs. Dynamic Modules (DSOs)
* Enabling and Disabling Modules (e.g., \`a2enmod\`, \`a2dismod\`)
* Listing Loaded Modules for Troubleshooting
EOF

cat <<EOF > "$DIR/002-Essential-Modules.md"
# Essential Modules

* \`mod_rewrite\`: URL Rewriting and Redirection
* \`mod_ssl\`: Enabling HTTPS with SSL/TLS Certificates
* \`mod_headers\`: Manipulating HTTP Headers
* \`mod_alias\`: Creating URL Aliases and Redirects
* \`mod_authz_core\` and \`mod_authn_core\`: Authentication and Authorization Basics
EOF

cat <<EOF > "$DIR/003-Advanced-Module-Usage.md"
# Advanced Module Usage

* \`mod_proxy\`: Core Proxying Capabilities
* \`mod_proxy_http\`: Reverse Proxy for HTTP/HTTPS
* \`mod_deflate\`: Compressing Content for Faster Delivery
* \`mod_expires\` and \`mod_cache\`: Caching Strategies
* \`mod_security\`: Web Application Firewall (WAF)
EOF

# ==============================================================================
# Part IV: Hosting & Virtual Hosts
# ==============================================================================
DIR="004-Hosting-Virtual-Hosts"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Virtual-Host-Concepts.md"
# Virtual Host Concepts

* The Need for Virtual Hosts to Host Multiple Websites
* Name-based vs. IP-based Virtual Hosts
EOF

cat <<EOF > "$DIR/002-Configuring-Virtual-Hosts.md"
# Configuring Virtual Hosts

* Creating Virtual Host Configuration Files
* Essential Directives: \`VirtualHost\`, \`ServerName\`, \`DocumentRoot\`, \`ErrorLog\`, \`CustomLog\`
* Enabling and Disabling Sites (\`a2ensite\`, \`a2dissite\`)
* Serving Multiple Domains and Subdomains from a Single Server
EOF

cat <<EOF > "$DIR/003-Advanced-Virtual-Host-Setups.md"
# Advanced Virtual Host Setups

* Using Wildcards for Server Aliases
* Configuring SSL/TLS Certificates for Each Virtual Host
* Directory-Specific Options within a Virtual Host
EOF

# ==============================================================================
# Part V: Security & Hardening
# ==============================================================================
DIR="005-Security-Hardening"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Fundamental-Security-Practices.md"
# Fundamental Security Practices

* Keeping Apache Updated to the Latest Version
* Running Apache as a Non-Privileged User
* Hiding Apache Version and OS Information
* Disabling Unnecessary Modules
* Restricting Access to Sensitive Directories
EOF

cat <<EOF > "$DIR/002-Access-Control-and-Authentication.md"
# Access Control and Authentication

* IP-Based Access Control (\`Require ip\`)
* Basic and Digest Authentication for Password Protection
* Using \`.htpasswd\` for User Management
EOF

cat <<EOF > "$DIR/003-SSL-TLS-Configuration.md"
# SSL/TLS Configuration

* Obtaining and Installing SSL/TLS Certificates (e.g., Let's Encrypt)
* Configuring Strong Ciphers and Protocols
* Implementing HTTP Strict Transport Security (HSTS)
* Redirecting HTTP to HTTPS
EOF

cat <<EOF > "$DIR/004-Advanced-Security-Modules.md"
# Advanced Security Modules

* \`mod_evasive\` for Mitigating DDoS and Brute-Force Attacks
* \`mod_security\` for Advanced Threat Protection
* Rate Limiting and Request Filtering
EOF

# ==============================================================================
# Part VI: Performance Tuning & Optimization
# ==============================================================================
DIR="006-Performance-Tuning-Optimization"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Multi-Processing-Modules-MPMs.md"
# Multi-Processing Modules (MPMs)

* Understanding MPMs: \`prefork\`, \`worker\`, and \`event\`
* Choosing the Right MPM for Your Workload
* Tuning MPM Directives (\`StartServers\`, \`MaxRequestWorkers\`, etc.) for Optimal Performance
EOF

cat <<EOF > "$DIR/002-Caching-and-Compression.md"
# Caching and Compression

* Leveraging Browser Caching with \`mod_expires\`
* Implementing Server-Side Caching with \`mod_cache\`
* Using \`mod_deflate\` to Compress Responses
EOF

cat <<EOF > "$DIR/003-Content-Delivery-Optimization.md"
# Content Delivery Optimization

* Enabling \`KeepAlive\` for Persistent Connections
* Tuning \`KeepAliveTimeout\` and \`MaxKeepAliveRequests\`
* Optimizing File Handling and Reducing HTTP Requests
EOF

cat <<EOF > "$DIR/004-Monitoring-and-Profiling.md"
# Monitoring and Profiling

* Using \`mod_status\` for Real-Time Server Monitoring
* Analyzing Access and Error Logs for Performance Bottlenecks
* Load Testing with Tools like ApacheBench (\`ab\`)
EOF

# ==============================================================================
# Part VII: Logging, Monitoring, and Troubleshooting
# ==============================================================================
DIR="007-Logging-Monitoring-Troubleshooting"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Logging-Configuration.md"
# Logging Configuration

* Understanding Access and Error Logs
* Customizing Log Formats (\`LogFormat\` and \`CustomLog\`)
* Conditional Logging Based on Request Characteristics
* Log Rotation and Management
EOF

cat <<EOF > "$DIR/002-Monitoring-and-Alerting.md"
# Monitoring and Alerting

* Real-time Log Monitoring with \`tail\`
* Integrating with External Monitoring Tools (e.g., Prometheus, Datadog)
* Setting Up Alerts for Critical Errors and Performance Issues
EOF

cat <<EOF > "$DIR/003-Troubleshooting-Common-Issues.md"
# Troubleshooting Common Issues

* Using \`apachectl configtest\` to Validate Configuration Syntax
* Diagnosing Service Failures with \`systemctl\` and \`journalctl\`
* Common Error Codes (403, 404, 500) and Their Causes
* Resolving Permission Issues and Misconfigurations
EOF

# ==============================================================================
# Part VIII: Advanced Topics & Use Cases
# ==============================================================================
DIR="008-Advanced-Topics-Use-Cases"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-Reverse-Proxy-and-Load-Balancing.md"
# Reverse Proxy and Load Balancing

* Setting up Apache as a Reverse Proxy with \`mod_proxy\`
* Configuring \`ProxyPass\` and \`ProxyPassReverse\`
* Load Balancing Across Multiple Backend Servers with \`mod_proxy_balancer\`
* Health Checks for Backend Servers
EOF

cat <<EOF > "$DIR/002-URL-Rewriting-with-mod_rewrite.md"
# URL Rewriting with mod_rewrite

* Introduction to Rewrite Rules and Conditions
* Common Use Cases: Clean URLs, Canonicalization, and Forcing HTTPS
* Regular Expressions in Rewrite Rules
EOF

cat <<EOF > "$DIR/003-Server-Side-Includes-SSI.md"
# Server-Side Includes (SSI)

* Enabling and Configuring SSI for Dynamic Content
* Basic SSI Directives (\`#include\`, \`#echo\`, etc.)
EOF

cat <<EOF > "$DIR/004-WebDAV-with-mod_dav.md"
# WebDAV with mod_dav

* Setting up a WebDAV Server for File Sharing and Collaboration
EOF

# ==============================================================================
# Appendices
# ==============================================================================
DIR="009-Appendices"
mkdir -p "$DIR"

cat <<EOF > "$DIR/001-References-and-Further-Reading.md"
# References and Further Reading

* Official Apache Documentation
* Community Resources
EOF

cat <<EOF > "$DIR/002-Glossary-of-Common-Apache-Terms.md"
# Glossary of Common Apache Terms

* Definitions of key terms used throughout the guide.
EOF

cat <<EOF > "$DIR/003-Commonly-Used-Commands.md"
# Commonly Used apachectl and systemctl Commands

* Reference cheat sheet for service management and control.
EOF

echo "Done! Directory structure created in: $ROOT_DIR"
```

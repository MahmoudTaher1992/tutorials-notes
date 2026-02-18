# ⚡ Nginx Deep Dive — Supplementary Table of Contents

> 🔗 **Companion to the main Web Servers Study Guide**
> This TOC expands exclusively on Nginx topics not covered or only briefly mentioned in the main guide. Cross-references to the main TOC are noted with 📎.

---

## 🧠 Part I: Nginx Internals & Design Philosophy

### 1. 🔬 Source Code Architecture
- 1.1 🗂️ Codebase Structure
  - Repository layout (`src/core`, `src/event`, `src/http`, `src/mail`, `src/stream`, `src/os`)
  - Naming conventions and code style
  - Key data structures
    - `ngx_cycle_t` — the main cycle object
    - `ngx_connection_t` — connection object
    - `ngx_request_t` — HTTP request object
    - `ngx_pool_t` — memory pool
    - `ngx_chain_t` and `ngx_buf_t` — buffer chains
    - `ngx_array_t`, `ngx_list_t`, `ngx_queue_t`, `ngx_rbtree_t`
- 1.2 ⚙️ Build System
  - `./configure` flags in depth
  - `auto/` scripts — how Nginx detects platform features
  - Building with specific modules (`--with-*`, `--without-*`)
  - Building dynamic modules (`--add-dynamic-module`)
  - Cross-compilation considerations
- 1.3 🔄 Startup & Initialization Sequence
  - `main()` function walkthrough
  - Config parsing phase
  - Module initialization order
  - Privilege dropping (running as root → worker user)
  - PID file management
- 1.4 🧵 Worker Process Lifecycle
  - `ngx_worker_process_cycle()` internals
  - Signal handling (`SIGTERM`, `SIGQUIT`, `SIGHUP`, `SIGUSR1`, `SIGUSR2`, `SIGWINCH`)
  - Graceful shutdown sequence step-by-step
  - Hot binary upgrade (`SIGUSR2` + `SIGWINCH` + `SIGQUIT`) — zero downtime upgrade
- 1.5 🔁 The Nginx Event Loop in Detail
  - `ngx_process_events_and_timers()` walkthrough
  - Timer management (red-black tree of timers)
  - Posted events queue (deferred callbacks)
  - Accept mutex — preventing thundering herd
  - `multi_accept` directive internals

---

### 2. 🧩 Module System Deep Dive
- 2.1 📐 Module Types
  - Core modules (`ngx_core_module`)
  - Event modules (`ngx_event_module`)
  - HTTP modules (`ngx_http_module`)
  - Stream modules (`ngx_stream_module`)
  - Mail modules (`ngx_mail_module`)
- 2.2 🏗️ Module Structure Internals
  - `ngx_module_t` struct fields
  - `ngx_command_t` — directive definitions
  - Context structs (`ngx_http_module_t`)
  - `preconfiguration`, `postconfiguration` hooks
  - `create_main_conf`, `init_main_conf`
  - `create_srv_conf`, `merge_srv_conf`
  - `create_loc_conf`, `merge_loc_conf`
- 2.3 🔗 HTTP Request Processing Phases
  - `NGX_HTTP_POST_READ_PHASE`
  - `NGX_HTTP_SERVER_REWRITE_PHASE`
  - `NGX_HTTP_FIND_CONFIG_PHASE`
  - `NGX_HTTP_REWRITE_PHASE`
  - `NGX_HTTP_POST_REWRITE_PHASE`
  - `NGX_HTTP_PREACCESS_PHASE`
  - `NGX_HTTP_ACCESS_PHASE`
  - `NGX_HTTP_POST_ACCESS_PHASE`
  - `NGX_HTTP_PRECONTENT_PHASE`
  - `NGX_HTTP_CONTENT_PHASE`
  - `NGX_HTTP_LOG_PHASE`
  - How phase handlers are registered and chained
  - Return codes: `NGX_OK`, `NGX_DECLINED`, `NGX_AGAIN`, `NGX_ERROR`, `NGX_DONE`
- 2.4 🔌 Writing a Custom C Module
  - Setting up the module scaffold
  - Registering directives
  - Hooking into a phase
  - Accessing request data
  - Generating a response body
  - Allocating from the request pool
  - Compiling and loading as a dynamic module
  - Example: a custom health-check module

---

## ⚙️ Part II: Configuration Mastery

### 3. 🗣️ Nginx Configuration Language In Depth
- 3.1 🔤 Directive Value Types
  - Size values (`k`, `m`, `g` suffixes)
  - Time values (`ms`, `s`, `m`, `h`, `d`, `w`, `M`, `y` suffixes)
  - Off/on booleans
  - Epoch values
- 3.2 🧮 Variables System
  - Built-in variables encyclopedia
    - Connection variables (`$remote_addr`, `$remote_port`, `$server_addr`, `$server_port`, `$connection`, `$connection_requests`)
    - Request variables (`$request`, `$request_method`, `$request_uri`, `$uri`, `$args`, `$query_string`, `$is_args`)
    - Header variables (`$http_*`, `$sent_http_*`, `$upstream_http_*`)
    - Response variables (`$status`, `$body_bytes_sent`, `$bytes_sent`)
    - SSL variables (`$ssl_protocol`, `$ssl_cipher`, `$ssl_client_cert`, `$ssl_session_id`)
    - Time variables (`$time_local`, `$time_iso8601`, `$msec`)
    - Upstream variables (`$upstream_addr`, `$upstream_status`, `$upstream_response_time`, `$upstream_cache_status`)
    - Geo variables, map variables
  - Variable evaluation laziness (computed on first access)
  - Creating variables with `set`, `map`, `geo`, `lua`
  - Variable scope and lifetime (per-request)
- 3.3 🗺️ The `map` Module Mastery
  - Basic `map` usage
  - `map` with regex
  - `map` with `default` and `hostnames`
  - Nested maps
  - `map` for feature flags
  - `map` for A/B routing logic
  - `map` with `include` for large mapping tables
- 3.4 🌍 The `geo` Module Mastery
  - IP-based variable assignment
  - CIDR block ranges
  - `geo` with `proxy` and `proxy_recursive`
  - Using `geo` for geo-fencing
  - Difference between `geo` and MaxMind GeoIP2
- 3.5 🔁 Rewrite Rules Mastery
  - `rewrite` directive flags: `last`, `break`, `redirect`, `permanent`
  - Rewrite rule execution flow and loop prevention
  - `return` directive vs. `rewrite` — when to use which
  - Capturing groups in regex rewrites
  - `try_files` — detailed behavior and edge cases
  - `error_page` — recursive error handling
  - Internal redirects and subrequests (`ngx_http_internal_redirect`)
- 3.6 📦 `split_clients` Module
  - Weighted traffic splitting for A/B testing
  - Combining with `map` and upstream selection
- 3.7 🔗 `upstream` Block Advanced Configuration
  - `keepalive` — persistent connections to backends
  - `keepalive_requests` and `keepalive_timeout`
  - `ntlm` — NTLM authentication passthrough
  - `zone` — shared memory zone for upstream state
  - `resolve` flag for DNS-based dynamic upstreams
  - `service` — SRV DNS record support

---

### 4. 🧩 Advanced Location Block Patterns
- 4.1 🗂️ Nested Location Blocks
  - Rules and limitations
  - Inheritance of directives
  - Named locations (`@named`)
- 4.2 🎯 Complex Matching Recipes
  - Matching multiple extensions
  - Excluding paths from rules
  - Matching query strings (workarounds)
  - Case-insensitive matching
- 4.3 🔀 Internal Locations & Subrequests
  - `internal` directive
  - `auth_request` module — delegating auth to a subrequest
  - `auth_request_set` — extracting headers from auth response
  - X-Accel-Redirect pattern (protected file download)
  - SSI (Server Side Includes) and subrequests
- 4.4 🧮 Conditional Logic Patterns
  - Nginx `if` — why it's considered harmful
  - Valid uses of `if`
  - Rewriting logic without `if` using `map` and `try_files`
  - The "if is evil" problem explained with examples

---

## 🌐 Part III: Proxying & Traffic Management Advanced

### 5. 🔀 Advanced Proxy Patterns
- 5.1 🔁 Request Buffering & Streaming
  - `proxy_request_buffering` — streaming uploads to upstream
  - `proxy_buffering` — buffering vs. streaming responses
  - `proxy_max_temp_file_size` — overflow to disk
  - `proxy_buffer_size` and `proxy_buffers` tuning
- 5.2 🔄 Proxy Caching Advanced
  - `proxy_cache_lock` — thundering herd on cache miss
  - `proxy_cache_use_stale` — serving stale on errors/updating
  - `proxy_cache_background_update`
  - `proxy_cache_bypass` and `proxy_no_cache`
  - Cache purging with `proxy_cache_purge` (Nginx Plus) and open-source alternatives
  - Vary header handling in proxy cache
  - Cache storage structure on disk (levels, keys_zone)
  - Cache file naming (MD5 of cache key)
- 5.3 📡 Dynamic Upstream Resolution
  - The `resolver` directive
  - DNS TTL respect in upstream
  - `resolver_timeout`
  - Using variables in `proxy_pass` for dynamic routing
  - Pitfalls of variable-based `proxy_pass`
- 5.4 🔗 Chained Proxy / Multi-hop
  - Forwarding `X-Forwarded-For` correctly
  - `proxy_set_header X-Real-IP`
  - `real_ip_header` and `set_real_ip_from`
  - Trusted proxy chains
- 5.5 🌐 HTTP/2 to Upstream
  - `grpc_pass` for gRPC backends
  - HTTP/2 upstream support (Nginx Plus)
  - Workarounds for OSS Nginx (HTTP/1.1 to upstream)

---

### 6. 🚦 Advanced Rate Limiting & Traffic Control
- 6.1 🪣 `limit_req` Module In Depth
  - `limit_req_zone` — defining zones with keys
  - `burst` parameter — queuing excess requests
  - `nodelay` — processing burst without delay
  - `delay` parameter — partial nodelay (Nginx 1.15.7+)
  - `limit_req_status` — custom error code
  - `limit_req_log_level`
  - Multiple `limit_req` directives stacking
- 6.2 🔌 `limit_conn` Module In Depth
  - Concurrent connection limiting per IP
  - Limiting by server zone
  - Combining `limit_conn` and `limit_req`
- 6.3 🎚️ Bandwidth Throttling
  - `limit_rate` — bytes per second limit
  - `limit_rate_after` — throttle after N bytes (useful for media)
  - `set $limit_rate` — dynamic rate limiting via variable
- 6.4 🛑 Request Size Limiting
  - `client_max_body_size`
  - `client_body_buffer_size`
  - `large_client_header_buffers`
  - `client_header_buffer_size`

---

## 🔒 Part IV: TLS Deep Dive (Nginx-Specific)

### 7. 🔐 Advanced TLS Configuration for Nginx
- 7.1 🔑 Certificate & Key Management
  - `ssl_certificate` with chained certificates
  - `ssl_certificate_key` with encrypted keys
  - `ssl_password_file` — passphrase for encrypted keys
  - Dual-certificate setup (RSA + ECDSA)
  - Dynamic certificate loading (Nginx Plus)
- 7.2 🏎️ TLS Performance Optimization
  - `ssl_session_cache shared:SSL:size` — shared across workers
  - `ssl_session_timeout`
  - `ssl_session_tickets` and ticket key rotation
  - TLS False Start
  - OCSP stapling with `ssl_stapling_verify` and `ssl_trusted_certificate`
  - `ssl_early_data` — 0-RTT for TLS 1.3 (risks and mitigations)
- 7.3 🔏 Client Certificate Authentication (mTLS)
  - `ssl_client_certificate` — CA for verifying clients
  - `ssl_verify_client` — optional vs. required
  - `ssl_verify_depth`
  - Passing client cert info to upstream (`$ssl_client_cert`, `$ssl_client_s_dn`)
  - CRL checking with `ssl_crl`
- 7.4 🔐 Cipher Suite Hardening
  - `ssl_ciphers` — building a safe cipher string
  - `ssl_prefer_server_ciphers`
  - Mozilla Intermediate vs. Modern configuration
  - Disabling weak ciphers (RC4, DES, EXPORT)
  - ECDH curve selection (`ssl_ecdh_curve`)
  - DHE parameter size (`ssl_dhparam`)
- 7.5 🌐 SNI (Server Name Indication) Internals
  - How Nginx uses SNI for virtual host selection
  - `ssl_preread` module — SNI-based TCP routing without decryption
  - Combining stream and http modules for SNI routing

---

## 🌊 Part V: Stream Module (TCP/UDP Proxying)

### 8. 🔌 `ngx_stream_module` In Depth
- 8.1 📖 Stream Module Overview
  - TCP proxy use cases (MySQL, Redis, SMTP, custom protocols)
  - UDP proxy use cases (DNS, QUIC, game servers)
  - Difference from HTTP proxying
- 8.2 ⚙️ Stream Block Configuration
  - `stream` context directives
  - `server` blocks in stream context
  - `listen` with `udp` flag
  - `proxy_pass` in stream context
  - `proxy_protocol` support
- 8.3 📊 Stream Load Balancing
  - Upstream blocks in stream context
  - All balancing algorithms available
  - Health checks in stream (`health_check` — Nginx Plus)
  - `least_time connect/first_byte/last_byte` (Nginx Plus)
- 8.4 🔐 TLS in Stream Module
  - `ssl_preread` — reading SNI/ALPN without terminating TLS
  - SSL termination in stream
  - SSL passthrough pattern
- 8.5 🗺️ Stream Geo & Map
  - `geo` in stream context
  - `map` in stream context
  - Access control by IP in stream
- 8.6 📝 Stream Logging
  - `access_log` in stream context
  - Available variables in stream context
  - Logging connection duration and bytes

---

## 🌙 Part VI: Lua & OpenResty Extended

### 9. 🌙 Lua Scripting with `lua-nginx-module`
- 9.1 🔗 Execution Phases in Lua
  - `init_by_lua*` — master process init (load shared data, LuaJIT warmup)
  - `init_worker_by_lua*` — per-worker init (background timers)
  - `ssl_certificate_by_lua*` — dynamic cert selection
  - `set_by_lua*` — compute variables
  - `rewrite_by_lua*` — rewrite phase logic
  - `access_by_lua*` — access control logic
  - `content_by_lua*` — response generation
  - `header_filter_by_lua*` — modify response headers
  - `body_filter_by_lua*` — modify response body
  - `log_by_lua*` — async logging after response
  - `balancer_by_lua*` — dynamic upstream selection
- 9.2 🧰 Lua Nginx API
  - `ngx.req.*` — request manipulation
  - `ngx.resp.*` — response manipulation
  - `ngx.var.*` — reading/writing Nginx variables
  - `ngx.ctx` — per-request Lua table
  - `ngx.shared.DICT` — shared memory dictionary (atomic ops)
  - `ngx.socket.tcp/udp` — cosocket API
  - `ngx.timer.*` — non-blocking timers
  - `ngx.re.*` — PCRE regex with caching
  - `ngx.log()`, `ngx.print()`, `ngx.say()`, `ngx.exit()`
- 9.3 🚀 LuaJIT & Performance
  - JIT compilation phases (trace compilation)
  - NYI (Not Yet Implemented) bytecodes that bail to interpreter
  - `jit.off()` and when to use it
  - LuaJIT FFI for calling C libraries from Lua
  - Profiling Lua code with `jit.p`
- 9.4 📦 OpenResty Libraries (lua-resty-*)
  - `lua-resty-redis` — Redis client with connection pooling
  - `lua-resty-mysql` — MySQL client
  - `lua-resty-http` — HTTP client (subrequests vs. cosockets)
  - `lua-resty-jwt` — JWT validation
  - `lua-resty-limit-traffic` — advanced rate limiting
  - `lua-resty-lrucache` — in-process LRU cache
  - `lua-resty-lock` — distributed lock via shared memory
  - `lua-resty-upstream-healthcheck`
  - `lua-resty-template` — HTML templating
- 9.5 🔧 Common OpenResty Patterns
  - Dynamic routing based on database/Redis lookup
  - JWT authentication at proxy layer
  - Request deduplication
  - Canary deployments with Lua
  - Custom WAF rules in Lua
  - Response body transformation (JSON rewriting)

---

## 📊 Part VII: Nginx Performance Engineering

### 10. 🏎️ Deep Performance Tuning
- 10.1 🧵 Worker Tuning
  - `worker_processes auto` — detection logic
  - `worker_cpu_affinity` — pinning workers to CPU cores
  - `worker_priority` — OS scheduling priority (`nice` value)
  - `worker_rlimit_nofile` — per-worker fd limit
  - `worker_shutdown_timeout`
- 10.2 📡 Connection & Event Tuning
  - `use epoll` — explicitly setting event method
  - `worker_connections` — maximum simultaneous connections
  - `multi_accept on` — accepting all pending connections at once
  - `accept_mutex off` — when to disable (high traffic)
  - `accept_mutex_delay`
- 10.3 💾 Buffer & Timeout Tuning
  - `client_body_timeout` vs. `client_header_timeout`
  - `send_timeout` — between successive write operations
  - `keepalive_timeout` two-parameter form (client vs. `Keep-Alive` header)
  - `reset_timedout_connection on` — freeing memory faster
  - `lingering_close`, `lingering_time`, `lingering_timeout`
- 10.4 📁 File Cache (`open_file_cache`)
  - `open_file_cache max=N inactive=T`
  - `open_file_cache_valid`
  - `open_file_cache_min_uses`
  - `open_file_cache_errors`
  - What is cached (fd, size, mtime, directory existence, errors)
- 10.5 🗜️ Compression Tuning
  - `gzip_comp_level` — CPU vs. ratio sweet spot
  - `gzip_min_length` — avoid compressing tiny responses
  - `gzip_proxied` — when to compress proxied responses
  - `gzip_vary on` — Vary header for caches
  - `gzip_types` — correct MIME type list
  - Pre-compressed files with `gzip_static` and `gunzip`
  - Brotli: `brotli_comp_level`, `brotli_types`, `brotli_static`
- 10.6 🔬 Profiling Nginx
  - Using `perf` to profile Nginx worker CPU usage
  - Flame graphs for Nginx
  - `systemtap` scripts for Nginx
  - `strace` / `ltrace` for I/O analysis
  - `/proc/PID/fd` — watching open file descriptors
  - Nginx built-in stub status metrics analysis

---

## 🩺 Part VIII: Operations & Reliability

### 11. 🔄 Zero-Downtime Operations
- 11.1 🔃 Hot Binary Upgrade (Detailed)
  - Step-by-step binary upgrade procedure
  - The `SIGUSR2` signal — starting new master
  - The `SIGWINCH` signal — graceful worker shutdown
  - Rolling back with `SIGQUIT` on new master
  - Automating binary upgrades
- 11.2 🔁 Configuration Reload
  - `nginx -s reload` — what happens internally
  - Graceful reload vs. restart
  - Minimizing config reload time
  - Detecting and alerting on failed reloads
- 11.3 📦 Nginx in Systemd
  - Correct `nginx.service` unit file
  - `Type=forking` vs. `Type=notify`
  - `nginx-debug` binary
  - Journal logging integration
  - Automatic restart on failure
- 11.4 🚨 Failure Modes & Recovery
  - Worker crash — master respawning behavior
  - OOM (Out of Memory) killer targeting Nginx
  - Upstream failure fallback behavior
  - `proxy_next_upstream` conditions
  - `proxy_next_upstream_tries` and `proxy_next_upstream_timeout`

---

### 12. 🐛 Nginx Debugging & Diagnostics
- 12.1 🔍 Debug Logging
  - Compiling Nginx with `--with-debug`
  - `error_log /path debug;` — extreme verbosity
  - Selective debug for a single IP (`debug_connection`)
  - Filtering debug output
- 12.2 🔬 Core Dump Analysis
  - Enabling core dumps for Nginx (`worker_rlimit_core`, `working_directory`)
  - Analyzing core with `gdb`
  - Getting backtraces from all threads
  - Debug symbols and `nginx-dbg` packages
- 12.3 🌡️ Runtime Diagnostics
  - `ss -tlnp` — checking listening sockets
  - `ss -s` — socket statistics summary
  - `netstat -anp` — connection states
  - Watching `TIME_WAIT` accumulation
  - `/proc/net/sockstat`
  - `nginx -V` — checking compiled modules and flags
- 12.4 🧩 Common Problems Solved
  - 502 Bad Gateway — root cause checklist
  - 504 Gateway Timeout — diagnosis steps
  - `upstream sent invalid header`
  - `upstream prematurely closed connection`
  - `no live upstreams while connecting to upstream`
  - `could not build server_names_hash`
  - `worker_connections are not enough`
  - SSL handshake failures decoded
  - "rewrite or internal redirection cycle"

---

## 🔌 Part IX: Integrations & Ecosystem

### 13. 🛡️ ModSecurity with Nginx
- 13.1 📖 ModSecurity v3 (libmodsecurity)
  - Differences from ModSecurity v2 (Apache)
  - Nginx connector (`ModSecurity-nginx`)
  - Compilation and installation
- 13.2 📋 OWASP Core Rule Set (CRS) with Nginx
  - CRS paranoia levels
  - Tuning false positives
  - Anomaly scoring mode
  - Whitelisting legitimate requests
- 13.3 ⚙️ ModSecurity Configuration Directives
  - `modsecurity on|off`
  - `modsecurity_rules_file`
  - `modsecurity_rules`
  - Per-location enabling/disabling

---

### 14. 📦 Nginx with Container Orchestration
- 14.1 ⚙️ Nginx Kubernetes Ingress Controller (ingress-nginx) Deep Dive
  - Architecture (controller pod + admission webhook)
  - Annotation reference (beyond the basics)
    - `nginx.ingress.kubernetes.io/rewrite-target`
    - `nginx.ingress.kubernetes.io/use-regex`
    - `nginx.ingress.kubernetes.io/proxy-body-size`
    - `nginx.ingress.kubernetes.io/limit-rps`
    - `nginx.ingress.kubernetes.io/auth-url` (external auth)
    - `nginx.ingress.kubernetes.io/configuration-snippet`
    - `nginx.ingress.kubernetes.io/server-snippet`
    - `nginx.ingress.kubernetes.io/canary*` annotations
  - ConfigMap global configuration
  - Custom Nginx template
  - Exposing TCP/UDP services via Ingress controller
- 14.2 🐳 Nginx Docker Image Customization
  - `envsubst` for environment-variable-based config
  - `docker-entrypoint.d/` hook scripts
  - Unprivileged Nginx image (rootless)
  - Multi-stage builds with custom modules
  - Nginx Unit — polyglot application server by Nginx team

---

### 15. 🌐 Nginx Plus vs. Open Source
- 15.1 💼 Nginx Plus Exclusive Features
  - Active health checks (vs. passive-only in OSS)
  - Live activity monitoring dashboard (built-in)
  - Dynamic reconfiguration API
  - DNS-based dynamic upstreams with instant re-resolve
  - JWT authentication natively
  - Key-value store (`keyval` module)
  - Session persistence (`sticky cookie`, `sticky route`, `sticky learn`)
  - `least_time` load balancing algorithm
  - High Availability with `nginx-ha-keepalived`
  - OIDC integration
  - OpenID Connect Reference Implementation
- 15.2 🔓 Open Source Alternatives to Plus Features
  - `lua-nginx-module` for active health checks
  - `nginx_upstream_check_module`
  - `ngx_http_dyups_module` — dynamic upstream management
  - Custom dashboards with stub_status + Prometheus

---

## 📐 Part X: Nginx as a Platform

### 16. 🏗️ Nginx Unit
- 16.1 📖 What is Nginx Unit?
  - Polyglot application server (Python, PHP, Ruby, JS, Go, Java, .NET)
  - Differences from Nginx HTTP server
- 16.2 ⚙️ Unit Configuration
  - JSON-based REST API configuration
  - Applications, listeners, and routes
  - Dynamic reconfiguration without restarts
- 16.3 🔗 Nginx + Unit together
  - Using Nginx as edge proxy in front of Unit
  - TLS termination at Nginx, app serving at Unit

---

### 17. 🔬 NGINX JavaScript (njs)
- 17.1 📖 What is njs?
  - ECMAScript 5.1+ subset
  - njs vs. Lua (lua-nginx-module) — comparison
  - njs vs. full V8 (not a full JS engine)
- 17.2 ⚙️ njs Execution Phases
  - `js_import` — loading njs modules
  - `js_set` — computing variables with JS
  - `js_content` — response generation
  - `js_header_filter` — modifying headers
  - `js_body_filter` — modifying body
  - `js_access` — access control
- 17.3 🧰 njs API
  - `r.headersIn`, `r.headersOut`
  - `r.requestBody`
  - `r.variables`
  - `ngx.fetch()` — subrequests / upstream calls
  - `ngx.log()`
  - Crypto API (HMAC, SHA)
- 17.4 🔧 njs Use Cases
  - Request/response transformation
  - HMAC request signing
  - JWT validation without Lua
  - Complex routing logic

---

## 📋 Part XI: Reference & Cheatsheets (Nginx-Specific)

### 18. 📚 Extended Nginx Reference
- 18.1 🗂️ Full Directive Reference by Module
  - Directives with allowed contexts, defaults, and syntax
  - Inheritance and override behavior table
- 18.2 🔤 All Built-in Variables Reference
  - Grouped by category with descriptions and examples
- 18.3 🧪 Nginx Configuration Recipes Cookbook
  - WordPress / PHP-FPM complete config
  - Laravel / PHP-FPM complete config
  - Node.js/Express reverse proxy config
  - Python FastAPI reverse proxy config
  - Next.js with static + API split config
  - WebSocket chat server proxy config
  - gRPC service proxy config
  - Maintenance mode / 503 page config
  - Multi-tenant subdomain routing config
  - Protected media downloads (X-Accel-Redirect) config
  - Canary deployment with `split_clients`
  - Geo-restricted content config
- 18.4 🛡️ Security Configuration Hardening Reference
  - Complete hardened `nginx.conf` template
  - TLS hardened config (Mozilla Modern)
  - Annotated security headers block
- 18.5 📊 Nginx Signals Quick Reference

| Signal | Command | Effect |
|---|---|---|
| `SIGTERM` | `nginx -s stop` | Fast shutdown |
| `SIGQUIT` | `nginx -s quit` | Graceful shutdown |
| `SIGHUP` | `nginx -s reload` | Reload configuration |
| `SIGUSR1` | `nginx -s reopen` | Reopen log files |
| `SIGUSR2` | *(manual)* | Upgrade binary in-place |
| `SIGWINCH` | *(manual)* | Graceful worker shutdown |

- 18.6 ⚡ Nginx Performance Tuning Quick Reference

| Directive | Recommended Value | Context |
|---|---|---|
| `worker_processes` | `auto` | main |
| `worker_connections` | `1024`–`65535` | events |
| `use` | `epoll` | events |
| `multi_accept` | `on` | events |
| `sendfile` | `on` | http |
| `tcp_nopush` | `on` | http |
| `tcp_nodelay` | `on` | http |
| `keepalive_timeout` | `65` | http |
| `open_file_cache` | `max=200000 inactive=20s` | http |
| `gzip_comp_level` | `4`–`6` | http |

---

> 💡 **Usage Tip:** This supplementary guide is designed to be used **alongside Section 8 of the main TOC**. Start with the main guide's Nginx section for conceptual grounding, then use this guide for production-depth mastery, source-level understanding, and advanced operational topics.
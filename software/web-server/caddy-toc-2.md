# 🔵 Caddy Server Deep Dive — Supplementary Table of Contents

> 🔗 **Companion to the main Web Servers Study Guide**
> This TOC expands exclusively on Caddy topics not covered or only briefly mentioned in the main guide (Section 10). Cross-references to the main TOC are noted with 📎.
> All Caddy 2 unless explicitly noted.

---

## 🧠 Part I: Caddy Internals & Design Philosophy

### 1. 🔬 Architecture & Design Decisions
- 1.1 🏗️ Why Go?
  - Goroutines vs. Nginx worker model — concurrency comparison
  - Go's `net/http` standard library as foundation
  - Static binary — no runtime dependencies
  - Cross-compilation and multi-platform support
  - Memory safety vs. C-based servers
  - GC pauses and tuning for low-latency serving
  - Go escape analysis and heap allocation minimization
- 1.2 🔄 Caddy Process Lifecycle
  - `main()` entry point walkthrough
  - CLI parsing (`caddy run`, `caddy start`, `caddy stop`, `caddy reload`)
  - Instance vs. process — Caddy's own abstraction
  - How `caddy reload` achieves zero-downtime (config diff + graceful drain)
  - Signal handling (`SIGTERM`, `SIGINT`, `SIGUSR1`)
  - PID file management
  - Run directory (`/var/lib/caddy`, `~/.local/share/caddy`)
- 1.3 🧩 Core Subsystems
  - `caddy` core package — module registry, config loading
  - `caddyhttp` — HTTP app subsystem
  - `caddytls` — TLS automation subsystem
  - `caddypki` — internal PKI subsystem
  - `caddyevents` — event bus subsystem
  - `notify` package — systemd/socket activation
- 1.4 🔁 Config Lifecycle
  - Config loading order (CLI flag → env → API)
  - Config validation before applying
  - Atomic config replacement — old config teardown + new config setup
  - Config persistence (`--resume` flag)
  - Rollback on failed config load
- 1.5 🏎️ Caddy vs. Nginx vs. Apache — Design Tradeoffs
  - Memory footprint comparison
  - Cold-start time comparison
  - Config complexity vs. expressiveness
  - Operational simplicity (no reload scripts, no cron for TLS)
  - Extension model differences

---

### 2. 🧩 Module System Deep Dive
- 2.1 📐 Caddy Module Architecture
  - `caddy.Module` interface — `CaddyModule() caddy.ModuleInfo`
  - Module namespacing (`caddy.*`, `http.handlers.*`, `http.matchers.*`, `tls.certificates.*`, etc.)
  - Module registry — `caddy.RegisterModule()`
  - Module namespaces as extension points (full namespace tree)
- 2.2 🔌 Module Interfaces Catalog
  - `caddy.App` — top-level applications
  - `caddy.Provisioner` — `Provision(ctx)` setup hook
  - `caddy.Validator` — `Validate()` config validation hook
  - `caddy.CleanerUpper` — `Cleanup()` teardown hook
  - `caddyhttp.MiddlewareHandler` — HTTP middleware
  - `caddyhttp.RequestMatcher` — matcher interface
  - `caddytls.CertificateLoader` — custom cert sources
  - `caddytls.Distributor` — cert distribution
  - `caddy.StorageConverter` — custom cert/ACME storage backends
- 2.3 🏗️ Writing a Custom Go Module
  - Module scaffold and boilerplate
  - Implementing `caddy.Module`
  - Implementing `caddy.Provisioner` and `caddy.Validator`
  - Implementing `caddyhttp.MiddlewareHandler`
  - JSON config struct with `caddy` struct tags
  - Caddyfile adapter — `caddyfile.Unmarshaler`
  - Registering directives with `caddyhttp.RegisterHandlerDirective`
  - Testing your module
  - Publishing and versioning your module
- 2.4 🔗 Module Dependency & Context
  - `caddy.Context` — module lifecycle context
  - `ctx.App()` — accessing other apps from a module
  - `ctx.Storage()` — accessing configured storage
  - `ctx.Logger()` — structured logging
  - `caddy.UsagePool` — shared resource management across modules
  - `caddy.NewReplacer()` — variable substitution system

---

## ⚙️ Part II: Caddyfile Mastery

### 3. 🗣️ Caddyfile Language In Depth
- 3.1 🔤 Lexical Structure
  - Token types: bare words, quoted strings, heredocs
  - Newline significance
  - Comment styles (`#`)
  - Continuation lines (backslash)
  - Block delimiters `{}`
  - Escape sequences in quoted strings
- 3.2 🏗️ Caddyfile Grammar
  - Site address syntax in full
    - Protocol prefixes (`http://`, `https://`)
    - Wildcard hostnames (`*.example.com`)
    - Bind addresses and port numbers (`localhost:8080`)
    - Multiple addresses per block (space or comma-separated)
    - IPv6 addresses in site blocks
  - Global options block `{ }` — position and uniqueness rules
  - Snippet definition and invocation (`(snippet-name)`, `import snippet-name`)
  - Directive order — why it matters and how it's determined
  - Directive ordering list (full canonical order)
- 3.3 🧮 Placeholders (Variables) System
  - Placeholder syntax `{placeholder.name}`
  - HTTP request placeholders
    - `{http.request.method}`, `{http.request.uri}`, `{http.request.uri.path}`
    - `{http.request.uri.query}`, `{http.request.uri.query.KEY}`
    - `{http.request.host}`, `{http.request.hostport}`
    - `{http.request.header.FIELD}`
    - `{http.request.remote}`, `{http.request.remote.host}`, `{http.request.remote.port}`
    - `{http.request.tls.version}`, `{http.request.tls.cipher_suite}`
    - `{http.request.tls.client.certificate_pem}`
    - `{http.request.body}` — request body placeholder
  - Response placeholders
    - `{http.response.header.FIELD}`
  - TLS placeholders
  - Auth placeholders (`{http.auth.user.*}`)
  - Error placeholders (`{http.error.status_code}`, `{http.error.message}`)
  - Environment variable placeholders (`{env.VAR_NAME}`)
  - System placeholders (`{system.hostname}`, `{system.slash}`, `{system.os}`)
  - Time placeholders (`{time.now}`, `{time.now.unix}`, `{time.now.common_log}`)
  - Custom placeholders via `vars` directive
  - Placeholder evaluation context and lazy evaluation
- 3.4 🔁 `import` Directive Full Reference
  - Importing Caddyfiles (`import /etc/caddy/conf.d/*.caddy`)
  - Importing snippets
  - Passing arguments to snippets (`{args[0]}`, `{args[1]}`)
  - Recursive imports and circular import prevention
  - Environment variable substitution in imported files
- 3.5 🌍 Global Options Block Complete Reference
  - `debug` — enable debug logging
  - `http_port`, `https_port` — override default ports
  - `default_bind` — bind address for all sites
  - `grace_period` — graceful shutdown duration
  - `shutdown_delay`
  - `admin` — admin API endpoint config
    - `admin off`
    - `admin localhost:2019`
    - `admin enforce_origin`
    - `admin origins`
  - `persist_config` — saving active config to disk
  - `storage` — selecting and configuring storage backend
  - `storage_clean_interval`
  - `renew_interval`
  - `ocsp_interval`
  - `acme_ca` — ACME directory URL
  - `acme_ca_root` — trust root for private ACME CA
  - `acme_dns` — global DNS challenge provider
  - `acme_eab` — External Account Binding
  - `cert_issuer` — global certificate issuer
  - `email` — ACME account email
  - `key_type` — global key type (rsa2048, rsa4096, p256, p384, ed25519)
  - `local_certs` — use internal CA for all sites
  - `auto_https` — fine-grained auto-HTTPS control
  - `skip_install_trust` — don't install local CA into system trust store
  - `servers` — HTTP server settings
    - `listener_wrappers`
    - `timeouts` (read, read_header, write, idle)
    - `max_header_size`
    - `enable_full_duplex`
    - `log_credentials`
    - `protocols`
    - `strict_sni_host`
  - `log` — global log config
  - `pki` — internal PKI configuration
  - `events` — event handler registration
  - `order` — overriding directive order

---

### 4. 🎯 Matchers Deep Dive
- 4.1 📐 Matcher Syntax Forms
  - Implicit path matcher (`/path`)
  - Named matcher (`@name`) — definition and use
  - Inline matcher set
  - Wildcard matcher `*` — matches everything
  - Matcher after directive on same line
- 4.2 🧩 All Built-in Matchers Reference
  - `host` — match by hostname (wildcards supported)
  - `path` — match by path (glob, prefix, exact, `*`)
  - `path_regexp` — match path by regex with capture groups
  - `method` — match HTTP methods
  - `query` — match query string parameters
  - `header` — match request headers (exact, prefix, suffix, contains, regex)
  - `header_regexp` — match headers by regex
  - `protocol` — `http`, `https`, `grpc`, `grpcs`
  - `remote_ip` — match client IP / CIDR ranges
    - `forwarded` option for `X-Forwarded-For` trust
  - `vars` — match against Caddy variables/placeholders
  - `vars_regexp` — match variables by regex
  - `not` — logical negation (wraps any other matcher)
  - `expression` — CEL (Common Expression Language) matcher
    - CEL syntax basics
    - Available CEL functions and variables
    - Complex boolean logic in a single expression
  - `file` — match based on filesystem existence
    - `root` in file matcher
    - `try_files` behavior
    - `try_policy` (first_exist, smallest_size, largest_size, most_recently_modified)
    - `split_path`
- 4.3 🔗 Combining Matchers (AND / OR Logic)
  - Multiple conditions within a named matcher (implicit AND)
  - Multiple named matchers per route (OR via multiple `handle` blocks)
  - Nesting `not` for complex NOT logic
  - `expression` for full boolean algebra

---

### 5. 🔀 Routing Directives Complete Reference
- 5.1 🗺️ Routing Architecture
  - How Caddy evaluates routes (terminal vs. non-terminal handlers)
  - Route ordering and the `route` directive
  - `handle` vs. `route` — when to use each
  - Mutual exclusivity with `handle`
  - Handler chains and middleware stack
- 5.2 📋 `route` Directive
  - Forcing strict directive order within a block
  - Use cases vs. relying on global directive order
- 5.3 📦 `handle` Directive
  - Exclusive matching — only one `handle` fires per request
  - `handle_path` — strips matched path prefix
  - `handle_errors` — error handler routes
    - Error handler placeholders
    - Nested error handlers
    - Custom error pages per status code
- 5.4 🔁 `redir` Directive Full Reference
  - Temporary (302) vs. permanent (301) redirects
  - `308` and `307` options
  - Redirect to HTTPS with placeholder
  - Strip/add `www` patterns
  - Wildcard redirect patterns
  - `html` redirect type — meta-refresh fallback
- 5.5 🔄 `rewrite` Directive Full Reference
  - Path rewriting
  - URI rewriting (path + query)
  - Using placeholders in rewrite targets
  - Regex rewriting with capture groups (`{re.name.1}`)
- 5.6 🧭 `map` Directive
  - Syntax and source/destination types
  - Default value
  - Mapping to multiple outputs
  - Using regex in map inputs
  - Using mapped output in other directives

---

## 🔒 Part III: TLS & PKI Mastery

### 6. 🔐 Automatic HTTPS Internals
- 6.1 🔍 Auto-HTTPS Decision Logic
  - Full flowchart: when Caddy issues, skips, or errors on TLS
  - Conditions that disable auto-HTTPS per site
  - `auto_https disable_redirects`
  - `auto_https ignore_loaded_certs`
  - `auto_https off`
- 6.2 🏗️ CertMagic Library
  - CertMagic as the underlying TLS automation library
  - CertMagic's state machine for certificate lifecycle
  - Obtaining → Storing → Loading → Renewing pipeline
  - Certificate renewal window (default: 30 days before expiry)
  - Renewal retry backoff
  - On-demand TLS via CertMagic
  - CertMagic storage interface
- 6.3 🌐 ACME Protocol Deep Dive (Caddy-Specific)
  - ACME account creation and key storage
  - Order → Authorization → Challenge → Finalize → Download flow
  - HTTP-01 challenge — how Caddy serves it (port 80 handler injection)
  - TLS-ALPN-01 challenge — how Caddy serves it (special TLS handshake)
  - DNS-01 challenge — async DNS propagation waiting
  - Challenge selection priority in Caddy
  - Preferred challenge configuration
  - ACME server selection (Let's Encrypt, ZeroSSL, Buypass, Google Trust Services)
  - EAB (External Account Binding) for private ACME servers
  - Rate limit awareness and avoidance
- 6.4 🏠 On-Demand TLS
  - What On-Demand TLS solves (SaaS multi-tenant, dynamic domains)
  - `on_demand` TLS policy
  - `ask` endpoint — permission check before issuing cert
    - Implementing the `ask` endpoint
    - Security implications of `ask`
  - Rate limiting On-Demand issuance (`interval`, `burst`)
  - On-Demand TLS and storage performance considerations
  - On-Demand TLS vs. wildcard certificates tradeoffs
- 6.5 🔑 Certificate Issuers Configuration
  - `acme` issuer — full options
  - `zerossl` issuer
  - `internal` issuer — local CA via Caddy PKI
  - `tailscale` issuer — Tailscale machine certs
  - Issuer fallback chain — trying multiple issuers in order
- 6.6 💾 Certificate Storage Backends
  - Default file system storage layout
    - Sites directory structure
    - ACME accounts storage
    - OCSP stapling cache
  - `storage` module system
  - `certmagic.Storage` interface for custom backends
  - Available storage plugins
    - `caddy-storage-redis`
    - `caddy-storage-s3`
    - Consul-based storage
    - Vault-based storage
  - Storage in clustered/multi-instance deployments — sharing storage

---

### 7. 🏛️ Internal PKI (Caddy as CA)
- 7.1 📖 Caddy PKI Overview
  - `pki` app in Caddy
  - Root CA and intermediate CA auto-generation
  - CA key and cert storage locations
  - Use cases: local development, internal services, mTLS mesh
- 7.2 ⚙️ PKI Configuration
  - Defining a CA in global options (`pki { ca internal { ... } }`)
  - `name` — human-readable CA name
  - `root_cn`, `intermediate_cn` — certificate common names
  - `root` — custom root cert/key
  - `intermediate` — custom intermediate cert/key
  - Multiple CAs in one Caddy instance
- 7.3 🖥️ Installing the Local Root CA
  - `caddy trust` — install into system store
  - `caddy untrust` — remove from system store
  - Browser-specific trust store quirks (Firefox NSS)
  - CI/CD trust installation
  - Docker container trust installation
- 7.4 🔗 Caddy PKI + mTLS
  - Issuing client certificates via internal CA
  - Configuring `tls client_auth` with internal CA
  - Rotating internal CA certificates
  - Certificate revocation in internal PKI (limitations)
- 7.5 🌐 Caddy as ACME Server
  - `caddy-acme-server` module (community)
  - Issuing certs to other Caddy instances or Certbot clients
  - Use in air-gapped environments

---

### 8. 🔐 Advanced TLS Directives
- 8.1 📋 `tls` Directive Complete Reference
  - `tls off` — explicit disable
  - `tls email` — ACME email override per site
  - `tls [cert] [key]` — manual cert loading
  - `tls load` — load from directory
  - `tls ca` — ACME CA per site
  - `tls dns PROVIDER` — DNS challenge per site
  - `tls alpn` — preferred challenge
  - `tls eab` — EAB credentials per site
  - `tls on_demand` — enable On-Demand for site
  - `tls issuer` — custom issuer block
  - `tls key_type` — per-site key type
  - `tls curves` — elliptic curve selection
  - `tls protocols` — min/max TLS versions
  - `tls ciphers` — cipher suite restriction
  - `tls client_auth` — mTLS configuration
    - `mode` (request, require, verify_if_given, require_and_verify)
    - `trusted_ca_cert`
    - `trusted_ca_cert_file`
    - `trusted_leaf_cert`
    - `verifier` — custom verifier module
  - `tls except` — exclude paths from HTTPS redirect
  - `tls internal` — use internal CA shorthand
- 8.2 🔄 Certificate Automation Hooks
  - Pre-certificate-obtain hooks
  - Post-certificate-obtain hooks
  - Renewal event hooks via `events` app

---

## 🔌 Part IV: Handlers & Middleware Complete Reference

### 9. 📦 Built-in HTTP Handlers
- 9.1 📁 `file_server` Directive In Depth
  - `file_server browse` — directory listing
    - Customizing the browse template
    - Browse template placeholders
  - `root` directive — document root
  - `file_server` with `hide` — hiding files/directories by pattern
  - `file_server` with `index` — custom index files
  - `file_server` with `precompressed` — serving `.gz` / `.br` files
    - Encoding selection order
  - `file_server` with `status` — custom status for all responses
  - `file_server` with `disable_canonical_uris`
  - `file_server` + `try_files` pattern for SPA
  - `file_server` pass-through behavior
- 9.2 🔁 `reverse_proxy` Directive In Depth
  - Upstream address formats (host:port, unix socket, srv+dns://)
  - Multiple upstreams — implicit round-robin
  - `to` subdirective
  - Load balancing policies subdirective
    - `lb_policy round_robin`
    - `lb_policy least_conn`
    - `lb_policy random`
    - `lb_policy random_choose N`
    - `lb_policy first`
    - `lb_policy ip_hash`
    - `lb_policy uri_hash`
    - `lb_policy header FIELD`
    - `lb_policy cookie NAME [secret]` — cookie-based sticky sessions
  - `lb_retries` and `lb_try_duration`
  - `lb_try_interval`
  - Health check subdirectives
    - `health_uri`
    - `health_port`
    - `health_interval`
    - `health_timeout`
    - `health_status`
    - `health_headers`
    - `health_body` (regex match)
    - `health_passes` and `health_fails` — threshold counts
  - Passive health checks
    - `fail_duration`
    - `max_fails`
    - `unhealthy_status`
    - `unhealthy_latency`
    - `unhealthy_request_count`
  - Header manipulation subdirectives
    - `header_up` — modify request headers to upstream
    - `header_down` — modify response headers from upstream
  - `flush_interval` — streaming response flushing
    - `-1` for immediate flush (SSE, streaming)
  - `buffer_requests` — buffer full request body before forwarding
  - `buffer_responses`
  - `max_buffer_size`
  - `trusted_proxies` — for X-Forwarded-For handling
  - `transport` subdirective
    - `http` transport
      - `tls` — TLS to upstream
      - `tls_client_auth` — mTLS to upstream
      - `tls_insecure_skip_verify`
      - `tls_timeout`
      - `tls_trusted_ca_certs`
      - `tls_server_name`
      - `keepalive` — connection reuse to upstream
      - `keepalive_idle_conns`
      - `keepalive_interval`
      - `max_conns_per_host`
      - `dial_timeout`, `response_header_timeout`, `expect_continue_timeout`
      - `read_buffer_size`, `write_buffer_size`
      - `compression` — disable/enable upstream compression
      - `versions` — HTTP versions to upstream (1.1, 2)
      - `local` — bind local address for upstream connection
    - `fastcgi` transport
      - `root`, `split`, `index`
      - `env` — extra FastCGI environment variables
      - `capture_stderr`
      - `dial_timeout`, `read_timeout`, `write_timeout`
      - `resolve_root_symlink`
- 9.3 🛡️ `header` Directive In Depth
  - Setting headers (overwrite, default `?`, add `+`)
  - Deleting headers (`-`)
  - Replacing header values (regex replace)
  - `defer` — apply after response is generated
  - Preventing response headers from upstream from reaching client
- 9.4 🗜️ `encode` Directive In Depth
  - `gzip` encoder options (`level`)
  - `zstd` encoder (Caddy's advantage over Nginx OSS)
  - `br` (Brotli) encoder options (`quality`)
  - `minimum_length` — size threshold
  - Matcher for content types to encode
  - Priority and negotiation with `Accept-Encoding`
- 9.5 🔒 `basicauth` Directive
  - Password hash format (bcrypt)
  - `caddy hash-password` CLI command
  - Multiple users
  - Accessing `{http.auth.user.id}` after auth
- 9.6 🔑 `authenticate` & `authorize` (with caddy-security plugin)
  - Overview of the caddy-security ecosystem (preview — plugin section)
- 9.7 📝 `log` Directive In Depth
  - `log` per-site vs. global log
  - `output` — `stdout`, `stderr`, `file`, `discard`
    - `file` output options (roll size, keep, age, compress)
  - `format` — `console`, `json`, `single_field`, `filter`
    - `filter` format — field-level filtering and transformations
    - `delete` — remove fields
    - `rename` — rename fields
    - `replace` — replace field values (regex)
    - `ip_mask` — anonymize IP fields (GDPR)
    - `hash` — hash sensitive fields
    - `query` — filter query string fields
    - `cookie` — filter cookie fields
    - `regexp` — filter by regex
  - `level` — log level per logger
  - `include` / `exclude` — filter by logger names
  - Structured log fields reference
    - `ts`, `logger`, `msg`
    - `request.*` fields
    - `resp_headers`, `status`, `size`, `duration`
    - `upstream_latency`
  - Access log vs. error log in Caddy (unified logging system)
- 9.8 ⏱️ `timeout` and `timeouts` Directives
  - `read_body`, `write`, `idle`, `read_header` timeouts
  - Per-route timeout overrides
- 9.9 📊 `metrics` Directive
  - Exposing Prometheus metrics endpoint
  - Metrics available (requests, TLS, reverse proxy upstream stats)
- 9.10 🔌 `respond` Directive
  - Static response body
  - Status code
  - Headers
  - `close` — close connection after response
- 9.11 🧩 `templates` Directive
  - Go `html/template` integration
  - Available template actions
    - `{{ .Args }}`, `{{ .RespHeader }}`, `{{ .Req }}`
    - `{{ httpInclude }}` — include another path's response
    - `{{ listFiles }}` — list directory contents
    - `{{ markdown }}` — render Markdown
    - `{{ env }}` — read environment variable
    - `{{ placeholder }}` — read Caddy placeholder
    - `{{ splitFrontMatter }}` — YAML front matter parsing
    - `{{ randInt }}`, `{{ now }}`, `{{ httpError }}`
  - Use cases: simple CMS, dynamic headers in HTML
- 9.12 🔀 `push` Directive (HTTP/2 Server Push)
  - Configuring push resources
  - Push rules by path
  - Performance considerations and deprecation context
- 9.13 🌐 `tracing` Directive
  - OpenTelemetry integration
  - `span` name configuration
  - Exporter configuration
  - Propagating trace context to upstream

---

### 10. 🔌 DNS Challenge Providers
- 10.1 📖 How DNS-01 Works in Caddy
  - `libdns` library — the abstraction layer
  - Provider modules — `caddy-dns/*` family
  - Credential configuration (env vars vs. Caddyfile)
- 10.2 📋 Provider Module Reference
  - `caddy-dns/cloudflare`
  - `caddy-dns/route53`
  - `caddy-dns/azure`
  - `caddy-dns/googleclouddns`
  - `caddy-dns/digitalocean`
  - `caddy-dns/namecheap`
  - `caddy-dns/porkbun`
  - `caddy-dns/godaddy`
  - `caddy-dns/hetzner`
  - `caddy-dns/njalla`
  - `caddy-dns/duckdns`
  - `caddy-dns/ovh`
  - `caddy-dns/netlify`
  - Writing a custom `libdns` provider
- 10.3 ⚙️ DNS Provider Configuration Patterns
  - Per-site DNS challenge
  - Global DNS challenge
  - Using environment variables for API keys
  - Using Caddy's secret management integrations

---

## 🚀 Part V: xcaddy & Build System

### 11. 🛠️ `xcaddy` — Custom Caddy Builds
- 11.1 📖 Why `xcaddy`?
  - Go module-based plugin system (compile-time linking)
  - No dynamic module loading (vs. Nginx DSO)
  - Tradeoffs: rebuild required, but simple and safe
- 11.2 ⚙️ `xcaddy` Usage
  - `xcaddy build` — basic usage
  - `--with MODULE@VERSION` — adding plugins
  - `--without MODULE` — removing default modules
  - `--replace` — local module development
  - `--output` — output binary path
  - `GOFLAGS` and `GOPROXY` environment variables
  - Cross-compiling with `GOOS` and `GOARCH`
  - Building for ARM (Raspberry Pi, AWS Graviton)
- 11.3 🐋 Dockerized Builds
  - Official `caddy:builder` Docker image
  - Multi-stage Dockerfile pattern for custom Caddy
  - Pinning plugin versions in Docker builds
  - Automated rebuild on plugin updates (CI/CD)
- 11.4 📦 Creating a Distributable Custom Build
  - Reproducible builds with `go.sum`
  - Signing custom binaries
  - Distributing in packages (`.deb`, `.rpm`)
  - GitHub Actions workflow for automated builds

---

## 🌐 Part VI: Admin API Deep Dive

### 12. 🔧 Caddy Admin API
- 12.1 📖 Admin API Overview
  - REST API on `localhost:2019` (default)
  - JSON config as first-class citizen
  - API vs. Caddyfile — when to use each
  - API authentication (admin `origins` enforcement)
  - Unix socket admin endpoint
  - Disabling the admin API (`admin off`)
- 12.2 📋 Admin API Endpoint Reference
  - `GET /config/` — retrieve current config
  - `POST /config/` — load full config
  - `PUT /config/PATH` — set config at path
  - `PATCH /config/PATH` — update config at path
  - `DELETE /config/PATH` — delete config at path
  - `GET /config/PATH` — retrieve config subtree
  - `POST /load` — load config (with format header)
  - `POST /stop` — stop Caddy
  - `GET /reverse_proxy/upstreams` — upstream health status
  - `GET /pki/ca/ID` — CA info
  - `GET /pki/ca/ID/certificates` — CA certificate chain
  - `POST /adapt` — adapt Caddyfile to JSON without applying
- 12.3 🔄 Dynamic Reconfiguration Patterns
  - Adding a new site at runtime
  - Removing a site without restart
  - Updating upstream list dynamically
  - Updating rate limit configuration
  - A/B testing via API-driven route manipulation
  - Canary deployments via API
- 12.4 🔗 Config Traversal Syntax
  - JSON path traversal (`/config/apps/http/servers/...`)
  - Array index access (`/config/apps/http/servers/srv0/routes/0`)
  - `@id` — named config nodes for direct access
    - Setting `@id` in config
    - Accessing by ID: `/id/MY_ID`
  - `@using` for config templating (experimental)
- 12.5 🛠️ Integrating with the Admin API
  - `curl` examples for all endpoints
  - Python client patterns
  - Go client patterns
  - Watching config changes (polling vs. webhooks)
  - Caddy API in Kubernetes operators

---

## 📦 Part VII: Plugin Ecosystem

### 13. 🔌 Essential Community Plugins
- 13.1 🔒 Security & Auth Plugins
  - `caddy-security` (authp)
    - Local user database
    - OAuth2 / OIDC providers (Google, GitHub, Facebook, Azure AD)
    - SAML integration
    - Multi-factor authentication (TOTP, YubiKey)
    - Portal UI customization
    - JWT issuing and validation
    - Authorization policies (ACL rules)
    - `authenticate with PORTAL` directive
    - `authorize with POLICY` directive
  - `caddy-jwt` — lightweight JWT validation
  - `caddy-hmac` — HMAC request signing validation
  - `caddy-ratelimit` (mholt/caddy-ratelimit)
    - Rate limiting by any placeholder
    - Multiple rate limit windows
    - Distributed rate limiting (with shared storage)
    - Jitter, burst configuration
  - `caddy-maxmind-geolocation` — GeoIP matching
    - MaxMind GeoLite2 / GeoIP2 database
    - Geo-based matchers
    - Blocking countries / allowing countries
- 13.2 📊 Observability Plugins
  - `caddy-prometheus` (if not using built-in `metrics`)
  - `caddy-json-logger` — advanced JSON log formatting
  - `caddy-event-logger` — logging Caddy events
  - `caddy-opentelemetry` — extended OTEL config
- 13.3 🗄️ Storage Plugins
  - `caddy-storage-redis`
    - Single node, Sentinel, Cluster modes
    - TLS to Redis
    - Key prefix configuration
  - `caddy-storage-s3`
    - Compatible with AWS S3, MinIO, Backblaze B2
    - IAM role vs. access key auth
  - `certmagic-sqlstorage` — PostgreSQL/MySQL storage
- 13.4 🔀 Proxy & Routing Plugins
  - `caddy-l4` (Layer 4 app)
    - TCP/UDP routing without HTTP
    - L4 matchers: TLS SNI, HTTP host, SSH, RDP, Proxy Protocol
    - L4 handlers: proxy, tls, echo, socks5
    - SOCKS5 proxy support
    - SSH proxying
    - Multiplexing protocols on same port (443: HTTPS + SSH)
  - `caddy-docker-proxy`
    - Auto-configuring Caddy from Docker labels
    - Label syntax reference
    - Networks and service discovery
    - TLS per container
    - Template directives in labels
  - `caddy-coraza-waf` — Coraza WAF (OWASP CRS)
    - Coraza vs. ModSecurity differences
    - CRS integration
    - Per-route WAF rules
  - `caddy-requestid` — generating and propagating request IDs
  - `caddy-replace-response` — response body find-and-replace
  - `caddy-cache` — full HTTP cache (RFC 7234)
    - Cache storage backends
    - Cache invalidation API
    - Vary header support
  - `caddy-grpc-web` — gRPC-Web to gRPC transcoding
  - `caddy-webdav` — WebDAV server
  - `caddy-git` — auto-pull from git on webhook
  - `caddy-exec` — run commands on events/requests
  - `caddy-ssh` — SSH server built into Caddy

---

## ☸️ Part VIII: Caddy in Production & Cloud

### 14. 🐋 Docker & Container Patterns
- 14.1 🐳 Official Docker Image Deep Dive
  - Image variants (`caddy`, `caddy:alpine`, `caddy:builder`)
  - Default entrypoint and CMD
  - Volumes: `/data` (storage), `/config` (config), `/etc/caddy` (Caddyfile)
  - Environment variables respected by image
  - `XDG_DATA_HOME` and `XDG_CONFIG_HOME`
  - Hot reload in Docker (`docker exec caddy caddy reload`)
  - Health check configuration for Docker
- 14.2 🔧 Docker Compose Patterns
  - Single-site Compose setup with auto-HTTPS
  - Multi-site reverse proxy Compose setup
  - Caddy + app container networking
  - Named volumes for persistent TLS data
  - Compose watch for development
  - Traefik-to-Caddy migration pattern
- 14.3 🏷️ `caddy-docker-proxy` Deep Dive
  - Container label schema
  - `caddy` label — site address
  - `caddy.reverse_proxy` — proxying to container
  - `caddy.tls` — TLS per container
  - `caddy.import` — snippet import per container
  - Label templating and inheritance
  - Handling Docker networks (overlay, bridge)
  - Swarm mode support

---

### 15. ☸️ Kubernetes Integration
- 15.1 🌐 Caddy as Kubernetes Ingress
  - `ingress-caddy` controller overview
  - Annotation support
  - TLS secret integration
  - Differences from ingress-nginx
- 15.2 🔄 Caddy Gateway API (Kubernetes)
  - Gateway API vs. Ingress API
  - `HTTPRoute`, `GatewayClass`, `Gateway` resources
  - Caddy Gateway API controller (experimental)
- 15.3 🗄️ Shared Storage in Kubernetes
  - Problem: multiple Caddy pods need shared TLS storage
  - Redis storage solution
  - S3 storage solution
  - PVC (Persistent Volume Claim) for single-pod setups
  - StatefulSet vs. Deployment for Caddy
- 15.4 ⚙️ ConfigMap-based Caddyfile
  - Mounting Caddyfile from ConfigMap
  - Reloading on ConfigMap change
  - Using `caddy reload` via sidecar or init container

---

### 16. ☁️ Cloud-Specific Deployments
- 16.1 🟠 AWS
  - EC2 + Caddy with Route53 DNS challenge
  - ECS (Fargate) Caddy container
  - S3 storage backend for ECS (shared TLS state)
  - ALB in front of Caddy (X-Forwarded-For handling)
  - AWS IAM role for Route53 DNS challenge (no static keys)
- 16.2 🔵 GCP
  - Compute Engine + Caddy
  - Cloud Run + Caddy (no port 80/443, HTTP only mode)
  - GCS storage backend
  - GCP IAM for Cloud DNS challenge
- 16.3 🟣 Azure
  - Azure VMs + Caddy
  - Azure DNS challenge with managed identity
  - Azure Blob Storage backend
- 16.4 🟤 DigitalOcean / Hetzner / Linode
  - Droplet + Caddy — simplest full stack
  - DNS challenge with provider tokens
  - Floating IP + Caddy HA setup
- 16.5 🌐 Bare Metal / VPS Hardening
  - Caddy with systemd (full unit file reference)
  - Caddy with `CAP_NET_BIND_SERVICE` (no root for ports 80/443)
  - `setcap` vs. systemd `AmbientCapabilities`
  - Caddy behind a hardware firewall (UFW / nftables rules)
  - Fail2ban integration with Caddy logs

---

## ⚡ Part IX: Performance Engineering

### 17. 🏎️ Caddy Performance Tuning
- 17.1 🧵 Go Runtime Tuning
  - `GOMAXPROCS` — goroutine scheduler threads
  - `GOGC` — GC aggressiveness vs. memory usage tradeoff
  - `GOMEMLIMIT` (Go 1.19+) — soft memory limit to control GC
  - `GODEBUG` options relevant to networking (`netdns`, `http2debug`)
  - `runtime/pprof` — CPU and memory profiling Caddy
  - `net/http/pprof` — live profiling via HTTP endpoint
- 17.2 📡 Connection Tuning
  - `servers > timeouts` in global options
  - `keepalive_interval` and `keepalive_idle_conns` in transport
  - `max_conns_per_host` — upstream connection pool
  - Enabling HTTP/2 and HTTP/3 — protocol performance comparison
  - `enable_full_duplex` — bidirectional streaming
- 17.3 💾 File Serving Performance
  - `precompressed` directive — avoiding runtime compression
  - `file_server` with large file handling
  - Memory-mapped file behavior in Go (`os.File` vs. `sendfile`)
  - Static asset cache headers with `header` + `file_server`
- 17.4 📊 Benchmarking Caddy
  - Comparing Caddy to Nginx for static files
  - Comparing Caddy to Nginx for reverse proxy
  - TLS handshake performance comparison
  - Memory usage profiling under load
  - Latency distribution analysis (p99 vs. p999)
- 17.5 🗜️ Compression Strategy
  - Brotli quality vs. CPU usage in Caddy
  - Zstandard (`zstd`) — Caddy's unique offering
  - Pre-compression workflow for static assets
  - Dynamic vs. static compression decision tree

---

## 🩺 Part X: Operations & Debugging

### 18. 🔄 Caddy Lifecycle Management
- 18.1 🛠️ CLI Commands Complete Reference
  - `caddy run` — foreground run (options: `--config`, `--adapter`, `--resume`, `--watch`)
  - `caddy start` — background daemon start
  - `caddy stop` — stop running instance
  - `caddy reload` — hot reload config
  - `caddy adapt` — convert Caddyfile to JSON
  - `caddy validate` — validate config without applying
  - `caddy fmt` — format Caddyfile
  - `caddy hash-password` — bcrypt password hashing
  - `caddy trust` / `caddy untrust`
  - `caddy environ` — print Caddy environment
  - `caddy version` — print version
  - `caddy list-modules` — list all compiled modules
  - `caddy build-info` — Go build info
  - `caddy manpage` — generate man pages
  - `caddy completion` — shell completion scripts
- 18.2 👁️ `--watch` Mode for Development
  - Auto-reload on Caddyfile change
  - Limitations and edge cases
  - Combining with `caddy-docker-proxy` in development
- 18.3 ⚙️ Systemd Integration (Complete)
  - Full recommended `caddy.service` unit file
  - `Type=notify` — systemd readiness notification
  - `WatchdogSec` — watchdog integration
  - `LimitNOFILE` — file descriptor limit
  - `PrivateTmp`, `ProtectSystem`, `ProtectHome` — hardening
  - `AmbientCapabilities=CAP_NET_BIND_SERVICE`
  - `NoNewPrivileges`
  - Journal logging and `journalctl -u caddy -f`
  - Socket activation with systemd
- 18.4 🔁 High Availability Patterns
  - Active-active Caddy with shared storage
  - Active-passive with keepalived / VRRP
  - Health check endpoint for external load balancers
  - Split brain prevention with shared TLS storage

---

### 19. 🐛 Debugging & Diagnostics
- 19.1 🔍 Debug Mode
  - `debug` global option — verbose logging
  - `CADDY_LOG_LEVEL=DEBUG` environment variable
  - Per-logger level configuration
  - TLS debug output (`GODEBUG=tls13=0`, etc.)
- 19.2 🧪 Config Troubleshooting
  - `caddy adapt --pretty` — pretty-print JSON config
  - `caddy validate` error messages decoded
  - Common Caddyfile syntax errors explained
  - `POST /adapt` API endpoint for live adaptation debugging
- 19.3 🌡️ Runtime Introspection
  - `GET /config/` — inspect live running config
  - `GET /reverse_proxy/upstreams` — upstream health states
  - `GET /pki/ca/local` — local CA certificate info
  - Go `pprof` endpoint activation and use
    - CPU profile: `curl localhost:2019/debug/pprof/profile`
    - Goroutine dump: `curl localhost:2019/debug/pprof/goroutine`
    - Memory profile: `curl localhost:2019/debug/pprof/heap`
  - Goroutine leak detection
- 19.4 🔬 TLS Debugging
  - Certificate state via admin API
  - `caddy` log entries for ACME operations
  - ACME challenge debugging (watching HTTP-01 challenge path)
  - `curl -v` for TLS handshake inspection
  - `openssl s_client` for certificate chain verification
  - Checking OCSP stapling: `openssl s_client -status`
  - Caddy's ACME error messages decoded
    - `urn:ietf:params:acme:error:rateLimited`
    - `urn:ietf:params:acme:error:dns`
    - `urn:ietf:params:acme:error:unauthorized`
    - `urn:ietf:params:acme:error:malformed`
- 19.5 🔥 Common Problems & Solutions
  - Port 80/443 already in use
  - Permission denied binding to low ports
  - ACME challenge fails (HTTP-01) — firewall/routing issues
  - DNS-01 propagation timeout
  - Certificate not renewing — storage permission issues
  - `context deadline exceeded` to upstream
  - Proxy returning 502 — upstream not running
  - WebSocket upgrade failing — missing headers
  - Large file upload timing out — body timeout config
  - Admin API not reachable after config reload
  - On-Demand TLS `ask` endpoint returning wrong status

---

## 📋 Part XI: Reference & Recipes

### 20. 🧪 Complete Configuration Recipes
- 20.1 🌐 Common Site Patterns
  - Static site with perfect caching headers
  - SPA (React/Vue/Angular) with HTML5 routing
  - WordPress with PHP-FPM (FastCGI)
  - Next.js (Node.js) reverse proxy
  - Django / FastAPI reverse proxy
  - Rails / Puma reverse proxy
  - Ghost blog reverse proxy
  - Gitea self-hosted git
  - Nextcloud reverse proxy (large uploads, WebDAV)
  - Jellyfin / Plex media server
- 20.2 🔒 Security Patterns
  - Full security headers block
  - IP allowlist for admin paths
  - Multi-factor-protected admin panel
  - mTLS for internal API
  - Rate limiting per endpoint
  - Country blocking with MaxMind
- 20.3 🏗️ Advanced Routing Patterns
  - Multi-tenant SaaS with On-Demand TLS
  - Canary deployment with `map` + `reverse_proxy`
  - A/B testing split by cookie
  - Blue-green deployment via Admin API
  - Path-based microservice routing
  - Subdomain-to-path rewriting
  - Maintenance mode toggle via API

---

### 21. 📚 Quick Reference Tables

- 21.1 📋 Caddyfile Directive Order (Canonical)

| Order | Directive |
|---|---|
| 1 | `tracing` |
| 2 | `map` |
| 3 | `root` |
| 4 | `log` |
| 5 | `skip_log` |
| 6 | `header` |
| 7 | `copy_response_headers` |
| 8 | `request_body` |
| 9 | `rate_limit` |
| 10 | `basicauth` |
| 11 | `authenticate` |
| 12 | `authorize` |
| 13 | `respond` |
| 14 | `metrics` |
| 15 | `route` |
| 16 | `handle` |
| 17 | `abort` |
| 18 | `error` |
| 19 | `templates` |
| 20 | `invoke` |
| 21 | `rewrite` |
| 22 | `uri` |
| 23 | `try_files` |
| 24 | `redir` |
| 25 | `reverse_proxy` |
| 26 | `grpc_web` |
| 27 | `file_server` |
| 28 | `encode` |
| 29 | `push` |
| 30 | `acme_server` |

- 21.2 🔤 Placeholder Quick Reference

| Placeholder | Description |
|---|---|
| `{host}` | Request Host header |
| `{path}` | Request URI path |
| `{query}` | Raw query string |
| `{method}` | HTTP method |
| `{remote_host}` | Client IP address |
| `{scheme}` | `http` or `https` |
| `{status}` | Response status code |
| `{upstream_latency}` | Upstream response time |
| `{tls_cipher}` | TLS cipher suite |
| `{tls_version}` | TLS version |
| `{uuid}` | Unique request ID |
| `{err.status_code}` | Error status (in `handle_errors`) |

- 21.3 🛡️ Hardened Caddyfile Template (Annotated)
- 21.4 🔧 Admin API `curl` Cheatsheet
- 21.5 📦 Plugin Compatibility Matrix (Caddy version vs. plugin version)
- 21.6 🆚 Nginx-to-Caddy Migration Cheatsheet

| Nginx | Caddy Equivalent |
|---|---|
| `server {}` | Site block |
| `location /path` | `handle /path {}` |
| `proxy_pass http://...` | `reverse_proxy http://...` |
| `try_files` | `try_files` |
| `rewrite ^/old /new` | `redir /old /new` |
| `gzip on` | `encode gzip` |
| `ssl_certificate` | `tls cert.pem key.pem` |
| `add_header` | `header +Name value` |
| `limit_req_zone` | `rate_limit` (plugin) |
| `access_log` | `log {}` |
| `include /path/*.conf` | `import /path/*.caddy` |
| `if ($var ~= regex)` | `@matcher { header_regexp ... }` |
| `upstream {}` | Multiple addresses in `reverse_proxy` |

---

> 💡 **Usage Tip:** Start with **Part II (Caddyfile Mastery)** and **Part III (TLS Mastery)** — these are Caddy's core differentiators. Then explore **Part VI (Admin API)** and **Part VII (Plugins)** for production power. Use **Part XI (Recipes)** as a daily reference while building.
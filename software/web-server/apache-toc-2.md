# 🪶 Apache HTTP Server Deep Dive — Supplementary Table of Contents

> 🔗 **Companion to the main Web Servers Study Guide**
> This TOC expands exclusively on Apache HTTP Server topics not covered or only briefly mentioned in the main guide (Section 7). Cross-references to the main TOC are noted with 📎.
> Covers Apache 2.4.x unless explicitly noted. Apache HTTP Server is referred to as "Apache" or "httpd" throughout.

---

## 🧠 Part I: Internals & Architecture Deep Dive

### 1. 🔬 Source Code & Build Architecture
- 1.1 🗂️ Source Tree Layout
  - `server/` — core server code
  - `modules/` — all bundled modules
  - `os/` — OS-specific implementations
  - `include/` — public header files
  - `support/` — utility programs (`ab`, `apachectl`, `rotatelogs`, etc.)
  - `build/` — autoconf/automake build system
  - Key source files walkthrough
    - `server/main.c` — entry point
    - `server/config.c` — configuration parsing
    - `server/request.c` — request processing
    - `server/vhost.c` — virtual host resolution
    - `server/log.c` — logging subsystem
    - `server/util.c` — utility functions
- 1.2 ⚙️ Build System (`./configure`)
  - APACI (Apache Portable Runtime Autoconf Interface)
  - `--prefix` — installation directory
  - `--enable-MODULE` / `--disable-MODULE`
  - `--with-MODULE=shared` / `--with-MODULE=static`
  - `--with-mpm=MPM` — selecting MPM at build time (pre-2.4)
  - `--enable-mpms-shared=all` — building all MPMs as shared (2.4+)
  - `--with-apr` / `--with-apr-util` — APR paths
  - `--with-pcre` — PCRE library
  - `--with-ssl` — OpenSSL path
  - `--with-z` — zlib for compression
  - `--enable-so` — DSO (Dynamic Shared Object) support
  - Platform-specific flags (Linux, FreeBSD, macOS, Solaris)
  - `apxs` — APache eXtenSion tool for building modules
    - `apxs -c -i mod_custom.c`
    - `apxs -i -a -n custom mod_custom.la`
- 1.3 🔄 Apache Portable Runtime (APR & APR-util)
  - What APR provides (cross-platform abstraction)
  - Memory pools (`apr_pool_t`)
  - File I/O abstractions
  - Network abstractions (`apr_socket_t`)
  - Atomic operations
  - Thread and process abstractions
  - Hash tables and arrays
  - String handling (`apr_pstrdup`, `apr_psprintf`)
  - APR-util: database, LDAP, XML, crypto abstractions
  - APR bucket brigades — streaming I/O model
    - `apr_bucket_brigade`
    - Bucket types: FILE, PIPE, SOCKET, HEAP, POOL, TRANSIENT, IMMORTAL, EOS, FLUSH
    - How bucket brigades enable streaming without buffering full response

---

### 2. 🏗️ MPM (Multi-Processing Module) Architecture Deep Dive
- 2.1 📖 MPM Overview
  - Why Apache has pluggable MPMs
  - MPM as a module (`LoadModule mpm_event_module`)
  - `httpd -V` — detecting compiled/loaded MPM
  - Selecting MPM at runtime (2.4+)
  - MPM-specific directives and their interactions
- 2.2 🍴 Prefork MPM
  - Process model: one process per request
  - No thread safety requirement for modules
  - Master process + pre-spawned child processes
  - `StartServers` — initial children at startup
  - `MinSpareServers` / `MaxSpareServers` — idle process range
  - `MaxRequestWorkers` — max simultaneous requests
  - `MaxConnectionsPerChild` — requests before child exits (memory leak mitigation)
  - `ServerLimit` — hard limit on `MaxRequestWorkers`
  - Child lifecycle: accept → process → back to pool
  - Scoreboard mechanism — shared memory state
  - When to use Prefork (mod_php, non-thread-safe libraries)
  - Memory overhead and scaling limits
- 2.3 🧵 Worker MPM
  - Hybrid multi-process + multi-thread model
  - `StartServers` — initial processes
  - `ServerLimit` — max processes
  - `ThreadsPerChild` — threads per process
  - `MinSpareThreads` / `MaxSpareThreads`
  - `MaxRequestWorkers` — total = processes × threads
  - `ThreadLimit` — hard limit on `ThreadsPerChild`
  - `MaxConnectionsPerChild`
  - Thread safety requirement for all modules
  - Memory advantage over Prefork
  - Thread-local storage patterns in Apache
- 2.4 ⚡ Event MPM
  - Evolution from Worker MPM
  - Dedicated listener thread per process
  - Worker threads freed during keep-alive wait
  - How Event MPM solves the keep-alive problem
  - Async connections (lingering close, keep-alive, TLS shutdown)
  - `AsyncRequestWorkerFactor` — async connections multiplier
  - `StartServers`, `ServerLimit`, `ThreadsPerChild`, `ThreadLimit`
  - `MinSpareThreads`, `MaxSpareThreads`, `MaxRequestWorkers`
  - `MaxConnectionsPerChild`
  - Restrictions: not compatible with some `mod_ssl` features pre-2.4.9
  - APR pollset-based event loop
  - Interaction with `mod_ssl` and async TLS
- 2.5 🏃 WinNT MPM (Windows)
  - Single process, multi-thread model
  - `ThreadsPerChild` — all threads in one process
  - `MaxConnectionsPerChild`
  - IOCP (I/O Completion Ports) usage
  - Windows service integration
- 2.6 📊 MPM Comparison & Selection Guide
  - Decision matrix: PHP → Prefork, other → Event
  - Benchmarks: requests/sec, memory/request
  - Keep-alive behavior differences
  - SSL/TLS implications per MPM
  - `mod_php` vs. PHP-FPM enabling Event MPM

---

### 3. 🔄 Request Processing Pipeline
- 3.1 🏗️ Handler & Hook Architecture
  - Apache Hook system (`ap_hook_*`)
  - Hook ordering: `APR_HOOK_REALLY_FIRST`, `APR_HOOK_FIRST`, `APR_HOOK_MIDDLE`, `APR_HOOK_LAST`, `APR_HOOK_REALLY_LAST`
  - Hook return values: `OK`, `DECLINED`, `DONE`, `HTTP_*`
  - How modules register for hooks
- 3.2 🔗 Full Request Processing Phases
  - `post_read_request` — first hook, raw request available
  - `translate_name` — URI to filename translation
  - `map_to_storage` — map to filesystem or other storage
  - `check_user_id` (authentication) — identify the user
  - `auth_checker` (authorization) — authorize the user
  - `access_checker` — additional access control
  - `type_checker` — determine content type and handler
  - `fixups` — last chance to modify before response
  - `handler` — generate the response
  - `log_transaction` — logging
  - `insert_filter` — insert output filters
  - `quick_handler` — bypass normal processing (cache hit)
  - Input and output filter chains
- 3.3 🔌 Filter Architecture
  - Input filters vs. output filters
  - `ap_add_input_filter()` / `ap_add_output_filter()`
  - Filter types: `AP_FTYPE_RESOURCE`, `AP_FTYPE_CONTENT_SET`, `AP_FTYPE_PROTOCOL`, `AP_FTYPE_TRANSCODE`, `AP_FTYPE_CONNECTION`, `AP_FTYPE_NETWORK`
  - Filter ordering by type
  - Passing bucket brigades between filters
  - `ap_pass_brigade()` — sending data downstream
  - `ap_get_brigade()` — reading data from upstream
  - Example filter chain for a PHP response:
    - PHP handler → `mod_deflate` filter → `mod_ssl` filter → network
- 3.4 🧠 `request_rec` Structure
  - Key fields of the request record
    - `method`, `uri`, `filename`, `path_info`
    - `headers_in`, `headers_out`, `err_headers_out`
    - `status`, `content_type`, `handler`
    - `connection`, `server`, `pool`
    - `user`, `ap_auth_type`
    - `args` — query string
    - `notes` — key-value annotations between modules
    - `subprocess_env` — environment variables
    - `per_dir_config`, `request_config`
  - Sub-requests (`ap_sub_req_lookup_uri()`)
  - Internal redirects (`ap_internal_redirect()`)
- 3.5 🏠 `server_rec` and `conn_rec`
  - `server_rec` — virtual host configuration
  - `conn_rec` — connection-level state
  - Per-connection vs. per-request vs. per-server state

---

### 4. 🧩 Module Development
- 4.1 📐 Module Structure
  - `module` struct definition
  - `AP_MODULE_DECLARE_DATA` macro
  - Lifecycle hooks: `pre_config`, `post_config`, `child_init`, `child_exit`
  - `pre_config` — before config file parsing
  - `post_config` — after config file parsed, before children forked
  - `child_init` — in each child process after fork
  - Module flags: `MPM_FLAG_ALWAYS_RUNS_UNPRIVILEGED`, etc.
- 4.2 🔧 Directive Handling
  - `command_rec` array
  - Directive types: `NO_ARGS`, `TAKE1`, `TAKE2`, `TAKE3`, `TAKE12`, `TAKE23`, `TAKE123`, `TAKE_ARGV`, `ITERATE`, `ITERATE2`, `FLAG`, `RAW_ARGS`
  - Directive scope: `RSRC_CONF`, `ACCESS_CONF`, `OR_ALL`, `OR_NONE`, `OR_LIMIT`, `OR_OPTIONS`, `OR_FILEINFO`, `OR_AUTHCFG`, `OR_INDEXES`
  - `cmd_parms` — directive parsing context
  - `ap_set_string_slot()`, `ap_set_int_slot()`, `ap_set_flag_slot()`
- 4.3 🗄️ Per-Directory Configuration
  - `create_dir_config` — allocate config struct for directory
  - `merge_dir_config` — merge parent into child directory config
  - `ap_get_module_config()` — retrieving config in handlers
  - `ap_set_module_config()` — storing config
  - Per-server config (`create_server_config`, `merge_server_config`)
- 4.4 🔨 Writing a Custom Module (Walkthrough)
  - Minimal module scaffold
  - Registering a content handler
  - Reading request headers
  - Writing response headers and body
  - Using APR pool for allocation
  - Adding a custom directive
  - `apxs` build and install
  - `LoadModule` in `httpd.conf`
  - Testing and debugging
- 4.5 🧪 Module Testing
  - `mod_authn_anon` — useful reference for auth module pattern
  - Unit testing with APR test harness
  - Integration testing with `ab` and `curl`
  - Debugging with `gdb` (attaching to child process)
  - Valgrind for memory error detection

---

## ⚙️ Part II: Configuration System Mastery

### 5. 🗣️ Configuration Language In Depth
- 5.1 🔤 Syntax Rules
  - Case insensitivity of directive names
  - Line continuation with backslash
  - Comments (`#`)
  - Quoting rules — when quotes are required
  - Argument parsing — whitespace-delimited
  - Escape sequences in double-quoted strings
  - Inline `<tags>` vs. block containers
  - Maximum line length and config file size
- 5.2 📐 Configuration Contexts
  - Server config context — outside all containers
  - Virtual host context — inside `<VirtualHost>`
  - Directory context — inside `<Directory>`, `<Location>`, `<Files>`
  - `.htaccess` context — per-directory override files
  - Context inheritance rules
  - `AllowOverride` — delegating config to `.htaccess`
  - `AllowOverrideList` — fine-grained directive-level delegation (2.4+)
- 5.3 🧮 Apache Expressions (2.4+)
  - Expression syntax (`%{VAR}`, `%{HTTP:Header}`, `%{ENV:var}`)
  - Comparison operators (`==`, `!=`, `<`, `>`, `=~`, `!~`)
  - Logical operators (`&&`, `||`, `!`)
  - String functions (`tolower()`, `toupper()`, `escape()`, `unescape()`, `base64()`, `unbase64()`, `md5()`, `sha1()`, `sha256()`)
  - Regular expression functions (`/regex/`)
  - List operators (`-in`, `-not-in`)
  - Request variable access in expressions
  - `<If>`, `<ElseIf>`, `<Else>` — conditional config blocks
  - Expression in `Require expr`
  - Expression in `Header` directive
  - Expression in `RewriteCond`
  - Expression engine vs. `mod_rewrite` conditions
  - `ap_expr` API for module developers
- 5.4 🔁 `Include` and `IncludeOptional`
  - Glob pattern support (`Include conf.d/*.conf`)
  - Processing order of included files
  - Recursive includes and prevention
  - `IncludeOptional` — silent skip if no match
  - Server-info includes vs. startup-time includes
- 5.5 🗺️ Variable Types
  - Server variables (`SERVER_NAME`, `SERVER_PORT`, `DOCUMENT_ROOT`, etc.)
  - Request variables (`REQUEST_URI`, `REQUEST_METHOD`, `QUERY_STRING`, etc.)
  - Environment variables (`SetEnv`, `PassEnv`, `UnsetEnv`)
  - SSL variables (`SSL_PROTOCOL`, `SSL_CIPHER`, `SSL_CLIENT_CERT`, etc.)
  - `%{varname}` in `mod_rewrite`
  - `%{HTTP:header}` — arbitrary request header
  - `%{ENV:varname}` — environment variable
  - `%{LA-U:varname}` — look-ahead with sub-request
  - `%{LA-F:varname}` — look-ahead with filename

---

### 6. 🏠 Container Directives Deep Dive
- 6.1 📂 `<Directory>` Container
  - Filesystem path matching (absolute paths)
  - Wildcard matching in directory paths (`*`, `?`)
  - Regex directories — `<DirectoryMatch>`
  - Directory inheritance — most specific wins
  - Symlink handling (`Options FollowSymLinks`, `Options SymLinksIfOwnerMatch`)
  - `<Directory "/">` — base configuration
  - Trailing slash significance
  - Interaction with `Alias` and `ScriptAlias`
- 6.2 📍 `<Location>` Container
  - URL-space matching (not filesystem)
  - Takes priority over `<Directory>` and `<Files>`
  - `<LocationMatch>` — regex URL matching
  - Use cases: protecting URLs not on filesystem, proxy handlers
  - `<Location "/server-status">` pattern
  - `<Location>` and `SetHandler`
- 6.3 📄 `<Files>` Container
  - Filename matching (just filename, no path)
  - `<FilesMatch>` — regex filename matching
  - Protecting configuration files:
    - `<Files ".htaccess">` with `Require all denied`
    - `<Files "*.log">` blocking
  - Interaction with `<Directory>` (merged together)
- 6.4 🔀 `<Proxy>` and `<ProxyMatch>` Containers
  - Per-URL proxy configuration
  - Access control for proxy URLs
  - `<Proxy "balancer://mycluster/*">`
  - Interaction with `mod_proxy` directives
- 6.5 🧭 Merge Order & Precedence
  - Full merge sequence:
    1. `<Directory "/">` and `.htaccess`
    2. `<Directory>` (longest match first)
    3. `<DirectoryMatch>` (in order of appearance)
    4. `<Files>` and `<FilesMatch>` (in order)
    5. `<Location>` and `<LocationMatch>` (in order)
  - `<VirtualHost>` and how it overlays
  - Regex vs. non-regex containers — non-regex first
  - Common merge order bugs and how to diagnose them
- 6.6 🌐 `<VirtualHost>` Deep Dive
  - Name-based virtual hosting internals
  - IP-based virtual hosting
  - `_default_` — catch-all virtual host
  - `NameVirtualHost` (Apache 2.2 legacy)
  - SNI and SSL virtual hosting
  - `ServerName` and `ServerAlias` matching algorithm
  - `UseCanonicalName` — impact on redirects and self-referential URLs
  - `UseCanonicalPhysicalPort`
  - Per-vhost log files
  - Per-vhost document root
  - Debugging vhost selection (`httpd -S`)

---

### 7. 🔧 Core Directives Encyclopedia
- 7.1 🌐 Server Identity Directives
  - `ServerName` — canonical server name and port
  - `ServerAlias` — additional hostnames
  - `ServerAdmin` — admin email (in error pages)
  - `ServerSignature` — server info in generated pages (On, Off, EMail)
  - `ServerTokens` — `Server` header verbosity (Full, Prod, Major, Minor, Min, OS)
  - `ServerRoot` — base for relative paths
  - `DocumentRoot` — default content root
- 7.2 📡 Binding & Listening Directives
  - `Listen` — address:port combinations
  - Multiple `Listen` directives
  - `Listen` with protocol hint (`Listen 443 https`)
  - `BindAddress` (legacy, replaced by `Listen`)
  - `DefaultRuntimeDir` — runtime file directory
  - `PidFile` — process ID file location
  - `Mutex` — mutex mechanism and file location
    - Mutex mechanisms: `default`, `posixsem`, `sysvsem`, `pthread`, `fcntl`, `flock`, `file`
- 7.3 ⏱️ Timeout Directives
  - `Timeout` — overall request timeout
  - `KeepAlive` — persistent connections on/off
  - `KeepAliveTimeout` — idle time on kept-alive connection
  - `MaxKeepAliveRequests` — requests per connection
  - `RequestReadTimeout` — granular read timeouts (2.4+)
    - `header` — time to receive headers
    - `body` — time to receive body
    - Min/max rate specification
  - `ProxyTimeout` — timeout for proxy requests
- 7.4 📁 Content Serving Directives
  - `DirectoryIndex` — default document list
  - `DirectorySlash` — trailing slash redirect
  - `Options` — per-directory feature flags
    - `Indexes` — directory listing
    - `FollowSymLinks` / `SymLinksIfOwnerMatch`
    - `ExecCGI` — CGI execution allowed
    - `MultiViews` — content negotiation
    - `IncludesNOEXEC` — SSI without exec
    - `Includes` — SSI with exec
    - `+`/`-` prefix — additive/subtractive Options
    - `All` and `None`
  - `DefaultType` (deprecated in 2.4)
  - `ForceType` — override MIME type
  - `SetHandler` — force a specific handler
  - `AddHandler`, `RemoveHandler`
  - `AddType`, `RemoveType`
  - `TypesConfig` — MIME types file
  - `AddEncoding`, `RemoveEncoding`
  - `AddLanguage`, `RemoveLanguage`
  - `AddCharset`, `RemoveCharset`
  - `AddDefaultCharset`
- 7.5 🔒 Access Control Directives (2.4 Authorization)
  - `Require all granted` / `Require all denied`
  - `Require ip CIDR`
  - `Require host hostname`
  - `Require user username`
  - `Require group groupname`
  - `Require valid-user`
  - `Require method GET POST`
  - `Require expr expression`
  - `Require env varname`
  - `Require local`
  - `<RequireAll>` — AND logic
  - `<RequireAny>` — OR logic
  - `<RequireNone>` — NOT logic
  - Nesting `<RequireAll>` and `<RequireAny>`
  - Migrating from Apache 2.2 `Order`/`Allow`/`Deny` to 2.4
- 7.6 🌐 MIME & Content Type Directives
  - `MIMEMagicFile` — content-type detection by magic bytes
  - `MultiviewsMatch` — which files qualify for MultiViews
  - `ContentDigest` — deprecated MD5 `Content-MD5` header
- 7.7 ⚡ Performance-Related Core Directives
  - `EnableSendfile` — OS-level `sendfile()` syscall
  - `EnableMMAP` — memory-mapped file reading
  - `FileETag` — ETag generation components (INode, MTime, Size, All, None)
  - `TraceEnable` — HTTP TRACE method (Off recommended)
  - `LimitRequestBody` — max request body size
  - `LimitRequestFields` — max number of request headers
  - `LimitRequestFieldSize` — max size of each request header
  - `LimitRequestLine` — max request line length
  - `LimitXMLRequestBody` — XML body limit for WebDAV
  - `GracefulShutdownTimeout` — wait for connections before force-stop
- 7.8 🔀 Redirect & Alias Directives (Core)
  - `Alias /url/ /path/` — filesystem mapping
  - `AliasMatch /regex/ /path/` — regex alias
  - `ScriptAlias /url/ /path/` — CGI alias (implies ExecCGI)
  - `ScriptAliasMatch`
  - `Redirect [status] /from /to` — HTTP redirect
  - `RedirectMatch [status] /regex/ /to`
  - `RedirectTemp` / `RedirectPermanent`

---

## 🔌 Part III: Module Deep Dives

### 8. 🔁 `mod_rewrite` Mastery
- 8.1 📖 `mod_rewrite` Internals
  - How `mod_rewrite` hooks into the request pipeline
  - Per-server vs. per-directory rewrite context differences
  - Rewrite rule processing loop
  - `PT` (passthrough) flag and interaction with `Alias`
  - `mod_rewrite` logging (`LogLevel rewrite:trace*`)
- 8.2 📋 `RewriteRule` In Depth
  - Syntax: `RewriteRule Pattern Substitution [Flags]`
  - Pattern matching: PCRE regex
  - Substitution: `$1`–`$9` back-references
  - Substitution: `%1`–`%9` from last `RewriteCond`
  - Special substitution values: `-` (no change), `!` (forbidden)
  - Server variables in substitution: `%{VAR}`
- 8.3 📋 `RewriteCond` In Depth
  - Syntax: `RewriteCond TestString CondPattern [Flags]`
  - TestString: server variables, back-references
  - CondPattern: regex, string comparison, special patterns
    - `-f` (is regular file), `-d` (is directory), `-l` (is symlink)
    - `-s` (is non-empty file), `-x` (is executable)
    - `<`, `>`, `=` string comparison
    - Integer comparison
  - `[NC]` — no case
  - `[OR]` — OR with next condition (default is AND)
  - Chaining multiple `RewriteCond` before one `RewriteRule`
- 8.4 🏳️ `RewriteRule` Flags Complete Reference
  - `[L]` — last rule, stop processing
  - `[R]` / `[R=301]` — redirect (external)
  - `[P]` — proxy (pass to `mod_proxy`)
  - `[PT]` — pass-through (continue with `Alias`/`Location`)
  - `[F]` — forbidden (403)
  - `[G]` — gone (410)
  - `[NC]` — no case (case-insensitive match)
  - `[NE]` — no escape (don't encode special chars)
  - `[NS]` — no subrequest (skip for internal subrequests)
  - `[S=N]` — skip next N rules
  - `[T=MIME-type]` — set content type
  - `[E=var:val]` — set environment variable
  - `[CO=...]` — set cookie
  - `[END]` — stop ALL rewrite processing (2.4+)
  - `[B]` — escape back-references before applying
  - `[DPI]` — discard path info
  - `[QSA]` — query string append
  - `[QSD]` — query string discard (2.4.0+)
  - `[BNP]` / `[BNPNP]` — back-reference no plus
  - `[UnsafeAllow3F]` — allow literal `?` in substitution
- 8.5 🗺️ `RewriteMap` Complete Reference
  - `txt` — plain text key-value map
  - `rnd` — randomized selection from values
  - `dbm` — DBM hash file (faster lookups)
    - `dbmType`: `default`, `SDBM`, `GDBM`, `NDBM`, `db`
    - `httxt2dbm` — converting text map to DBM
  - `int` — internal Apache functions
    - `toupper`, `tolower`, `escape`, `unescape`
  - `prg` — external rewrite program (long-running process via stdin/stdout)
    - Protocol: one line in → one line out
    - Locking and performance considerations
  - `dbd` — database-backed map (SQL query via `mod_dbd`)
    - `dbd` map type and SQL query
    - Connection pooling via `mod_dbd`
  - `fastdbd` — cached DBD map
  - Using maps in `RewriteRule` and `RewriteCond`
- 8.6 🧩 `mod_rewrite` Common Patterns
  - Canonical hostname enforcement
  - HTTP → HTTPS redirect (multiple methods)
  - www → non-www (and reverse)
  - Removing `index.php` from URLs
  - Pretty URLs for WordPress / CMS
  - File-based blocking (hotlink protection)
  - Maintenance mode redirect
  - Geolocation-based redirect
  - Mobile redirect by User-Agent
  - API versioning via URL rewrite
  - Language prefix routing
  - A/B testing with `RewriteMap rnd`
  - Rewrite logging for debugging (`LogLevel rewrite:trace6`)
- 8.7 ⚠️ `mod_rewrite` Pitfalls
  - Rules in `<Directory>` vs. `<VirtualHost>` context differences
  - Rewrite loop prevention (`[L]` and `[END]`)
  - `.htaccess` rewrite and `RewriteBase`
  - Interaction with `mod_alias` — `PT` flag necessity
  - Percent-encoding in patterns and substitutions
  - Query string handling — `QSA` vs. explicit `?`

---

### 9. 🔐 `mod_ssl` Deep Dive
- 9.1 🔑 `mod_ssl` Architecture
  - OpenSSL integration
  - BoringSSL and LibreSSL compatibility
  - SSL session cache backends: `none`, `nonenotnull`, `dbm`, `shmcb`, `dc`, `memcache`, `redis`
  - Session ticket key management
  - Per-connection SSL state (`SSLConnRec`)
  - SSL hooks for custom extensions
- 9.2 📜 Certificate Configuration
  - `SSLCertificateFile` — server certificate (PEM)
  - `SSLCertificateKeyFile` — private key
  - `SSLCertificateChainFile` (deprecated 2.4.8+; embed in cert file)
  - `SSLCACertificateFile` — CA bundle for client auth
  - `SSLCACertificatePath` — directory of CA certs (hashed)
  - `SSLCARevocationFile` / `SSLCARevocationPath` — CRL
  - `SSLCARevocationCheck` — chain, leaf, or off
  - `SSLCertificateFile` with ECC (ECDSA) cert — dual cert setup
  - Combining RSA + ECDSA certificates in same vhost
- 9.3 ⚙️ Protocol & Cipher Configuration
  - `SSLProtocol` — enabled protocol versions
    - `all`, `+TLSv1.3`, `-SSLv3`, `-TLSv1`, `-TLSv1.1`
  - `SSLCipherSuite` — TLS 1.0–1.2 cipher string (OpenSSL format)
  - `SSLCipherSuite TLSv1.3` — TLS 1.3 cipher groups
  - `SSLHonorCipherOrder` — server vs. client preference
  - `SSLCompression` — disable TLS compression (CRIME)
  - `SSLSessionTickets` — session ticket on/off
  - `SSLOpenSSLConfCmd` — passing raw OpenSSL config
    - `DHParameters` — DH param file
    - `ECDHParameters` — curve selection
    - `SignatureAlgorithms`
    - `Curves`
  - Mozilla SSL Configuration Generator output for Apache
- 9.4 🔒 Client Certificate Authentication
  - `SSLVerifyClient` — none, optional, require, optional_no_ca
  - `SSLVerifyDepth` — chain depth
  - `SSLUserName` — derive `REMOTE_USER` from cert field
    - `SSL_CLIENT_S_DN_CN`, `SSL_CLIENT_S_DN_Email`
  - `SSLOptions` flags
    - `StdEnvVars` — populate SSL env variables (performance cost)
    - `ExportCertData` — export cert to env
    - `FakeBasicAuth` — convert cert DN to Basic Auth header
    - `StrictRequire` — strict SSL requirement enforcement
    - `OptRenegotiate` — per-directory renegotiation (disabled TLS 1.3)
  - Per-directory client cert requirement (`SSLVerifyClient require`)
  - TLS 1.3 and renegotiation — post-handshake authentication
- 9.5 📊 OCSP Stapling
  - `SSLUseStapling` — enable OCSP stapling
  - `SSLStaplingCache` — staple cache (requires `shmcb`)
  - `SSLStaplingResponseTimeSkew`
  - `SSLStaplingResponseMaxAge`
  - `SSLStaplingStandardCacheTimeout`
  - `SSLStaplingErrorCacheTimeout`
  - `SSLStaplingReturnResponderErrors`
  - `SSLStaplingFakeTryLater`
  - Debugging OCSP stapling with `openssl s_client -status`
- 9.6 🌐 SNI Configuration
  - Multiple SSL virtual hosts on same IP/port
  - `ServerName` matching for SNI
  - Fallback (default) SSL virtual host
  - `SSLStrictSNIVHostCheck` — reject clients without SNI
  - SNI and `SSLSessionCache` interaction
- 9.7 🔧 SSL Variables Reference
  - `SSL_PROTOCOL`, `SSL_CIPHER`, `SSL_CIPHER_ALGKEYSIZE`
  - `SSL_SESSION_ID`, `SSL_SESSION_RESUMED`
  - `SSL_SERVER_S_DN`, `SSL_SERVER_I_DN`
  - `SSL_CLIENT_S_DN`, `SSL_CLIENT_I_DN`, `SSL_CLIENT_VERIFY`
  - `SSL_CLIENT_CERT`, `SSL_CLIENT_CERT_CHAIN_N`
  - `SSL_CLIENT_FINGERPRINT` (SHA1, SHA256)
  - `SSL_SERVER_CERT`
  - `HTTPS` — "on" if HTTPS connection
  - Using SSL variables in `RewriteCond`, `Header`, `CustomLog`
- 9.8 🚀 TLS Performance Tuning
  - `SSLSessionCacheTimeout` — session cache TTL
  - `SSLSessionCache shmcb:/path/ssl_scache(512000)` sizing
  - Hardware acceleration (Intel QAT, AES-NI detection)
  - `SSLRandomSeed` — entropy sources for key generation
  - TLS 1.3 0-RTT considerations and risks
  - Certificate stapling cache sizing

---

### 10. 🔀 `mod_proxy` Ecosystem
- 10.1 📖 `mod_proxy` Architecture
  - Proxy scheme handler mapping
  - Worker concept — upstream connection pool
  - Shared memory for worker state (`mod_slotmem_shm`)
  - `forward proxy` vs. `reverse proxy` mode
  - `ProxyRequests` — enabling/disabling forward proxy
  - Open proxy dangers
- 10.2 🔌 Proxy Sub-modules
  - `mod_proxy_http` — HTTP/1.1 proxying
  - `mod_proxy_http2` — HTTP/2 proxying to upstream
  - `mod_proxy_fcgi` — FastCGI protocol
  - `mod_proxy_scgi` — SCGI protocol
  - `mod_proxy_uwsgi` — uWSGI protocol
  - `mod_proxy_ajp` — AJP/1.3 protocol (Tomcat)
  - `mod_proxy_wstunnel` — WebSocket tunneling
  - `mod_proxy_ftp` — FTP proxy
  - `mod_proxy_connect` — CONNECT method (SSL tunneling)
  - `mod_proxy_balancer` — load balancing
  - `mod_proxy_express` — mass reverse proxy from DBM map
  - `mod_proxy_hcheck` — health checking
- 10.3 ⚙️ Proxy Worker Configuration
  - `ProxyPass` — basic reverse proxy rule
  - `ProxyPassMatch` — regex-based proxy rule
  - `ProxyPassReverse` — rewriting Location headers
  - `ProxyPassReverseCookieDomain` — rewriting cookie domains
  - `ProxyPassReverseCookiePath` — rewriting cookie paths
  - Inline worker parameters:
    - `connectiontimeout` — connect timeout
    - `timeout` — request timeout
    - `retry` — seconds before retrying failed worker
    - `loadfactor` — relative weight
    - `route` — sticky session route identifier
    - `ping` — keepalive ping interval
    - `keepalive` — TCP keepalive
    - `max` — max simultaneous connections
    - `smax` — soft max (idle connections to keep)
    - `ttl` — idle connection TTL
    - `acquire` — timeout to acquire connection from pool
    - `flushpackets` — flush output to client
    - `flushwait` — wait time between flushes
    - `disablereuse` — disable connection reuse
    - `enablereuse`
    - `upgrade` — protocol upgrade (WebSocket)
    - `secret` — AJP secret
- 10.4 ⚖️ `mod_proxy_balancer` Deep Dive
  - `<Proxy "balancer://name">` definition
  - `BalancerMember` directive
  - Load balancing scheduler algorithms:
    - `byrequests` — weighted request count (default)
    - `bytraffic` — weighted byte traffic
    - `bybusyness` — weighted pending request count
    - `heartbeat` — based on `mod_heartbeat` data
  - `ProxySet` — setting balancer/worker parameters
  - Balancer Manager (`mod_status` + `mod_proxy_balancer`)
    - `/balancer-manager` endpoint
    - Runtime drain/enable/disable of members
    - Hot configuration changes
  - `lbmethod` parameter
  - `maxattempts` — failover attempt limit
  - `nonce` — CSRF protection for balancer manager
  - `stickysession` — sticky session cookie/path parameter
  - `scolonpathdelim` — semicolon path delimiter for sticky sessions
  - `failonstatus` — treat response codes as failure
  - `failontimeout` — treat timeout as failure
- 10.5 🏥 `mod_proxy_hcheck` (Health Checks)
  - `ProxyHCExpr` — defining health check expressions
  - `ProxyHCTemplate` — reusable health check configs
  - `hcmethod` — health check method (HEAD, GET, OPTIONS, CPING, PROVIDER, TCP)
  - `hcuri` — health check URI
  - `hcinterval` — check interval
  - `hcpasses` — consecutive passes to mark healthy
  - `hcfails` — consecutive fails to mark unhealthy
  - `hctemplate` — apply template to `BalancerMember`
  - `hcexpr` — custom expression for response evaluation
  - Integrating health checks with balancer manager
- 10.6 🔧 Advanced Proxy Patterns
  - Proxying to Unix domain sockets (`unix:/path/to/sock|http://localhost/`)
  - Proxying HTTP/2 to upstream (`H2` worker type)
  - Stripping path prefix before proxying
  - Adding request headers before proxying
  - `ProxyAddHeaders` — adding forwarding headers
  - `ProxyVia` — `Via` header control
  - `ProxyPreserveHost` — preserve `Host` header
  - `ProxyErrorOverride` — use Apache error pages for proxy errors
  - `ProxyTimeout`
  - `ProxyIOBufferSize`
  - `ProxyMaxForwards` — `Max-Forwards` header limit
  - `SSLProxyEngine` — TLS to upstream
  - `SSLProxyVerify` — verify upstream certificate
  - `SSLProxyCACertificateFile` — CA for upstream cert
  - `SSLProxyCheckPeerCN`, `SSLProxyCheckPeerName`
  - `SSLProxyCipherSuite`, `SSLProxyProtocol`

---

### 11. 🗃️ Caching Modules
- 11.1 📖 Apache Caching Architecture
  - Cache provider model
  - `mod_cache` — shared caching framework
  - Cache storage providers: `mod_cache_disk`, `mod_cache_socache`
  - Quick handler hook — cache hits bypass normal processing
  - Cache validation (conditional GETs to upstream)
- 11.2 💾 `mod_cache_disk`
  - `CacheRoot` — cache directory
  - `CacheEnable disk /` — enable for URL space
  - `CacheDisable /nocache/`
  - `CacheDirLevels` / `CacheDirLength` — directory structure
  - `CacheMaxFileSize` / `CacheMinFileSize`
  - `CacheReadSize` / `CacheReadTime` — streaming thresholds
  - `htcacheclean` utility
    - `-p` path, `-l` limit, `-i` interval, `-n` nice
    - Manual vs. daemon mode
    - Dry-run mode
- 11.3 💾 `mod_cache_socache`
  - Shared object cache providers: `shmcb`, `memcache`, `redis`
  - `CacheSocache memcache:host1:11211,host2:11211`
  - Size limits for socache
  - Use cases vs. disk cache
- 11.4 ⚙️ `mod_cache` Directives
  - `CacheEnable` / `CacheDisable`
  - `CacheHeader` — `X-Cache` header
  - `CacheDetailHeader` — `X-Cache-Detail`
  - `CacheIgnoreCacheControl` — serve from cache ignoring directives
  - `CacheIgnoreHeaders` — headers to exclude from caching decision
  - `CacheIgnoreNoLastMod` — cache even without `Last-Modified`
  - `CacheIgnoreQueryString` — ignore query string in cache key
  - `CacheIgnoreURLSessionIdentifiers` — strip session IDs from cache key
  - `CacheLock` — thundering herd protection
  - `CacheLockPath` / `CacheLockMaxAge`
  - `CacheMaxExpire` — max cache age
  - `CacheMinExpire` — min cache age
  - `CacheDefaultExpire` — default if no expiry headers
  - `CacheLastModifiedFactor` — heuristic expiry calculation
  - `CacheStoreExpired` — serve stale while revalidating
  - `CacheStoreNoStore` — cache even `no-store` responses (dangerous)
  - `CacheStorePrivate` — cache even `private` responses
  - `CacheKeyBaseURL` — normalize cache key URL
- 11.5 🧠 `mod_file_cache`
  - `CacheFile` — preload files into memory at startup
  - `MMapFile` — mmap files at startup
  - Best for small, frequently-accessed, rarely-changing files
  - Limitation: files loaded at startup, not dynamically

---

### 12. 📊 `mod_status` & `mod_info`
- 12.1 📈 `mod_status` Deep Dive
  - `/server-status` endpoint
  - `ExtendedStatus On` — per-request detailed stats
  - Status page sections:
    - Server version, MPM, uptime
    - Total accesses and traffic
    - CPU usage
    - Requests/sec, bytes/sec, bytes/request
    - Scoreboard — per-slot request state
  - Scoreboard character meanings:
    - `_` — waiting for connection
    - `S` — starting up
    - `R` — reading request
    - `W` — sending reply
    - `K` — keepalive
    - `D` — DNS lookup
    - `C` — closing connection
    - `L` — logging
    - `G` — gracefully finishing
    - `I` — idle cleanup
    - `.` — open slot with no current process
  - Machine-readable status (`?auto`)
  - Monitoring with Prometheus (`apache_exporter`)
  - `mod_status` security — restrict by IP
- 12.2 📋 `mod_info`
  - `/server-info` endpoint
  - Loaded modules list
  - Configuration per-module
  - Hook registration display
  - Security — never expose in production without auth

---

### 13. 📝 Logging Modules
- 13.1 📋 `mod_log_config` Deep Dive
  - `LogFormat` — named format strings
  - `CustomLog` — output file with format
  - `TransferLog` — log using last defined `LogFormat`
  - `BufferedLogs` — buffered write for performance
  - Format string specifier complete reference:
    - `%a` — client IP (`%{c}a` — underlying connection IP)
    - `%A` — local IP
    - `%b` / `%B` — bytes sent (CLF format / plain)
    - `%{VARNAME}C` — cookie value
    - `%D` — request time in microseconds
    - `%{VARNAME}e` — environment variable
    - `%f` — filename served
    - `%h` — remote hostname (or IP if `HostnameLookups Off`)
    - `%H` — request protocol
    - `%{HEADER}i` — request header
    - `%I` — bytes received (requires `mod_logio`)
    - `%k` — keepalive requests count
    - `%l` — remote logname (identd)
    - `%L` — request log ID (2.4.26+)
    - `%m` — request method
    - `%{VARNAME}n` — note from another module
    - `%{HEADER}o` — response header
    - `%O` — bytes sent including headers (requires `mod_logio`)
    - `%p` — server port
    - `%{format}p` — port with format (canonical, local, remote)
    - `%P` — PID of child
    - `%{tid}P` — thread ID
    - `%q` — query string
    - `%r` — first line of request
    - `%R` — handler generating response
    - `%s` — status code (last internal redirect)
    - `%>s` — final status code
    - `%t` — time in CLF format
    - `%{format}t` — time in `strftime` format
    - `%T` — time to serve request (seconds)
    - `%{ms}T` — time in milliseconds
    - `%{us}T` — time in microseconds
    - `%u` — remote user (from auth)
    - `%U` — URL path (without query string)
    - `%v` — canonical server name
    - `%V` — server name per `UseCanonicalName`
    - `%X` — connection status after response (`X`, `+`, `-`)
    - `%{format}^ti` — request trailer header
    - `%{format}^to` — response trailer header
  - Conditional logging (`%!200,304,302s`)
  - Per-vhost log files
  - Piped logging (`CustomLog "|/usr/bin/tee /var/log/access.log"`)
- 13.2 🔄 `mod_logio`
  - Actual bytes in/out at I/O level
  - `%I` — bytes received, `%O` — bytes sent, `%S` — combined
  - Difference from `%b` (application-level bytes)
- 13.3 🔍 `mod_log_forensic`
  - Before-and-after request logging
  - Forensic ID (`%{forensic-id}n`) in access log
  - Correlating access log with forensic log
  - Use case: debugging partial requests / crashes
- 13.4 📊 `mod_dumpio`
  - Logging all I/O to error log
  - `DumpIOInput On` / `DumpIOOutput On`
  - `LogLevel dumpio:trace7` requirement
  - Use: debugging protocol issues, header problems
  - Performance impact — dev/debug only

---

### 14. 🔑 Authentication & Authorization Modules
- 14.1 🔐 Auth Framework Architecture
  - `mod_auth_basic` — framework for Basic auth
  - `mod_auth_digest` — framework for Digest auth
  - Authentication providers (`authn_*`)
  - Authorization providers (`authz_*`)
  - `AuthBasicProvider` — listing providers in order
  - Provider fallthrough behavior
- 14.2 👤 Authentication Provider Modules
  - `mod_authn_file` — `htpasswd` file authentication
    - `AuthUserFile /path/.htpasswd`
    - `htpasswd` utility complete reference
      - `-c` create, `-n` no file, `-m` MD5, `-B` bcrypt, `-C` cost, `-s` SHA1, `-p` plaintext
      - `htpasswd -Bc 10 /path/.htpasswd user`
  - `mod_authn_dbm` — DBM file authentication
    - `AuthDBMUserFile`
    - `AuthDBMType` — SDBM, GDBM, NDBM, default
    - `dbmmanage` utility
    - `htdbm` utility
  - `mod_authn_dbd` — SQL database authentication
    - `AuthDBDUserPWQuery` — SQL for password lookup
    - `AuthDBDUserRealmQuery` — SQL for Digest realm
    - Integration with `mod_dbd` connection pool
  - `mod_authn_socache` — caching authentication results
    - `AuthnCacheProvider`
    - `AuthnCacheTimeout`
    - `AuthnCacheSOCache` — socache type
    - Reducing backend auth load
  - `mod_authn_anon` — anonymous access with logging
    - `Anonymous` — list of accepted usernames
    - `Anonymous_MustGiveEmail`
    - `Anonymous_LogEmail`
    - `Anonymous_NoUserID`
    - `Anonymous_VerifyEmail`
  - `mod_authnz_ldap` — LDAP authentication and authorization
    - `AuthLDAPURL` — LDAP URL format
    - `AuthLDAPBindDN` / `AuthLDAPBindPassword`
    - `AuthLDAPBindAuthoritative`
    - `AuthLDAPGroupAttribute` — membership attribute
    - `AuthLDAPGroupAttributeIsDN`
    - `AuthLDAPRemoteUserAttribute`
    - `AuthLDAPMaxSubGroupDepth`
    - `Require ldap-user`, `Require ldap-group`, `Require ldap-dn`
    - `Require ldap-attribute attr=val`
    - `Require ldap-filter (objectClass=...)`
    - `LDAPConnectionTimeout`, `LDAPOpCacheEntries`, `LDAPCacheEntries`
    - `LDAPTrustedGlobalCert`, `LDAPTrustedClientCert`
    - `LDAPVerifyServerCert`
    - StartTLS configuration
  - `mod_authnz_fcgi` — FastCGI authorization server
- 14.3 🔏 Authorization Provider Modules
  - `mod_authz_host` — `Require ip`, `Require host`, `Require local`
  - `mod_authz_user` — `Require user`, `Require valid-user`
  - `mod_authz_groupfile` — `AuthGroupFile` + `Require group`
    - `htpasswd` group file format
  - `mod_authz_dbm` — DBM group files
  - `mod_authz_dbd` — SQL-based authorization
  - `mod_authz_owner` — file owner authorization (`Require file-owner`, `Require file-group`)
- 14.4 🎫 Token-Based Auth (Third-Party)
  - `mod_auth_openidc` — OIDC / OAuth 2.0 (widely used)
    - `OIDCProviderMetadataURL`
    - `OIDCClientID`, `OIDCClientSecret`
    - `OIDCRedirectURI`
    - `OIDCCryptoPassphrase`
    - `OIDCScope`
    - `OIDCCookie` / `OIDCSessionType`
    - `Require claim sub:userid`
    - `Require valid-user` (any authenticated OIDC user)
  - `mod_auth_mellon` — SAML 2.0 SP

---

### 15. 🖥️ CGI & FastCGI Modules
- 15.1 📖 `mod_cgi` and `mod_cgid`
  - CGI specification (RFC 3875) recap
  - `mod_cgi` — for Prefork MPM
  - `mod_cgid` — for threaded MPMs (daemon process)
  - `ScriptLog` / `ScriptLogLength` / `ScriptLogBuffer` — CGI error logging
  - `CGIPassAuth` — pass Authorization header to CGI
  - `CGIVar` — override CGI variables
  - Environment variables passed to CGI scripts
  - `AddHandler cgi-script .cgi .pl`
- 15.2 🚀 `mod_proxy_fcgi` (PHP-FPM Integration)
  - Connecting to PHP-FPM via TCP socket
    - `ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/var/www/html/$1`
  - Connecting to PHP-FPM via Unix socket
    - `ProxyPassMatch ... unix:/run/php/php8.2-fpm.sock|fcgi://localhost/var/www/html`
  - `SetHandler "proxy:fcgi://..."` pattern
  - `SetHandler "proxy:unix:..."` pattern
  - `ProxyFCGISetEnvIf` — conditional env vars to FastCGI
  - `ProxyFCGIBackendType` — FPM vs. GENERIC
  - `FPM` vs. `GENERIC` backend differences
  - PHP-FPM pool configuration to match Apache workers
- 15.3 🔌 `mod_fcgid`
  - Alternative FastCGI module (manages processes itself)
  - `FcgidMaxRequestsPerProcess`
  - `FcgidMinProcessesPerClass`
  - `FcgidMaxProcesses`
  - `FcgidIdleTimeout`
  - `FcgidConnectTimeout`
  - `FcgidIOTimeout`
  - Comparison with `mod_proxy_fcgi`

---

### 16. 🌐 HTTP/2 with `mod_http2`
- 16.1 📖 `mod_http2` Overview
  - `nghttp2` library dependency
  - HTTP/2 over TLS (h2) and cleartext (h2c)
  - `Protocols h2 http/1.1` — enabling HTTP/2
  - `ProtocolsHonorOrder` — server vs. client preference
- 16.2 ⚙️ HTTP/2 Directives
  - `H2Direct` — h2c direct connection
  - `H2MaxSessionStreams` — max concurrent streams
  - `H2StreamMaxMemSize` — max memory per stream
  - `H2WindowSize` — flow control window
  - `H2ModernTLSOnly` — require modern TLS for h2
  - `H2Upgrade` — HTTP Upgrade to h2c
  - `H2SerializeHeaders` — debugging header serialization
  - `H2TLSWarmUpSize` — bytes before reducing TLS record size
  - `H2TLSCoolDownSecs`
  - `H2MinWorkers` / `H2MaxWorkers` — worker thread count
  - `H2MaxWorkerIdleSeconds`
  - `H2SessionExtraFiles`
  - `H2Push` — server push enable/disable
  - `H2PushPriority` — push resource priority
  - `H2PushDiarySize` — client push diary cache
  - `H2EarlyHints` — `103 Early Hints` support
  - `H2CopyFiles` — file serving behavior
- 16.3 🚀 HTTP/2 Server Push
  - `Link` response header — `</style.css>; rel=preload; as=style`
  - `H2Push` and `H2PushResource`
  - Push priority configuration
  - Push and caching interaction
  - Client push diary — avoiding duplicate pushes
  - When server push helps vs. hurts (HTTP/3 deprecation context)
- 16.4 ⚠️ HTTP/2 and MPM Compatibility
  - HTTP/2 requires Event or Worker MPM
  - `mod_http2` and Prefork incompatibility
  - `mod_php` + HTTP/2 — the conflict
  - Solution: PHP-FPM + Event MPM + HTTP/2

---

### 17. 🗜️ Compression & Encoding
- 17.1 🗜️ `mod_deflate` Deep Dive
  - `AddOutputFilterByType DEFLATE text/html text/css application/javascript`
  - `DeflateCompressionLevel` — 1–9
  - `DeflateWindowSize` — zlib window size
  - `DeflateMemLevel` — zlib memory usage
  - `DeflateFilterNote` — log compression ratio
    - `DeflateFilterNote Input instream`
    - `DeflateFilterNote Output outstream`
    - `DeflateFilterNote Ratio ratio`
  - `DeflateAlteringResponseHeaders` — ETag modification
  - `DeflateInflateLimitRequestBody` — decompression limit
  - `DeflateInflateRatioLimit` — bomb detection
  - `DeflateInflateRatioBurst`
  - `SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png)$ no-gzip dont-vary` — excluding already-compressed
  - `BrowserMatch ^Mozilla/4 gzip-only-text/html` — browser quirks
- 17.2 🌿 `mod_brotli`
  - Installation and `LoadModule brotli_module`
  - `AddOutputFilterByType BROTLI_COMPRESS text/html`
  - `BrotliCompressionQuality` — 0–11
  - `BrotliCompressionWindow` — sliding window bits
  - `BrotliCompressionMaxInputBlock`
  - `BrotliFilterNote` — logging ratio
  - Serving pre-compressed `.br` files (combining with `mod_rewrite`)
  - Brotli vs. gzip — when to serve which

---

### 18. 🔒 `mod_security` (WAF)
- 18.1 📖 ModSecurity Architecture
  - Embedded mode vs. standalone mode
  - ModSecurity v2 (Apache native) vs. v3 (libmodsecurity)
  - Processing phases (1–5):
    - Phase 1: Request headers
    - Phase 2: Request body
    - Phase 3: Response headers
    - Phase 4: Response body
    - Phase 5: Logging
  - SecRule Engine states: DetectionOnly, On, Off
- 18.2 ⚙️ Core Directives
  - `SecRuleEngine On|Off|DetectionOnly`
  - `SecRequestBodyAccess On|Off`
  - `SecResponseBodyAccess On|Off`
  - `SecResponseBodyMimeType text/plain text/html application/json`
  - `SecRequestBodyLimit` / `SecRequestBodyNoFilesLimit`
  - `SecRequestBodyInMemoryLimit`
  - `SecResponseBodyLimit`
  - `SecDebugLog` / `SecDebugLogLevel`
  - `SecAuditLog` / `SecAuditLogParts`
    - Audit log parts: A (header), B (request headers), C (request body), D, E (response body), F (response headers), G, H (audit header), I, J, K (matched rules), Z (trailer)
  - `SecAuditLogType` — Serial vs. Concurrent
  - `SecAuditLogStorageDir` — concurrent log directory
  - `SecDataDir` — persistent data storage
  - `SecTmpDir` — temporary files
  - `SecUploadDir` / `SecUploadKeepFiles`
  - `SecDefaultAction`
  - `SecAction` — unconditional action
  - `SecRule VARIABLES OPERATOR [ACTIONS]`
- 18.3 📋 SecRule Reference
  - Variables: `ARGS`, `ARGS_NAMES`, `REQUEST_HEADERS`, `REQUEST_URI`, `REQUEST_BODY`, `RESPONSE_HEADERS`, `RESPONSE_BODY`, `FILES`, `IP`, `SESSION`, `TX`, `GEO`, `REMOTE_ADDR`, `REQUEST_METHOD`, `REQUEST_COOKIES`
  - Operators: `@rx` (regex), `@pm` (phrase match), `@pmf` (phrase match file), `@streq`, `@contains`, `@beginsWith`, `@endsWith`, `@within`, `@lt`, `@le`, `@gt`, `@ge`, `@detectSQLi`, `@detectXSS`, `@inspectFile`, `@validateByteRange`, `@validateUrlEncoding`, `@validateUtf8Encoding`, `@rsub`, `@geoLookup`, `@ipMatch`, `@ipMatchF`
  - Actions: `pass`, `block`, `deny`, `drop`, `redirect`, `allow`, `log`, `nolog`, `auditlog`, `noauditlog`, `status`, `t:transformation`, `id`, `phase`, `chain`, `msg`, `tag`, `severity`, `capture`, `setvar`, `expirevar`, `initcol`, `setsid`, `setuid`, `ctl`, `skip`, `skipAfter`
  - Transformations: `lowercase`, `urlDecode`, `urlDecodeUni`, `htmlEntityDecode`, `base64Decode`, `base64Encode`, `removeWhitespace`, `compressWhitespace`, `removeNulls`, `removeComments`, `escapeSeqDecode`, `normalisePath`, `normalizePathWin`
- 18.4 🛡️ OWASP Core Rule Set (CRS) with Apache
  - CRS installation and include pattern
  - `crs-setup.conf` configuration
  - Paranoia Level (PL1–PL4)
  - Anomaly scoring mode configuration
  - `SecDefaultAction "phase:2,log,auditlog,pass"`
  - Tuning false positives
    - `SecRuleRemoveById ID`
    - `SecRuleRemoveByTag TAG`
    - `SecRuleUpdateTargetById`
    - `SecRuleUpdateActionById`
    - Per-location exclusions
  - Allowlisting with `ctl:ruleRemoveById`
  - CRS exclusion packages (WordPress, Drupal, NextCloud, etc.)

---

### 19. 📡 Other Notable Modules
- 19.1 🌐 `mod_headers`
  - `Header` — modify response headers
    - `add`, `set`, `append`, `merge`, `unset`, `echo`, `edit`, `edit*`, `note`
    - `always` keyword — apply even on error responses
    - Conditional headers with `expr=`
    - `Header always set Strict-Transport-Security "max-age=63072000"`
    - `Header always set Content-Security-Policy "default-src 'self'"`
    - `Header unset Server`
  - `RequestHeader` — modify request headers
    - `set`, `add`, `append`, `merge`, `unset`, `edit`
    - Adding `X-Forwarded-Proto https` behind load balancer
    - `RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"`
  - Timing: `early` vs. `late` — before vs. after most processing
  - `Header` and `mod_cache` interaction
- 19.2 🌍 `mod_negotiation`
  - Content negotiation algorithm
  - Type maps (`.var` files)
  - `MultiViews` option — automatic type map
  - `LanguagePriority` — preferred language order
  - `ForceLanguagePriority` — behavior on tie or no match
  - `CacheNegotiatedDocs`
- 19.3 ⏱️ `mod_expires`
  - `ExpiresActive On`
  - `ExpiresByType MIME/type "access plus 1 year"`
  - `ExpiresDefault "access plus 1 month"`
  - Epoch-based vs. access-based expiry
  - Interaction with `Cache-Control` headers
  - Combining with `mod_headers` for `Cache-Control: immutable`
- 19.4 🔌 `mod_env`
  - `SetEnv VAR value` — set environment variable
  - `PassEnv VAR` — pass from OS environment
  - `UnsetEnv VAR` — remove variable
  - Use in `CustomLog` and CGI/FCGI passthrough
- 19.5 🔀 `mod_substitute`
  - Response body find-and-replace (regex)
  - `Substitute s/pattern/replacement/flags`
  - `SubstituteMaxLineLength`
  - `SubstituteInheritBefore`
  - Use case: fixing absolute URLs in proxied responses
- 19.6 🧩 `mod_macro`
  - `<Macro NAME params>` — define reusable config blocks
  - `Use NAME value1 value2` — invoke macro
  - `UndefMacro NAME`
  - DRY configuration patterns
  - Macro for virtual host templates
- 19.7 📦 `mod_dbd`
  - Managed database connection pool
  - `DBDriver` — `sqlite3`, `mysql`, `pgsql`, `oracle`, `freetds`
  - `DBDParams` — connection string
  - `DBDMin`, `DBDKeep`, `DBDMax` — pool sizing
  - `DBDExptime` — connection TTL
  - `DBDInitSQL` — init queries on connection
  - Used by `mod_authn_dbd`, `mod_authz_dbd`, `mod_rewrite` DBD map, `mod_session_dbd`
- 19.8 🍪 `mod_session`
  - `Session On`
  - `SessionCookieName` / `SessionCookieName2`
  - `SessionCryptoCipher` / `SessionCryptoPassphrase`
  - Session stores: `mod_session_cookie` (client-side), `mod_session_dbd` (server-side DB)
  - `SessionHeader` — passing session to app via header
  - `SessionEnv` — expose session to CGI/FCGI
- 19.9 🔒 `mod_ratelimit`
  - `SetOutputFilter RATE_LIMIT`
  - `SetEnv rate-limit KBPS` — rate limit in KB/s
  - `SetEnv rate-initial-burst KBPS` — burst allowance
  - Per-directory and per-location rate limiting
  - Combining with `mod_setenvif` for conditional rate limiting
- 19.10 🚦 `mod_reqtimeout`
  - Request timeout module (complements `Timeout`)
  - `RequestReadTimeout header=20-40,MinRate=500`
  - `RequestReadTimeout body=20,MinRate=500`
  - Slowloris attack mitigation
  - Rate-based timeout calculation
- 19.11 📊 `mod_remoteip`
  - `RemoteIPHeader X-Forwarded-For`
  - `RemoteIPInternalProxy` / `RemoteIPInternalProxyList`
  - `RemoteIPTrustedProxy` / `RemoteIPTrustedProxyList`
  - `RemoteIPProxiesHeader` — header to store original chain
  - Replacing `%h` in logs with real client IP
  - `RemoteIPHeader X-Real-IP` for Nginx frontend
- 19.12 🔌 `mod_spnego` / `mod_auth_kerb`
  - Kerberos authentication (third-party)
  - Keytab file configuration
  - SPNEGO negotiation

---

## 🔒 Part IV: Security Deep Dive

### 20. 🛡️ Apache Security Hardening
- 20.1 🏗️ OS-Level Hardening
  - Running Apache as dedicated non-root user (`www-data`, `apache`, `httpd`)
  - `User` / `Group` directives
  - Privilege dropping after binding port 80/443
  - File system permissions for document root
  - Separate partition for logs
  - `chroot` jail (advanced — complex with DSOs)
  - SELinux / AppArmor profiles for Apache
    - Default SELinux contexts (`httpd_t`, `httpd_sys_content_t`)
    - `setsebool -P httpd_can_network_connect 1`
    - Custom SELinux policy for Apache
    - AppArmor profile for Apache
- 20.2 📋 Configuration Hardening
  - `ServerTokens Prod` — minimal server header
  - `ServerSignature Off` — no signature on error pages
  - `TraceEnable Off` — disable TRACE
  - `Options None` — disable all `Options` by default
  - `AllowOverride None` — disable `.htaccess` globally, enable selectively
  - `IndexOptions` — secure directory listing if enabled
  - Disabling unused modules (minimal module load)
  - `LimitRequestBody 10485760` — 10MB limit
  - `LimitRequestFields 100`
  - `LimitRequestFieldSize 8190`
  - `LimitRequestLine 8190`
  - Disabling `TRACE` via `RewriteRule`
  - `Header always unset X-Powered-By`
- 20.3 🔒 `.htaccess` Security
  - Disabling `.htaccess` globally: `AllowOverride None`
  - Enabling `.htaccess` selectively
  - Performance cost of `.htaccess` (filesystem traversal)
  - Protecting `.htaccess` itself
  - Blocking sensitive file access via `.htaccess`
  - `.htpasswd` file protection
- 20.4 🚫 Common Attack Mitigations
  - **Clickjacking**: `Header always set X-Frame-Options "SAMEORIGIN"`
  - **MIME sniffing**: `Header always set X-Content-Type-Options "nosniff"`
  - **XSS**: Content-Security-Policy configuration
  - **Slowloris**: `mod_reqtimeout` configuration
  - **DDoS**: `mod_evasive` configuration
    - `DOSHashTableSize`
    - `DOSPageCount` / `DOSPageInterval`
    - `DOSSiteCount` / `DOSSiteInterval`
    - `DOSBlockingPeriod`
    - `DOSEmailNotify`
    - `DOSLogDir`
    - `DOSWhitelist`
  - **Directory traversal**: `Options -Indexes`, request filtering
  - **SSRF via proxy**: `ProxyRequests Off`, `<Proxy>` restrictions
  - **HTTP Request Smuggling**: `HttpProtocolOptions Strict` (2.4.49+)
    - `HttpProtocolOptions Strict LenientMethods AllowNullRange`
  - **Shellshock (CVE-2014-6271)**: ModSecurity rules or update Bash
- 20.5 📜 `HttpProtocolOptions` (2.4.49+)
  - `Strict` — reject ambiguous requests
  - `Unsafe` — backward compatibility
  - `RegisteredMethods` — only registered HTTP methods
  - `LenientMethods` — lenient method parsing
  - `AllowNullRange` — allow `Range: bytes=0-`
  - `UnsafeWhitespace` — allow whitespace in headers (very unsafe)

---

## 📊 Part V: Performance Engineering

### 21. ⚡ Performance Tuning
- 21.1 🔧 OS-Level Tuning for Apache
  - `ulimit -n` — file descriptors (same as Nginx 📎 but Apache-specific values)
  - Shared memory limits for scoreboard
  - `ServerLimit` interplay with OS process limits
  - `ListenBacklog` — `listen()` backlog queue
  - TCP tuning for Apache keep-alive
  - NUMA topology and Apache worker binding
- 21.2 📁 I/O Optimization
  - `EnableSendfile On` — `sendfile()` for static files
  - `EnableMMAP On` — memory-mapped file reads
  - `SendBufferSize` / `ReceiveBufferSize` — socket buffer overrides
  - `AcceptFilter http data` (FreeBSD) / `AcceptFilter http httpready`
  - Accept filters on Linux (`TCP_DEFER_ACCEPT`)
  - `AcceptFilter https data` (TLS accept filter)
- 21.3 🗜️ Compression Performance
  - `DeflateCompressionLevel` sweet spot (6)
  - Static pre-compression with `mod_brotli` / `mod_deflate` + `mod_rewrite`
  - Excluding already-compressed files (images, videos, zip)
  - CPU overhead measurement of dynamic compression
- 21.4 🧵 MPM Tuning (Event MPM Focus)
  - Calculating `MaxRequestWorkers`:
    - Available memory ÷ memory per process = max children
    - Children × threads = `MaxRequestWorkers`
  - `AsyncRequestWorkerFactor` — async connection multiplier
    - Total async connections ≈ `MaxRequestWorkers × (1 + AsyncRequestWorkerFactor)`
  - `ThreadsPerChild` — balance between processes and threads
  - `MinSpareThreads` / `MaxSpareThreads` — dynamic scaling
  - `ServerLimit` — absolute process count ceiling
  - `ThreadLimit` — absolute thread count ceiling
  - Worker recycling with `MaxConnectionsPerChild`
- 21.5 🧮 Profiling Apache
  - `mod_status` extended status for real-time analysis
  - `ab` (ApacheBench) — built-in load tester
    - `ab -n 1000 -c 100 -k https://example.com/`
    - Interpreting ab output: RPS, latency percentiles, failed requests
  - `siege` — alternative load tester with user files
  - `perf` profiling on Linux (`perf top -p $(pgrep httpd)`)
  - `strace -p PID` — system call tracing
  - `lsof -p PID` — open file inspection
  - `/proc/PID/status` — memory and thread info

---

## 🩺 Part VI: Operations & Debugging

### 22. 🔄 Apache Lifecycle Management
- 22.1 🛠️ `apachectl` / `httpd` Commands
  - `apachectl start` / `stop` / `restart` / `graceful` / `graceful-stop`
  - `apachectl configtest` — validate configuration
  - `apachectl -S` — virtual host settings (essential debugging tool)
  - `apachectl -M` — loaded modules list
  - `apachectl -L` — directive list
  - `apachectl -t -D DUMP_VHOSTS` — dump vhost settings
  - `apachectl -t -D DUMP_MODULES` — dump modules
  - `apachectl -t -D DUMP_INCLUDES` — dump include files
  - `apachectl -t -D DUMP_RUN_CFG` — dump runtime configuration
  - `httpd -V` — compile-time settings
  - `httpd -v` — version only
  - `httpd -X` — single-process debug mode (no fork)
  - `httpd -e debug` — set startup error log level
- 22.2 📡 Signal Handling
  - `SIGTERM` — immediate stop
  - `SIGWINCH` — graceful stop (drain connections)
  - `SIGHUP` — graceful restart (reload config)
  - `SIGUSR1` — graceful restart (like `SIGHUP` but different semantics)
  - `SIGUSR2` — graceful restart with binary replacement
  - `SIGINT` — like SIGTERM
  - Log file reopen (for logrotate): `SIGUSR1` → graceful restart reopens logs
  - `kill -HUP $(cat /var/run/apache2/apache2.pid)` pattern
- 22.3 🔁 Graceful Restart Deep Dive
  - Master sends `SIGWINCH` to all children
  - Children finish current requests then exit
  - New children spawned with new config
  - Zero dropped connections during config reload
  - Graceful restart and `MaxConnectionsPerChild`
  - `GracefulShutdownTimeout` — force kill after timeout
- 22.4 📦 Log Rotation
  - `logrotate` configuration for Apache
  - `postrotate` — `SIGUSR1` or `apachectl graceful`
  - `copytruncate` — alternative (may lose logs)
  - Piped logging with `rotatelogs`
    - `CustomLog "|/usr/sbin/rotatelogs /var/log/apache2/access_%Y%m%d.log 86400"`
    - Time-based vs. size-based rotation
    - UTC vs. local time offset parameter
    - `rotatelogs` with link name for latest log
  - `cronolog` — alternative pipe logger

---

### 23. 🐛 Debugging & Diagnostics
- 23.1 🔍 Debug Logging
  - `LogLevel debug` — verbose logging
  - Per-module log levels (2.4+)
    - `LogLevel warn rewrite:trace6 ssl:info proxy:debug`
    - Module-specific trace levels: `trace1`–`trace8`
  - `LogLevel rewrite:trace6` — rewrite rule debugging
  - `LogLevel ssl:trace4` — TLS handshake debugging
  - `LogLevel proxy:trace2` — proxy debugging
  - `LogLevel authn_file:debug` — auth debugging
  - Error log format string (`ErrorLogFormat`)
    - Default: `[timestamp] [module:level] [pid tid] client message`
    - `%v` — vhost, `%P` — PID, `%T` — TID, `%E` — APR error code
    - `%{REQUEST_URI}r` — request URI in error context
    - `%L` — log ID (correlate with access log `%L`)
- 23.2 🌡️ Runtime Diagnostics
  - `apachectl -S` — most important diagnostic command
  - `mod_status?auto` — machine-readable metrics
  - `mod_info` — module and configuration dump
  - `mod_log_forensic` — before/after request logging
  - `mod_dumpio` — raw I/O logging
  - Process list inspection (`ps aux | grep httpd`)
  - `pmap PID` — memory map of worker
  - `/proc/PID/net/tcp` — connection states
- 23.3 🔬 Configuration Debugging
  - `apachectl -t` — config syntax check
  - `apachectl -S` — vhost debugging
  - `httpd -t -D DUMP_RUN_CFG` — full running config dump
  - `httpd -t -D DUMP_INCLUDES` — all included files
  - Tracing which `<Directory>` block applies to a request
  - `mod_rewrite` trace (`LogLevel rewrite:trace8`)
  - Testing rewrite rules with `RewriteLogLevel` equivalent
- 23.4 🔥 Common Problems Decoded
  - `403 Forbidden`
    - Check `Require all granted` (2.4 auth change)
    - `Options -Indexes` on directory without index
    - SELinux context (`httpd_sys_content_t`)
    - File permissions (apache user cannot read)
  - `404 Not Found`
    - `DocumentRoot` mismatch
    - `Alias` not configured
    - Rewrite rule wrong
  - `500 Internal Server Error`
    - CGI/FCGI script error
    - `.htaccess` syntax error
    - Module loading failure
    - PHP-FPM connection refused
  - `502 Bad Gateway`
    - Upstream (PHP-FPM, app server) not running
    - Upstream socket path wrong
    - Upstream crashed
  - `503 Service Unavailable`
    - `ProxyErrorOverride` masking upstream error
    - No backend workers available
    - `mod_security` blocking
  - `AH00558` — could not determine server's FQDN
  - `AH01630` — client denied by server configuration
  - `AH02811` — SSL handshake failed
  - `AH01144` — no protocol handler found
  - Rewrite loop (`AH00691`)
  - `Symbolic link not allowed or link target not accessible`
  - `Permission denied: access to /.htaccess denied`
  - `mod_fcgid: can't apply process slot` (fcgid process limit)

---

## ☁️ Part VII: Deployment & Integration

### 24. 🚀 Deployment Patterns
- 24.1 🐋 Apache in Docker
  - Official `httpd` image deep dive
  - Image tag selection (alpine vs. debian base)
  - `httpd-foreground` entrypoint
  - Overriding `httpd.conf` with bind mount
  - Using `COPY` for config in custom image
  - Environment variable substitution in config
    - `envsubst` with `httpd.conf`
    - `sed` substitution in entrypoint
  - Volume mounts: document root, certificates, logs
  - Non-root Apache in Docker
    - Changing to high port (8080)
    - `User www-data` vs. UID in Dockerfile
  - Multi-stage Dockerfile with custom modules
  - Health check configuration
- 24.2 ☸️ Apache in Kubernetes
  - Apache as Ingress controller (less common than Nginx)
  - Apache sidecar proxy pattern
  - `ConfigMap` for `httpd.conf`
  - `Secret` for TLS certificates
  - Liveness and readiness probe configuration
    - `/server-status` as health endpoint
  - Horizontal Pod Autoscaling considerations (stateless design)
  - Persistent Volume for document root vs. init container
- 24.3 🤖 Configuration Management
  - Ansible `apache2` / `httpd` role
    - `ansible-galaxy role install geerlingguy.apache`
    - Common role variables
    - Virtual host template tasks
  - Puppet `apache` module (puppetlabs-apache)
    - `apache::vhost` defined type
    - Module management with `apache::mod`
  - Chef `apache2` cookbook
  - Salt state for Apache
  - Comparison of approaches
- 24.4 🔄 CI/CD Integration
  - `apachectl configtest` in pre-deploy stage
  - Container image build pipeline
  - Blue-green deployment with Apache + `mod_proxy_balancer`
  - Canary deployments using `BalancerMember` weights
  - Configuration drift detection
  - Integration testing Apache config with `serverspec`

---

## 📋 Part VIII: Reference & Cheatsheets

### 25. 📚 Quick Reference
- 25.1 📊 MPM Directive Comparison Table

| Directive | Prefork | Worker | Event |
|---|---|---|---|
| `StartServers` | ✅ | ✅ | ✅ |
| `MinSpareServers` | ✅ | ❌ | ❌ |
| `MaxSpareServers` | ✅ | ❌ | ❌ |
| `MinSpareThreads` | ❌ | ✅ | ✅ |
| `MaxSpareThreads` | ❌ | ✅ | ✅ |
| `ThreadsPerChild` | ❌ | ✅ | ✅ |
| `ThreadLimit` | ❌ | ✅ | ✅ |
| `ServerLimit` | ✅ | ✅ | ✅ |
| `MaxRequestWorkers` | ✅ | ✅ | ✅ |
| `MaxConnectionsPerChild` | ✅ | ✅ | ✅ |
| `AsyncRequestWorkerFactor` | ❌ | ❌ | ✅ |

- 25.2 📋 `apachectl` / `httpd` Quick Reference

| Command | Purpose |
|---|---|
| `apachectl configtest` | Validate syntax |
| `apachectl -S` | Dump virtual host config |
| `apachectl -M` | List loaded modules |
| `apachectl -L` | List available directives |
| `apachectl graceful` | Graceful restart (no dropped connections) |
| `apachectl graceful-stop` | Drain and stop |
| `apachectl start/stop/restart` | Lifecycle management |
| `httpd -V` | Compile-time flags |
| `httpd -X` | Single-process debug mode |
| `httpd -e debug` | Debug startup |
| `httpd -t -D DUMP_INCLUDES` | Show all included files |
| `httpd -t -D DUMP_RUN_CFG` | Dump running config |

- 25.3 🔁 `mod_rewrite` Flags Quick Reference

| Flag | Meaning |
|---|---|
| `[L]` | Last — stop rule processing |
| `[END]` | End — stop ALL rewrite processing |
| `[R=301]` | Redirect (external) |
| `[P]` | Proxy via `mod_proxy` |
| `[PT]` | Pass-through to next handler |
| `[F]` | Forbidden (403) |
| `[G]` | Gone (410) |
| `[NC]` | No case — case-insensitive |
| `[NE]` | No escape — don't encode output |
| `[QSA]` | Query string append |
| `[QSD]` | Query string discard |
| `[NS]` | No subrequest — skip for internal |
| `[S=N]` | Skip next N rules |
| `[E=var:val]` | Set environment variable |
| `[T=mime]` | Set content type |
| `[B]` | Escape back-references |

- 25.4 🔒 Security Headers Template

```apache
# Security Headers Block
Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
Header always set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'"
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
Header always set Cross-Origin-Opener-Policy "same-origin"
Header always set Cross-Origin-Embedder-Policy "require-corp"
Header always set Cross-Origin-Resource-Policy "same-origin"
Header unset X-Powered-By
Header unset Server
```

- 25.5 🌐 Virtual Host Templates
  - HTTP-only virtual host
  - HTTPS virtual host with modern TLS
  - HTTP → HTTPS redirect virtual host
  - Reverse proxy virtual host
  - PHP-FPM virtual host
  - Name-based multi-site template with `mod_macro`

- 25.6 🆚 Apache vs. Nginx Configuration Equivalents

| Apache | Nginx Equivalent |
|---|---|
| `<VirtualHost *:80>` | `server { listen 80; }` |
| `ServerName example.com` | `server_name example.com;` |
| `DocumentRoot /var/www/html` | `root /var/www/html;` |
| `<Directory>` | `location` block |
| `<Location>` | `location` block (URL-based) |
| `AllowOverride` | (no equivalent — config only in nginx.conf) |
| `mod_rewrite RewriteRule` | `rewrite` directive / `location` |
| `ProxyPass` | `proxy_pass` |
| `mod_deflate` | `gzip on` |
| `mod_expires` | `expires` directive |
| `mod_headers Header set` | `add_header` |
| `mod_proxy_balancer` | `upstream {}` |
| `ErrorDocument 404 /404.html` | `error_page 404 /404.html;` |
| `Options -Indexes` | (no directory listing by default) |
| `AuthType Basic` | `auth_basic` |
| `Require ip 192.168.1.0/24` | `allow 192.168.1.0/24; deny all;` |
| `mod_status` | `stub_status` |
| `apachectl graceful` | `nginx -s reload` |
| `.htaccess` | (no equivalent — all in nginx.conf) |
| `LogFormat` | `log_format` |
| `CustomLog` | `access_log` |
| `ErrorLog` | `error_log` |

- 25.7 🏥 Performance Tuning Cheatsheet (Event MPM)

```apache
# Event MPM Tuning
<IfModule mpm_event_module>
    StartServers             2
    MinSpareThreads         25
    MaxSpareThreads         75
    ThreadLimit             64
    ThreadsPerChild         25
    MaxRequestWorkers      150
    MaxConnectionsPerChild   0
    AsyncRequestWorkerFactor 2
</IfModule>

# I/O Optimization
EnableSendfile On
EnableMMAP On
FileETag MTime Size

# Keep-Alive
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5

# Request Timeouts
RequestReadTimeout header=20-40,MinRate=500
RequestReadTimeout body=20,MinRate=500
```

- 25.8 📋 Module Loading Quick Reference

```apache
# Essential Modules
LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule http2_module modules/mod_http2.so
LoadModule ssl_module modules/mod_ssl.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule headers_module modules/mod_headers.so
LoadModule deflate_module modules/mod_deflate.so
LoadModule expires_module modules/mod_expires.so
LoadModule status_module modules/mod_status.so
LoadModule remoteip_module modules/mod_remoteip.so
LoadModule security2_module modules/mod_security2.so
```

- 25.9 🚀 Production Readiness Checklist
  - ✅ `ServerTokens Prod` + `ServerSignature Off`
  - ✅ `TraceEnable Off`
  - ✅ Minimal modules loaded
  - ✅ `AllowOverride None` globally, selective override
  - ✅ TLS 1.2/1.3 only, strong ciphers
  - ✅ OCSP stapling enabled
  - ✅ Security headers set
  - ✅ `LimitRequest*` directives set
  - ✅ `mod_reqtimeout` configured
  - ✅ `mod_evasive` or rate limiting configured
  - ✅ `mod_security` with OWASP CRS (at least DetectionOnly)
  - ✅ Access logging with correlation IDs
  - ✅ Log rotation configured
  - ✅ `mod_status` restricted by IP
  - ✅ SELinux/AppArmor profile active
  - ✅ Running as non-root user
  - ✅ `MaxRequestWorkers` sized for available RAM
  - ✅ `EnableSendfile On` for static content
  - ✅ Compression enabled for text content
  - ✅ Far-future expires for static assets
  - ✅ HTTP/2 enabled (`mod_http2`)
  - ✅ `apachectl configtest` passes cleanly
  - ✅ `apachectl -S` shows expected virtual hosts
  - ✅ FQDN set (`ServerName`) — no `AH00558` in log

---

> 💡 **Usage Tip:** Start with **Part II (Configuration Mastery)** — particularly the container directives and merge order — as misunderstanding these causes most Apache configuration bugs. **Part III (Module Deep Dives)** is the heart of this guide; focus on `mod_rewrite` (Section 8), `mod_ssl` (Section 9), and `mod_proxy` (Section 10) for production work. Use **Part IV (Security)** and the **Production Readiness Checklist** (Section 25.9) before any production deployment.
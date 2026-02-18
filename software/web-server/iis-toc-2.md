# 🪟 Microsoft IIS Deep Dive — Supplementary Table of Contents

> 🔗 **Companion to the main Web Servers Study Guide**
> This TOC expands exclusively on IIS topics not covered or only briefly mentioned in the main guide (Section 9). Cross-references to the main TOC are noted with 📎.
> Covers IIS 8.5, 10.0 (Windows Server 2016/2019/2022) and IIS 10.0 v1809+ unless explicitly noted.

---

## 🧠 Part I: IIS Internals & Architecture

### 1. 🔬 Architecture Deep Dive
- 1.1 🏗️ IIS Component Stack
  - Full stack diagram: NIC → TCP/IP → HTTP.sys → W3SVC → WAS → Application Pool → w3wp.exe
  - Kernel-mode vs. user-mode component split
  - Why IIS's architecture differs fundamentally from Nginx/Apache
  - Component responsibilities at each layer
  - Request flow from wire to application code
- 1.2 🖥️ `HTTP.sys` — Kernel-Mode HTTP Driver
  - What `HTTP.sys` does (TCP accept, HTTP parsing, TLS, response caching)
  - URL namespace reservation (`netsh http add urlacl`)
  - Kernel-mode response cache — what gets cached and why
  - `HTTP.sys` logging (separate from IIS logging)
  - `HTTP.sys` limits and configuration via registry
    - `MaxConnections`
    - `MaxRequestBytes`
    - `UriEnableCache`
    - `UriMaxUriBytes`
    - `UriScavengerPeriod`
    - `TeredoEnabled`
  - `HTTP.sys` error log (`C:\Windows\System32\LogFiles\HTTPERR\`)
  - `HTTP.sys` and TLS — kernel-mode TLS offload (HTTP.sys TLS)
  - `netsh http` command reference
    - `show urlacl`, `add urlacl`, `delete urlacl`
    - `show sslcert`, `add sslcert`, `delete sslcert`
    - `show servicestate`
    - `show counters`
    - `show iplisten`, `add iplisten`
    - `flush logbuffer`
- 1.3 🔧 W3SVC — World Wide Web Publishing Service
  - Role of W3SVC
  - Interaction with WAS
  - Service startup and dependency chain
  - W3SVC vs. WAS service responsibilities
  - Monitoring W3SVC via `sc.exe` and PowerShell
- 1.4 ⚙️ WAS — Windows Process Activation Service
  - WAS role — process lifecycle management
  - WAS configuration store (`applicationHost.config`)
  - Idle timeout and process recycling triggers
  - Non-HTTP activation (WCF, named pipes, TCP)
  - WAS listener adapters
  - WAS and `net.tcp`, `net.pipe`, `net.msmq` protocols
- 1.5 🏭 `w3wp.exe` — Worker Process
  - One worker process per application pool (default)
  - Web Garden — multiple worker processes per pool
  - Worker process identity and permissions
  - `w3wp.exe` command-line arguments
  - Worker process crash recovery
  - Rapid-fail protection
  - Orphaning worker processes for debugging
  - Attaching debugger to `w3wp.exe`
- 1.6 🔄 Request Processing Pipeline (Integrated Mode)
  - `HttpRequest` enters `HTTP.sys`
  - Routing to correct application pool via site binding
  - `w3wp.exe` receives request via named pipe
  - IIS integrated pipeline stages (20 stages)
    - `BeginRequest`
    - `AuthenticateRequest` / `PostAuthenticateRequest`
    - `AuthorizeRequest` / `PostAuthorizeRequest`
    - `ResolveRequestCache` / `PostResolveRequestCache`
    - `MapRequestHandler` / `PostMapRequestHandler`
    - `AcquireRequestState` / `PostAcquireRequestState`
    - `PreExecuteRequestHandler`
    - `ExecuteRequestHandler`
    - `ReleaseRequestState` / `PostReleaseRequestState`
    - `UpdateRequestCache` / `PostUpdateRequestCache`
    - `LogRequest` / `PostLogRequest`
    - `EndRequest`
    - `PreSendRequestHeaders`
    - `PreSendRequestContent`
  - How ASP.NET / ASP.NET Core hook into pipeline stages
  - Native modules vs. managed modules in the pipeline
- 1.7 🔀 Integrated Pipeline vs. Classic Pipeline
  - History: IIS 6 Classic mode
  - Classic pipeline — two separate pipelines (IIS + ASP.NET)
  - Integrated pipeline — unified single pipeline
  - When Classic mode is still needed (legacy ASP.NET apps)
  - Migrating from Classic to Integrated mode
  - `system.webServer` vs. `system.web` configuration sections

---

### 2. 🧩 Module System Architecture
- 2.1 📐 Module Types
  - **Native modules** — C++ DLLs, run in worker process
  - **Managed modules** — .NET assemblies, run in CLR
  - Module registration in `applicationHost.config`
  - `<globalModules>` vs. `<modules>` sections
  - Module preconditions (`precondition="managedHandler"`, `runtimeVersion`, `bitness`)
  - Module ordering and its effect on pipeline
- 2.2 🔌 Built-in Native Modules Reference
  - `UriCacheModule` — `HTTP.sys` URI cache integration
  - `HttpCacheModule` — kernel-mode and user-mode caching
  - `StaticFileModule` — static file serving
  - `DefaultDocumentModule` — default document resolution
  - `DirectoryListingModule` — directory browsing
  - `ProtocolSupportModule` — HTTP/1.1 `Keep-Alive`, `Expect: 100-Continue`
  - `HttpRedirectionModule` — HTTP redirects
  - `ServerSideIncludeModule` — SSI processing
  - `AnonymousAuthenticationModule`
  - `BasicAuthenticationModule`
  - `WindowsAuthenticationModule`
  - `DigestAuthenticationModule`
  - `CertificateMappingAuthenticationModule`
  - `IISCertificateMappingAuthenticationModule`
  - `UrlAuthorizationModule`
  - `RequestFilteringModule` — request filtering
  - `IpRestrictionModule` — IP-based access control
  - `DynamicIpRestrictionModule`
  - `CompressionModule` (static + dynamic)
  - `TracingModule` — Failed Request Tracing
  - `CustomErrorModule` — custom error pages
  - `HttpLoggingModule` — IIS logging
  - `RequestMonitorModule` — runtime state
  - `IsapiModule` — ISAPI extensions
  - `IsapiFilterModule` — ISAPI filters
  - `FastCgiModule` — FastCGI support (PHP)
  - `RewriteModule` — URL Rewrite
  - `ApplicationInitializationModule` — app warm-up
  - `WebSocketModule` — WebSocket support
  - `HttpForbiddenModule` — returning 403
  - `CgiModule` — CGI support
- 2.3 📦 Managed Modules (ASP.NET Integration)
  - `FormsAuthenticationModule`
  - `WindowsAuthenticationModule` (managed)
  - `RoleManagerModule`
  - `SessionStateModule`
  - `OutputCacheModule`
  - `AnonymousIdentificationModule`
  - Removing unused managed modules for performance
  - `runAllManagedModulesForAllRequests` — why it's dangerous
- 2.4 🔧 Writing a Custom Native Module
  - IIS `IHttpModule` C++ interface
  - Module factory pattern
  - Registering for pipeline events
  - Reading/modifying request and response
  - `IHttpContext`, `IHttpRequest`, `IHttpResponse` interfaces
  - Building and deploying native modules
- 2.5 🔧 Writing a Custom Managed Module
  - `IHttpModule` .NET interface
  - `HttpApplication` event subscription
  - `HttpContext` access
  - Registering in `web.config`

---

## ⚙️ Part II: Configuration System Mastery

### 3. 🗂️ Configuration Architecture
- 3.1 🏗️ Configuration File Hierarchy
  - `applicationHost.config` — server-level (master config)
  - `web.config` — site/application/directory level
  - `machine.config` — .NET machine-wide settings
  - `administration.config` — IIS management config
  - Configuration inheritance and override rules
  - `<location>` element — path-specific overrides
  - `allowOverride` and `lockAttributes` — preventing delegation
  - Configuration read order and merge behavior
- 3.2 📋 `applicationHost.config` Deep Dive
  - File location (`%windir%\System32\inetsrv\config\`)
  - `<configSections>` — section schema registration
  - `<system.applicationHost>` top-level section
    - `<applicationPools>` — all pool definitions
    - `<sites>` — all site definitions
    - `<webLimits>` — server-wide connection limits
    - `<customMetadata>` — legacy compatibility
  - `<system.webServer>` — server defaults
  - `<system.ftpServer>` — FTP configuration
  - Backup and restore (`%windir%\System32\inetsrv\config\backup\`)
  - `appcmd list config` — displaying effective config
  - Configuration history and rollback
- 3.3 🔒 Configuration Locking
  - `lockAttributes="*"` — lock all attributes
  - `lockElements` — lock child elements
  - `lockAllAttributesExcept`
  - `lockAllElementsExcept`
  - `lockItem` — lock a single item
  - `overrideMode="Deny"` — prevent `web.config` override
  - `overrideModeDefault` — section-level default
  - Common lock scenarios (preventing apps from changing auth)
- 3.4 📄 `web.config` Structure
  - `<configuration>` root element
  - `<configSections>` — registering custom sections
  - `<system.web>` — ASP.NET classic settings
  - `<system.webServer>` — IIS settings
  - `<connectionStrings>` — database connections
  - `<appSettings>` — key-value application settings
  - `<location>` — path-specific overrides within same file
  - `<runtime>` — CLR runtime settings
  - Transformations (`web.Release.config`, `web.Debug.config`)
    - `xdt:Transform` attribute values
    - `xdt:Locator` attribute values
    - Common transformation patterns
  - Environment-specific config with `environmentVariables`

---

### 4. 🏊 Application Pools Deep Dive
- 4.1 📖 Application Pool Concepts
  - Isolation between applications
  - One pool can serve multiple sites/apps
  - Pool state: Started, Stopped, Unknown
  - `DefaultAppPool` and built-in pools
- 4.2 ⚙️ Application Pool Settings Complete Reference
  - **General**
    - `.NET CLR Version` — v2.0, v4.0, No Managed Code
    - `Managed Pipeline Mode` — Integrated, Classic
    - `Enable 32-Bit Applications` — for legacy 32-bit code
    - `Queue Length` — max queued requests
    - `Start Mode` — OnDemand vs. AlwaysRunning
    - `Auto Start` — start on service start
  - **CPU**
    - `Limit` — CPU usage percentage limit
    - `Limit Action` — NoAction, KillW3wp, Throttle, ThrottleUnderLoad
    - `Limit Interval` — measurement window
    - `Processor Affinity Enabled` / `Mask` — NUMA/CPU pinning
  - **Process Model**
    - `Identity` — ApplicationPoolIdentity, LocalSystem, LocalService, NetworkService, Custom
    - `Idle Time-out` — minutes before shutting down idle worker
    - `Idle Time-out Action` — Terminate vs. Suspend (v8.5+)
    - `Load User Profile`
    - `Maximum Worker Processes` — Web Garden count
    - `Ping Enabled`, `Ping Period`, `Ping Response Time`
    - `Shutdown Time Limit`
    - `Startup Time Limit`
    - `User Name` / `Password` — for custom identity
    - `Log Event On Process Model Errors`
  - **Recycling**
    - `Disable Overlapped Recycle`
    - `Disable Recycling for Configuration Changes`
    - `Generate Recycle Event Log Entry` — logging recycle reasons
    - Regular Time Interval (minutes)
    - Specific Times (scheduled recycle)
    - Request Limit
    - Virtual Memory Limit
    - Private Memory Limit
    - `Logging` — what events to log
  - **Rapid-Fail Protection**
    - `Enabled`
    - `Failure Interval`
    - `Maximum Failures`
    - `Auto-Shutdown Exe` / `Auto-Shutdown Params`
    - `Load Balancer Capabilities` — HttpLevel, TcpLevel, NoFailure
  - **Process Orphaning**
    - `Enabled` — keep orphaned process alive for debugging
    - `Orphan Worker Process Exe`
    - `Orphan Action Params`
- 4.3 🔑 Application Pool Identity Security
  - `ApplicationPoolIdentity` — virtual account (recommended)
    - How virtual accounts work
    - Granting permissions to `IIS AppPool\<name>`
    - Network access limitations
  - `NetworkService` — network-capable built-in account
  - Custom service account
    - Group Managed Service Account (gMSA) — no password management
    - gMSA setup and assignment to app pool
  - Principle of least privilege for app pools
  - File system permissions for app pool identity
  - Registry permissions
  - Database access with app pool identity (Windows Auth)
- 4.4 🌐 Web Gardens
  - Multiple worker processes per pool
  - When to use Web Gardens
  - Session state incompatibility (in-proc session)
  - CPU affinity with Web Gardens
  - Processor Affinity Mask configuration

---

### 5. 🌐 Sites & Bindings
- 5.1 📋 Site Configuration
  - Site ID and name
  - `physicalPath` — root physical path
  - `applicationDefaults` — default settings for apps in site
  - `virtualDirectoryDefaults`
  - Site limits: `maxBandwidth`, `maxConnections`, `connectionTimeout`
  - Site state management
- 5.2 🔗 Bindings Deep Dive
  - Binding tuple: protocol + IP + port + hostname
  - `*` wildcard vs. specific IP binding
  - `0.0.0.0` vs. specific interface binding
  - Multiple bindings per site
  - HTTP bindings
  - HTTPS bindings — certificate association
    - `sslFlags` — SNI (`1`), Central Cert Store (`2`), SNI + CCS (`3`)
    - Binding a certificate via `netsh` vs. IIS Manager vs. PowerShell
  - `net.tcp`, `net.pipe` bindings for WCF
  - Host header matching and priority
  - Catch-all site (no host header)
  - Binding conflicts and resolution
- 5.3 🏗️ Applications & Virtual Directories
  - Application vs. virtual directory distinction
  - Application pool assignment per application
  - `preloadEnabled` — application initialization
  - Virtual directory `physicalPath` and UNC paths
  - UNC passthrough authentication
  - `connectAs` — credentials for UNC share access
  - Nested applications

---

### 6. 🔁 URL Rewrite Module Deep Dive
- 6.1 📖 URL Rewrite Overview
  - Installation (separate download)
  - `<rewrite>` section in `web.config`
  - Rules processing order
  - Rule inheritance from parent levels
- 6.2 📋 Inbound Rules
  - Rule anatomy: match + conditions + action
  - **Match section**
    - `matchType` — IsFile, IsDirectory, Pattern
    - `pattern` — regex or wildcards
    - `patternSyntax` — ECMAScript, ExactMatch, Wildcard
    - `ignoreCase`
    - `negate`
  - **Conditions section**
    - `logicalGrouping` — MatchAll vs. MatchAny
    - Condition input: server variables, headers, query string
    - Condition `matchType` — IsFile, IsDirectory, Pattern
    - `{REQUEST_FILENAME}`, `{REQUEST_URI}`, `{QUERY_STRING}` etc.
    - Back-references: `{C:1}`, `{C:2}` from conditions
    - Rule back-references: `{R:1}`, `{R:2}` from match
  - **Action section**
    - `Rewrite` — internal URL rewrite
    - `Redirect` — HTTP redirect (301, 302, 303, 307)
    - `CustomResponse` — return custom status
    - `AbortRequest` — drop connection
    - `None` — stop rule processing
  - Stop processing (`stopProcessing="true"`)
- 6.3 📋 Outbound Rules
  - Modifying response headers and body
  - `preConditions` — when to apply outbound rules
  - Matching response content (requires `allowedMarkupHandling`)
  - `<preConditions>` element
  - Response header rewriting
- 6.4 🔑 Server Variables in Rewrite
  - Full server variable list
    - `HTTP_HOST`, `HTTP_URL`, `HTTP_METHOD`
    - `HTTPS`, `SERVER_PORT`, `SERVER_NAME`
    - `REQUEST_FILENAME`, `REQUEST_URI`
    - `QUERY_STRING`, `PATH_INFO`
    - `REMOTE_ADDR`, `REMOTE_HOST`
    - `AUTH_USER`, `AUTH_TYPE`
    - `HTTP_X_FORWARDED_FOR`
  - Setting custom server variables
  - Allowed server variables list (security restriction)
- 6.5 🗺️ Rewrite Maps
  - Static rewrite maps (key-value lookup)
  - Using maps in rule conditions
  - Rewrite map from file (generated maps)
  - Performance considerations
- 6.6 🔧 URL Rewrite Common Recipes
  - HTTP → HTTPS redirect
  - www → non-www (and reverse)
  - Trailing slash normalization
  - Extensionless URL rewriting (ASP.NET MVC)
  - SPA (`index.html`) fallback
  - Blocking bad bots by User-Agent
  - Canonical URL enforcement
  - Reverse proxy rules with URL Rewrite + ARR
  - Removing default document from URL
  - Language-based redirect
- 6.7 🔀 Distributed Rules (in `web.config`)
  - Rules at directory level
  - Inheritance chain
  - `<clear>` — resetting inherited rules

---

## 🔒 Part III: Security

### 7. 🛡️ Authentication Deep Dive
- 7.1 📖 Authentication Architecture
  - Authentication module pipeline
  - Multiple auth modules — mutual exclusivity
  - `AuthenticateRequest` phase
  - Anonymous identity vs. authenticated identity
  - `Request.IsAuthenticated`, `User.Identity`
- 7.2 👤 Anonymous Authentication
  - `anonymousAuthentication` configuration
  - Anonymous user identity (`IUSR` vs. app pool identity)
  - `userName=""` — use app pool identity for anonymous
  - When to use `IUSR` vs. app pool identity
- 7.3 🪟 Windows Authentication
  - NTLM protocol — challenge-response flow
  - Kerberos protocol — ticket-based flow
  - IIS Kerberos setup requirements (SPN registration)
  - `authPersistNonNTLM` — auth persistence for non-NTLM
  - `authPersistSingleRequest` — force re-auth each request
  - `providers` — Negotiate (Kerberos first) vs. NTLM
  - Kernel-mode authentication (`useKernelMode`)
  - Extended Protection for Authentication (EPA)
  - Windows Auth through reverse proxy (Kerberos constrained delegation)
  - Double-hop problem and solutions
    - Kerberos constrained delegation
    - Resource-based constrained delegation
    - Protocol transition
- 7.4 🔑 Basic Authentication
  - Configuration and realm name
  - Base64 encoding — not encryption (requires HTTPS)
  - Domain vs. local account authentication
  - Credential caching
- 7.5 🔏 Digest Authentication
  - MD5 challenge-response
  - `realm` configuration
  - Domain requirement
  - Limitations and deprecation context
- 7.6 📜 Client Certificate Authentication
  - `clientCertificateMappingAuthentication`
  - `iisClientCertificateMappingAuthentication`
  - SSL settings — `clientCertValidation` (Ignore, Accept, Require)
  - One-to-one mapping (certificate → Windows account)
  - Many-to-one mapping (wildcard rules → account)
  - `DS_MAPPER` — Active Directory certificate mapping
- 7.7 🔐 Forms Authentication (ASP.NET)
  - `<forms>` element in `<authentication>`
  - `loginUrl`, `timeout`, `slidingExpiration`
  - `protection` — All, Encryption, Validation, None
  - `cookieName`, `cookieless`, `domain`, `path`
  - `requireSSL`, `httpOnlyCookies`
  - `ticketCompatibilityMode` — Framework 4.5+
  - Machine key configuration for forms auth tickets
  - Forms auth across web farms (shared machine key / Data Protection API)
- 7.8 🌐 Federated Authentication
  - WS-Federation with ADFS
  - OpenID Connect / OAuth 2.0 with OWIN/Katana (classic ASP.NET)
  - OpenID Connect with ASP.NET Core middleware 📎
  - Azure AD integration overview

---

### 8. 🚫 Request Filtering
- 8.1 📖 Request Filtering Overview
  - First line of defense (runs before other modules)
  - `<requestFiltering>` in `web.config` / `applicationHost.config`
  - `allowDoubleEscaping` — URL double-encoding
  - `allowHighBitCharacters` — non-ASCII in URLs
  - `unescapeQueryString`
- 8.2 📏 Size Limits
  - `maxAllowedContentLength` — request body size (bytes)
  - `maxUrl` — maximum URL length (bytes)
  - `maxQueryString` — maximum query string length
  - `requestLengthDiskThreshold` — when to buffer to disk
  - Relationship with `httpRuntime maxRequestLength` (ASP.NET)
- 8.3 🔡 Verb Filtering
  - `<verbs>` — allow or deny HTTP methods
  - `<add verb="OPTIONS" allowed="false" />`
  - Denying TRACE, DELETE, PUT globally
  - Allowing specific verbs per path via `<location>`
- 8.4 📂 File Extension Filtering
  - `<fileExtensions>` — allow or deny by extension
  - `allowUnlisted` — deny all unlisted extensions
  - Blocking `.config`, `.bak`, `.log`, `.cs`, `.vb` etc.
  - Wildcard extensions
- 8.5 📋 URL Filtering
  - `<hiddenSegments>` — denying access to path segments
    - Default hidden: `App_Code`, `App_GlobalResources`, `App_LocalResources`, `App_WebReferences`, `App_Data`, `App_Browsers`, `bin`
  - `<denyUrlSequences>` — blocking URL patterns
    - `../` — directory traversal
    - `:` — alternate data streams
    - `//` — double slash
- 8.6 🔤 Header & Query String Filtering
  - `<requestLimits>` — per-header size limits
  - `maxAllowedHeaders`
  - Filtering by header name and value (custom rules)
- 8.7 🌐 Dynamic IP Restrictions
  - `<dynamicIpSecurity>` element
  - Deny by request rate (`denyByConcurrentRequests`)
    - `maxConcurrentRequests`
  - Deny by request frequency (`denyByRequestRate`)
    - `maxRequests`, `requestIntervalInMilliseconds`
  - `enableLoggingOnlyMode` — log without blocking
  - Proxy mode — `enableProxyMode` for load balanced environments
  - `denyAction` — Abort, Forbidden, NotFound, UnauthorizedAccess

---

### 9. 🔐 TLS/SSL Configuration Deep Dive
- 9.1 📜 Certificate Management in Windows
  - Windows Certificate Store (Cert Snap-in, `certlm.msc`)
  - Certificate stores: Personal, Trusted Root CAs, Intermediate CAs
  - `LocalMachine\My` — where IIS looks for certs
  - Importing PFX files (`certutil`, PowerShell, MMC)
  - `certutil -importpfx` — command-line import
  - CSR generation with IIS Manager
  - Certificate renewal workflow
  - Let's Encrypt on IIS (win-acme / Certify The Web)
    - `win-acme` setup and automation
    - `Certify The Web` GUI tool
    - ACME challenge types on IIS (HTTP-01, DNS-01)
    - Automatic binding update on renewal
- 9.2 🔗 SSL Bindings Management
  - Binding certificate via IIS Manager
  - `netsh http add sslcert ipport=0.0.0.0:443 certhash=THUMBPRINT appid={GUID}`
  - `netsh http show sslcert`
  - SNI binding (`hostnameport` instead of `ipport`)
  - Wildcard SNI binding (IIS 10 v1809+)
  - Central Certificate Store (CCS)
    - CCS setup — UNC share with certificates as PFX files
    - Naming convention for CCS (`hostname.pfx`)
    - CCS with private key password
    - Benefits for large-scale multi-site deployments
    - CCS with wildcard certificates
- 9.3 ⚙️ SSL Settings Per Site
  - `<access sslFlags="Ssl" />` — require SSL
  - `sslFlags` values:
    - `None` — HTTP allowed
    - `Ssl` — HTTPS required
    - `SslNegotiateCert` — request client cert
    - `SslRequireCert` — require client cert
    - `Ssl128` — require 128-bit encryption
  - Configuring at site vs. directory level
- 9.4 🔧 TLS Protocol & Cipher Configuration
  - `Schannel` — Windows TLS implementation
  - Registry-based protocol configuration (`HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL`)
  - Enabling/disabling TLS 1.0, 1.1, 1.2, 1.3
  - Cipher suite ordering (`CipherSuiteOrder`)
  - `IIS Crypto` tool — GUI for TLS/cipher hardening
    - Best Practices template
    - PCI DSS template
    - FIPS 140-2 template
  - `CryptSetProvParam` and `BCryptSetContextFunctionProperty`
  - Applying Mozilla TLS recommendations on Windows
  - TLS 1.3 on Windows Server 2022
  - HTTP/2 and TLS requirements
  - HSTS configuration in IIS
    - Via Custom Headers
    - Via URL Rewrite rule
    - HSTS preloading implications
- 9.5 🔒 OCSP Stapling on IIS
  - Windows handles OCSP stapling automatically (via `HTTP.sys`)
  - Verifying OCSP stapling is working
  - OCSP Must-Staple (certificate extension)
- 9.6 🛡️ Security Headers in IIS
  - Adding security headers via `<customHeaders>`
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: SAMEORIGIN`
  - `Content-Security-Policy`
  - `Referrer-Policy`
  - `Permissions-Policy`
  - Removing default headers
    - `X-Powered-By` — remove via `<customHeaders><remove name="X-Powered-By"/>`
    - `Server` — remove via `<requestFiltering removeServerHeader="true"/>` (IIS 10)
    - `X-AspNet-Version` — `<httpRuntime enableVersionHeader="false"/>`
    - `X-AspNetMvc-Version` — `MvcHandler.DisableMvcResponseHeader = true`

---

## 🔗 Part IV: ASP.NET & ASP.NET Core Integration

### 10. 🔷 ASP.NET Core with IIS Deep Dive
- 10.1 🏗️ ANCM (ASP.NET Core Module) Architecture
  - ANCM v1 (Out-of-Process only)
  - ANCM v2 (In-Process + Out-of-Process)
  - ANCM as a native IIS module
  - Installation: Hosting Bundle
  - ANCM version detection and compatibility
  - ANCM error page (`500.0`, `500.30`, `500.31`, `500.32`, `500.33`, `500.34`, `500.35`, `500.36`, `500.37`, `500.38`)
- 10.2 🔄 In-Process Hosting
  - How In-Process works — Kestrel replaced by IIS HTTP Server (`IISHttpServer`)
  - `hostingModel="InProcess"` in `web.config`
  - Single `w3wp.exe` process (no inter-process communication)
  - Performance advantages over Out-of-Process
  - Limitations of In-Process
    - Only one app per app pool
    - No `WebApplication.CreateBuilder()` restart
    - `Console.SetOut` behavior
  - `CreateDefaultBuilder()` behavior in In-Process
  - Event log entries for In-Process startup
- 10.3 🔄 Out-of-Process Hosting
  - How Out-of-Process works — ANCM proxies to Kestrel
  - `hostingModel="OutOfProcess"` in `web.config`
  - Process management by ANCM
  - Port assignment (random high port)
  - Startup timeout — `startupTimeLimit`
  - Shutdown timeout — `shutdownTimeLimit`
  - Request timeout — `requestTimeout`
  - `processPath` — path to `dotnet.exe` or app executable
  - `arguments` — dotnet arguments
  - `forwardWindowsAuthToken` — pass Windows auth token
  - `stdoutLogEnabled` / `stdoutLogFile` — stdout redirection
  - `environmentVariables` — per-app env vars in `web.config`
  - Restart behavior on crash
- 10.4 🔧 `web.config` for ASP.NET Core
  - `<aspNetCore>` element — full attribute reference
  - `processPath`, `arguments`, `hostingModel`
  - `startupTimeLimit`, `shutdownTimeLimit`, `requestTimeout`
  - `forwardWindowsAuthToken`
  - `stdoutLogEnabled`, `stdoutLogFile`
  - `<environmentVariables>` section
  - `<handlerSettings>` — ANCM handler settings
    - `debugFile` — ANCM debug log
    - `debugLevel` — ANCM debug verbosity
  - Self-contained vs. framework-dependent deployment
  - Single-file deployment considerations
- 10.5 🚀 Application Initialization with ASP.NET Core
  - `applicationInitialization` module
  - `<applicationInitialization>` in `web.config`
  - `initializationPage` — warm-up URL
  - `hostName` — warm-up hostname override
  - `doAppInitAfterRestart`
  - `Start Mode` = `AlwaysRunning` in app pool
  - `preloadEnabled` on site
  - Eliminating cold-start latency

---

### 11. 🏛️ Classic ASP.NET (Framework) Integration
- 11.1 📋 ASP.NET Framework Pipeline Integration
  - `HttpApplication` and `HttpModule` in IIS Integrated mode
  - Global.asax — application events
  - `Application_Start`, `Application_End`
  - `Application_BeginRequest`, `Application_EndRequest`
  - `Application_Error` — global error handling
  - `Application_AuthenticateRequest`, `Application_AuthorizeRequest`
  - `Session_Start`, `Session_End`
- 11.2 🔑 Machine Key Configuration
  - `<machineKey>` element
  - `validationKey` and `decryptionKey`
  - `validation` — SHA1, HMACSHA256, HMACSHA384, HMACSHA512, AES
  - `decryption` — AES, DES, 3DES
  - Auto-generate vs. explicit keys
  - Web farm machine key — must match across all nodes
  - `compatibilityMode`
  - IIS auto-generate keys per application (IIS 7.5+)
  - DPAPI machine key protection
- 11.3 📦 HTTP Handlers & Modules (Classic ASP.NET)
  - `IHttpHandler` — synchronous handler
  - `IHttpAsyncHandler` — async handler
  - `IHttpModule` — pipeline module
  - `<handlers>` configuration in `web.config`
  - `<modules>` configuration in `web.config`
  - Handler path and verb mapping
  - `IsReusable` — handler pooling
- 11.4 🗄️ Session State Configuration
  - `InProc` — in-worker-process memory
  - `StateServer` — `ASP.NET State Service`
  - `SQLServer` — SQL Server session store
  - `Custom` — custom provider
  - `Off` — disabled
  - `sqlConnectionString` — SQL Server connection
  - `timeout` — session expiration
  - `cookieName`, `cookieless`, `regenerateExpiredSessionId`
  - `compressionEnabled`
  - Distributed cache session (Redis via StackExchange.Redis)
- 11.5 ⚡ Output Cache
  - `<outputCache>` element
  - `<outputCacheSettings>` and cache profiles
  - `<caching>` in `<system.webServer>` — kernel-mode cache
  - `[OutputCache]` attribute on controllers/actions
  - `VaryByParam`, `VaryByHeader`, `VaryByCustom`
  - Donut caching pattern
  - Cache dependencies (file, SQL, custom)

---

## 📊 Part V: Performance

### 12. ⚡ IIS Performance Tuning
- 12.1 📊 Performance Counters for IIS
  - `Web Service` object counters
    - `Current Connections`
    - `Total Bytes Received/Sent`
    - `Total Connection Attempts`
    - `Get Requests/sec`, `Post Requests/sec`
    - `Total Method Requests/sec`
    - `Not Found Errors/sec`
    - `CGI Requests/sec`
    - `ISAPI Extension Requests/sec`
  - `W3SVC_W3WP` counters
    - `Active Requests`
    - `Active Threads Count`
    - `Maximum Threads Count`
    - `Requests / Sec`
    - `Total HTTP Requests Served`
  - `ASP.NET` counters
    - `Requests Queued`
    - `Requests Rejected`
    - `Application Restarts`
    - `Worker Process Restarts`
    - `Request Execution Time`
  - `ASP.NET Applications` counters
    - `Requests/Sec`
    - `Errors Total/Sec`
    - `Sessions Active`
    - `Cache Total Hits`, `Cache Total Misses`
  - Setting up Performance Monitor (`perfmon.exe`) dashboards
  - Collecting counter logs for analysis
- 12.2 🗜️ Compression Configuration
  - Static vs. dynamic compression
  - `<urlCompression doStaticCompression="true" doDynamicCompression="true"/>`
  - `<staticContent>` compression settings
    - `mimeType` — which types to compress
    - `enabled` per MIME type
  - `<dynamicTypes>` compression settings
  - Compression level (`staticCompressionLevel`, `dynamicCompressionLevel` 1–10)
  - `minFileSizeForComp` — skip tiny files
  - CPU throttling — `dynamicCompressionDisableCpuUsage`, `dynamicCompressionEnableCpuUsage`
  - Adding Brotli compression to IIS (third-party `iis-brotli` module)
  - Static pre-compressed files (`.gz` serving)
  - Compression and `ETags` interaction
- 12.3 💾 Output Caching & Kernel Cache
  - `HTTP.sys` kernel-mode cache — what gets cached
  - Cache control headers required for kernel caching
  - `<caching>` section in `<system.webServer>`
    - `<profiles>` — cache profiles by extension or path
    - `policy` — DontCache, CacheUntilChange, CacheForTimePeriod, DisableCache
    - `kernelCachePolicy` — same options for kernel cache
    - `duration` — cache duration
    - `varyByHeaders`, `varyByQueryString`
    - `location` — Any, Client, Downstream, Server, None, ServerAndClient
  - Flushing the kernel cache
  - Output cache and dynamic content caveats
  - ETags and caching interaction
- 12.4 🔗 Connection & Thread Tuning
  - `maxConcurrentRequestsPerCPU` — ASP.NET request queue
  - `maxConcurrentThreadsPerCPU`
  - `requestQueueLimit` — max queued requests
  - ThreadPool tuning (`minWorkerThreads`, `minIoThreads`)
    - `<processModel autoConfig="true">` vs. manual
  - `<webLimits>` in `applicationHost.config`
    - `connectionTimeout`
    - `dynamicIdleThreshold`
    - `headerWaitTimeout`
    - `minBytesPerSecond`
  - HTTP/2 connection handling
- 12.5 📁 Static File Optimization
  - `sendfile` equivalent — TransmitFile API
  - `TransmitFileBufferSize`
  - `staticFile` handler optimization
  - Far-future `Expires` headers via `<clientCache>`
    - `cacheControlMode` — NoControl, DisableCache, UseMaxAge, UseExpires
    - `cacheControlMaxAge`
    - `httpExpires`
    - `cacheControlCustom`
  - `ETag` generation and control
    - `setEtag` — enable/disable ETags
  - `useVerbosity` — detailed 304 responses
  - MIME type registration for new file types
- 12.6 🏎️ HTTP/2 Configuration
  - HTTP/2 on IIS (Windows Server 2016+, IIS 10)
  - Requirements: TLS 1.2+, `ALPN`
  - HTTP/2 enabled by default — no extra config
  - HTTP/2 per-connection settings via registry
    - `MaxStreamsPerConnection`
  - Server Push via `Response.PushPromise()` (ASP.NET Core)
  - HTTP/2 and `Windows Authentication` incompatibility
  - Verifying HTTP/2 is active (`curl --http2 -I`, browser DevTools)
  - HTTP/3 / QUIC on IIS (Windows Server 2022 preview)

---

## 🏢 Part VI: Web Farm & High Availability

### 13. 🔄 Application Request Routing (ARR)
- 13.1 📖 ARR Overview
  - ARR as IIS extension (free download)
  - ARR vs. Nginx/HAProxy for load balancing
  - ARR + URL Rewrite as reverse proxy
  - ARR installation and dependencies
- 13.2 ⚖️ Server Farm Configuration
  - Creating a server farm
  - Adding servers to farm
  - Server farm settings
    - `applicationRequestRouting` — enable ARR
    - `eagerlyFailoverOnStatusCodes`
    - `stateful` routing
  - Load balancing algorithms
    - Weighted Round Robin
    - Weighted Total Traffic
    - Weighted URL Hash
    - Weighted Request Count
    - Least Current Request
    - Least Response Time
    - IP Hash
    - Request Hash
  - Server weights
  - Connection limits per server
- 13.3 🏥 Health Checks in ARR
  - URL health check (`healthCheck` element)
  - `url` — health check endpoint
  - `interval` — check frequency
  - `timeout`
  - `acceptStatusCodes` — expected status codes
  - `protocol` — http or https
  - Live traffic monitoring as health signal
  - `responseMatch` — body content match
- 13.4 💾 Disk Cache with ARR
  - ARR disk-based caching
  - Cache drive configuration
  - Cache quota
  - `cachePolicy` — per-rule caching decisions
  - Cache revalidation
  - Cache warm-up
- 13.5 🔒 ARR and TLS
  - SSL offloading — terminate TLS at ARR, HTTP to backend
  - SSL bridging — re-encrypt to backend
  - SSL passthrough — TCP-level forwarding (URL Rewrite required)
  - Client certificate forwarding to backend
- 13.6 🔀 ARR as Reverse Proxy
  - URL Rewrite + ARR for reverse proxy
  - `<action type="Rewrite" url="http://backend/{R:1}" />`
  - Preserving host header
  - Response header rewriting (outbound rules)
  - Request header manipulation
  - Reverse proxy to non-IIS backends (Node.js, Java, Python)

---

### 14. 🌐 Shared Configuration & Web Farms
- 14.1 📋 Shared Configuration
  - Concept: multiple IIS servers share `applicationHost.config`
  - Setup: export config to UNC share
  - `Enable Shared Configuration` in IIS Manager
  - `physicalPath` — UNC path to shared config
  - `userName` / `password` — access credentials
  - Encryption keys export/import (`configEncryptionKeys.xml`)
  - Shared configuration and local overrides
  - Limitations (certificates not shared — use CCS)
- 14.2 🔑 Central Certificate Store (CCS) for Web Farms
  - CCS overview 📎 (cross-ref to TLS section)
  - CCS + Shared Configuration = full web farm TLS
  - Automating certificate deployment to CCS share
  - Let's Encrypt + CCS for web farms
- 14.3 🔄 Web Farm Deployment Strategies
  - Manual rolling deploy
  - Web Deploy (MSDeploy) for synchronized deployment
  - Deployment agents
  - Blue-green deployment with ARR
  - Taking servers offline in ARR during deploy
- 14.4 📦 Web Deploy (MSDeploy) Deep Dive
  - Web Deploy architecture
  - Web Deploy provider model
  - `msdeploy.exe` command-line
  - Publish profiles (`.pubxml`)
  - Web Deploy agent service vs. Web Management Service (WMSvc)
  - Sync site content
  - Sync IIS configuration
  - Database deployment (`dbFullSql`, `dbDacFx` providers)
  - ACL and permission sync
  - `skip` rules — excluding files/directories
  - `setParam` — parameterizing deployments
  - Web Deploy and CI/CD pipelines

---

## 📝 Part VII: Logging & Diagnostics

### 15. 📊 IIS Logging Deep Dive
- 15.1 📋 IIS Log Format
  - W3C Extended Log Format (default)
  - NCSA Common Log Format
  - IIS Log Format
  - Custom (ODBC) — logging to database
  - Binary Log Format (`httperr` logs)
- 15.2 ⚙️ W3C Log Field Reference
  - `date`, `time` — UTC timestamp
  - `s-sitename` — IIS site name
  - `s-computername`
  - `s-ip` — server IP
  - `cs-method` — HTTP method
  - `cs-uri-stem` — URL path
  - `cs-uri-query` — query string
  - `s-port`
  - `cs-username`
  - `c-ip` — client IP
  - `cs(User-Agent)`
  - `cs(Referer)` (sic)
  - `sc-status` — HTTP status code
  - `sc-substatus` — IIS sub-status code
  - `sc-win32-status` — Win32 error code
  - `sc-bytes` — bytes sent
  - `cs-bytes` — bytes received
  - `time-taken` — request duration (ms)
  - `cs-host` — Host header
  - `cs(Cookie)`
  - Custom field addition
- 15.3 🔢 IIS Sub-Status Codes Reference
  - `400.x` — Bad Request sub-statuses
  - `401.x` — Unauthorized sub-statuses (1–16 explained)
  - `403.x` — Forbidden sub-statuses (1–24 explained)
  - `404.x` — Not Found sub-statuses
  - `500.x` — Internal Server Error sub-statuses (0, 11, 12, 19, 21, 22, 23, 24, 50, 100)
  - `503.x` — Service Unavailable sub-statuses
  - Sub-status as diagnostic tool
- 15.4 ⚙️ Log Configuration
  - Log file location (`%SystemDrive%\inetpub\logs\LogFiles\`)
  - Per-site logging vs. centralized logging
  - Log file rollover: hourly, daily, weekly, monthly, max size
  - `localTimeRollover` — local vs. UTC time for filenames
  - ETW (Event Tracing for Windows) logging
  - Pipe-delimited log format
  - Log buffering and flush period
  - Binary log format for high-performance logging
- 15.5 🔍 Log Analysis Tools
  - `Log Parser 2.2` — SQL-like queries on IIS logs
    - Common Log Parser queries
    - Top IPs, URLs, status codes, user agents
    - Error analysis queries
    - Performance analysis queries
  - `Log Parser Studio` — GUI for Log Parser
  - `GoAccess` with IIS logs
  - ELK Stack + Filebeat for IIS logs
    - Filebeat IIS module
    - Kibana IIS dashboard
  - Azure Monitor / Log Analytics for IIS logs
  - Splunk IIS add-on

---

### 16. 🔭 Failed Request Tracing (FREB)
- 16.1 📖 FREB Overview
  - What FREB captures (full pipeline trace)
  - Performance impact of FREB
  - FREB XML output and XSL stylesheet
  - FREB log location (`%SystemDrive%\inetpub\logs\FailedReqLogFiles\`)
- 16.2 ⚙️ FREB Configuration
  - Enabling at site level
  - `<traceFailedRequests>` element
  - `<add path="*">` — match all paths
  - `<traceAreas>` — which providers to trace
    - `ASP` — classic ASP tracing
    - `ASPNET` — ASP.NET tracing
    - `ISAPI Extension`
    - `WWW Server` (with `areas` bitmask)
      - Authentication, Security, Filter, StaticFile, CGI, Compression, Cache, RequestNotifications, Module, FastCGI, WebSocket, Rewrite, RequestRouting, ANCM
  - `<failureDefinitions>` — what counts as failure
    - `statusCodes` — e.g., `500`, `404`, `400-599`
    - `timeTaken` — requests slower than threshold
    - `verbosity` — Warning, Error, CriticalError
  - `maxLogFiles` — limit stored traces
  - `maxLogFileSizeKB`
- 16.3 🔍 Reading FREB Output
  - Opening FREB XML in browser (auto-XSLT)
  - Request Summary tab
  - Compact View — events timeline
  - Performance View — time spent per module
  - Auth tab — authentication events
  - Headers tab — request/response headers
  - Identifying slow modules from FREB
  - Identifying authentication failures from FREB
  - Identifying custom error triggers from FREB
- 16.4 🧪 FREB for Common Diagnostics
  - Diagnosing 500 errors with FREB
  - Diagnosing 401 auth failures
  - Diagnosing slow requests
  - Diagnosing ANCM startup failures
  - FREB in production (temporary enablement)

---

### 17. 🩺 IIS Diagnostics Tools
- 17.1 🛠️ Built-in Diagnostics
  - `Event Viewer` — Application, System, IIS logs
    - Event IDs for app pool recycling (5079, 5080, 5117, 5172, 5186, 5189, 5190, 5191, 5196)
    - Event IDs for worker process failures
    - WAS event IDs (5001–5206)
  - `Resource Monitor` — per-process network and file I/O
  - `Process Monitor (Procmon)` — file/registry/network events from `w3wp.exe`
  - `Process Explorer` — deep process inspection
- 17.2 🔧 IIS-Specific Tools
  - `IIS Manager` — GUI administration
  - `appcmd.exe` — command-line administration (full reference in Part IX)
  - `AppCmd` vs. PowerShell WebAdministration — comparison
  - `IIS Diagnostics Toolkit`
  - `DebugDiag` — crash/hang/memory analysis
    - Analysis rules for IIS
    - Automatic dump collection on crash
    - Memory leak analysis
    - Hang analysis (blocked threads)
  - `WinDbg` / `WinDbg Preview` — advanced crash analysis
    - SOS extension for .NET debugging
    - `!clrstack`, `!threads`, `!dumpheap`, `!finalizequeue`
  - `PerfView` — .NET performance profiling
  - `dotMemory`, `dotTrace` (JetBrains) — commercial profilers
- 17.3 🌐 Runtime State Inspection
  - `appcmd list wp` — running worker processes
  - `appcmd list requests /wp.name:PID` — active requests
  - `AppCmd list requests /elapsed:5000` — slow requests
  - IIS Manager → Worker Processes — GUI runtime state
  - `Request Monitor` page in IIS Manager
  - PowerShell `Get-WebRequest`

---

## ⚙️ Part VIII: Management & Automation

### 18. 🖥️ IIS Manager (GUI) Deep Dive
- 18.1 🗺️ IIS Manager Navigation
  - Connections pane — server / site / app hierarchy
  - Features view vs. Content view
  - Server-level vs. site-level vs. app-level features
  - Feature delegation — what site admins can change
- 18.2 🔧 Key Feature Pages Reference
  - Authentication
  - Authorization Rules
  - SSL Settings
  - IP Address and Domain Restrictions
  - Request Filtering
  - URL Rewrite
  - Compression
  - Caching (Output Caching)
  - Default Document
  - Directory Browsing
  - Error Pages
  - HTTP Redirect
  - HTTP Response Headers (Custom Headers)
  - MIME Types
  - Modules
  - Handlers
  - Logging
  - Failed Request Tracing
  - Application Pools (server level)
  - Sites (server level)
  - Worker Processes (server level)
- 18.3 🌐 Remote IIS Manager
  - IIS Manager for Remote Administration
  - Web Management Service (WMSvc) configuration
  - Connecting remotely via IIS Manager
  - IIS Manager users vs. Windows users for remote access
  - Firewall requirements (port 8172)

---

### 19. 💻 `appcmd.exe` Complete Reference
- 19.1 📖 AppCmd Overview
  - Location: `%windir%\System32\inetsrv\appcmd.exe`
  - Object model: site, app, vdir, apppool, config, wp, request, module, backup
  - Output formats: text (default), XML (`/xml`), config (`/config`)
  - Piping AppCmd output
- 19.2 📋 AppCmd Command Reference

  **Sites**
  - `appcmd list site` — list all sites
  - `appcmd add site /name:"MySite" /bindings:http/*:80: /physicalPath:C:\sites\mysite`
  - `appcmd set site /site.name:"MySite" /+bindings.[protocol='https',bindingInformation='*:443:mysite.com']`
  - `appcmd delete site /site.name:"MySite"`
  - `appcmd start site /site.name:"MySite"`
  - `appcmd stop site /site.name:"MySite"`

  **Application Pools**
  - `appcmd list apppool`
  - `appcmd add apppool /name:"MyPool" /managedRuntimeVersion:v4.0`
  - `appcmd set apppool /apppool.name:"MyPool" /processModel.userName:domain\user`
  - `appcmd recycle apppool /apppool.name:"MyPool"`
  - `appcmd start apppool /apppool.name:"MyPool"`
  - `appcmd stop apppool /apppool.name:"MyPool"`

  **Applications**
  - `appcmd list app`
  - `appcmd add app /site.name:"MySite" /path:/myapp /physicalPath:C:\apps\myapp`
  - `appcmd set app /app.name:"MySite/myapp" /applicationPool:"MyPool"`

  **Config**
  - `appcmd list config "MySite/" /section:system.webServer/defaultDocument`
  - `appcmd set config "MySite/" /section:httpProtocol /+customHeaders.[name='X-Frame-Options',value='SAMEORIGIN']`
  - `appcmd lock config /section:system.webServer/security/requestFiltering`
  - `appcmd unlock config /section:system.webServer/security/requestFiltering`

  **Backups**
  - `appcmd add backup "BeforeChange"`
  - `appcmd list backup`
  - `appcmd restore backup "BeforeChange"`
  - `appcmd delete backup "BeforeChange"`

  **Runtime**
  - `appcmd list wp` — worker processes
  - `appcmd list requests` — active requests
  - `appcmd list requests /elapsed:5000` — requests > 5s

---

### 20. 🔷 PowerShell & WebAdministration Module
- 20.1 📖 WebAdministration Module
  - `Import-Module WebAdministration`
  - IIS PSDrive (`IIS:\`)
  - Navigation: `IIS:\Sites`, `IIS:\AppPools`, `IIS:\SslBindings`
- 20.2 📋 PowerShell Cmdlets Reference
  - **Sites**
    - `New-Website`, `Remove-Website`, `Get-Website`, `Set-Website`
    - `Start-Website`, `Stop-Website`
    - `New-WebBinding`, `Remove-WebBinding`, `Get-WebBinding`
  - **Application Pools**
    - `New-WebAppPool`, `Remove-WebAppPool`, `Get-WebAppPool`, `Set-WebAppPool`
    - `Start-WebAppPool`, `Stop-WebAppPool`, `Restart-WebAppPool`
  - **Applications & Virtual Directories**
    - `New-WebApplication`, `Remove-WebApplication`, `Get-WebApplication`
    - `New-WebVirtualDirectory`, `Remove-WebVirtualDirectory`
  - **Configuration**
    - `Get-WebConfigurationProperty`
    - `Set-WebConfigurationProperty`
    - `Add-WebConfiguration`
    - `Remove-WebConfiguration`
    - `Get-WebConfiguration`
    - `Clear-WebConfiguration`
    - `Backup-WebConfiguration`, `Restore-WebConfiguration`
  - **SSL**
    - `Get-ChildItem IIS:\SslBindings`
    - `New-Item IIS:\SslBindings\0.0.0.0!443` — binding cert
    - `Remove-Item IIS:\SslBindings\0.0.0.0!443`
  - **Runtime State**
    - `Get-WebRequest`
    - `Get-Website | Select State`
- 20.3 🔧 IISAdministration Module (Newer)
  - `Import-Module IISAdministration`
  - `Get-IISServerManager` — access raw ServerManager API
  - `New-IISSite`, `Remove-IISSite`, `Get-IISSite`
  - `New-IISServerManagerCommit` — transactional config changes
  - Difference from `WebAdministration` module
  - When to prefer IISAdministration over WebAdministration
- 20.4 🤖 Automation Recipes
  - Provisioning a new site + app pool (full script)
  - Bulk SSL certificate binding
  - Automating app pool recycling schedules
  - Exporting IIS config to JSON/XML for documentation
  - Comparing two IIS configs (drift detection)
  - DSC (Desired State Configuration) for IIS
    - `xWebAdministration` DSC resource
    - `xWebsite`, `xWebApplication`, `xWebAppPool` resources
    - Idempotent IIS configuration with DSC

---

## 🌐 Part IX: FTP Server (IIS FTP)

### 21. 📁 IIS FTP Service
- 21.1 📖 IIS FTP Overview
  - FTP vs. SFTP vs. FTPS
  - IIS FTP installation (separate role service)
  - FTP site vs. web site in IIS
- 21.2 ⚙️ FTP Site Configuration
  - FTP bindings (port 21, passive port range)
  - `<ftpServer>` element
  - `<security>` — authentication and SSL
  - `<userIsolation>` — virtual directory isolation
    - None, StartInUsersDirectory, IsolateRootDirectoryOnly, IsolateAllDirectories, ActiveDirectory, Custom
  - `<directoryBrowse>` — FTP listing options
  - `<messages>` — banner, greeting, exit, max clients messages
  - `<connections>` — timeouts and limits
  - `<logFile>` — FTP logging
- 21.3 🔒 FTP Security
  - FTPS (FTP over SSL) configuration
    - Explicit FTPS vs. Implicit FTPS
    - SSL policy: Allow, Require, Disable
    - Client certificate authentication
  - FTP authentication providers
  - IP restrictions for FTP
  - Firewall passive port range configuration
  - FTP authorization rules (read, write per user/role)
- 21.4 🔧 FTP with Windows Authentication
  - Active Directory user isolation
  - Home directory from AD attribute
  - Virtual host FTP

---

## 📋 Part X: Reference & Cheatsheets

### 22. 📚 Quick Reference Tables
- 22.1 🔢 IIS Version History

| IIS Version | Windows Version | Key Features Added |
|---|---|---|
| IIS 6.0 | Server 2003 | Application pools, Worker process isolation |
| IIS 7.0 | Vista / Server 2008 | Integrated pipeline, modular architecture, `web.config` |
| IIS 7.5 | Win7 / Server 2008 R2 | Best Practices Analyzer, FTP 7.5 |
| IIS 8.0 | Win8 / Server 2012 | SNI, CPU throttling, App Initialization, WebSocket |
| IIS 8.5 | Win8.1 / Server 2012 R2 | Idle suspend, enhanced logging, ETW |
| IIS 10.0 | Win10 / Server 2016 | HTTP/2, Wildcard host headers, Nano Server |
| IIS 10.0 v1709 | Server 1709 | Container improvements |
| IIS 10.0 v1809 | Server 2019 | Wildcard SNI, gRPC |
| IIS 10.0 (2022) | Server 2022 | HTTP/3 preview, TLS 1.3 |

- 22.2 📂 IIS Directory Structure Reference

| Path | Purpose |
|---|---|
| `%SystemRoot%\System32\inetsrv\` | IIS binaries, `appcmd.exe`, modules |
| `%SystemRoot%\System32\inetsrv\config\` | `applicationHost.config`, `administration.config` |
| `%SystemRoot%\System32\inetsrv\config\backup\` | Config backups |
| `%SystemDrive%\inetpub\wwwroot\` | Default website root |
| `%SystemDrive%\inetpub\logs\LogFiles\` | IIS access logs |
| `%SystemDrive%\inetpub\logs\FailedReqLogFiles\` | FREB traces |
| `%SystemDrive%\inetpub\temp\` | Temp files, compressed files cache |
| `%SystemRoot%\System32\LogFiles\HTTPERR\` | `HTTP.sys` error logs |

- 22.3 🔢 Common IIS Sub-Status Codes

| Status | Sub-Status | Meaning |
|---|---|---|
| 401 | 1 | Logon failed |
| 401 | 2 | Logon failed due to server config |
| 401 | 3 | Unauthorized due to ACL |
| 401 | 7 | Access denied by URL authorization |
| 403 | 4 | Execute access forbidden |
| 403 | 6 | IP address rejected |
| 403 | 7 | SSL certificate required |
| 403 | 8 | SSL site name mismatch |
| 403 | 14 | Directory listing denied |
| 403 | 18 | URL sequences denied |
| 403 | 19 | Denied by filtering rule |
| 404 | 0 | File or directory not found |
| 404 | 7 | File extension denied |
| 404 | 11 | Hidden namespace |
| 500 | 0 | Module/ISAPI error |
| 500 | 11 | App offline (app_offline.htm) |
| 500 | 19 | Configuration data invalid |
| 500 | 21 | Module not recognized |
| 500 | 24 | Fatal error in ASP |
| 500 | 50 | Rewrite error |
| 503 | 0 | App pool unavailable |
| 503 | 2 | Concurrent request limit hit |
| 503 | 3 | ASP.NET queue full |

- 22.4 🔧 `appcmd.exe` Quick Reference Cheatsheet
- 22.5 🛡️ IIS Security Hardening Checklist (Annotated)
- 22.6 🔁 URL Rewrite Common Rules Reference
- 22.7 🪟 IIS PowerShell One-Liners Cheatsheet
- 22.8 🆚 IIS vs. Nginx Configuration Equivalents

| IIS Concept | Nginx Equivalent |
|---|---|
| Site | `server {}` block |
| Application | Sub-`location` with `root` |
| Virtual Directory | `alias` directive |
| Application Pool | Worker process (no direct equiv.) |
| `web.config` | `nginx.conf` / include files |
| URL Rewrite Rule | `rewrite` / `location` |
| ARR Server Farm | `upstream {}` block |
| Request Filtering | `ngx_http_access_module` |
| `customErrors` | `error_page` directive |
| Output Caching | `proxy_cache` |
| `HTTP.sys` cache | (Nginx kernel has no equiv.) |
| FREB | `error_log debug` |
| `appcmd` | `nginx -s`, no full equiv. |

- 22.9 🔐 TLS Hardening Reference for IIS
  - Registry paths for Schannel protocol settings
  - Recommended cipher suite order
  - `IIS Crypto` automation commands
  - Verification commands (`nmap --script ssl-enum-ciphers`)
- 22.10 🚀 Production Readiness Checklist

---

> 💡 **Usage Tip:** Start with **Part II (Configuration)** and **Part III (Security)** to establish a solid, secure base. Master **Part IV (ASP.NET/ASP.NET Core)** if running .NET applications — this is IIS's primary strength. Use **Part VII (Logging & Diagnostics)** heavily during incident response, especially **FREB (Section 16)** which is IIS's most powerful unique diagnostic tool. Refer to **Part VI (ARR/Web Farm)** when scaling beyond a single server.
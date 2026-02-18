# 🐱 Apache Tomcat Deep Dive — Supplementary Table of Contents

> 🔗 **Companion to the main Web Servers Study Guide**
> This TOC expands exclusively on Tomcat topics not covered or only briefly mentioned in the main guide (Section 12.10). Cross-references to the main TOC are noted with 📎.
> Covers Tomcat 9, 10, and 11 unless explicitly noted.

---

## 🧠 Part I: Tomcat Internals & Architecture

### 1. 🔬 Architecture Deep Dive
- 1.1 🏗️ Tomcat Component Hierarchy
  - Server → Service → Engine → Host → Context → Wrapper
  - Full component tree explained with analogies
  - How components map to `server.xml` elements
  - Parent-child lifecycle relationships
  - Component initialization order
- 1.2 🧩 Core Abstractions
  - `Catalina` — the servlet container shell
  - `Coyote` — the HTTP connector layer
  - `Jasper` — the JSP engine
  - `Cluster` — the distributed session layer
  - `Naming` — the JNDI naming subsystem
  - `Juli` — Tomcat's logging system (Java Util Logging extension)
  - How these components interact at runtime
- 1.3 🔄 Request Processing Pipeline
  - Connector receives TCP connection
  - `CoyoteAdapter` bridges Coyote ↔ Catalina
  - `Mapper` — URI-to-context/wrapper resolution
  - Container pipeline (Engine → Host → Context → Wrapper)
  - `FilterChain` invocation
  - `Servlet.service()` invocation
  - Response flushing and connection return
  - Full sequence diagram walkthrough
- 1.4 🧵 Threading Model
  - Acceptor thread — accepting new connections
  - Poller thread — monitoring connections with NIO selector
  - Worker thread pool — processing requests
  - `Executor` thread pool vs. connector-embedded pool
  - Thread naming conventions and monitoring
  - `LimitLatch` — connection count limiting
  - Virtual threads (Project Loom) in Tomcat 11
- 1.5 🔁 Container Pipeline & Valve Architecture
  - What is a Pipeline?
  - What is a Valve?
  - `invoke(request, response)` chain
  - Basic valve at end of each pipeline
  - Standard valves per container level
  - Custom valve insertion points
  - Valve vs. Filter — when to use each
- 1.6 🗺️ Mapper Subsystem
  - How Tomcat resolves which Context handles a request
  - How Tomcat resolves which Wrapper (servlet) handles a request
  - Exact, prefix, extension, and default mappings
  - Mapper cache and invalidation
  - Mapper updates on hot deploy

---

### 2. 🧩 Servlet & Jakarta EE Integration
- 2.1 📜 Servlet Specification Versions
  - Servlet 3.0 → Tomcat 7
  - Servlet 3.1 → Tomcat 8 / 8.5
  - Servlet 4.0 → Tomcat 9 (javax.* namespace)
  - Servlet 5.0 → Tomcat 10 (jakarta.* namespace migration)
  - Servlet 6.0 → Tomcat 10.1 / 11
  - **`javax.*` vs. `jakarta.*` namespace change explained**
  - Migration impact and compatibility layers
- 2.2 📦 Jakarta EE vs. Java EE vs. MicroProfile
  - What Tomcat implements (Web Profile subset)
  - What Tomcat does NOT implement (full EE server)
  - Servlet, JSP, EL, WebSocket, JNDI — supported
  - EJB, JPA, CDI, JAX-RS — NOT built-in
  - Adding CDI (Weld), JAX-RS (Jersey/RESTEasy) to Tomcat
- 2.3 🔌 Servlet Container Responsibilities
  - Servlet lifecycle: `init()`, `service()`, `destroy()`
  - `ServletContext` — shared application context
  - `ServletConfig` — per-servlet configuration
  - `HttpServletRequest` and `HttpServletResponse` wrapping
  - Async servlet support (`AsyncContext`)
  - Non-blocking I/O in servlets (`ReadListener`, `WriteListener`)
- 2.4 🔖 Servlet Registration Methods
  - `web.xml` — traditional deployment descriptor
  - `@WebServlet`, `@WebFilter`, `@WebListener` annotations
  - Programmatic registration via `ServletContext.addServlet()`
  - `web-fragment.xml` — JAR-based partial descriptors
  - Ordering of `web-fragment.xml` with `<absolute-ordering>`
  - `ServletContainerInitializer` — framework bootstrap hook
    - `HandlesTypes` annotation
    - Spring Framework's `SpringServletContainerInitializer`

---

## ⚙️ Part II: Configuration Mastery

### 3. 🗂️ `server.xml` Deep Dive
- 3.1 🏗️ `<Server>` Element
  - `port` — shutdown port (security implications)
  - `shutdown` — shutdown command string
  - Disabling the shutdown port (`port="-1"`)
  - `address` — binding shutdown listener
  - `Server` lifecycle listeners
- 3.2 🔧 `<Service>` Element
  - Grouping connectors with an engine
  - `name` attribute
  - Multiple services in one server (advanced)
- 3.3 🌐 `<Connector>` Element Complete Reference
  - **HTTP/1.1 Connector** (`org.apache.coyote.http11.Http11NioProtocol`)
    - `port`, `address`, `maxThreads`, `minSpareThreads`
    - `acceptCount` — TCP accept backlog
    - `maxConnections` — max simultaneous connections
    - `connectionTimeout`
    - `keepAliveTimeout`
    - `maxKeepAliveRequests`
    - `compression`, `compressionMinSize`, `compressibleMimeType`
    - `maxHttpHeaderSize`
    - `maxPostSize`
    - `maxParameterCount`
    - `URIEncoding`
    - `useBodyEncodingForURI`
    - `relaxedQueryChars`, `relaxedPathChars`
    - `rejectIllegalHeader`
    - `server` — override Server header value
    - `xpoweredBy` — disable X-Powered-By
    - `scheme`, `secure`, `proxyName`, `proxyPort` — proxy-aware settings
  - **HTTP/2 Connector** (UpgradeProtocol)
    - `Http2Protocol` configuration
    - HTTP/2 over cleartext (h2c)
    - HTTP/2 settings frames
    - `maxConcurrentStreams`
    - `maxHeaderCount`
    - `keepAliveTimeout`
    - `overheadCountFactor`
    - `overheadDataThreshold`
  - **AJP Connector** (`org.apache.coyote.ajp.AjpNioProtocol`)
    - AJP protocol purpose and packet format
    - `secret` — required AJP secret (Tomcat 9.0.31+)
    - `address` — bind to localhost only
    - `requiredSecret`
    - `allowedRequestAttributesPattern`
    - Why AJP over mod_proxy_http?
    - Security history (Ghostcat CVE-2020-1938)
    - Disabling AJP when not needed
  - **NIO vs. NIO2 vs. APR connectors**
    - `Http11NioProtocol` — Java NIO (recommended)
    - `Http11Nio2Protocol` — Java NIO.2 (AIO)
    - `Http11AprProtocol` — Native APR/OpenSSL
    - Comparison table: throughput, latency, TLS performance
  - **SSL/TLS Connector Configuration**
    - `SSLHostConfig` element
    - `SSLHostConfig` attributes: `protocols`, `ciphers`, `honorCipherOrder`
    - `Certificate` element: `certificateFile`, `certificateKeyFile`, `certificateChainFile`
    - JSSE vs. OpenSSL (APR) SSL implementation
    - Keystore-based TLS (`keystoreFile`, `keystorePass`)
    - `defaultSSLHostConfigName` — SNI default
    - Multiple `SSLHostConfig` for SNI virtual hosting
    - Client authentication (`certificateVerification`)
- 3.4 🏎️ `<Engine>` Element
  - `name` and `defaultHost`
  - `jvmRoute` — sticky session identifier suffix
  - Engine-level Valves (apply to all hosts)
  - `backgroundProcessorDelay`
- 3.5 🏠 `<Host>` Element Complete Reference
  - `name` — hostname
  - `appBase` — application directory (default `webapps/`)
  - `autoDeploy` — watch `appBase` for new apps
  - `deployOnStartup`
  - `deployXML` — whether to process context XML in WAR
  - `copyXML`
  - `unpackWARs`
  - `workDir`
  - `errorReportValveClass`
  - `startStopThreads` — parallel context startup
  - Host aliases (`<Alias>`)
  - Host-level Valves
- 3.6 📦 `<Context>` Element Complete Reference
  - Where to define contexts (server.xml, conf/Catalina/localhost/*.xml, META-INF/context.xml)
  - `path` — context path
  - `docBase` — application directory or WAR file
  - `reloadable` — class change detection (dev only)
  - `crossContext` — allow `ServletContext.getContext()`
  - `privileged` — access to container servlets
  - `override` — override default context settings
  - `cookies` — enable/disable cookie session tracking
  - `sessionCookieName`, `sessionCookiePath`, `sessionCookieDomain`
  - `useHttpOnly` — HttpOnly flag on session cookie
  - `sessionCookieSecure` — Secure flag
  - `sameSiteCookies` — SameSite attribute
  - `antiResourceLocking` — Windows file locking workaround
  - `clearReferencesStopTimers`
  - `clearReferencesHttpClientKeepAliveThread`
  - `logEffectiveWebXml`
  - `backgroundProcessorDelay` — per-context

---

### 4. 📋 `web.xml` Mastery
- 4.1 🏗️ Deployment Descriptor Structure
  - XML schema versions and namespaces (web-app 3.0, 4.0, 5.0, 6.0)
  - Processing order of configuration elements
  - `metadata-complete` — disabling annotation scanning
- 4.2 🔧 DefaultServlet Configuration
  - `DefaultServlet` — serving static files
  - `readonly` parameter — disabling PUT/DELETE
  - `listings` — directory listing enable/disable
  - `debug` parameter
  - `input` / `output` buffer sizes
  - `sendfileSize` — threshold for `sendfile()` use
  - `fileEncoding`
  - `useBomIfPresent`
  - `allowPartialPut`
- 4.3 🖥️ JspServlet Configuration
  - `JspServlet` init parameters
  - `development` mode — recompile on change
  - `fork` — separate JVM for compilation
  - `keepgenerated` — keep generated Java source
  - `trimSpaces`
  - `mappedfile` — line number mapping for debugging
  - `modificationTestInterval`
  - `recompileOnFail`
  - `scratchdir` — JSP work directory
  - `classdebuginfo`
  - `compiler` — Java compiler to use
  - `compilerSourceVM`, `compilerTargetVM`
- 4.4 🔒 Security Constraints
  - `<security-constraint>` element
  - `<web-resource-collection>` — URL patterns and methods
  - `<auth-constraint>` — required roles
  - `<user-data-constraint>` — transport guarantee (CONFIDENTIAL)
  - `<login-config>` — authentication mechanism
    - BASIC, DIGEST, FORM, CLIENT-CERT
  - `<security-role>` declarations
  - Programmatic security (`request.isUserInRole()`, `request.getUserPrincipal()`)
- 4.5 🌐 Session Configuration
  - `<session-config>` element
  - `<session-timeout>`
  - `<cookie-config>` — name, domain, path, comment, http-only, secure, max-age
  - `<tracking-mode>` — COOKIE, URL, SSL
- 4.6 🔀 Error Pages
  - `<error-page>` by status code
  - `<error-page>` by exception type
  - Chaining error pages
  - Exception attributes in error page (`javax.servlet.error.*`)
- 4.7 🔌 Listeners
  - `ServletContextListener` — app start/stop
  - `HttpSessionListener` — session create/destroy
  - `HttpSessionAttributeListener`
  - `ServletRequestListener`
  - Declaration order and lifecycle

---

### 5. 🌿 Context Configuration Files
- 5.1 📂 Configuration File Locations & Priority
  - `conf/context.xml` — global default
  - `conf/Catalina/localhost/ROOT.xml` — host-specific default
  - `conf/Catalina/localhost/myapp.xml` — per-app context
  - `META-INF/context.xml` inside WAR
  - Priority and override rules
- 5.2 🗄️ JNDI Resource Configuration
  - `<Resource>` element
  - JNDI name conventions (`java:comp/env/jdbc/mydb`)
  - DataSource configuration (JDBC connection pool)
  - Mail session resource
  - Environment entries (`<Environment>`)
  - Resource links (`<ResourceLink>`)
- 5.3 🔌 JDBC Connection Pool (DBCP2 & Tomcat Pool)
  - Tomcat's built-in JDBC pool (`org.apache.tomcat.jdbc.pool.DataSource`)
  - DBCP2 pool (`org.apache.commons.dbcp2.BasicDataSource`)
  - Pool attributes:
    - `maxTotal`, `minIdle`, `maxIdle`
    - `maxWaitMillis`
    - `validationQuery`, `testOnBorrow`, `testWhileIdle`
    - `timeBetweenEvictionRunsMillis`
    - `minEvictableIdleTimeMillis`
    - `removeAbandoned`, `removeAbandonedTimeout`
    - `logAbandoned`
    - `initialSize`
    - `connectionProperties` — JDBC URL extras
  - HikariCP as alternative (adding to Tomcat)
  - Connection pool monitoring via JMX

---

## 🏗️ Part III: Deployment & Application Management

### 6. 🚀 Application Deployment
- 6.1 📦 WAR File Deep Dive
  - WAR file structure (`WEB-INF/`, `META-INF/`, static resources)
  - `WEB-INF/classes/` vs. `WEB-INF/lib/`
  - Exploded directory deployment vs. WAR
  - WAR file manifest (`MANIFEST.MF`) — `Class-Path` entry
  - Signed WAR files
  - WAR naming convention → context path mapping
    - `ROOT.war` → `/`
    - `myapp.war` → `/myapp`
    - `myapp#v2.war` → `/myapp/v2` (hash encoding)
- 6.2 🔄 Hot Deployment & Reloading
  - `autoDeploy` — file system watcher thread
  - `reloadable` — class change detection
  - `backgroundProcessorDelay` — polling interval
  - Cold deploy vs. hot deploy trade-offs
  - Classloader leaks during reload
  - `antiResourceLocking` on Windows
  - `undeploy` before redeploy — cleaning work directory
- 6.3 🛠️ Manager Application
  - Enabling and securing the Manager app
  - Manager roles: `manager-gui`, `manager-script`, `manager-jmx`, `manager-status`
  - Manager GUI — browser-based deployment
  - Manager API (HTTP endpoints)
    - `/manager/text/deploy?path=&war=`
    - `/manager/text/undeploy?path=`
    - `/manager/text/start?path=`
    - `/manager/text/stop?path=`
    - `/manager/text/reload?path=`
    - `/manager/text/list`
    - `/manager/text/serverinfo`
    - `/manager/text/status`
    - `/manager/text/expire?path=&session=`
  - Restricting Manager access by IP
  - Manager in production — security risks
- 6.4 🌐 Virtual Hosting with Multiple Apps
  - Multiple `<Host>` elements
  - Name-based virtual hosting
  - `appBase` per host
  - Shared libraries across hosts
  - Default host fallback
- 6.5 🔁 Parallel Deployment (Zero-Downtime)
  - Deploying multiple versions simultaneously
  - Version string in WAR name (`myapp##001.war`)
  - Session routing to old version during migration
  - Undeploying old version after drain
  - Limitations and caveats

---

### 7. 🧩 Classloading Architecture
- 7.1 📚 Java Classloading Review
  - Parent delegation model
  - Bootstrap → Extension → System classloaders
  - `ClassNotFoundException` vs. `NoClassDefFoundError`
- 7.2 🏗️ Tomcat Classloader Hierarchy
  - Bootstrap classloader
  - System classloader (Tomcat bootstrap JARs)
  - Common classloader (`lib/` directory)
  - Catalina classloader (Tomcat internals — not visible to apps)
  - Shared classloader
  - WebApp classloader (per-application)
  - Full hierarchy diagram
- 7.3 🔄 WebApp Classloader Behavior
  - **Inverted delegation** — local classes loaded first (opposite of Java standard)
  - `delegate` attribute — restoring standard delegation
  - What's always loaded from parent (`javax.*`, `jakarta.*`, `org.xml.*`, etc.)
  - `<Loader>` element in context
- 7.4 📦 Library Placement Guide
  - `$CATALINA_HOME/lib/` — shared across all apps (JDBC drivers, etc.)
  - `WEB-INF/lib/` — app-specific JARs
  - `WEB-INF/classes/` — app-specific classes
  - System classpath — generally avoid
  - When duplicate JARs cause problems
  - Dependency conflicts and resolution strategies
- 7.5 🕳️ Classloader Leak Detection
  - What causes classloader leaks (ThreadLocals, JDBC drivers, loggers)
  - Tomcat's leak prevention listeners
    - `JreMemoryLeakPreventionListener`
    - `ThreadLocalLeakPreventionListener`
    - `JdbcLeakPreventionListener`
  - Detecting leaks with `VisualVM` / `Eclipse Memory Analyzer (MAT)`
  - `log4j`, `slf4j` leak patterns
  - JDBC driver deregistration on undeploy

---

## 🔒 Part IV: Security

### 8. 🛡️ Tomcat Security Architecture
- 8.1 🔐 Realm Architecture
  - What is a Realm?
  - Realm positioning (Engine, Host, Context level)
  - Combined realms (`LockOutRealm`, `CombinedRealm`, `JAASRealm`)
  - Realm credential caching (`credentialCachingEnabled`)
- 8.2 📋 Built-in Realm Types
  - `MemoryRealm` — `conf/tomcat-users.xml`
    - XML format
    - Roles and users
    - Not for production
  - `DataSourceRealm` — database-backed authentication
    - `dataSourceName`, `userTable`, `userNameCol`, `userCredCol`
    - `userRoleTable`, `roleNameCol`
    - Digest support
  - `JDBCRealm` — direct JDBC (legacy, prefer DataSourceRealm)
  - `JNDIRealm` — LDAP/Active Directory authentication
    - `connectionURL`, `connectionName`, `connectionPassword`
    - `userBase`, `userSearch`, `userSubtree`
    - `roleBase`, `roleSearch`, `roleName`
    - `referrals`, `derefAliases`
    - Connection pooling
    - StartTLS / SSL to LDAP
  - `UserDatabaseRealm` — `GlobalNamingResources` UserDatabase
  - `JAASRealm` — Java Authentication and Authorization Service
  - `ProxyRealm` — wrapper for testing
  - `LockOutRealm` — brute force protection wrapper
    - `failureCount`, `lockOutTime`, `cacheSize`, `cacheRemovalWarningTime`
  - `CombinedRealm` — try multiple realms in sequence
- 8.3 🔑 Password Hashing in Realms
  - Plaintext passwords (never in production)
  - MD5, SHA-1 (deprecated)
  - SHA-256, SHA-512
  - `CredentialHandler` implementations
    - `MessageDigestCredentialHandler`
    - `SecretKeyCredentialHandler` (PBKDF2)
    - `BCryptCredentialHandler`
    - `SHA512CredentialHandler`
  - `digest.sh` / `digest.bat` utility
  - Salt and iteration count configuration
- 8.4 🔒 Security Manager (Java Security Manager)
  - Tomcat Security Manager overview
  - `catalina.policy` — permission grants
  - Running with Security Manager (`-security` flag)
  - Granting permissions to webapps
  - Deprecation in Java 17+
- 8.5 🚧 Security Hardening Checklist
  - Remove example applications (`examples`, `docs`, `ROOT`)
  - Secure or remove Manager and Host Manager
  - Disable AJP if not used
  - Set AJP secret if used
  - Bind AJP to localhost only
  - Change shutdown port or disable it
  - Remove server version banner (`server=""` in Connector)
  - Disable `xpoweredBy`
  - Set `HttpOnly` and `Secure` on session cookies
  - Configure `SameSite` on session cookie
  - Disable `TRACE` method (`allowTrace="false"`)
  - Set `maxPostSize` to prevent large POST abuse
  - Set `maxParameterCount`
  - Enable `rejectIllegalHeader`
  - Run Tomcat as non-root OS user
  - Restrict file permissions on `conf/`
  - Separate `CATALINA_HOME` and `CATALINA_BASE`
- 8.6 🔥 Notable CVEs & Patches History
  - Ghostcat (CVE-2020-1938) — AJP file read/RCE
  - CVE-2017-12617 — JSP upload via PUT
  - CVE-2019-0232 — CGI RCE on Windows
  - CVE-2021-41079 — infinite loop in HTTP/2
  - CVE-2022-42252 — request smuggling
  - CVE-2023-28708 — RemoteIpFilter cookie attribute
  - Lessons and mitigations for each

---

### 9. 🔌 Valves for Security
- 9.1 🚦 `RemoteAddrValve`
  - IP allowlist / denylist
  - CIDR range support
  - `allow`, `deny` regex patterns
  - `denyStatus` — custom HTTP status for denied requests
  - `addConnectorPort` — match IP:port
  - `invalidAuthenticationWhenDeny`
- 9.2 🌐 `RemoteHostValve`
  - Hostname-based access control
  - DNS lookup overhead consideration
- 9.3 📝 `AccessLogValve`
  - Pattern format specifiers (full reference)
    - `%h` — remote host, `%l` — ident, `%u` — user
    - `%t` — timestamp, `%r` — request line
    - `%s` — status, `%b` — bytes sent
    - `%{Header}i` — request header
    - `%{Header}o` — response header
    - `%{Cookie}c` — cookie value
    - `%D` — processing time ms, `%T` — processing time s
    - `%I` — thread name
    - `%S` — session ID
  - `rotatable`, `prefix`, `suffix`, `fileDateFormat`
  - `buffered` — async write
  - `requestAttributesEnabled` — use attributes set by other valves
  - `encoding` — log file encoding
- 9.4 🕵️ `RemoteIpValve`
  - Extracting real client IP from `X-Forwarded-For`
  - `remoteIpHeader`, `internalProxies`, `trustedProxies`
  - `protocolHeader` — `X-Forwarded-Proto`
  - `protocolHeaderHttpsValue`
  - `httpServerPort`, `httpsServerPort`
  - Integrating with `AccessLogValve`
  - Essential when behind Nginx/Apache/load balancer
- 9.5 🔒 `SSLValve`
  - Extracting SSL info from proxy headers
  - `sslClientCertHeader`, `sslCipherHeader`, `sslSessionIdHeader`
- 9.6 ⏱️ `StuckThreadDetectionValve`
  - Detecting threads blocked longer than threshold
  - `threshold` — seconds before marking stuck
  - `interruptThreadThreshold` — attempt interrupt
  - JMX notification on stuck threads
- 9.7 🚫 `ErrorReportValve`
  - Disabling stack traces in error pages
  - `showReport`, `showServerInfo`
  - Custom error report valve implementation
- 9.8 🔄 `RewriteValve`
  - Rewrite rules similar to Apache `mod_rewrite`
  - Rule syntax
  - `RewriteCond` conditions
  - Flags: `L`, `R`, `NC`, `NE`, `QSA`
  - `rewrite.config` file location

---

## 🌐 Part V: Session Management

### 10. 💾 Session Architecture
- 10.1 🔍 Session Internals
  - `HttpSession` lifecycle
  - `Manager` interface — session store abstraction
  - `Session` object internals
  - Session ID generation (`SecureRandom`)
  - Session ID length and entropy
  - `sessionIdLength` configuration
  - Custom session ID generators (`SessionIdGenerator` interface)
- 10.2 📋 Session Manager Types
  - `StandardManager` — in-memory (default)
    - Session persistence on restart (`PersistAuthentication`)
    - `maxActiveSessions` — limit active sessions
    - `processExpiresFrequency`
  - `PersistentManager` — persistent session store
    - `saveOnRestart`
    - `maxIdleBackup` — move idle sessions to store
    - `minIdleSwap`, `maxIdleSwap` — swapping to store
    - Store implementations:
      - `FileStore` — sessions as files
        - `directory` — storage path
        - `checkInterval`
      - `JDBCStore` — sessions in database
        - Table and column configuration
        - Connection pool settings
  - Custom `Manager` implementations
- 10.3 🌐 Session Tracking Modes
  - Cookie-based (default)
  - URL rewriting (`jsessionid` in URL)
  - SSL session ID
  - Configuring via `web.xml` or `ServletContext`
  - Security implications of URL-based session tracking
- 10.4 🔄 Session Events & Listeners
  - `HttpSessionActivationListener` — session passivation/activation
  - `HttpSessionBindingListener` — attribute bind/unbind
  - `HttpSessionListener` — session creation/destruction
  - `HttpSessionAttributeListener`

---

## 🏢 Part VI: Clustering & High Availability

### 11. 🔗 Tomcat Clustering
- 11.1 📖 Cluster Overview
  - Why cluster Tomcat?
  - Session replication vs. sticky sessions
  - Active-active vs. active-passive
  - `<Cluster>` element in `server.xml`
- 11.2 📡 Cluster Communication
  - `McastService` — IP multicast membership (legacy)
  - `CloudMembershipService` — DNS-based membership (containers)
    - `membershipProviderClassName`
    - `dns.membership.domain`
  - `StaticMembershipService` — explicit member list
    - `StaticMember` elements
  - `NioReceiver` — NIO-based message receiver
    - `address`, `port`, `autoBind`
    - `selectorTimeout`, `maxThreads`
  - `ReplicationTransmitter` — sending messages to members
    - `PooledParallelSender` — parallel transmission
    - `BlockingSender`
- 11.3 🔄 Session Replication Strategies
  - `DeltaManager` — replicate session deltas to ALL nodes
    - All-to-all replication
    - Suitable for small clusters (< 8 nodes)
    - `expireSessionsOnShutdown`
    - `notifyListenersOnReplication`
  - `BackupManager` — replicate to ONE backup node
    - Primary-backup model
    - More scalable than DeltaManager
    - `mapSendOptions`
  - Serialization requirements (`Serializable` attributes)
  - `ClusterSessionListener`
- 11.4 🔀 Sticky Sessions with Load Balancer
  - `jvmRoute` — appended to session ID (`JSESSIONID.node1`)
  - Nginx `ip_hash` or `sticky cookie` with jvmRoute
  - Apache `mod_proxy_balancer` with `stickysession`
  - HAProxy with `cookie` persistence
  - Failover behavior when a node dies
- 11.5 📋 Cluster Valve Components
  - `ReplicationValve` — triggering replication on dirty sessions
    - `filter` — URL patterns to skip replication
    - `primaryIndicator`
  - `JvmRouteBinderValve` — re-binding session on failover
  - `TcpFailureDetector` — detecting failed members
- 11.6 🌐 Cluster File Deployment
  - `FarmWarDeployer` — deploying WARs to all cluster members
  - `watchDir` — watch directory for WAR files
  - `deployDir`, `tempDir`

---

## 📊 Part VII: Performance Tuning

### 12. ⚡ JVM Tuning for Tomcat
- 12.1 ☕ JVM Selection
  - OpenJDK vs. GraalVM vs. Eclipse Temurin vs. Amazon Corretto
  - JVM version compatibility with Tomcat version
  - 32-bit vs. 64-bit JVM considerations
- 12.2 🧠 Heap Memory Tuning
  - `-Xms`, `-Xmx` — initial and max heap
  - `-XX:MetaspaceSize`, `-XX:MaxMetaspaceSize`
  - `-XX:MaxDirectMemorySize` — NIO direct buffers
  - Heap sizing rules of thumb for Tomcat
  - `-XX:+UseContainerSupport` — Docker memory awareness
  - `-XX:MaxRAMPercentage` — percentage-based heap in containers
- 12.3 🗑️ Garbage Collector Tuning
  - G1GC (default Java 9+) — options for Tomcat
    - `-XX:+UseG1GC`
    - `-XX:MaxGCPauseMillis`
    - `-XX:G1HeapRegionSize`
    - `-XX:InitiatingHeapOccupancyPercent`
  - ZGC — low-latency GC (Java 15+)
    - `-XX:+UseZGC`
    - Generational ZGC (Java 21+)
  - Shenandoah GC — Red Hat low-pause GC
  - CMS (deprecated, removed in Java 14)
  - GC logging configuration
    - `-Xlog:gc*:file=gc.log:time,uptime:filecount=10,filesize=10m`
  - GC analysis with GCEasy, GCViewer
- 12.4 🧵 Thread Tuning
  - Calculating optimal `maxThreads`
  - Little's Law applied to thread sizing
  - `minSpareThreads` — keeping warm threads
  - `maxQueueSize` — request queue depth (Tomcat 8.5+)
  - Thread dump analysis
    - `kill -3` on Unix
    - `jstack PID`
    - Thread state meanings (RUNNABLE, BLOCKED, WAITING, TIMED_WAITING)
    - Finding deadlocks in thread dumps
  - `jcmd` — modern alternative to `jstack`
- 12.5 📡 Connector Tuning
  - NIO connector buffer sizes
    - `socket.appReadBufSize`
    - `socket.appWriteBufSize`
    - `socket.rxBufSize`
    - `socket.txBufSize`
  - `socket.soKeepAlive`
  - `socket.performanceConnectionTime`, `performanceLatency`, `performanceBandwidth`
  - `socket.directBuffer` — direct vs. heap buffers
  - `socket.directSslBuffer`
  - Acceptor and poller thread counts
    - `acceptorThreadCount`
    - `pollerThreadCount`

---

### 13. 🗜️ Compression & Static Content
- 13.1 🗜️ Tomcat Compression
  - `compression="on"` in Connector
  - `compressionMinSize`
  - `compressibleMimeType`
  - `noCompressionStrongETag` (Tomcat 9+)
  - Tomcat compression vs. letting Nginx compress
- 13.2 📁 Static Content Serving
  - `DefaultServlet` for static files
  - `sendfileSize` threshold — when to use OS `sendfile()`
  - Caching headers from `DefaultServlet`
  - `readmeFile` — per-directory readme
  - Preferring Nginx/Apache for static content
  - `X-Sendfile` pattern with Nginx frontend
- 13.3 🚀 JSP Precompilation
  - Why precompile JSPs?
  - `jspc` Ant task
  - Maven plugin for JSP precompilation
  - Deploying precompiled JSPs
  - Eliminating `JspServlet` compilation latency

---

## 🔍 Part VIII: Monitoring & Observability

### 14. 📊 JMX Monitoring
- 14.1 📖 Tomcat JMX Overview
  - What is exposed via JMX
  - MBean categories (Catalina, Coyote, Jasper)
- 14.2 ⚙️ Enabling Remote JMX
  - `-Dcom.sun.management.jmxremote`
  - `jmxremote.port`, `jmxremote.rmi.port`
  - `jmxremote.authenticate`, `jmxremote.ssl`
  - JMX over SSL setup
  - Firewall considerations for JMX (RMI port)
  - JMX via Jolokia (HTTP bridge)
- 14.3 🔧 Key MBeans Reference
  - `Catalina:type=Connector` — connector stats
    - `currentThreadsBusy`, `currentThreadCount`, `maxThreads`
    - `requestCount`, `errorCount`, `processingTime`
    - `bytesSent`, `bytesReceived`
  - `Catalina:type=Manager` — session stats
    - `activeSessions`, `maxActive`, `expiredSessions`
    - `sessionCounter`, `rejectedSessions`
  - `Catalina:type=GlobalRequestProcessor` — aggregate request stats
  - `Catalina:type=DataSource` — connection pool stats
    - `numActive`, `numIdle`, `maxTotal`
  - `Catalina:type=Cache` — WebResource cache
  - JVM MBeans — memory pools, GC, threads
- 14.4 🛠️ JMX Tools
  - `jconsole` — built-in JVM GUI
  - `jvisualvm` / `VisualVM` — profiling and monitoring
  - `jmc` (Java Mission Control) + Flight Recorder
  - `Prometheus JMX Exporter` — scraping JMX for Prometheus
    - `jmx_prometheus_javaagent` setup
    - YAML config for Tomcat metrics mapping
  - Grafana dashboard for Tomcat JMX metrics

---

### 15. 📝 Logging System (JULI)
- 15.1 📖 JULI Architecture
  - JULI = Java Util Logging (JUL) + per-classloader isolation
  - Why Tomcat needs its own logging (classloader isolation)
  - JULI `FileHandler` — per-context log files
- 15.2 ⚙️ `logging.properties` Configuration
  - Handler types: `ConsoleHandler`, `FileHandler`, `AsyncFileHandler`
  - Logger hierarchy configuration
  - Per-context `logging.properties` in `WEB-INF/classes/`
  - Log level mapping (SEVERE, WARNING, INFO, CONFIG, FINE, FINER, FINEST)
  - `AsyncFileHandler` — non-blocking async logging
    - `bufferSize`, `overflow`, `prefix`, `suffix`, `level`
- 15.3 🔗 Integrating Third-Party Logging
  - Replacing JULI with Log4j 2
    - `log4j-appserver` module
    - `log4j2.xml` for Tomcat's own logging
  - SLF4J + Logback inside web applications
  - `jul-to-slf4j` bridge
  - `log4j-jul` bridge
  - Separating Tomcat logs from application logs
- 15.4 📋 Log Files Reference
  - `catalina.out` — stdout/stderr (main log)
  - `catalina.YYYY-MM-DD.log` — Catalina log
  - `localhost.YYYY-MM-DD.log` — host log
  - `localhost_access_log.YYYY-MM-DD.txt` — AccessLogValve output
  - `manager.YYYY-MM-DD.log` — manager application
  - `host-manager.YYYY-MM-DD.log`
  - Per-context application logs

---

### 16. 🩺 Diagnostics & Troubleshooting
- 16.1 🌡️ Tomcat Status Endpoints
  - `/manager/status` — server status page
  - `/manager/status?XML=true` — XML status
  - JMX `Catalina:type=GlobalRequestProcessor` stats
  - Custom status servlet pattern
- 16.2 🧵 Thread Dump Analysis
  - Taking thread dumps (`kill -3`, `jstack`, `jcmd`)
  - Identifying stuck request threads
  - Identifying blocked threads (lock contention)
  - Deadlock detection
  - Thread dump analysis tools (fastthread.io, TDA)
- 16.3 🕵️ Heap Dump Analysis
  - Taking heap dumps (`jmap`, `jcmd`, OOM auto-dump)
    - `-XX:+HeapDumpOnOutOfMemoryError`
    - `-XX:HeapDumpPath=/path/to/dump.hprof`
  - Eclipse Memory Analyzer (MAT)
    - Leak suspects report
    - Dominator tree
    - OQL queries
  - VisualVM heap walker
- 16.4 ✈️ Java Flight Recorder
  - Enabling JFR for Tomcat (`-XX:+FlightRecorder`)
  - `jcmd PID JFR.start` / `JFR.dump` / `JFR.stop`
  - Analyzing JFR recordings in Java Mission Control
  - Continuous recording for production
  - JFR event types relevant to Tomcat (I/O, GC, class loading, threads)
- 16.5 🐛 Common Problems Decoded
  - `java.lang.OutOfMemoryError: Java heap space`
  - `java.lang.OutOfMemoryError: Metaspace`
  - `java.lang.OutOfMemoryError: GC overhead limit exceeded`
  - `java.lang.OutOfMemoryError: Direct buffer memory`
  - `SEVERE: Servlet.service() for servlet threw exception`
  - `Connection reset` errors
  - `Broken pipe` errors
  - `The server encountered an internal error` (500)
  - `NullPointerException in StandardWrapperValve`
  - Context startup failure (`FAIL` state)
  - `Unable to create initial connections of pool` (DataSource)
  - Session replication split-brain symptoms
  - `ClassCastException` on hot reload (classloader leak)
  - `LinkageError` — duplicate class definitions
  - Long GC pauses causing request timeouts
  - File descriptor exhaustion (`Too many open files`)

---

## 🔗 Part IX: Integrating with Frontends

### 17. 🔀 Nginx + Tomcat Integration
- 17.1 📡 `proxy_pass` to Tomcat (HTTP)
  - Nginx `proxy_pass http://localhost:8080/`
  - Header forwarding (`X-Forwarded-For`, `X-Real-IP`, `X-Forwarded-Proto`)
  - `RemoteIpValve` in Tomcat for header extraction
  - Timeout alignment (Nginx `proxy_read_timeout` ↔ Tomcat `connectionTimeout`)
  - Keepalive connections from Nginx to Tomcat
  - Path prefix stripping strategies
- 17.2 🔌 AJP Connector with `mod_proxy_ajp`
  - When AJP is preferable
  - Nginx AJP support via `nginx_ajp_module` (third-party)
  - AJP secret configuration both sides
  - AJP packet format overview
- 17.3 ⚖️ Nginx Load Balancing Multiple Tomcats
  - `upstream` block with multiple Tomcat instances
  - Session stickiness with `ip_hash` or `sticky` module
  - jvmRoute-based sticky sessions with Nginx
  - Health check configuration

---

### 18. 🪶 Apache httpd + Tomcat Integration
- 18.1 🔗 `mod_proxy_http` Integration
  - `ProxyPass` and `ProxyPassReverse`
  - `ProxyPreserveHost on`
  - `mod_proxy_balancer` for multiple Tomcats
  - `stickysession` setting for session affinity
  - Balancer manager (`/balancer-manager`)
- 18.2 🔌 `mod_jk` Integration (Legacy)
  - `workers.properties` configuration
  - `uriworkermap.properties`
  - Load balancing with `mod_jk`
  - Why `mod_proxy_ajp` is preferred over `mod_jk`
- 18.3 🔧 Common Configuration Patterns
  - Serving static files from Apache, dynamic from Tomcat
  - SSL termination at Apache
  - Passing SSL information to Tomcat via headers

---

## 🧪 Part X: Jasper — JSP Engine

### 19. 🖥️ JSP Processing Deep Dive
- 19.1 🔄 JSP-to-Servlet Compilation Pipeline
  - JSP → Java source (by Jasper)
  - Java source → bytecode (by Java compiler)
  - Compiled class loaded by WebApp classloader
  - Request routed to compiled servlet
  - Development mode vs. production mode
- 19.2 📋 JSP Standard Syntax
  - Scripting elements (`<% %>`, `<%= %>`, `<%! %>`)
  - Directives (`<%@ page %>`, `<%@ include %>`, `<%@ taglib %>`)
  - Actions (`<jsp:include>`, `<jsp:forward>`, `<jsp:useBean>`, `<jsp:setProperty>`, `<jsp:getProperty>`)
  - EL (Expression Language) in JSPs
  - Implicit objects (`request`, `response`, `session`, `application`, `out`, `config`, `pageContext`, `page`, `exception`)
- 19.3 🔖 JSTL (Jakarta Standard Tag Library)
  - Core tags (`c:if`, `c:choose`, `c:forEach`, `c:forTokens`, `c:import`, `c:redirect`, `c:url`, `c:set`, `c:remove`, `c:out`, `c:catch`)
  - Formatting tags (`fmt:formatDate`, `fmt:formatNumber`, `fmt:message`, `fmt:setLocale`)
  - SQL tags (avoid in production)
  - XML tags
  - Functions (`fn:length`, `fn:substring`, `fn:contains`, `fn:split`, `fn:join`, etc.)
  - Adding JSTL to Tomcat applications
- 19.4 🔌 Custom Tag Libraries
  - `TLD` (Tag Library Descriptor) file
  - `SimpleTag` vs. `Tag` interfaces
  - `TagSupport` and `BodyTagSupport`
  - Tag file (`.tag` files)
  - Tag pooling in Jasper
- 19.5 🗂️ JSP Fragments and Includes
  - Static include (`<%@ include file="..." %>`) vs. dynamic include (`<jsp:include>`)
  - Performance implications
  - `RequestDispatcher.include()` and `forward()`

---

## 🌐 Part XI: WebSocket Support

### 20. 🔌 Tomcat WebSocket Implementation
- 20.1 📖 Jakarta WebSocket (JSR 356)
  - API overview
  - `@ServerEndpoint` annotation
  - `Endpoint` class approach
  - `WebSocketContainer` client API
- 20.2 ⚙️ Server Endpoint Configuration
  - `@ServerEndpoint` attributes (`value`, `encoders`, `decoders`, `subprotocols`, `configurators`)
  - Path parameters in endpoint URLs
  - `Session` management
  - `@OnOpen`, `@OnClose`, `@OnMessage`, `@OnError` annotations
  - Message types (text, binary, pong)
  - Partial messages
  - Async sending (`RemoteEndpoint.Async`)
- 20.3 🔧 Tomcat WebSocket Configuration
  - `WsServerContainer` attributes
    - `maxTextMessageBufferSize`
    - `maxBinaryMessageBufferSize`
    - `asyncSendTimeout`
    - `maxSessionIdleTimeout`
    - `backgroundProcessPeriod`
  - `Configurator` — custom handshake logic
    - Checking `Origin` header
    - Custom headers in handshake response
    - Subprotocol selection
- 20.4 🔀 WebSocket Behind Nginx/Apache
  - Nginx WebSocket proxy configuration 📎
  - Apache `mod_proxy_wstunnel` configuration
  - Timeout alignment for long-lived connections
  - Load balancing WebSocket connections (sticky sessions requirement)

---

## 🏗️ Part XII: Embedded Tomcat

### 21. 🔩 Running Tomcat Embedded
- 21.1 📖 Embedded Tomcat Overview
  - Use cases: testing, microservices, fat JARs
  - Embedded vs. standalone trade-offs
  - Spring Boot's use of embedded Tomcat (context)
- 21.2 ⚙️ Embedded Tomcat API
  - `Tomcat` class — the main entry point
  - `tomcat.setPort()`, `tomcat.setBaseDir()`
  - `tomcat.addWebapp()` — adding a web application
  - `tomcat.addContext()` — programmatic context
  - `tomcat.addServlet()` — registering servlets
  - `tomcat.getConnector()` — connector configuration
  - `tomcat.start()`, `tomcat.getServer().await()`, `tomcat.stop()`
- 21.3 🔒 Embedded TLS Configuration
  - Programmatic SSL connector setup
  - `SSLHostConfig` in embedded mode
  - Loading keystore from classpath
- 21.4 🧪 Embedded Tomcat for Integration Testing
  - JUnit integration
  - Starting before tests, stopping after
  - Dynamic port allocation
  - Reusing across test classes
  - Arquillian framework overview
- 21.5 🚀 Spring Boot + Embedded Tomcat Tuning
  - `server.*` properties in `application.properties`
  - `TomcatServletWebServerFactory` customizer
  - Adding Valves programmatically
  - Custom `ConnectorCustomizer`
  - Overriding connector protocol
  - Enabling HTTP/2 in Spring Boot + Tomcat

---

## 📋 Part XIII: Reference & Cheatsheets

### 22. 📚 Quick Reference
- 22.1 📂 Directory Structure Reference

| Directory | Purpose |
|---|---|
| `bin/` | Startup scripts, `bootstrap.jar` |
| `conf/` | `server.xml`, `web.xml`, `context.xml`, `tomcat-users.xml`, `logging.properties` |
| `lib/` | Shared JARs (JDBC drivers, etc.) |
| `logs/` | Log files output |
| `temp/` | Temporary files |
| `webapps/` | Default `appBase` — deployed applications |
| `work/` | Jasper compiled JSP classes, temp work |

- 22.2 ⚙️ Key JVM Flags for Tomcat

| Flag | Purpose |
|---|---|
| `-Xms512m -Xmx1024m` | Heap size |
| `-XX:MaxMetaspaceSize=256m` | Metaspace limit |
| `-XX:+UseG1GC` | Use G1 garbage collector |
| `-XX:+HeapDumpOnOutOfMemoryError` | Auto heap dump on OOM |
| `-Djava.security.egd=file:/dev/urandom` | Faster random for session IDs |
| `-Djava.awt.headless=true` | Headless mode (no display) |
| `-Dfile.encoding=UTF-8` | Default file encoding |
| `-Dcatalina.base=$CATALINA_BASE` | Separate base directory |
| `-Xlog:gc*:file=gc.log` | GC logging |

- 22.3 🔢 Tomcat Version Compatibility Matrix

| Tomcat | Servlet | JSP | EL | WebSocket | Java Min |
|---|---|---|---|---|---|
| 7.x | 3.0 | 2.2 | 2.2 | 1.1 | 6 |
| 8.0.x | 3.1 | 2.3 | 3.0 | 1.1 | 7 |
| 8.5.x | 3.1 | 2.3 | 3.0 | 1.1 | 7 |
| 9.x | 4.0 | 2.3 | 3.0 | 1.1 | 8 |
| 10.0.x | 5.0 | 3.0 | 4.0 | 2.0 | 8 |
| 10.1.x | 6.0 | 3.1 | 5.0 | 2.1 | 11 |
| 11.0.x | 6.1 | 4.0 | 5.0 | 2.2 | 17 |

- 22.4 🔧 `catalina.sh` / `startup.sh` Cheatsheet

| Command | Action |
|---|---|
| `catalina.sh start` | Start in background |
| `catalina.sh run` | Start in foreground |
| `catalina.sh stop` | Graceful stop |
| `catalina.sh stop -force` | Force stop |
| `catalina.sh configtest` | Validate configuration |
| `catalina.sh version` | Print version info |
| `catalina.sh jpda start` | Start with JPDA debugger |

- 22.5 🌐 Manager API Quick Reference

| Endpoint | Action |
|---|---|
| `/manager/text/list` | List deployed apps |
| `/manager/text/deploy?path=/app&war=file:/path` | Deploy WAR |
| `/manager/text/undeploy?path=/app` | Undeploy app |
| `/manager/text/start?path=/app` | Start app |
| `/manager/text/stop?path=/app` | Stop app |
| `/manager/text/reload?path=/app` | Reload app |
| `/manager/text/sessions?path=/app` | Session info |
| `/manager/text/serverinfo` | Server information |

- 22.6 🏗️ Common `server.xml` Skeleton (Annotated)
- 22.7 🗄️ JNDI DataSource Configuration Recipes
  - MySQL / MariaDB
  - PostgreSQL
  - Oracle
  - SQL Server
  - H2 (in-memory for testing)
- 22.8 🚀 Production Readiness Checklist

---

> 💡 **Usage Tip:** Begin with **Part II (Configuration)** and **Part III (Deployment)** to get applications running. Dive into **Part IV (Security)** before any production deployment. Use **Part VII (Performance)** and **Part VIII (Monitoring)** for ongoing production operation. Refer to **Part VI (Clustering)** only when scaling beyond a single node.
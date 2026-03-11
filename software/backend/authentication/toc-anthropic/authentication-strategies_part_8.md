# Authentication Strategies — Part 8: Phase 2 — Specific Implementations

---

## Phase 2: Specific Implementations

### P2.1 Passport.js (Node.js)
#### P2.1.1 Architecture
- P2.1.1.1 Strategy pattern — pluggable auth strategies via npm packages
- P2.1.1.2 Middleware integration — Express/Koa/Fastify compatible
- P2.1.1.3 Session serialization — serializeUser / deserializeUser hooks

#### P2.1.2 Key Strategies
- P2.1.2.1 passport-local — username/password with Verify callback → See §2.0
- P2.1.2.2 passport-jwt — JWT extraction strategies (header/cookie/query) → See §3.0
- P2.1.2.3 passport-oauth2 → See §4.0
- P2.1.2.4 passport-google-oauth20 → See §4.2
- P2.1.2.5 **Unique: `failureFlash`** — flash messages for failed auth UI feedback
- P2.1.2.6 **Unique: Multi-strategy chaining** — try strategies in sequence, first win

#### P2.1.3 Session Integration
- P2.1.3.1 express-session integration → See §2.2
- P2.1.3.2 **Unique: `req.user` injection** — automatic user object population on routes
- P2.1.3.3 **Unique: `req.isAuthenticated()`** — convenience boolean check

### P2.2 Spring Security (Java / Spring Boot)
#### P2.2.1 Security Filter Chain
- P2.2.1.1 OncePerRequestFilter pattern → See §2.0
- P2.2.1.2 SecurityContextHolder — ThreadLocal principal storage
- P2.2.1.3 **Unique: FilterSecurityInterceptor** — method-level security with SpEL

#### P2.2.2 OAuth2 / OIDC Client
- P2.2.2.1 spring-security-oauth2-client → See §4.0, §5.0
- P2.2.2.2 **Unique: ClientRegistrationRepository** — dynamic OIDC client config bean
- P2.2.2.3 **Unique: `@PreAuthorize`** — SpEL expression-based method security

#### P2.2.3 JWT Resource Server
- P2.2.3.1 `spring-security-oauth2-resource-server` → See §3.5
- P2.2.3.2 **Unique: JwtDecoder custom claim converter** — map claims to GrantedAuthority

#### P2.2.4 SAML 2.0 SP
- P2.2.4.1 spring-security-saml2-service-provider → See §9.2
- P2.2.4.2 **Unique: RelyingPartyRegistrationRepository** — multi-IdP config registry

### P2.3 Django REST Framework (Python)
#### P2.3.1 Authentication Classes
- P2.3.1.1 SessionAuthentication → See §2.0
- P2.3.1.2 BasicAuthentication — HTTP Basic (development only, avoid production)
- P2.3.1.3 TokenAuthentication — simple token model
  - P2.3.1.3.1 **Unique: single token per user** — no built-in refresh mechanism
- P2.3.1.4 djangorestframework-simplejwt → See §3.0

#### P2.3.2 Permission Classes
- P2.3.2.1 `IsAuthenticated`, `IsAdminUser`, `AllowAny` → See §1.1
- P2.3.2.2 **Unique: Object-level permissions** — `has_object_permission(request, view, obj)` hook

#### P2.3.3 Social Auth
- P2.3.3.1 python-social-auth / dj-rest-auth → See §4.2, §5.0
- P2.3.3.2 **Unique: Pipeline** — customizable auth pipeline steps (association, creation)

### P2.4 ASP.NET Core Identity
#### P2.4.1 Identity System
- P2.4.1.1 UserManager<T> / RoleManager<T> → See §2.0
- P2.4.1.2 **Unique: PasswordHasher** — ASP.NET Identity password format v3 (PBKDF2-SHA256)
- P2.4.1.3 **Unique: UserStore** — pluggable storage backend (EF Core, custom)

#### P2.4.2 JWT Bearer
- P2.4.2.1 AddAuthentication().AddJwtBearer() → See §3.5
- P2.4.2.2 **Unique: TokenValidationParameters** — fine-grained validation config
- P2.4.2.3 **Unique: IssuerSigningKeyResolver** — dynamic key resolution via kid

#### P2.4.3 OAuth / OIDC
- P2.4.3.1 AddOpenIdConnect() → See §5.0
- P2.4.3.2 **Unique: ClaimActions** — map IdP claims to Identity claims namespace

### P2.5 Keycloak
#### P2.5.1 Architecture
- P2.5.1.1 Realm — isolated tenant namespace → See §9.1
- P2.5.1.2 Client — OAuth 2.0 client registration → See §4.1.2
- P2.5.1.3 **Unique: SPI (Service Provider Interface)** — custom authenticator plugins

#### P2.5.2 Protocol Support
- P2.5.2.1 OAuth 2.0 + OIDC → See §4.0, §5.0
- P2.5.2.2 SAML 2.0 → See §9.2
- P2.5.2.3 **Unique: Keycloak token format** — additional `realm_access`/`resource_access` claims

#### P2.5.3 Unique Features
- P2.5.3.1 **Unique: Fine-Grained Authorization (UMA 2.0)** — resource-based permissions
- P2.5.3.2 **Unique: Admin REST API** — programmatic realm/client/user management
- P2.5.3.3 **Unique: Event listeners** — real-time auth event hooks (SPI)
- P2.5.3.4 **Unique: Session management UI** — admin console active session list + kill

### P2.6 Auth0
#### P2.6.1 Architecture
- P2.6.1.1 Tenant — isolated namespace → See §9.1
- P2.6.1.2 Universal Login — hosted login page (XSS-safe via isolation)
- P2.6.1.3 **Unique: Actions pipeline** — custom JS logic on login/register/token events

#### P2.6.2 Protocol Support
- P2.6.2.1 OAuth 2.0 + OIDC → See §4.0, §5.0
- P2.6.2.2 SAML → See §9.2
- P2.6.2.3 **Unique: Auth0 Management API** — user CRUD, role/permission assignment

#### P2.6.3 Enterprise Extensions
- P2.6.3.1 **Unique: Organizations** — B2B multi-tenant with per-org SSO config
- P2.6.3.2 **Unique: Anomaly Detection** — built-in brute force + breached password checks

### P2.7 AWS Cognito
#### P2.7.1 User Pools
- P2.7.1.1 JWT tokens — Access + ID + Refresh → See §3.0
- P2.7.1.2 **Unique: SRP auth flow (USER_SRP_AUTH)** — password never sent in plaintext
  - P2.7.1.2.1 Secure Remote Password — challenge-response over HTTPS
- P2.7.1.3 **Unique: Lambda triggers** — pre/post auth, pre token generation, custom message

#### P2.7.2 Identity Pools
- P2.7.2.1 **Unique: Federated identity → AWS credentials** — temporary IAM role via STS
- P2.7.2.2 Developer authenticated identities — backend-validated identity

#### P2.7.3 Advanced Security Features
- P2.7.3.1 **Unique: Adaptive authentication** — risk-based MFA challenge (impossible travel)
- P2.7.3.2 **Unique: Compromised credential protection** — breached password screening

### P2.8 Firebase Authentication
#### P2.8.1 Architecture
- P2.8.1.1 Firebase ID Token — short-lived JWT (1 hour) → See §3.0
- P2.8.1.2 **Unique: Client-side SDK** — browser/mobile handles full auth flow
- P2.8.1.3 Firebase Auth Emulator — local development with mock IdP

#### P2.8.2 Providers
- P2.8.2.1 Email/password → See §2.0 (server-managed via Admin SDK)
- P2.8.2.2 Google, Facebook, GitHub → See §4.2
- P2.8.2.3 Phone number (SMS OTP) → See §7.2
- P2.8.2.4 **Unique: Anonymous auth** — temporary UID for pre-login sessions

#### P2.8.3 Token Management
- P2.8.3.1 **Unique: Custom claims via Admin SDK** — server-side claim injection post-auth
- P2.8.3.2 Token refresh — Firebase SDK auto-refreshes via secure HTTP-only cookie
- P2.8.3.3 **Unique: Session cookies** — server-managed 2-week session via Admin SDK

---

> **Navigation:** [← Part 7: Security & Performance](authentication-strategies_part_7.md)

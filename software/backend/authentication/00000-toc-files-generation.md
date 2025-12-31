Here is the bash script to generate the directory structure and files based on your "Backend Authentication & Authorization Study Plan" TOC.

I have combined the details from both TOCs provided to ensure the content inside the markdown files is comprehensive.

### Instructions:
1.  Open your terminal in Ubuntu.
2.  Create a new script file: `nano create_auth_study.sh`
3.  Paste the code below into the file.
4.  Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).
5.  Make the script executable: `chmod +x create_auth_study.sh`
6.  Run the script: `./create_auth_study.sh`

### The Bash Script

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Backend-Auth-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $ROOT_DIR..."

# ==============================================================================
# PART 1: Foundational Authentication Patterns
# ==============================================================================
DIR_01="001-Foundational-Authentication-Patterns"
mkdir -p "$DIR_01"

# 1.A Basic Authentication
cat <<EOF > "$DIR_01/001-Basic-Authentication.md"
# Basic Authentication

## Concepts
- **How it Works**: Base64 encoding of "username:password" in the Authorization header.
- **State**: Stateless.
- **Key Takeaway**: Simple, stateless, but fundamentally insecure (sends credentials with every request).
- **Pros/Cons**: Very simple to implement, but not flexible and requires HTTPS to be even remotely safe.
EOF

# 1.B Cookie-Based Authentication
cat <<EOF > "$DIR_01/002-Cookie-Based-Authentication.md"
# Cookie-Based Authentication (Stateful)

## Concepts
- **How it Works**: Server creates a session on login, stores it, and sends a session ID cookie to the browser.
- **State**: Stateful (server must store session data).
- **Use Case**: Traditional monolithic web applications.
- **Security Focus**: 
    - Mitigating CSRF (Cross-Site Request Forgery).
    - Using flags: HttpOnly, Secure, & SameSite.
EOF

# 1.C Token-Based Authentication
cat <<EOF > "$DIR_01/003-Token-Based-Authentication.md"
# Token-Based Authentication (Stateless)

## Concepts
- **How it Works**: Server issues a signed token (e.g., JWT) which the client stores and sends with requests.
- **State**: Stateless (server doesn't need to store token data).
- **Use Case**: Modern APIs, Single Page Applications (SPAs), Mobile apps.

## Core Component: JWT (JSON Web Token)
- **Purpose**: A standard for self-contained, verifiable claims.
- **Structure**:
    1. **Header**: Algorithm & Token Type.
    2. **Payload**: Claims (user info, permissions, expiration).
    3. **Signature**: To verify the token's integrity.
EOF

# ==============================================================================
# PART 2: Production-Ready Implementation & Security
# ==============================================================================
DIR_02="002-Production-Ready-Implementation-Security"
mkdir -p "$DIR_02"

# 2.A Credential Security
cat <<EOF > "$DIR_02/001-Credential-Security.md"
# Credential Security

## Concepts
- **Password Hashing & Salting**: Never store plain text. Use algorithms like bcrypt or Argon2.
- **Brute-Force Protection**: Implementing Rate Limiting and Account Lockout mechanisms.
EOF

# 2.B Token Lifecycle Management
cat <<EOF > "$DIR_02/002-Token-Lifecycle-Management.md"
# Token Lifecycle Management

## Concepts
- **Refresh Tokens**: Used to obtain new access tokens. Allows for short-lived access tokens and secure user sessions.
- **Token Revocation**: Handling immediate logout. Since JWTs are stateless, this often requires blocklists (e.g., using Redis) to invalidate tokens before expiry.
- **Secure Key Management**: Strategies for Secret rotation & JWKS (JSON Web Key Sets).
EOF

# 2.C Introduction to Authorization
cat <<EOF > "$DIR_02/003-Introduction-to-Authorization.md"
# Introduction to Authorization

## Concepts
- **Role-Based Access Control (RBAC)**: Granting permissions based on user roles (e.g., Admin, Editor, Viewer).
- Separating "Who you are" (Authentication) from "What you can do" (Authorization).
EOF

# ==============================================================================
# PART 3: Delegated Authority & Federated Identity
# ==============================================================================
DIR_03="003-Delegated-Authority-Federated-Identity"
mkdir -p "$DIR_03"

# 3.A OAuth 2.0
cat <<EOF > "$DIR_03/001-OAuth-2.0.md"
# OAuth 2.0 (The Authorization Framework)

## Concepts
- **Core Purpose**: Delegated Authorization (granting permission), NOT authentication. Allows an application to act on a user's behalf.
- **Key Roles**:
    1. **Resource Owner**: The User.
    2. **Client**: The application requesting access.
    3. **Authorization Server**: Issues the tokens.
    4. **Resource Server**: The API that holds the data.
- **The Flow**: User grants permission -> Application gets an Access Token.
EOF

# 3.B OIDC (OpenID Connect)
cat <<EOF > "$DIR_03/002-OIDC-OpenID-Connect.md"
# OIDC (OpenID Connect) - The Identity Layer

## Concepts
- **Core Purpose**: Authentication (proving who a user is).
- **How it Works**: An identity layer built ON TOP of OAuth 2.0.
- **Key Component**: The ID Token (a JWT).
- **Distinction**: "OAuth is for getting access, OIDC is for proving who you are."
- **Use Case**: Social Logins (e.g., "Sign in with Google").
EOF

# 3.C SAML 2.0
cat <<EOF > "$DIR_03/003-SAML-2.0.md"
# SAML 2.0 (The Enterprise SSO Standard)

## Concepts
- **Core Purpose**: Federated Identity for Single Sign-On (SSO).
- **How it Works**: XML-based assertions exchanged between an Identity Provider (IdP) and a Service Provider (SP).
- **Use Case**: Corporate and B2B environments (e.g., "Log in with your company account" to access Salesforce/Slack).
EOF

# ==============================================================================
# PART 4: Advanced Topics & The Future
# ==============================================================================
DIR_04="004-Advanced-Topics-The-Future"
mkdir -p "$DIR_04"

# 4.A Advanced Authorization Models
cat <<EOF > "$DIR_04/001-Advanced-Authorization-Models.md"
# Advanced Authorization Models

## Concepts
- **Attribute-Based Access Control (ABAC)**: Fine-grained, policy-based access.
- Decisions are based on attributes of the User, the Resource, the Action, and the Environment (Context).
EOF

# 4.B Multi-Factor Authentication (MFA/2FA)
cat <<EOF > "$DIR_04/002-Multi-Factor-Authentication.md"
# Multi-Factor Authentication (MFA/2FA)

## Concepts
- **Concept**: Adding a second verification factor (Something you know + Something you have).
- **Common Standard**: TOTP (Time-based One-Time Password), used in apps like Google Authenticator.
EOF

# 4.C The Future is Passwordless
cat <<EOF > "$DIR_04/003-The-Future-is-Passwordless.md"
# The Future is Passwordless

## Concepts
- **Magic Links**: Email-based, single-use login links (frictionless but relies on email security).
- **Passkeys (WebAuthn/FIDO2)**: The phishing-resistant gold standard using public-key cryptography. Replaces passwords with cryptographic keys stored on the device.
EOF

echo "Done! Structure created in '$ROOT_DIR'."
```

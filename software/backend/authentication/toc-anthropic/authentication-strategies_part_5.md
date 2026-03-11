# Authentication Strategies — Part 5: Passwordless Authentication & MFA

---

## 7.0 Passwordless Authentication

### 7.1 Magic Links
#### 7.1.1 Token Generation & Storage
- 7.1.1.1 CSPRNG token — 256-bit entropy, base64url encoded
- 7.1.1.2 Token storage — store hash(token) in DB with user_id + expiry
- 7.1.1.3 Single-use enforcement — delete on first successful use
- 7.1.1.4 Pre-existing session handling — invalidate old tokens on new request

#### 7.1.2 Delivery Mechanism
- 7.1.2.1 Email delivery — transactional email provider (SES, SendGrid, Postmark)
- 7.1.2.2 Link format — `https://app.com/auth?token=...&email=...`
- 7.1.2.3 Email enumeration prevention — same response whether email exists or not

#### 7.1.3 Security Considerations
- 7.1.3.1 Expiration — 15-minute TTL maximum
- 7.1.3.2 Replay protection — invalidate on use
- 7.1.3.3 Email account compromise transfers full auth compromise
- 7.1.3.4 Device binding — restrict token to requesting browser via cookie correlation

### 7.2 OTP (One-Time Passwords)
#### 7.2.1 TOTP — Time-Based OTP (RFC 6238)
- 7.2.1.1 HMAC-SHA1(secret, floor(unix_time / 30)) → 6-digit derivation
  - 7.2.1.1.1 Time step — 30s default, 60s supported
  - 7.2.1.1.2 Clock drift tolerance — ±1 step window (accepts T-1, T, T+1)
- 7.2.1.2 Secret provisioning — QR code with otpauth:// URI
  - 7.2.1.2.1 otpauth URI format — issuer, account, secret, algorithm, digits, period
- 7.2.1.3 Backup codes — 8-10 random codes, hashed storage, single-use
- 7.2.1.4 Replay prevention — reject reuse of valid OTP within same time window

#### 7.2.2 HOTP — Counter-Based OTP (RFC 4226)
- 7.2.2.1 HMAC-SHA1(secret, counter) — sequential counter increment
- 7.2.2.2 Counter resync — acceptable lookahead window for desync recovery
- 7.2.2.3 Use cases — hardware tokens, SMS OTP (SMS now deprecated for security)

### 7.3 WebAuthn / FIDO2 / Passkeys
#### 7.3.1 Architecture & Components
- 7.3.1.1 Authenticator types — platform (TPM, Secure Enclave) vs. roaming (USB/NFC/BLE)
- 7.3.1.2 Relying Party (RP) — server validating WebAuthn assertions
- 7.3.1.3 Client — browser/app mediating between RP and authenticator

#### 7.3.2 Registration (Attestation) Flow
- 7.3.2.1 RP generates challenge — 32-byte CSPRNG
- 7.3.2.2 Authenticator creates keypair — private key in secure hardware
  - 7.3.2.2.1 Credential ID — random handle for key lookup
  - 7.3.2.2.2 Attestation — device authenticity proof (Basic, ECDAA, None, Packed)
  - 7.3.2.2.3 AAGUID — authenticator model identifier
- 7.3.2.3 RP stores credential_id + public_key + aaguid + sign_count

#### 7.3.3 Authentication (Assertion) Flow
- 7.3.3.1 RP generates new challenge per authentication attempt
- 7.3.3.2 Authenticator signs challenge with private key
- 7.3.3.3 RP verifies signature + counter increment (replay prevention)
  - 7.3.3.3.1 Counter validation — stored counter < received counter
  - 7.3.3.3.2 Counter rollback detection — possible credential cloning indicator
- 7.3.3.4 clientDataHash binding — origin + challenge in signed data

#### 7.3.4 Passkeys (Synced Credentials)
- 7.3.4.1 Passkey = WebAuthn credential synced via platform cloud
- 7.3.4.2 iCloud Keychain (iOS/macOS), Google Password Manager (Android/Chrome)
- 7.3.4.3 Cross-device authentication — hybrid transport (BLE proximity)
  - 7.3.4.3.1 QR code scan on phone to auth on desktop
- 7.3.4.4 Passkey vs. hardware key — synced convenience vs. device-bound security

#### 7.3.5 RP Requirements
- 7.3.5.1 rpId — domain name (must match origin)
- 7.3.5.2 Credential storage — indexed by userId + credentialId
- 7.3.5.3 allowCredentials list — discoverable vs. non-discoverable credentials

---

## 8.0 Multi-Factor Authentication (MFA/2FA)

### 8.1 MFA Factor Categories & Strength
#### 8.1.1 Factor Combinations
- 8.1.1.1 Knowledge + Possession — password + TOTP (most common 2FA combo)
- 8.1.1.2 Possession + Inherence — hardware key + biometric
- 8.1.1.3 Adaptive MFA — risk-based factor selection per context

#### 8.1.2 MFA Strength Levels
- 8.1.2.1 SMS OTP — weakest (SIM swapping, SS7 interception, social engineering)
- 8.1.2.2 TOTP app — moderate (phishing susceptible, but no SMS relay)
- 8.1.2.3 FIDO2/WebAuthn — strongest (phishing-resistant, origin-bound)

### 8.2 TOTP MFA Implementation
#### 8.2.1 Enrollment Flow
- 8.2.1.1 Secret generation — base32-encoded 160-bit secret
- 8.2.1.2 QR code display — one-time, then secret discarded from view
- 8.2.1.3 Verification on enrollment — user must confirm TOTP before enabling

#### 8.2.2 Verification Flow
- 8.2.2.1 OTP rate limiting — max 5 attempts, lockout on failure
- 8.2.2.2 Step-up authentication — re-challenge on sensitive actions
- 8.2.2.3 TOTP window validation — T-1, T, T+1 accepted

### 8.3 Push Notification Authentication
#### 8.3.1 Flow
- 8.3.1.1 Login triggers push to registered mobile device via FCM/APNs
- 8.3.1.2 User approves/denies in authenticator app
- 8.3.1.3 Number matching to prevent push fatigue attacks
  - 8.3.1.3.1 Number matching — display same code in login UI + push notification
  - 8.3.1.3.2 Push bombing mitigation — throttle push requests, require number match

#### 8.3.2 Device Registration
- 8.3.2.1 Device token registration — FCM/APNs token stored per user device
- 8.3.2.2 Multi-device support — approve from any registered device

### 8.4 Hardware Tokens
#### 8.4.1 YubiKey (FIDO2 / U2F / OTP)
- 8.4.1.1 OTP mode — Yubico OTP with AES-128 encryption
- 8.4.1.2 FIDO2 mode — hardware-bound credential (preferred)
- 8.4.1.3 Static password mode — not recommended for MFA

#### 8.4.2 FIDO U2F (Legacy)
- 8.4.2.1 U2F vs. FIDO2 — U2F is subset, FIDO2 supersedes
- 8.4.2.2 U2F backward compatibility in WebAuthn

### 8.5 MFA Bypass & Recovery
#### 8.5.1 Recovery Mechanisms
- 8.5.1.1 Backup codes — 8-10 codes, single-use, hashed storage, shown once
- 8.5.1.2 Recovery via secondary email/phone
- 8.5.1.3 Admin-assisted recovery — identity verification required before reset

#### 8.5.2 MFA Bypass Attacks
- 8.5.2.1 Real-time phishing proxy — AiTM session hijacking
  - 8.5.2.1.1 Evilginx2-style reverse proxy captures session cookies post-MFA
  - 8.5.2.1.2 Mitigation — phishing-resistant FIDO2 as mandatory factor
- 8.5.2.2 SIM swapping — social engineering mobile carrier for SMS OTP
- 8.5.2.3 MFA fatigue / push bombing — repeated deny-then-accidental-approve
- 8.5.2.4 SS7 interception — telecom protocol vulnerability for SMS redirection

---

> **Navigation:** [← Part 4: OIDC & API Keys](authentication-strategies_part_4.md) | [Part 6: SSO & mTLS →](authentication-strategies_part_6.md)

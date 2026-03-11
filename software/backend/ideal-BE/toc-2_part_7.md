# The Ideal Backend — Complete Study Guide

## Table of Contents — Part 7: Features (§30–39)

---

### 30. File Handling & Storage

#### 30.1 File Uploads
- 30.1.1 Multipart form uploads
- 30.1.2 File size and type validation
- 30.1.3 Streaming uploads (avoiding memory overload)
- 30.1.4 Chunked/resumable uploads (tus protocol)
- 30.1.5 Direct-to-cloud uploads (presigned URLs)

#### 30.2 Storage Backends
- 30.2.1 Local filesystem storage
- 30.2.2 Cloud object storage (AWS S3, GCS, Azure Blob)
- 30.2.3 Storage abstraction layers (filesystem adapters)
- 30.2.4 CDN integration for file delivery

#### 30.3 File Management
- 30.3.1 File naming strategies (UUID, hash-based)
- 30.3.2 Directory organization
- 30.3.3 File metadata storage (database references)
- 30.3.4 File deletion and cleanup (orphan files)
- 30.3.5 Access control for private files (signed URLs, tokens)

---

### 31. Email & Notifications

#### 31.1 Email Sending
- 31.1.1 SMTP integration
- 31.1.2 Email service providers (SendGrid, Mailgun, AWS SES, Postmark)
- 31.1.3 Email templates (HTML + plain text)
- 31.1.4 Template engines for emails (Handlebars, MJML)
- 31.1.5 Email queue and async sending

#### 31.2 Email Best Practices
- 31.2.1 SPF, DKIM, DMARC configuration
- 31.2.2 Bounce handling and suppression lists
- 31.2.3 Unsubscribe headers (RFC 8058)
- 31.2.4 Rate limiting and throttling
- 31.2.5 Email delivery monitoring

#### 31.3 Other Notification Channels
- 31.3.1 SMS (Twilio, Vonage)
- 31.3.2 Push notifications (FCM, APNs)
- 31.3.3 In-app notifications
- 31.3.4 Slack/Teams/Discord integrations
- 31.3.5 Notification preferences and opt-out management

---

### 32. Payments & Billing

#### 32.1 Payment Integration
- 32.1.1 Payment gateways (Stripe, PayPal, Adyen, Square)
- 32.1.2 Payment intents and checkout flows
- 32.1.3 Card tokenization and PCI compliance
- 32.1.4 3D Secure / SCA (Strong Customer Authentication)
- 32.1.5 Handling payment webhooks

#### 32.2 Subscription & Recurring Billing
- 32.2.1 Subscription plans and pricing tiers
- 32.2.2 Billing cycles and proration
- 32.2.3 Trial periods and grace periods
- 32.2.4 Upgrade/downgrade handling
- 32.2.5 Dunning (failed payment recovery)

#### 32.3 Financial Operations
- 32.3.1 Refunds and partial refunds
- 32.3.2 Invoicing and receipts
- 32.3.3 Tax calculation (Stripe Tax, TaxJar)
- 32.3.4 Multi-currency support
- 32.3.5 Accounting ledger patterns (double-entry)

---

### 33. Media Processing & Document Generation

#### 33.1 Image Processing
- 33.1.1 Resize, crop, and thumbnail generation
- 33.1.2 Format conversion (WebP, AVIF)
- 33.1.3 On-the-fly transformations (Imgproxy, Cloudinary)
- 33.1.4 Image optimization and compression

#### 33.2 Video & Audio Processing
- 33.2.1 Transcoding (FFmpeg integration)
- 33.2.2 Adaptive streaming (HLS, DASH)
- 33.2.3 Thumbnail extraction from video
- 33.2.4 Audio processing basics

#### 33.3 Document Generation
- 33.3.1 PDF generation (Puppeteer, wkhtmltopdf, WeasyPrint, iText)
- 33.3.2 Excel/spreadsheet generation (ExcelJS, OpenXML, openpyxl)
- 33.3.3 Invoice and report templates
- 33.3.4 QR code and barcode generation

---

### 34. SSR & Template Engines

#### 34.1 Server-Side Rendering
- 34.1.1 Traditional SSR (HTML generated per request)
- 34.1.2 SSR vs CSR vs SSG vs ISR
- 34.1.3 Hybrid rendering strategies
- 34.1.4 SEO benefits of SSR

#### 34.2 Template Engines by Ecosystem
- 34.2.1 Razor (.NET), Thymeleaf (Java), Jinja2 (Python)
- 34.2.2 EJS, Handlebars, Pug (Node.js)
- 34.2.3 ERB, Slim, Haml (Ruby)
- 34.2.4 Blade (PHP/Laravel)

#### 34.3 Template Features
- 34.3.1 Layouts and partials/components
- 34.3.2 Template inheritance
- 34.3.3 Helpers and filters
- 34.3.4 Auto-escaping for XSS prevention
- 34.3.5 Template caching and precompilation

---

### 35. Multi-tenancy

- 35.1 Tenant isolation strategies (database-per-tenant, schema-per-tenant, row-level)
- 35.2 Tenant identification (subdomain, header, JWT claim, path)
- 35.3 Tenant-aware middleware and request context
- 35.4 Data isolation and cross-tenant query prevention
- 35.5 Tenant-specific configuration and feature flags
- 35.6 Tenant onboarding and provisioning automation

### 36. Geospatial Features

- 36.1 Geospatial data types and storage (PostGIS, MongoDB geo)
- 36.2 Geocoding and reverse geocoding (Google Maps, Mapbox, Nominatim)
- 36.3 Spatial queries (within radius, bounding box, nearest neighbor)
- 36.4 Spatial indexing (R-tree, geohash, S2)
- 36.5 Distance calculation (Haversine formula, geodesic)
- 36.6 Map integration in APIs (GeoJSON responses)

### 37. i18n & l10n

- 37.1 Internationalization framework setup (i18next, gettext, resource files)
- 37.2 Translation file formats (JSON, PO, XLIFF, RESX)
- 37.3 Locale detection (Accept-Language header, user preference, URL)
- 37.4 Date, time, number, and currency formatting per locale
- 37.5 Timezone handling (UTC storage, user timezone conversion)
- 37.6 RTL (right-to-left) support considerations
- 37.7 Pluralization rules per language

### 38. Feature Flags & Experimentation

- 38.1 Feature flag types (boolean, percentage rollout, user segment)
- 38.2 Feature flag services (LaunchDarkly, Unleash, Flagsmith, ConfigCat)
- 38.3 Homegrown feature flags (database-backed, config-backed)
- 38.4 A/B testing infrastructure
- 38.5 Gradual rollout strategies (canary at app level)
- 38.6 Kill switches for emergency feature disable
- 38.7 Technical debt: cleaning up old feature flags

### 39. AI/ML Integration

- 39.1 Model serving endpoints (REST, gRPC)
- 39.2 LLM integration (OpenAI, Anthropic, local models)
- 39.3 Streaming AI responses (SSE for token-by-token)
- 39.4 Embeddings and vector search (pgvector, Pinecone, Weaviate)
- 39.5 RAG (Retrieval-Augmented Generation) patterns
- 39.6 AI prompt management and versioning
- 39.7 Cost tracking and token usage monitoring
- 39.8 Guardrails and content filtering

---

> **Navigation:** [← Part 6: Infrastructure](toc-2_part_6.md) | [Part 8: Operations (§40–44) →](toc-2_part_8.md)

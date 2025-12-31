Here is the bash script to generate the folder structure and Markdown files for your OpenAPI Specification study guide.

To use this:
1.  Copy the code block below.
2.  Paste it into a file named `create_oas_guide.sh` (e.g., `nano create_oas_guide.sh`).
3.  Make it executable: `chmod +x create_oas_guide.sh`.
4.  Run it: `./create_oas_guide.sh`.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="OpenAPI-Study-Guide"

# Create Root Directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

# ==========================================
# PART I: Fundamentals of API Specifications
# ==========================================
PART_DIR="001-Fundamentals-of-API-Specifications"
mkdir -p "$PART_DIR"

# File A
FILE="001-Introduction-to-API-First-and-Specification-Driven-Development.md"
echo "# Introduction to API-First and Specification-Driven Development

* The Role of a \"Contract\" in Software Development
* Contract-First vs. Code-First Approaches
* Benefits of a Machine-Readable API Definition:
    * Single Source of Truth
    * Automation (Docs, Code, Tests)
    * Parallel Development for Producers and Consumers" > "$PART_DIR/$FILE"

# File B
FILE="002-What-is-the-OpenAPI-Specification.md"
echo "# What is the OpenAPI Specification?

* A Brief History: From Swagger to the OpenAPI Initiative (OAI)
* Core Purpose: Describing RESTful (and other) HTTP APIs
* Key Distinctions: The Specification vs. The Tooling (e.g., Swagger UI)" > "$PART_DIR/$FILE"

# File C
FILE="003-The-Anatomy-of-an-OpenAPI-Document.md"
echo "# The Anatomy of an OpenAPI Document

* Formats: YAML vs. JSON (Pros and Cons)
* The Root Document Structure
* Core Metadata: \`openapi\`, \`info\`, \`servers\`" > "$PART_DIR/$FILE"

# File D
FILE="004-The-OpenAPI-Ecosystem.md"
echo "# The OpenAPI Ecosystem

* The OAI and Community
* Overview of the Tooling Landscape: Editors, Generators, Validators, Mocks" > "$PART_DIR/$FILE"


# ==========================================
# PART II: Core Concepts: Describing API Structure
# ==========================================
PART_DIR="002-Core-Concepts-Describing-API-Structure"
mkdir -p "$PART_DIR"

# File A
FILE="001-Defining-Paths-and-Operations.md"
echo "# Defining Paths and Operations

* The \`paths\` Object: Mapping URLs to Operations
* Path Templating with Parameters (e.g., \`/users/{userId}\`)
* The \`operations\` Object: \`get\`, \`put\`, \`post\`, \`delete\`, \`patch\`, \`options\`, \`head\`
* Essential Operation Metadata: \`summary\`, \`description\`, \`operationId\`, \`tags\`" > "$PART_DIR/$FILE"

# File B
FILE="002-Describing-Parameters.md"
echo "# Describing Parameters

* The Four Parameter Locations (\`in\`): \`path\`, \`query\`, \`header\`, \`cookie\`
* Common Parameter Properties: \`name\`, \`description\`, \`required\`
* Defining Parameter Data Types with \`schema\`" > "$PART_DIR/$FILE"

# File C
FILE="003-Describing-Request-Payloads.md"
echo "# Describing Request Payloads

* The \`requestBody\` Object
* The \`content\` Object and Media Types (e.g., \`application/json\`, \`application/xml\`)
* Defining the Body's Structure with \`schema\`
* Handling Different Payload Formats for the same endpoint" > "$PART_DIR/$FILE"

# File D
FILE="004-Describing-Responses.md"
echo "# Describing Responses

* The \`responses\` Object
* Mapping HTTP Status Codes (\`200\`, \`201\`, \`404\`, \`500\`) to Response Definitions
* Defining Response Bodies with \`content\` and \`schema\`
* Describing Response \`headers\` (e.g., \`Location\`, \`ETag\`, \`X-Rate-Limit-Remaining\`)" > "$PART_DIR/$FILE"


# ==========================================
# PART III: Data Modeling with Schemas
# ==========================================
PART_DIR="003-Data-Modeling-with-Schemas"
mkdir -p "$PART_DIR"

# File A
FILE="001-Introduction-to-JSON-Schema.md"
echo "# Introduction to JSON Schema

* OAS Schemas as an Extended Superset of JSON Schema
* The \`schema\` Object
* Primitive Data Types: \`string\`, \`number\`, \`integer\`, \`boolean\`" > "$PART_DIR/$FILE"

# File B
FILE="002-Defining-Complex-Data-Structures.md"
echo "# Defining Complex Data Structures

* Objects (\`type: object\`) and their \`properties\`
* Arrays (\`type: array\`) and their \`items\`
* Modeling Nested Objects and Arrays of Objects" > "$PART_DIR/$FILE"

# File C
FILE="003-Validation-and-Constraints.md"
echo "# Validation and Constraints

* String Formats: \`date\`, \`date-time\`, \`byte\`, \`binary\`, \`email\`, \`uuid\`
* Regular Expressions (\`pattern\`)
* Numeric Constraints: \`minimum\`, \`maximum\`, \`exclusiveMinimum\`
* String & Array Constraints: \`minLength\`, \`maxLength\`, \`minItems\`, \`maxItems\`, \`uniqueItems\`
* Enumerations (\`enum\`)" > "$PART_DIR/$FILE"

# File D
FILE="004-Advanced-Schema-Techniques-and-Reusability.md"
echo "# Advanced Schema Techniques and Reusability

* Composition: \`allOf\`, \`oneOf\`, \`anyOf\` for Polymorphism and Inheritance
* The \`discriminator\` Object for explicit type mapping
* Handling Nullable Values (\`nullable: true\`)
* Read-Only and Write-Only Fields (\`readOnly\`, \`writeOnly\`)
* Providing Examples (\`example\` vs. \`examples\`)" > "$PART_DIR/$FILE"


# ==========================================
# PART IV: Designing for Reusability and Organization
# ==========================================
PART_DIR="004-Designing-for-Reusability-and-Organization"
mkdir -p "$PART_DIR"

# File A
FILE="001-The-Components-Object.md"
echo "# The components Object: The Central Repository

* Purpose: Creating a Library of Reusable Definitions (DRY Principle)
* Reusable \`schemas\`
* Reusable \`parameters\`
* Reusable \`responses\`
* Reusable \`requestBodies\`
* Reusable \`headers\` and \`examples\`" > "$PART_DIR/$FILE"

# File B
FILE="002-Referencing-Components-with-Ref.md"
echo "# Referencing Components with \$ref

* Internal Document References (\`#/components/schemas/User\`)
* External File References for Splitting Large Specifications (\`./schemas/User.yaml\`)
* Best Practices for Structuring Multi-File Specifications" > "$PART_DIR/$FILE"


# ==========================================
# PART V: Describing Security
# ==========================================
PART_DIR="005-Describing-Security"
mkdir -p "$PART_DIR"

# File A
FILE="001-Declaring-Security-Schemes.md"
echo "# Declaring Security Schemes

* The \`securitySchemes\` Object within \`components\`
* Describing API Keys (\`type: apiKey\`, \`in: header | query | cookie\`)
* Describing HTTP Authentication (\`type: http\`, \`scheme: basic | bearer\`)
* Describing OAuth 2.0 (\`type: oauth2\`)
    * Defining \`flows\`: \`authorizationCode\`, \`implicit\`, \`password\`, \`clientCredentials\`
    * Defining Authorization and Token URLs
    * Defining \`scopes\`
* Describing OpenID Connect (\`type: openIdConnect\`)" > "$PART_DIR/$FILE"

# File B
FILE="002-Applying-Security-to-Operations.md"
echo "# Applying Security to Operations

* The \`security\` Requirement Object
* Applying Security Globally (Root Level)
* Overriding or Disabling Security at the Operation Level
* Specifying Required OAuth 2.0 Scopes for an Operation" > "$PART_DIR/$FILE"


# ==========================================
# PART VI: The OpenAPI Tooling Ecosystem in Practice
# ==========================================
PART_DIR="006-The-OpenAPI-Tooling-Ecosystem-in-Practice"
mkdir -p "$PART_DIR"

# File A
FILE="001-Documentation-and-Developer-Experience.md"
echo "# Documentation and Developer Experience

* Generating Interactive API Consoles: Swagger UI, ReDoc
* Static Documentation Generation
* Developer Portals and Hosted Solutions (Stoplight, ReadMe, SwaggerHub)" > "$PART_DIR/$FILE"

# File B
FILE="002-Code-Generation.md"
echo "# Code Generation

* Server-Side: Generating API Skeletons/Stubs (e.g., for Spring, Express, FastAPI)
* Client-Side: Generating SDKs and Client Libraries (e.g., for TypeScript, Java, Python)
* Using OpenAPI Generator, NSwag, and other tools" > "$PART_DIR/$FILE"

# File C
FILE="003-API-Testing-and-Validation.md"
echo "# API Testing and Validation

* Linting and Style Validation (e.g., Spectral)
* Mock Server Generation for Consumers (e.g., Prism)
* Contract Testing: Validating Implementation Against the Specification (e.g., Dredd)" > "$PART_DIR/$FILE"

# File D
FILE="004-API-Design-and-Editing.md"
echo "# API Design and Editing

* Visual Editors and IDEs (VS Code extensions, Stoplight Studio, Swagger Editor)" > "$PART_DIR/$FILE"


# ==========================================
# PART VII: Advanced & Evolving Topics
# ==========================================
PART_DIR="007-Advanced-and-Evolving-Topics"
mkdir -p "$PART_DIR"

# File A
FILE="001-Describing-Advanced-HTTP-Concepts.md"
echo "# Describing Advanced HTTP Concepts

* Links and Hypermedia (HATEOAS)
* Callbacks (for Webhooks and Asynchronous Operations)
* File Uploads (\`format: binary\` and \`multipart/form-data\`)" > "$PART_DIR/$FILE"

# File B
FILE="002-Managing-the-Specification-Lifecycle.md"
echo "# Managing the Specification Lifecycle

* Versioning the OpenAPI Document
* Documenting Deprecated Operations and Fields (\`deprecated: true\`)
* Adding Custom Metadata with Specification Extensions (\`x-\` properties)" > "$PART_DIR/$FILE"

# File C
FILE="003-The-Wider-Specification-Landscape.md"
echo "# The Wider Specification Landscape

* OAS 2.0 (Swagger) vs. OAS 3.0 vs. OAS 3.1
    * Key Changes: \`components\`, \`requestBody\`, \`callbacks\`
    * OAS 3.1's Alignment with Modern JSON Schema
* Comparison with Other Formats: RAML, API Blueprint
* The Emergence of AsyncAPI for Event-Driven Architectures" > "$PART_DIR/$FILE"

echo "Directory structure and files created successfully in '$ROOT_DIR'."
```

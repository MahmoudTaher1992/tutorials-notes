
#!/bin/bash

# Define the root directory name
ROOT_DIR="Terraform-Comprehensive-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

echo "Creating Terraform study structure in $(pwd)..."

# ==============================================================================
# Part I: Infrastructure as Code (IaC) & Terraform Fundamentals
# ==============================================================================
DIR_NAME="001-IaC-and-Terraform-Fundamentals"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Introduction-to-IaC.md"
# Introduction to Infrastructure as Code (IaC)

- Motivation and Philosophy (Managing infrastructure declaratively)
- Imperative vs. Declarative Approaches
- Benefits: Automation, Versioning, Collaboration, and Governance
- Key IaC Tools and Their Place (Terraform, CloudFormation, Ansible, Pulumi, Bicep)
- The Role of Terraform in a Modern DevOps/SRE Culture
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Introduction-to-Terraform.md"
# Introduction to Terraform

- Core Concepts: Providers, Resources, State, Plan/Apply Cycle
- The Terraform Workflow (Write, Plan, Apply, Destroy)
- Terraform's Architecture: Core & Provider Plugins
- Why Terraform? (Multi-Cloud, Large Community, Mature Ecosystem)
- Installing Terraform and Setting Up the CLI
- Configuring Cloud Provider Credentials (AWS, Azure, GCP)
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-Your-First-Terraform-Project.md"
# Your First Terraform Project

- Project Structure and File Organization (`main.tf`, `variables.tf`, `outputs.tf`)
- Writing Your First Configuration (e.g., an S3 bucket or EC2 instance)
- Running `terraform init`, `plan`, and `apply`
- Inspecting the State File (`terraform.tfstate`)
- Destroying Infrastructure with `terraform destroy`
EOF

# ==============================================================================
# Part II: HCL (HashiCorp Configuration Language) Core Syntax
# ==============================================================================
DIR_NAME="002-HCL-Core-Syntax"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-HCL-Building-Blocks.md"
# HCL Building Blocks

- Resources and Data Sources: The Core of Infrastructure Definition
- Variables: Input Variables (`variable` blocks), Type Constraints, Default Values
- Outputs: Exposing Information from Your Infrastructure
- Locals: Named Expressions for DRY (Don't Repeat Yourself) Code
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-HCL-Syntax-Deep-Dive.md"
# HCL Syntax Deep Dive

- Expressions, Types, and Literals (strings, numbers, booleans, lists, maps)
- String Interpolation and Directives
- Comments and Code Formatting (`terraform fmt`)
- Built-in Functions (string manipulation, collections, encoding, etc.)
- Dependencies: Implicit vs. Explicit (`depends_on`)
- Meta-Arguments: `provider`, `lifecycle`, `count`, `for_each`
EOF

# ==============================================================================
# Part III: Advanced HCL & Dynamic Configurations
# ==============================================================================
DIR_NAME="003-Advanced-HCL-and-Dynamic-Configurations"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Dynamic-Infrastructure.md"
# Dynamic Infrastructure

- Conditional Expressions (`condition ? true_val : false_val`)
- Looping with `count` vs. `for_each` (and when to use each)
- `for` Expressions: Transforming and Filtering Data
- The Splat Expression (`[*]`)
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Dynamic-Blocks.md"
# Dynamic Blocks

- Creating Repeatable Nested Blocks within a Resource
- Use Cases: Security Group Rules, Load Balancer Listeners, etc.
- Combining Dynamic Blocks with `for_each`
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-Expressions-and-Functions.md"
# Expressions and Functions

- Advanced Function Usage (e.g., `fileset`, `zipmap`, `try`, `can`)
- Working with Complex Data Structures (nested maps, lists of objects)
- Type Conversion Functions
- Version Constraints for Providers and Modules (`~>`, `>=`, etc.)
EOF

# ==============================================================================
# Part IV: Managing State
# ==============================================================================
DIR_NAME="004-Managing-State"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Terraform-State-Deep-Dive.md"
# Terraform State Deep Dive

- The Purpose of State: Mapping Resources to the Real World
- Inspecting State (`terraform show`, `terraform state list`)
- Why You Shouldn't Manually Edit the State File
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Remote-State-and-Collaboration.md"
# Remote State & Collaboration

- Problems with Local State Files
- Remote State Backends: S3, Azure Blob Storage, Google Cloud Storage, Terraform Cloud
- Configuring a Remote Backend
- State Locking: Preventing Concurrent Modifications
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-State-Manipulation.md"
# State Manipulation (The "Danger Zone")

- Importing Existing Infrastructure (`terraform import`)
- Moving and Renaming Resources (`terraform state mv`)
- Removing Resources from State (`terraform state rm`)
- Tainting Resources (`terraform taint`) vs. `-replace` Flag
EOF

# ==============================================================================
# Part V: Reusability with Modules
# ==============================================================================
DIR_NAME="005-Reusability-with-Modules"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Module-Basics.md"
# Module Basics

- The "Component" Model of Terraform
- Structuring a Reusable Module (inputs, outputs, resources)
- Calling a Module from a Root Configuration
- Sources: Module Registry, Git Repositories, Local Paths
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Advanced-Module-Design.md"
# Advanced Module Design

- Module Composition: Calling Modules from Other Modules
- Passing Providers Explicitly
- Best Practices for Writing Reusable and Versioned Modules
- Public vs. Private Module Registries
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-Module-Versioning-and-Management.md"
# Module Versioning and Management

- Semantic Versioning for Modules
- Pinning Module Versions for Predictable Deployments
- Strategies for Module Development and Testing
EOF

# ==============================================================================
# Part VI: Terraform Workflow & Collaboration
# ==============================================================================
DIR_NAME="006-Terraform-Workflow-and-Collaboration"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Workspaces.md"
# Workspaces (formerly Environments)

- Managing Multiple Environments (dev, staging, prod) with a Single Configuration
- Isolating State for Different Deployments
- When to Use Workspaces vs. Separate Directories/Modules
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Terraform-Cloud-and-Enterprise.md"
# Terraform Cloud & Terraform Enterprise

- Core Features: Remote State, Remote Runs, Private Module Registry, Sentinel Policies
- Collaboration and Governance Workflows
- Cost Estimation
- Comparison with Self-Hosted Solutions
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-Code-Organization-at-Scale.md"
# Code Organization at Scale

- Directory Layout Strategies (Monorepo vs. Multi-repo)
- Structuring Repositories for Multiple Applications and Environments
- Using Terragrunt for DRY Configurations and Remote State Management
EOF

# ==============================================================================
# Part VII: Providers In-Depth
# ==============================================================================
DIR_NAME="007-Providers-In-Depth"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Provider-Fundamentals.md"
# Provider Fundamentals

- How Providers Work: The API Bridge
- Provider Configuration and Authentication
- Aliased Providers (e.g., managing resources in multiple AWS regions)
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Working-with-Different-Providers.md"
# Working with Different Providers

- Cloud Providers: AWS, Azure, GCP
- Infrastructure Providers: Kubernetes, Helm, Docker
- Platform Providers: Datadog, Cloudflare, GitHub
- Versioning and Upgrading Providers
EOF

# ==============================================================================
# Part VIII: Testing, Validation, and Code Quality
# ==============================================================================
DIR_NAME="008-Testing-Validation-and-Code-Quality"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Static-Analysis-and-Validation.md"
# Static Analysis & Validation

- `terraform validate`: Syntax Checking
- `terraform fmt`: Code Formatting
- Linters and Static Analysis Tools: TFLint, Checkov, tfsec
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Testing-Strategies.md"
# Testing Strategies

- Unit & Integration Testing with the `terraform test` Framework (new in 1.6+)
- End-to-End (E2E) Testing with Tools like Terratest
- Mocking Providers and Resources for Isolated Tests
- The Testing Pyramid in an IaC Context
EOF

# ==============================================================================
# Part IX: Security & Compliance
# ==============================================================================
DIR_NAME="009-Security-and-Compliance"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Managing-Secrets.md"
# Managing Secrets

- The Problem with Hardcoded Secrets
- Using `sensitive = true` for Variables and Outputs
- Integration with Secret Managers: HashiCorp Vault, AWS Secrets Manager, Azure Key Vault
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Identity-and-Access-Management.md"
# Identity and Access Management (IAM)

- Principle of Least Privilege for Terraform's Execution Role/Principal
- Managing Cloud IAM Policies with Terraform
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-Policy-as-Code.md"
# Policy as Code

- Enforcing Governance and Best Practices
- Sentinel (Terraform Enterprise/Cloud)
- Open Policy Agent (OPA) with Conftest
- Using Tools like Checkov/tfsec in CI
EOF

# ==============================================================================
# Part X: The Broader Ecosystem & Tooling
# ==============================================================================
DIR_NAME="010-Broader-Ecosystem-and-Tooling"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Automation-and-Orchestration.md"
# Automation & Orchestration

- **Terragrunt**: Keeping Configurations DRY and Managing Remote State
- **Atlantis**: Terraform Pull Request Automation
- **Spacelift / Env0**: Alternative SaaS platforms for Terraform management
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Cost-Management.md"
# Cost Management

- **Infracost**: See Cloud Cost Estimates in a `terraform plan`
- Tagging Strategies for Cost Allocation and Reporting
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-CI-CD-Integration.md"
# CI/CD Integration

- Integrating Terraform into Jenkins, GitHub Actions, GitLab CI, etc.
- Structuring Pipelines for `plan` and `apply` Stages
- PR/MR Comments with Plan Output
EOF

# ==============================================================================
# Part XI: Extending Terraform
# ==============================================================================
DIR_NAME="011-Extending-Terraform"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Custom-Provider-Development.md"
# Custom Provider Development

- The Provider Development Lifecycle
- Writing a Provider with the Go Plugin Framework
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Terraform-CDK.md"
# Terraform CDK (Cloud Development Kit)

- Writing Terraform Configurations in TypeScript, Python, Go, etc.
- Benefits and Trade-offs vs. HCL
- Use Cases and Target Audience
EOF

# ==============================================================================
# Part XII: Production Patterns & Best Practices
# ==============================================================================
DIR_NAME="012-Production-Patterns-and-Best-Practices"
mkdir -p "$DIR_NAME"

# Section A
cat <<'EOF' > "$DIR_NAME/001-Advanced-State-Management.md"
# Advanced State Management

- State Splitting Strategies (by environment, by component)
- Disaster Recovery for State Files
EOF

# Section B
cat <<'EOF' > "$DIR_NAME/002-Refactoring-and-Upgrades.md"
# Refactoring & Upgrades

- Safely Refactoring Large Terraform Codebases
- Managing Terraform Version Upgrades (`terraform 0.13upgrade`, etc.)
- Provider Version Upgrade Strategies
EOF

# Section C
cat <<'EOF' > "$DIR_NAME/003-Performance-and-Optimization.md"
# Performance & Optimization

- Parallelism and Graph Theory (`-parallelism=n`)
- Reducing Plan/Apply Times in Large Configurations
- Caching Provider Plugins
EOF

echo "Done! Directory structure created in $ROOT_DIR"


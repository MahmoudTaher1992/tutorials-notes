Mastering Terraform
Find the interactive version of this
roadmap and other similar roadmaps
roadmap.sh

## Part I: Introduction to Infrastructure as Code & Terraform Fundamentals

### A. Introduction to Infrastructure as Code (IaC)
- What is IaC? Principles and Benefits
- Declarative vs. Imperative Approaches
- Idempotency in IaC
- Configuration as Code (CaC) vs. IaC: Key Differences
- Evolution of IaC: Scripting, Configuration Management, Orchestration

### B. Understanding Terraform
- What is Terraform? Core Concepts and Architecture
- Key Use Cases and Benefits of Terraform
  - Multi-Cloud Infrastructure Provisioning
  - Environment Standardization and Disaster Recovery
  - Immutable Infrastructure
  - Self-Service Infrastructure
- Terraform vs. Other IaC Tools (Ansible, Pulumi, CloudFormation)
- Installing Terraform CLI
  - Manual Installation (Linux, macOS, Windows)
  - Using Version Managers (e.g., `tfenv`)
- Terraform Workflow: Write, Plan, Apply

### C. HashiCorp Configuration Language (HCL)
- What is HCL? Purpose and Structure
- Basic HCL Syntax
  - Blocks, Arguments, and Expressions
  - Data Types: Strings, Numbers, Booleans, Lists, Maps, Objects, Sets
  - Operators and Functions
  - Comments
- Terraform Configuration File Structure (`.tf` files)

### D. Providers and Project Initialization
- Terraform Providers: What they are and their role
- Terraform Registry: Public vs. Private Registries
- Configuring Providers
  - `provider` Block Syntax
  - Specifying Provider Versions (`required_providers`)
  - Provider Aliases for Multiple Configurations
  - Authentication Methods for Providers
- Project Initialization: `terraform init`
  - Downloading Providers
  - Backend Configuration Initialization
  - Module Installation

## Part II: Core Configuration Language & Resource Management

### A. Resources
- Resource Blocks: Defining Infrastructure Objects
- Resource Behavior: Create, Read, Update, Delete (CRUD) Operations
- Implicit vs. Explicit Dependencies
- Meta-Arguments:
  - `depends_on`: Managing Explicit Dependencies
  - `count`: Creating Multiple Identical Resources
  - `for_each`: Creating Resources from Maps or Sets
  - `provider`: Specifying Non-Default Provider Configurations
  - `lifecycle` Block:
    - `create_before_destroy`
    - `prevent_destroy`
    - `ignore_changes`
    - `replace_triggered_by`

### B. Input Variables
- Defining Input Variables (`variable` Block)
  - `description`
  - `type` Constraints (string, number, bool, list, map, object, set)
  - `default` Values
  - `sensitive` Flag
  - `nullable` Argument
- Passing Variable Values
  - Command Line Arguments (`-var`)
  - Variable Definition Files (`.tfvars`, `*.auto.tfvars`)
  - Environment Variables (`TF_VAR_`)
- Custom Validation Rules for Variables

### C. Local Values
- The `locals` Block
- Defining and Using Local Values
- Benefits: Simplifying Expressions, Improving Readability

### D. Output Values
- Defining Output Values (`output` Block)
- Accessing Resource Attributes and Local Values
- `sensitive` Flag for Protecting Output Data
- Use Cases: Sharing Information between Configurations, Displaying Key Infrastructure Details

### E. Data Sources
- Querying Existing Infrastructure (`data` Block)
- Examples: Fetching AMIs, VPCs, DNS Records, Remote State
- The `terraform_remote_state` Data Source

### F. File System & Templating Functions
- `file` Function: Reading Content from Files
- `templatefile` Function: Rendering Dynamic Configuration Files

## Part III: Terraform CLI Workflow & State Management

### A. Core CLI Commands
- `terraform fmt`: Formatting Configuration Files
- `terraform validate`: Validating Configuration Syntax and Semantics
- `terraform plan`: Generating and Reviewing Execution Plans
  - Understanding the Plan Output
  - Outputting Plans to File (`-out`)
  - Generating JSON Plans
- `terraform apply`: Applying Configuration Changes
  - Auto-Approval (`-auto-approve`)
  - Targeting Specific Resources (`-target`)
- `terraform destroy`: Tearing Down Infrastructure
  - Prompting for Confirmation
  - Targeting Specific Resources (`-target`)
- `terraform console`: Interactive Console for HCL Expressions

### B. State Management Fundamentals
- What is Terraform State?
- Purpose and Importance of the State File
- Local State (`terraform.tfstate`)
- State File Structure and Contents
- Best Practices for State Management
  - Limiting State File Size
  - Access Control and Permissions

### C. Remote State Backends
- Why Use Remote State? Benefits and Challenges
- Configuring Remote State (`backend` Block)
- Popular Remote Backends:
  - AWS S3
  - Azure Blob Storage
  - Google Cloud Storage
  - HashiCorp Cloud Platform (HCP)
  - HashiCorp Consul
- State Locking: Preventing Concurrent Modifications
- State Versioning (Supported by Backends)

### D. Advanced State Manipulation
- `terraform state list`: Listing Resources in State
- `terraform state show`: Displaying Resource Details from State
- `terraform state rm`: Removing Resources from State (without destroying them)
- `terraform state mv`: Moving Resources within State
- `terraform import`: Importing Existing Infrastructure into Terraform State
- `terraform state pull / push`: Manual State Operations (for debugging/recovery)
- `terraform state replace-provider`: Changing Provider Configuration in State
- `terraform state force-unlock`: Resolving Stuck State Locks
- The `-replace` Option with `terraform apply`

## Part IV: Modules & Reusability

### A. Understanding Modules
- What are Terraform Modules?
- Root Modules vs. Child Modules
- Benefits of Using Modules: Reusability, Organization, Encapsulation

### B. Consuming Modules
- Module Sources:
  - Local Path Modules
  - Terraform Registry Modules
  - Git Modules (GitHub, GitLab, Bitbucket)
  - S3 Bucket Modules
- Specifying Module Versions
- Passing Inputs to Modules
- Accessing Outputs from Modules

### C. Creating Your Own Modules
- Module Structure: `main.tf`, `variables.tf`, `outputs.tf`
- Defining Module Inputs (`variable` blocks within the module)
- Defining Module Outputs (`output` blocks within the module)
- Module Best Practices:
  - Single Responsibility Principle
  - Clear Input/Output Definitions
  - Versioning Your Modules
  - Testing Modules

## Part V: Provisioners & Advanced Features

### A. Provisioners
- When to Use Provisioners: Use Cases and Anti-Patterns
- Types of Provisioners:
  - `file` Provisioner: Copying Files to Remote Resources
  - `local-exec` Provisioner: Executing Commands on the Local Machine
  - `remote-exec` Provisioner: Executing Commands on Remote Resources (SSH, WinRM)
- `when` Argument: `create`, `destroy`
- `on_failure` Argument: `continue`, `fail`
- Considerations and Alternatives (Cloud-init, Configuration Management Tools)

### B. Workspaces
- `terraform workspace`: Managing Multiple Environments with a Single Configuration
- `new`, `select`, `show`, `list`, `delete` Commands
- Use Cases and Limitations of Workspaces

### C. Graphing and Visualization
- `terraform graph`: Generating a Visual Dependency Graph
- Interpreting the Graph Output
- Tools for Graph Visualization (Graphviz)

### D. Tainting Resources
- `terraform taint`: Forcing a Resource to be Recreated
- `terraform untaint`: Removing a Taint

## Part VI: CI/CD Integration, Testing & Scaling

### A. CI/CD Integration
- Automating Terraform in CI/CD Pipelines
- Common CI/CD Platforms:
  - GitHub Actions: Example Workflows, OIDC Authentication
  - GitLab CI/CD: Pipeline Configuration, Caching
  - CircleCI: Orb Integration
  - Jenkins: Pipeline Stages for Terraform
- Best Practices for CI/CD:
  - Automated `plan` on Pull Requests
  - Manual Approval for `apply`
  - Managing Secrets in CI/CD

### B. Testing Terraform Configurations
- Why Test Terraform?
- Types of Testing:
  - Unit Testing (e.g., `terraform test` framework, Terratest with Go)
  - Integration Testing (Deploying small-scale infrastructure, asserting state)
  - End-to-End Testing (Full deployment and validation)
- Testing Frameworks and Tools:
  - `terraform test` (Built-in framework in Terraform CLI)
  - Terratest (Go library for infrastructure testing)
  - Policy as Code Tools for Pre-Deployment Checks

### C. Scaling Terraform for Large Infrastructures
- Strategies for Splitting Large State Files
  - Directory-based Organization
  - Leveraging Modules and Workspaces Effectively
- Parallelism in Terraform (`-parallelism` flag)
- Deployment Workflows: GitOps Principles for Infrastructure
- Orchestration Tools:
  - Terragrunt: DRY (Don't Repeat Yourself) principle, Remote State Management
  - Atlantis: GitOps Workflow Automation

### D. Cost Estimation & Optimization
- Infracost: Integrating Cost Estimation into CI/CD
- Budgeting and Forecasting for Infrastructure Costs

## Part VII: Security, Compliance & Advanced Ecosystem

### A. Secret Management
- Handling Sensitive Data in Terraform
- Integration with Secret Management Tools:
  - HashiCorp Vault
  - AWS Secrets Manager
  - Azure Key Vault
  - Google Secret Manager

### B. Security and Compliance (Policy as Code)
- Importance of Security in IaC
- Static Analysis Tools for Terraform:
  - Checkov
  - Terrascan
  - KICS (Keeping Infrastructure as Code Secure)
- HashiCorp Sentinel: Policy as Code Framework for Terraform Enterprise/HCP
  - Defining Policies
  - Enforcement Levels

### C. HashiCorp Cloud Platform (HCP) Terraform (formerly Terraform Cloud/Enterprise)
- What is HCP Terraform? Managed Service for Terraform Workflows
- Benefits: Remote Operations, State Management, Collaboration
- Enterprise Features:
  - Version Control System (VCS) Integration (GitHub, GitLab, Bitbucket)
  - Workspaces (HCP Workspaces vs. CLI Workspaces)
  - Remote Runs and Run Tasks (Pre/Post-plan/apply hooks)
  - Team Management and Role-Based Access Control (RBAC)
  - Private Module Registry
  - Cost Estimation and Governance

### D. Terraform Version Management
- Managing Terraform CLI Versions (`tfenv`, manual updates)
- Pinning Provider Versions (`required_providers`)
- Versioning Custom Modules

### E. Monitoring and Observability
- Integrating Terraform with Monitoring Solutions
- Exporting Metrics and Logs from Managed Resources

### F. Disaster Recovery & Backup
- Strategies for Backing Up Terraform State
- Rebuilding Infrastructure in a Disaster Scenario
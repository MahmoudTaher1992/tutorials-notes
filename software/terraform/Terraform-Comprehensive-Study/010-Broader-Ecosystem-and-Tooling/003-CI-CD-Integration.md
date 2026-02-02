Here is a detailed explanation of **Part X, Section C: CI/CD Integration** from the ecosystem tooling module.

---

# 010-Broader-Ecosystem-and-Tooling / 003-CI-CD-Integration

This section moves Terraform from "running locally on your laptop" to "enterprise-grade automation."

In a professional setting, relying on individual engineers to run `terraform apply` from their local command line is risky (version mismatches, lack of audit trails, credential leakage). **CI/CD Integration** involves setting up automated pipelines using tools like GitHub Actions, GitLab CI, or Jenkins to manage the Terraform lifecycle.

Here is the breakdown of the three key concepts listed in that section.

---

## 1. Integrating Terraform into Jenkins, GitHub Actions, GitLab CI, etc.

The goal here is **GitOps**. You want your infrastructure changes to be treated exactly like application code changes: committed to Git, peer-reviewed, tested, and automatically deployed.

### Why do this?
*   **Consistency:** The CI environment is the "source of truth." It always uses the same Terraform version, the same OS, and the same credentials.
*   **Security:** Developers don't need direct write access (Administrator access) to the AWS/Azure/GCP cloud console. Only the CI runner needs those credentials.
*   **Audit Trail:** You see exactly who merged a change, when it ran, and the logs of what resources were created.

### How it works (General steps):
Regardless of the tool (Jenkins/GitLab/GitHub), the process usually involves:
1.  **Container/Runner:** The CI system spins up a Docker container (usually a Linux image) that has the Terraform CLI and Cloud CLI (e.g., AWS CLI) installed.
2.  **Authentication:** The CI system injects credentials (via Environment Variables like `AWS_ACCESS_KEY_ID`) so Terraform can talk to the cloud provider. *Modern approach: Use OIDC (OpenID Connect) to avoid long-lived access keys.*
3.  **Execution:** The CI script runs standard commands: `terraform init` -> `terraform plan`.

---

## 2. Structuring Pipelines for `plan` and `apply` Stages

This is the most critical part of the architecture. You cannot simply run `terraform apply` every time someone pushes code, or you might destroy production infrastructure by accident.

The industry-standard pattern is the **Plan-Review-Apply workflow**.

### A. The "Pull Request" (PR) Workflow (Continuous Integration)
This pipeline triggers when a developer creates a Pull Request (or Merge Request). This stage is **Read-Only**.

1.  **Checkout Code:** Get the Terraform code.
2.  **Formatting & Validation:** Run `terraform fmt -check` and `terraform validate` to ensure code styles match.
3.  **Security Scans:** Run tools like `checkov` or `tfsec` to catch misconfigurations (e.g., "You left an S3 bucket open to the public").
4.  **The Plan:** Run `terraform plan -out=tfplan`.
    *   This generates a speculative plan showing what *would* happen if merged.
    *   It **does not** modify any infrastructure.

### B. The "Main Branch" Workflow (Continuous Deployment)
This pipeline triggers **only** after the PR is reviewed and merged into the `main` (or `master`) branch.

1.  **Checkout Code:** Get the merged code.
2.  **Init:** Run `terraform init`.
3.  **Apply:** Run `terraform apply -auto-approve`.
    *   This actually modifies the cloud resources.

### The "Plan File" Best Practice
Use the `-out` flag.
*   **Wrong:** Run `plan` on the PR. Merge. Run `apply` on Main.
    *   *Risk:* In the seconds between the PR plan and the Main apply, someone else might have changed the infrastructure, making the apply invalid or dangerous.
*   **Right:** The Main workflow should ideally re-run the plan or load a saved plan artifact to strictly confirm the state matches before apply.

---

## 3. PR/MR Comments with Plan Output

One of the biggest pain points in CI/CD is that Jenkins/GitHub logs are hard to read. A developer shouldn't have to dig through 5,000 lines of console logs to see if Terraform is adding 1 resource or destroying a database.

**The Solution:** Automate a bot to post the `terraform plan` summary directly onto the Pull Request conversation.

### How it looks nicely
When you open a PR, a bot comments:

> **Terraform Plan:**
> 🟢 **14 to add**, 🟡 **2 to change**, 🔴 **0 to destroy**.
> <details><summary>Click to view details</summary>
>
> ... (Detailed log of changes) ...
>
> </details>

### How to implement this
1.  **Generate the Plan:** run `terraform plan -no-color > plan.txt`
2.  **Scripting:** Use a utility (like a simple Python script or the `actions/github-script` in GitHub Actions).
3.  **API Call:** The script reads `plan.txt` and uses the GitHub/GitLab API to post a comment on the specific Issue/PR ID.

### Alternatives
Instead of building this manually in Jenkins/GitHub Actions, this is where tools like **Atlantis** come in.
*   **Atlantis (Pull Request Automation):** A specialized tool that runs as a server. When you type `atlantis plan` in a GitHub comment, Atlantis runs the plan and replies with the output automatically. When you type `atlantis apply`, it applies it and merges the PR. This is commonly referred to as **ChatOps**.

---

## Summary Implementation Example (GitHub Actions YAML)

Here is a simplified example of how this looks in code (`.github/workflows/terraform.yml`):

```yaml
name: "Terraform Infrastructure"

on:
  push:
    branches: [ main ] # Triggers 'Apply'
  pull_request: # Triggers 'Plan'

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Init
        run: terraform init

      # ONLY RUN ON PULL REQUEST
      - name: Terraform Plan
        if: github.event_name == 'pull_request'
        run: terraform plan -no-color
        # Note: In a real setup, you would pipe this output 
        # to a PR comment bot here.

      # ONLY RUN ON MERGE TO MAIN
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve
```

#!/bin/bash

# Define the root directory name
ROOT_DIR="AWS-Identity-Architecture-Study"

# Create the root directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

# ==============================================================================
# PART 1: The Environment Scope: AWS Organizations
# ==============================================================================
PART_DIR="001-The-Environment-Scope-AWS-Organizations"
mkdir -p "$PART_DIR"

# -- Section A: The Management Account --
FILE_NAME="001-The-Management-Account.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# The Management Account

*   **Root of Trust:** Why Identity Center must be enabled in the Management Account (or a Delegated Administrator account).
*   **Service Control Policies (SCPs):** The difference between Organization-level guardrails and Identity Center permissions.
EOF

# -- Section B: Multi-Account Strategy --
FILE_NAME="002-Multi-Account-Strategy.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# Multi-Account Strategy

*   **The Hierarchy:** Applying access to Dev, Staging, and Prod accounts centrally from one place.
*   **Member Accounts:** How Identity Center pushes roles into downstream accounts automatically.
EOF

# ==============================================================================
# PART 2: AWS IAM Identity Center (The Engine)
# ==============================================================================
PART_DIR="002-AWS-IAM-Identity-Center"
mkdir -p "$PART_DIR"

# -- Section A: Service Evolution --
FILE_NAME="001-Service-Evolution.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# Service Evolution

*   **SSO vs. Identity Center:** Understanding that "AWS SSO" was renamed; the underlying technology remains the same.
EOF

# -- Section B: Identity Source Configuration --
FILE_NAME="002-Identity-Source-Configuration.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# Identity Source Configuration

*   **Changing the Source:** Switching from "Identity Center Directory" to "External Identity Provider" (SAML 2.0).
*   **The Metadata Exchange:**
    *   Importing the IdP Metadata (from Google/Okta).
    *   Exporting the SP Metadata (ACS URL & Entity ID) to give to the IdP.
EOF

# -- Section C: Provisioning Settings --
FILE_NAME="003-Provisioning-Settings.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# Provisioning Settings

*   **Manual vs. SCIM:** Deciding whether to manually create users in AWS to match the IdP or enable automatic SCIM provisioning (recommended).
EOF

# ==============================================================================
# PART 3: Authorization Strategy: Permission Sets
# ==============================================================================
PART_DIR="003-Authorization-Strategy-Permission-Sets"
mkdir -p "$PART_DIR"

# -- Section A: Permission Sets vs IAM Roles --
FILE_NAME="001-Permission-Sets-vs-IAM-Roles.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# Permission Sets vs IAM Roles

*   **The Concept:** A Permission Set is a *template* that AWS uses to deploy standard IAM Roles into specific accounts.
*   **Abstraction:** You manage the *Set*, AWS manages the *Trust Policy* and *Role creation*.
EOF

# -- Section B: Defining Policies --
FILE_NAME="002-Defining-Policies.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# Defining Policies

*   **Managed Policies:** Attaching AWS Pre-defined policies (e.g., \`AdministratorAccess\`, \`ViewOnlyAccess\`).
*   **Inline Policies:** Writing custom JSON for granular access requirements.
EOF

# -- Section C: The Mapping Logic (The Core Task) --
FILE_NAME="003-The-Mapping-Logic.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# The Mapping Logic (The Core Task)

*   **Group-Based Assignment:** Assigning the "GCP-Dev-Group" to the "Developer Permission Set" on the "AWS-Dev-Account."
*   **Least Privilege:** Strategies for creating different Permission Sets for different environments (e.g., ReadOnly in Prod, Admin in Dev).
EOF

# ==============================================================================
# PART 4: The End-User Experience & Verification
# ==============================================================================
PART_DIR="004-The-End-User-Experience-and-Verification"
mkdir -p "$PART_DIR"

# -- Section A: The AWS Access Portal --
FILE_NAME="001-The-AWS-Access-Portal.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# The AWS Access Portal

*   **The Start URL:** The specific endpoint (e.g., \`https://<your-id>.awsapps.com/start\`) where the flow begins.
*   **IdP Redirection:** Verifying the browser redirects to the External IdP (Google) for authentication.
EOF

# -- Section B: Acceptance Criteria (Verification) --
FILE_NAME="002-Acceptance-Criteria.md"
FILE_PATH="$PART_DIR/$FILE_NAME"
echo "Creating $FILE_PATH..."
cat <<EOF > "$FILE_PATH"
# Acceptance Criteria (Verification)

*   **Successful Login:** User lands on the AWS Portal dashboard after authenticating with the IdP.
*   **Account Visibility:** User sees *only* the AWS accounts they are assigned to.
*   **Role Assumption:** Clicking an account successfully opens the AWS Console with the correct Federated Role active.
EOF

echo "=========================================="
echo "Structure created successfully inside: $(pwd)"
echo "=========================================="

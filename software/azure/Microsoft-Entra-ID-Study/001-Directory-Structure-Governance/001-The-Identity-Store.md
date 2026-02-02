# The Identity Store (Entra ID)

*Goal: Organizing the "Source of Truth" users and groups for external mapping.*

## Key Concepts
*   **i. Users:** The atomic units. Understanding Hybrid identities (synced from on-prem AD via Azure AD Connect) vs. Cloud-only users.
*   **ii. Security Groups:** The crucial mechanism for Role Mapping. Strategy: Create specific groups (e.g., `AWS-Production-Admins`, `AWS-Dev-ViewOnly`) to map 1:1 with downstream permissions.
*   **iii. [NEW] Dynamic Memberships:** Automating group entry based on attributes (e.g., `user.department -eq "Engineering"` automatically adds user to `AWS-Dev-Group`).

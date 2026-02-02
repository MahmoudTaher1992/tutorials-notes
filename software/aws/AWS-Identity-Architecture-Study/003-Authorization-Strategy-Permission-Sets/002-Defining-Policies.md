Based on the Table of Contents provided, you are looking at **Section 3, Part B: Defining Policies**. This section acts as the bridge between the "Template" (The Permission Set) and the actual "Power" (The ability to touch AWS resources).

Here is a detailed explanation of **Defining Policies** within AWS IAM Identity Center.

---

# 3.B. Defining Policies

In AWS Identity Center, a **Permission Set** is just an empty container—a shell of a Role. **Defining Policies** is the act of filling that container with rules. It answers the question: *"Once this user logs in, exactly what actions are they allowed to perform?"*

There are two primary ways to fill this container, as outlined in your TOC: **Managed Policies** and **Inline Policies**.

## i. Managed Policies (The "Pre-Fab" Approach)
**Managed Policies** are pre-built permission structures created and maintained by AWS. They are designed to cover common job functions without requiring you to write code.

*   **How it works:** You browse a list of hundreds of pre-existing policies provided by AWS and simply check a box to attach them to your Permission Set.
*   **The "Updated by AWS" Benefit:** This is the biggest advantage. If AWS releases a new service or feature that falls under the scope of a Managed Policy, AWS automatically updates the policy. You don't have to go back and edit it.
*   **Common Examples:**
    *   **`AdministratorAccess`:** The "God-mode" policy. Allows full access to everything. Usually reserved for the CloudOps team.
    *   **`ViewOnlyAccess`:** Allows users to look at configurations and data but prevents them from changing, deleting, or creating anything. Great for auditors or junior trainees.
    *   **`PowerUserAccess`:** Allows full access to services (like creating servers and databases) but forbids changes to User Management (IAM). This is very common for Senior Developers.
    *   **`AmazonS3FullAccess`:** Grants full control over simple storage (S3) but nothing else.

**When to use it:**
Use Managed Policies for broad, distinct roles where standard AWS definitions act as a "good enough" baseline (e.g., "This user is an Admin," or "This user is a Viewer").

---

## ii. Inline Policies (The "Custom Tailored" Approach)
Sometimes, AWS Managed Policies are too broad (giving too much access) or too generic. **Inline Policies** allow you to write custom JSON code to define highly specific, granular rules.

*   **The Concept:** You explicitly write a JSON document consisting of statements that define the **Effect** (Allow/Deny), the **Action** (e.g., `s3:ListBucket`), and the **Resource** (e.g., `arn:aws:s3:::my-financial-data`).
*   **1:1 Relationship:** Unlike a Managed Policy, which can be shared across many different roles, an Inline Policy exists *only* inside the Permission Set where you wrote it. It is strictly coupled to that specific set.
*   **Strict Control (Least Privilege):** This is the best tool for security compliance. You don't want to give a developer full access to S3 (`AmazonS3FullAccess`); you only want them to access *one specific bucket* for their project.

**Example Scenario:**
You have a contractor who needs to restart a specific server, but they should not be allowed to terminate (delete) it, nor should they see any other servers.

**The Inline Policy JSON would look like this:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:RebootInstances",
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "arn:aws:ec2:us-east-1:123456789012:instance/i-0abcdef1234567890"
        }
    ]
}
```

**When to use it:**
Use Inline Policies when you need to enforce **Least Privilege**. This is required when standard AWS policies are too permissive or when you need to restrict access based on specific conditions (like prohibiting access unless the user is on the corporate VPN).

---

### Summary: How they work together

AWS allows you to **mix and match** specific to Section 3.B.

You can create a "Developer Permission Set" that contains:
1.  **Managed Policy:** `ViewOnlyAccess` (So they can see everything in the account).
2.  **Inline Policy:** A custom JSON snippet that allows them to `Create` and `Delete` Lambda functions *only*.

This combination creates a role that can look at the whole house, but can only renovate the kitchen.

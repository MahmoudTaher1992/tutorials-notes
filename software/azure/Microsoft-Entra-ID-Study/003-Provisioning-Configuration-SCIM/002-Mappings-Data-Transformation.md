Based on the Table of Contents you provided, here is a detailed explanation of section **3.B. Mappings (Data Transformation)**.

In the context of SCIM (System for Cross-domain Identity Management), "Mappings" act as the **translation dictionary** between your Identity Provider (Entra ID) and the Service Provider (AWS IAM Identity Center).

Entra ID stores user data in a specific way, and AWS expects data in a specific standard. This section configures how those two talk to each other.

---

### i. Attribute Mapping: The Wiring
This configuration controls exactly which piece of data moves from Microsoft to AWS. It is rarely a simple "copy-paste"; it requires defining the relationship between fields.

There are three ways to map an attribute:

#### 1. Direct Mapping
This is the simplest form. You take a field from Entra ID and push it directly into a standard SCIM field.
*   **Logic:** Value X = Value Y
*   **Example:**
    *   **Source (Entra ID):** `user.givenName` (e.g., "Sarah")
    *   **Target (AWS SCIM):** `name.givenName` (e.g., "Sarah")

#### 2. Constant Mapping
This forces a static value for *every* user, regardless of who they are.
*   **Logic:** Every user = "Value Z"
*   **Example:**
    *   **Target (AWS SCIM):** `urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeType`
    *   **Constant Value:** "Employee"
    *   *Result:* Every user created in AWS is tagged as "Employee", even if Entra ID doesn't have that data.

#### 3. Expression Mapping (Data Transformation)
This is the advanced part mentioned in your TOC Item `3-B-i`. Sometimes the data in Entra ID is formatted incorrectly for AWS, or you need to combine two fields. You use code-like expressions to fix the data *before* it leaves Microsoft.

*   **Example 1: Combining Names**
    *   **Goal:** AWS wants a "Display Name" that looks like "Last Name, First Name".
    *   **Expression:** `Join(", ", [surname], [givenName])`
    *   **Result:** A user named "Alice" "Smith" becomes "Smith, Alice" in AWS.

*   **Example 2: The Extension Attribute (Your TOC Example)**
    *   **Context:** `Connecting Entra ID fields (Run on premises extensionAttribute1) to SCIM fields (externalId)`
    *   **The Problem:** Emails change (e.g., user gets married). If you match users based on Email, a name change breaks the link.
    *   **The Solution:** You use an **Immutable ID**. In a Hybrid environment (On-Prem Active Directory -> Entra ID), you might have a unique Employee ID stored in `extensionAttribute1`.
    *   **The Mapping:**
        *   **Source:** `extensionAttribute1` (e.g., "12345")
        *   **Target:** `externalId` (AWS uses this as the unique anchor).
    *   **Benefit:** Even if the user changes their name and email to `new.name@company.com`, AWS knows it is still User `12345` and keeps their permissions intact.

---

### ii. Matching Precedence: The specific "Link" logic
This section (TOC Item `3-B-ii`) is critical for **preventing duplicate users** and creates the logic for determining "Who is who."

When Entra ID runs the provisioning job, it looks at a user in its database and asks: *"Does this person already exist in AWS?"*

Matching Precedence defines how it answers that question.

#### 1. How it works
You define a specific attribute as the **Matching Attribute**.
1.  Entra ID takes the user `john.doe@variable.com`.
2.  It looks at the Provisioning Rule. The rule says: "Match objects using this attribute."
3.  Entra query logic: "AWS, do you have a user where `userName` equals `john.doe@variable.com`?"

#### 2. The Outcomes
Based on the precedence check, one of three things happens:

*   **Match Found (Update):** Entra ID finds "John Doe" in AWS. It simply **updates** any attributes that have changed (e.g., John moved from the Sales Dept to Marketing). **No new user is created.**
*   **No Match Found (Create):** Entra ID confirms the user does not exist. It sends a request to **create** a fresh user in AWS.
*   **Conflict:** If the mapping is configured poorly (e.g., matching on "First Name"), it might link the wrong Entra user to the wrong AWS user.

#### 3. Priority Levels (Precedence)
You can set multiple matching rules with a priority order (1, 2, 3).

*   **Priority 1:** "Check `EmployeeID` first."
    *   *If match found:* Stop and update.
    *   *If no match:* Go to Priority 2.
*   **Priority 2:** "Check `Email Address`."
    *   *If match found:* Link them and update.
    *   *If no match:* Create new user.

### Why is this section vital for AWS?
If you mess up **Mappings**, user data appears corrupted in AWS (e.g., phone numbers in the name field).

If you mess up **Matching Precedence**, you might accidentally delete existing AWS users, create duplicates of the same person, or fail to sync users entirely because AWS reports "User already exists."

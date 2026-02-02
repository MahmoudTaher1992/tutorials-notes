Based on the Table of Contents, **Part VII: Security Architecture - Section A (Core Security Principles)** is arguably the most important section to internalize. Before you buy a firewall or write a single line of authentication code, you must understand *why* you are securing the system and *what* you are protecting.

Here is a detailed breakdown of the concepts found in **001-Core-Security-Principles.md**.

---

# 001-Core-Security-Principles.md: Detailed Explanation

This module covers the "Philosophy of Security." As a Software Architect, you cannot rely solely on tools (like antivirus or firewalls) to secure a system. You must design security into the architecture itself ("Security by Design").

## 1. The CIA Triad
The CIA Triad is the industry-standard model for determining security policies. Every security decision you make involves balancing these three pillars.

### **C** - Confidentiality
**Definition:** Ensuring that information is not made available or disclosed to unauthorized individuals, entities, or processes.
*   **The Goal:** "Only the right people can **read** the data."
*   **Architectural Mechanisms:**
    *   **Encryption:** Encrypting data at rest (database) and in transit (HTTPS/TLS) so that if stolen, it is unreadable.
    *   **Access Controls:** MFA (Multi-Factor Authentication).
*   **Example:** A user’s medical records should only be visible to the patient and their doctor.

### **I** - Integrity
**Definition:** Maintaining the accuracy and completeness of data. Ensuring data cannot be modified in an unauthorized or undetected manner.
*   **The Goal:** "Only the right people can **write/change** the data, and we know if it was tampered with."
*   **Architectural Mechanisms:**
    *   **Hashing/Signatures:** Using checksums to ensure a file hasn't been altered during download.
    *   **Database Constraints:** Preventing invalid data entry.
    *   **Version Control:** Keeping a history of changes.
*   **Example:** A bank balance should not change unless a valid transaction occurs.

### **A** - Availability
**Definition:** Ensuring that authorized users have access to information and associated assets when required.
*   **The Goal:** "The system is **up and running** when needed."
*   **Architectural Mechanisms:**
    *   **Redundancy:** Having backup servers.
    *   **DDoS Protection:** Preventing attackers from overwhelming the server.
    *   **Load Balancing:** Distributing traffic so no single server crashes.
*   **Example:** If Amazon is "secure" but the website is down on Black Friday, the business fails.

> **Architectural Trade-off:** Increasing **Confidentiality** (complex passwords, strict firewalls) often decreases **Availability** (harder to login) or usability. The architect's job is to balance this triad based on business needs.

---

## 2. Defense in Depth (DiD)
Also known as the "Layered Security" approach.

**The Concept:**
Never rely on a single defensive mechanism. If one layer fails, another should be standing behind it to stop the attack. Think of a medieval castle: it has a moat, a drawbridge, an outer wall, an inner wall, and guards.

**The Layers (From Outside In):**
1.  **Physical Layer:** Data center security, guards, locked server racks.
2.  **Perimeter Layer:** DDoS protection, Firewalls at the network edge.
3.  **Network Layer:** Network segmentation (VLANs), Jump boxes (Bastion hosts).
4.  **Compute/Host Layer:** OS patching, Antivirus, Endpoint detection.
5.  **Application Layer:** Code security, Input validation, Authentication (Login).
6.  **Data Layer:** Encryption at rest, Database masking.

**Why it matters to Architects:**
If you build an API, you cannot assume the Firewall will catch everything. You must *also* validate input in your code and encrypt the data in the database.

---

## 3. Principle of Least Privilege (PoLP)
This is the foundation of **Zero Trust** architecture.

**The Concept:**
A subject (user, process, or program) should be given only those privileges needed for it to complete its task—and no more.

**In Practice:**
*   **Humans:** A Junior Developer should not have "Admin" access to the Production Database. They should only have "Read" access to the Development Database.
*   **Machines:** If Microservice A only needs to *read* User Profiles from the database, the database credentials it uses should **not** have the ability to *delete* tables or *drop* the database.

**Why it matters:**
This limits the **Blast Radius**. If a hacker steals the credentials of Microservice A, they can only read profiles. They cannot delete the entire database because the credentials didn't have that permission in the first place.

---

## 4. Threat Modeling (STRIDE)
Threat modeling is a structured process of identifying potential security threats during the **design phase** (before you write code). The most common framework used by Microsoft and architects is **STRIDE**.

You look at every component in your architecture diagram and ask: "Is it vulnerable to..."

*   **S - Spoofing:** Can an attacker pretend to be someone else?
    *   *Solution:* Strong Authentication (MFA, API Keys, Digital Signatures).
*   **T - Tampering:** Can an attacker modify data in transit or on disk?
    *   *Solution:* Integrity checks (HMAC), HTTPS integrity.
*   **R - Repudiation:** Can an attacker perform an action (like deleting a file) and deny they did it? ("It wasn't me!")
    *   *Solution:* Non-repudiation via comprehensive Logging and Audit Trails.
*   **I - Information Disclosure:** Can an attacker view private data?
    *   *Solution:* Encryption (At rest and In Transit), ACLs (Access Control Lists).
*   **D - Denial of Service:** Can an attacker crash the system so legitimate users can't use it?
    *   *Solution:* Rate limiting, CDNs, elasticity/auto-scaling.
*   **E - Elevation of Privilege:** Can a standard user trick the system into making them an Admin?
    *   *Solution:* Input validation, secure authorization logic (RBAC).

### Summary for the Architect
When you study this section, you are learning how to:
1.  Define what "Secure" means for your specific project (**CIA**).
2.  Design multiple safety nets so one bug doesn't ruin the company (**Defense in Depth**).
3.  Ensure that if a breach happens, the damage is contained (**Least Privilege**).
4.  Think like a hacker to find design flaws before they become code flaws (**STRIDE**).

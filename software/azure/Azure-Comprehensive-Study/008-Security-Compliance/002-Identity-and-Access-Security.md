Based on the Table of Contents you provided, **Part VIII: Security and Compliance -> B. Identity and Access Security** focuses on hardening the "front door" of your cloud environment.

In modern cloud computing, **Identity is the new perimeter**. We no longer rely solely on firewalls to keep people out; we rely on verifying exactly *who* is trying to access resources and *how* they are connecting.

Here is a detailed explanation of the two specific bullet points listed under that section.

---

### 1. Advanced Microsoft Entra ID Features

In **Part II**, you learned the basics of Entra ID (Users, Groups, MFA). **Part VIII** focuses on the advanced, enterprise-grade features included in Premium P1 and P2 licenses that prevent identity theft and govern high-level access.

#### A. Privileged Identity Management (PIM)
In a secure environment, you should avoid "Standing Access" (where an admin has Super User/Global Admin rights 24/7). If that admin’s account is hacked at 3 AM while they are sleeping, the hacker has the keys to the kingdom.

*   **Just-in-Time (JIT) Access:** PIM allows you to give users eligibility for a role rather than the role itself. When they need to do administrative work, they must "activate" the role.
*   **Time-Bound:** Access is granted for a specific duration (e.g., 2 hours). It automatically expires afterward.
*   **Approval Workflow:** You can require that a manager approve the request before access is granted.
*   **Justification:** The admin must type in why they need the access (auditing trail).

#### B. Microsoft Entra Identity Protection
This feature uses machine learning to detect suspicious activities related to your user accounts. It looks for **Risk Signals**, such as:
*   **Atypical Travel:** A user logs in from London, and 5 minutes later logs in from Tokyo.
*   **Leaked Credentials:** Microsoft scans the "dark web" for user/password pairs; if a match for your user is found, their risk level goes up.
*   **Anonymous IP:** Logging in from a Tor browser or anonymous VPN.

*How it helps:* You can set policies that say, "If the User Risk is Medium or High, force a password change immediately" or "Block access until an admin reviews it."

#### C. Access Reviews
Organizations often grant access to a user for a project, and then forget to remove it when the project ends. This leads to "permission creep."
*   Access Reviews automate the process of recertifying access.
*   System admins or Group Owners receive an email asking, "Do these 5 users still need access to the HR Database?"
*   If the reviewer says "No" (or doesn't respond), access can be automatically revoked.

---

### 2. Azure Bastion

This covers the security of *how* administrators remotely connect to Virtual Machines (VMs).

#### The Problem (The Traditional Way)
To manage a Windows VM (via RDP) or a Linux VM (via SSH), you historically had to give that VM a **Public IP address** and open port 3389 or 22 on the firewall.
*   **The Risk:** Hackers actively scan the entire internet for open ports 3389/22. Within minutes of creating a VM with a Public IP, it will be bombarded with brute-force password attacks.

#### The Solution (Azure Bastion)
Azure Bastion is a fully managed PaaS (Platform as a Service) that acts as a secure "jump box" or gateway between the public internet and your private VMs.

*   **How it works:**
    1.  You deploy the Bastion service into your Virtual Network.
    2.  You **remove** Public IPs from your VMs. They now only have private (internal) IPs.
    3.  When you want to manage a VM, you log into the **Azure Portal** via your web browser.
    4.  You click "Connect via Bastion" on the VM blade.
*   **The Connection Flow:** The connection happens over **SSL/TLS (Port 443) via the browser**. The Bastion host takes that web traffic and forwards it to the private IP of the VM inside the Azure network.

#### Key Benefits of Bastion
1.  **Zero Public Exposure:** Your VMs do not need Public IPs. They are hidden from the internet.
2.  **No Client Software:** You don't need to install PuTTY or an RDP client; you just need a web browser (Chrome, Edge, etc.).
3.  **Firewall Friendly:** It uses standard HTTPS (port 443), which is allowed through almost all corporate firewalls.
4.  **Protection:** It protects against port scanning and malware attempting to exploit RDP/SSH vulnerabilities.

### Summary
This section of the study guide is about moving from "Basic Authentication" to a **Zero Trust** model:
1.  **Entra ID Advanced:** Ensures the user is who they say they are and that they haven't been compromised (Identity Protection), and ensures they only have admin rights exactly when they need them (PIM).
2.  **Azure Bastion:** Ensures that the path to the server is secure and encrypted, without exposing the server to the open internet.

Based on the Table of Contents you provided, the section **`009-Appendices/002-CLI-PowerShell-Reference.md`** (labeled in the list as "Azure CLI and PowerShell Quick Reference") serves as a practical "cheat sheet" or "toolbox" document.

While the earlier parts of the course (Parts I through VIII) teach you the *theory* and *concepts*, this specific appendix focuses on the **syntax** needed to manage Azure without using the graphical web browser (Azure Portal).

Here is a detailed explanation of what this section covers, why it matters, and examples of what would be inside it.

---

### 1. The Purpose: "Infrastructure as Code" & Automation
In the professional world, clicking buttons in the Azure Portal is too slow and prone to human error. This specific appendix is designed to provide you with the commands needed to:
*   **Automate tasks:** Script the creation of 50 Virtual Machines at once instead of creating them one by one.
*   **Repeatability:** Ensure that a test environment looks exactly like the production environment.
*   **Speed:** Type a command much faster than navigating through menus.

### 2. The Two Main Tools
This appendix compares and lists commands for the two primary command-line tools used in Azure. It usually highlights the differences between them so you can choose the one that fits your background.

#### A. Azure CLI (Command-Line Interface)
*   **Style:** Based on Python.
*   **Syntax:** Text-based usage (e.g., `az group create`).
*   **Who it is for:** Users coming from **Linux or MacOS** backgrounds, or developers who rely heavily on Bash scripting.
*   **Structure:** It follows a hierarchy: `az [service] [sub-service] [command]`.

#### B. Azure PowerShell
*   **Style:** Based on the .NET framework.
*   **Syntax:** "Verb-Noun" structure (e.g., `New-AzResourceGroup`).
*   **Who it is for:** Users coming from **Windows Administration** backgrounds. It deals with "Objects" rather than simple text text, allowing for powerful data manipulation (piping).
*   **Structure:** It follows standard PowerShell nouns and verbs.

---

### 3. What is likely inside this Reference File?
This appendix acts as a **"Rosetta Stone"** or translation guide. It typically organizes common tasks side-by-side so you can see how to perform them in both languages.

Here is a detailed breakdown of the referenced commands you would find in this section:

#### Category 1: Authentication & Context
How to log in and select exactly which subscription you want to work on.

| Action | Azure CLI Command | Azure PowerShell Command |
| :--- | :--- | :--- |
| **Log in** | `az login` | `Connect-AzAccount` |
| **List Subscriptions** | `az account list --output table` | `Get-AzSubscription` |
| **Set Active Subscription**| `az account set --subscription "Name"` | `Set-AzContext -Subscription "Name"` |

#### Category 2: Resource Groups (The Container)
Every resource in Azure must belong to a Resource Group (RG).

| Action | Azure CLI Command | Azure PowerShell Command |
| :--- | :--- | :--- |
| **Create a Group** | `az group create -n MyRG -l eastus` | `New-AzResourceGroup -Name MyRG -Location EastUS` |
| **Delete a Group** | `az group delete -n MyRG` | `Remove-AzResourceGroup -Name MyRG` |

#### Category 3: Virtual Machines (Compute)
Creating a computer in the cloud.

| Action | Azure CLI Command | Azure PowerShell Command |
| :--- | :--- | :--- |
| **Create VM** | `az vm create --resource-group MyRG --name MyVM --image UbuntuLTS` | `New-AzVM -ResourceGroupName MyRG -Name MyVM -Image UbuntuLTS` |
| **Start VM** | `az vm start -g MyRG -n MyVM` | `Start-AzVM -ResourceGroupName MyRG -Name MyVM` |
| **Stop VMs** | `az vm stop -g MyRG -n MyVM` | `Stop-AzVM -ResourceGroupName MyRG -Name MyVM` |

#### Category 4: Storage
Managing files and blobs.

| Action | Azure CLI Command | Azure PowerShell Command |
| :--- | :--- | :--- |
| **Create Storage Account**| `az storage account create ...` | `New-AzStorageAccount ...` |
| **Get Storage Keys** | `az storage account keys list ...` | `Get-AzStorageAccountKey ...` |

---

### 4. Why is this Appendix important for you?

1.  **For Exams (AZ-900 / AZ-104):** Microsoft exams frequently ask questions like: *"Which command would you use to create a VM?"* You must be able to recognize that `New-AzVM` is PowerShell and `az vm create` is CLI.
2.  **For Troubleshooting:** Sometimes the Azure Portal crashes or is slow. Knowing how to restart a server using the command line (Cloud Shell) can save the day.
3.  **Quick Lookup:** You are not expected to memorize every single command. This file is intended to be kept open on a second monitor while you work, so you can copy/paste the syntax and modify it for your needs.

### Summary
This section is not a conceptual chapter; it is a **dictionary**. It provides the actual code snippets required to build the infrastructure defined in the previous Theoretical chapters (Parts I-VIII).

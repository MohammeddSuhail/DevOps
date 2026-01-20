# Azure Resources

Azure resources are the building blocks of your cloud infrastructure in Microsoft Azure. These resources can be virtual machines, databases, storage accounts, or any other service offered by Azure. Each resource is a manageable item in Azure, and they are provisioned and managed individually.

## Resource Groups in Azure

A **Resource Group** in Azure is a logical container for resources that share the same lifecycle, permissions, and policies. It helps you organize and manage related Azure resources efficiently. Resources within a group can be deployed, updated, and deleted together as a single management unit.

### Key Points about Resource Groups:

- **Lifecycle Management:** Resources within a group can be managed collectively, making it easy to handle deployments, updates, and deletions.

- **Resource Organization:** Grouping resources based on projects, environments, or applications helps keep your Azure environment well-organized.

- **Role-Based Access Control (RBAC):** Permissions and access control are applied at the resource group level, allowing you to manage who can access and modify resources within a group.

## Azure Resource Manager (ARM) Overview

**Azure Resource Manager (ARM)** is the central management layer for all of Azure. Whether you are using the Portal, CLI, or PowerShell, every single action is handled by ARM.

### Key Features of Azure Resource Manager:

- The Single Point of Entry
ARM acts as a consistent "front door" for Azure. No matter which tool you use, they all communicate with the same ARM REST API.

- The Workflow: User → Tool (Portal/CLI/SDK) → ARM API → Resource Providers (Compute, Storage, etc.).

- When a request hits ARM, it performs four essential checks before any resource is touched:
    - Authentication: Validates your identity (via Microsoft Entra ID).
    - Authorization: Checks RBAC (Role-Based Access Control) to see if you have permission.
    - Policy Compliance: Checks Azure Policy (e.g., "Is this VM in an allowed region?").
    - Locks: Checks for Resource Locks to prevent accidental deletion or modification.
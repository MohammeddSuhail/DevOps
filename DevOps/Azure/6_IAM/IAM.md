## Azure Identity and Access Management (IAM)
Identity and Access Management (IAM) is a security framework that ensures the right people and right resources (like apps or VMs) have the correct level of access to technology resources at the right time.

### Core Concepts: Authentication vs. Authorization
Office analogy to distinguish between these two fundamental terms:

* **Authentication (AuthN):** Verifying **who you are**. Carrying a valid ID card to enter the office building 
* **Authorization (AuthZ):** Verifying **what you can do**. Checking if your ID allows you into the cafeteria versus the high-security data center.


### Microsoft Entra ID (Formerly Azure AD): For users
The primary service for managing identities in Azure is now called **Microsoft Entra ID** 

* **Users:** Individual identities. By default, users have no access until authorized 
* **Groups:** Collections of users. It is a "best practice" to assign roles to groups rather than individuals to simplify management as the organization grows 
* **Roles:** Permissions assigned to users/groups to perform actions (e.g., Reader, Contributor, Owner) 


### Identity for Resources
IAM isn't just for humans. Resources often need to talk to each other (e.g., a VM reading a file from a Storage Account) 

* **Service Principal:** An identity created for an application/service. The user is responsible for managing and rotating its credentials 
* **Managed Identity:** The preferred, more secure method. Azure automatically handles the identity's lifecycle and credential rotation 
    * **System-Assigned:** Tied directly to a single resource (e.g., one specific VM) 
    * **User-Assigned:** Created as a standalone resource that can be assigned to multiple Azure resources 
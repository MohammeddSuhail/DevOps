# Terraform:
Infrastructure as Code (IaC) means that Terraform calls APIs of cloud providers (Azure, AWS, GCP, etc.) to manage infrastructure. Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define, provision, and manage cloud infrastructure using a declarative configuration language called HCL (HashiCorp Configuration Language).

terraform <----> terraform provider <----> provider API

---

## **Terraform State**
is a file that keeps track of all the resources Terraform manages.
- It records details like resource IDs, metadata, and properties of your infrastructure.
- This allows Terraform to understand:
  - What exists in your cloud environment,
  - What needs to be created, updated, or deleted,
  - And how your current configuration relates to real infrastructure.
Best to store in AWS S3 bucket or Azure Blob Storage.


---

## **Terraform Lock**
When the terraform apply command is run, it checks if someone is holding the lock. If so, it waits until the lock is released, then continues.
Why: 
 To prevent concurrent modifications to the state file, ensuring consistency and avoiding conflicts.

Where can it be stored: DynamoDB/Azure Blob Storage
 - For AWS, the state file is stored in an S3 bucket, and the lock is managed using DynamoDB. Why DynamoDB? Because it provides atomic operations and strong consistency needed for reliable locking. Why not S3 for locking? S3 is object storage and doesn't support atomic operations or native locking, which could lead to race conditions. 
 - For Azure, both state and lock are handled by Azure Blob Storage.


---

## **Provisioners**
Terraform components to execute scripts, commands, or upload files on resources after creation or before destruction. Used for tasks that can't be done by just declaring resources in Terraform.

When used? Why? For installing software, running scripts, or configuring apps when providers can't do it natively.

During creation/deletion? Creation (default), destruction (when="destroy"), or both.

When to use? Sparingly; prefer declarative alternatives like user data or Ansible.

Types:
- local-exec: Runs on local machine (e.g., API calls).
- remote-exec: Runs on remote resource (e.g., via SSH).
- file: Uploads files to remote resource.

When to use what? local-exec for local tasks, remote-exec for remote commands, file for uploads. Avoid if possible because they can make configurations less reliable, harder to test, and less portable.


---

## **Workspace**

Terraform Workspaces allow you to manage multiple distinct sets of infrastructure resources from the same configuration files. Each workspace has its own State File.
Why use them? To manage multiple environments (e.g., Dev, Staging, Prod) using the exact same code without copying files.

Key Characteristics:
- Separation of State: Every workspace maintains its own state file. In an S3 backend, these are typically stored under a env:/<workspace_name>/ prefix.
- Default Workspace: Every Terraform configuration starts with a workspace named default. This cannot be deleted.
- Environment Logic: You can use the variable ${terraform.workspace} within your code to change resource names or sizes based on the active environment (e.g., using a t3.medium in Prod but a t3.micro in Dev).

Workflow Commands:
- terraform workspace list: Shows all existing workspaces.
- terraform workspace new <name>: Creates a new workspace and switches to it.
- terraform workspace select <name>: Switches between environments.
- terraform workspace show: Displays the name of the current workspace.

ex:
my-terraform-state-bucket/
├── proj_name_or_some_prefix/
│   └── terraform.tfstate             # (The 'default' workspace)
└── env:/
    ├── dev/
    │   └── proj_name_or_some_prefix/
    │       └── terraform.tfstate     # (The 'Dev' workspace)
    ├── staging/
    │   └── proj_name_or_some_prefix/
    │       └── terraform.tfstate     # (The 'Staging' workspace)
    └── prod/
        └── proj_name_or_some_prefix/
            └── terraform.tfstate     # (The 'Prod' workspace)


---
## Importing Existing Resources into Terraform(Migratiiom)
To bring a resource created manually or via other tools (like AWS CloudFormation) into Terraform management, you can use the declarative import block.
1. The Configuration (main.tf):
provider "aws" {
  region = "us-east-1"
}
import {
  id = "i-0573763ef5312afd6f" <!--The actual ID of the resource from the AWS Console-->
  to = aws_instance.example <!--The address the resource will have in your Terraform code-->
}
2. Generating the Code:
Run this command. Terraform will create a new file named generated.tf containing the full resource configuration (tags, instance type, etc.) pulled directly from AWS.
terraform plan -generate-config-out=generated.tf
generated.tf will have the code
3. Update the State:
Run this command to officially "hand over" management to Terraform.
terraform apply




## **Drift Detection**
The process of identifying discrepancies between the **Desired State** (Terraform code) and the **Actual State** (Real-world infrastructure). Drift occurs when "out-of-band" changes are made via cloud consoles, CLI, or other tools without updating the HCL code.

---

### **1. Detection: Scheduled Reconciliation**
Terraform identifies drift by comparing the `terraform.tfstate` against the live environment.

* **Primary Command:** `terraform plan -refresh-only`
    * **Purpose:** Safely updates the state file to match reality and previews "drift" without proposing infrastructure changes.
* **Automation:** Run as a **CI/CD Cron Job** (e.g., every 24 hours).
* **Alerting:** Use the `-detailed-exitcode` flag in pipelines.
    * `Exit Code 0`: No changes (Clean).
    * `Exit Code 2`: Drift detected (Trigger Slack/Email alert).

---

### **2. Auditing: Traceability & Logging**
When drift occurs, use audit logs to identify the "Who, When, and What."

* **AWS (CloudTrail + EventBridge):**
    * **CloudTrail:** Logs every API call.
    * **Monitoring:** Trigger an **AWS Lambda** via EventBridge for any `Create/Update/Delete` event. If the actor is not the "Terraform Service Role," log a high-priority security alert in **CloudWatch**.
* **Azure (Activity Logs + Monitor):**
    * **Activity Logs:** Provides a full history of control-plane changes.
    * **Monitoring:** Use **Azure Monitor Alerts** to detect manual edits in the Portal.
    * **Analysis:** Query logs using KQL in a **Log Analytics Workspace** to find changes made outside of your Service Principal.

### **3. Prevention: Access Control (IAM/RBAC)**
The most effective way to manage drift is to remove the ability for humans to create it.

| Strategy | **AWS Implementation** | **Azure Implementation** |
| :--- | :--- | :--- |
| **Least Privilege** | Assign humans **Read-Only** IAM roles. | Assign humans the **Reader** RBAC role. |
| **Locking** | Use **Service Control Policies (SCPs)** to block "Write" actions for everyone except the Terraform Role. | Apply **Management Locks** (`ReadOnly` or `CanNotDelete`) to production Resource Groups. |
| **Policy** | Use **Permission Boundaries** to cap maximum user permissions. | Use **Azure Policy** to "Deny" any resource creation that isn't compliant with code. |

---

### **Summary Checklist**
| Feature | AWS Strategy | Azure Strategy |
| :--- | :--- | :--- |
| **Detection** | `plan -refresh-only` | `plan -refresh-only` |
| **Auditing** | CloudTrail + Lambda | Activity Logs + Log Analytics |
| **Prevention** | SCPs / Permission Boundaries | Management Locks / Azure Policy |



---
## What is Drift Detection?
Drift Detection is the process of identifying discrepancies between the Desired State (your Terraform code) and the Actual State (the real resources in AWS/Azure). Drift occurs when changes are made manually via the Console/Portal or via external CLI tools without updating the HCL code.

- Detection: State Reconciliation
To identify drift, you must compare the current state of infrastructure against the last known state file.
Modern Command: terraform plan -refresh-only
Why: It updates the state file with real-world changes and shows you the "drift" without proposing infrastructure changes.
Automation: Execute this via CI/CD Cron Jobs (e.g., every 24 hours).
Alerting: Use the -detailed-exitcode flag. An exit code of 2 indicates drift; use this to trigger a Slack/Email notification.

- 1. Terraform Refresh: Refreshes the state file(run it as cron job: one every hour or day)
- 2. Configre strict IAM rules(add more on this also be inclusive of azure)
- 3. Have audit logs(best approach) using tool like cloud whatch or other using lamda functions: more on this also be inclusive of azure


---

## Configuration Approaches

In Terraform, simple configurations often rely on cloud provider defaults (like default VPCs, subnets, and security groups) for quick deployments, allowing resources to work without explicit definitions. For example, an `aws_instance` without specified `subnet_id` or `vpc_security_group_ids` will use the default VPC and its default subnet/security group in the region. Detailed configurations, however, explicitly create and reference custom infrastructure components for full control, security, and repeatability. While defaults are convenient for testing, they can vary by account/region and lack customization, making custom setups preferable for production environments.
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



## Configuration Approaches

In Terraform, simple configurations often rely on cloud provider defaults (like default VPCs, subnets, and security groups) for quick deployments, allowing resources to work without explicit definitions. For example, an `aws_instance` without specified `subnet_id` or `vpc_security_group_ids` will use the default VPC and its default subnet/security group in the region. Detailed configurations, however, explicitly create and reference custom infrastructure components for full control, security, and repeatability. While defaults are convenient for testing, they can vary by account/region and lack customization, making custom setups preferable for production environments.
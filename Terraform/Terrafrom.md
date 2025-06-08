# 🚀 Terraform with Azure: Beginner to Practical VM Deployment

This guide covers:
- Terraform basics
- Full example to deploy a VM in Azure
- Deep comments explaining every part
- Adding 100 GB disk space
- Networking concepts (VNet, Subnet, NIC)
- Ready to push to GitHub!

---

## 🧱 Prerequisites

- Azure CLI installed (`az login`)
- Terraform installed
- Azure subscription
- Basic terminal usage

---

## 📁 File Structure

```plaintext
terraform-azure-vm/
│
├── main.tf             # Main Terraform config
├── variables.tf        # All input variables
├── terraform.tfvars    # Values for variables
├── outputs.tf          # (Optional) Outputs like public IP
```

---

## 🔧 Step-by-Step Code with Comments

### `main.tf`

```hcl
# Provider tells Terraform which cloud you're using
provider "azurerm" {
  features {}  # Mandatory block for AzureRM provider
}

# 📦 Resource Group (like a folder to hold everything)
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name   # e.g., "rg-suhail"
  location = var.location              # e.g., "East US"
}

# 🌐 Virtual Network — like a private office building
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]       # Huge IP block for the VNet
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 🧱 Subnet — like a room inside the building
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]      # Smaller chunk of IPs
}

# 📡 Network Interface Card — attaches VM to the subnet
resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"  # Azure assigns IP automatically
  }
}

# 🖥️ Virtual Machine — Ubuntu Linux
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  size                  = "Standard_B1s"  # 💡 Change to desired VM SKU
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]
  disable_password_authentication = false  # Allow password SSH (not just SSH keys)

  # 💽 OS Disk settings
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 100  # ✅ Set OS disk size to 100 GB
  }

  # 📦 VM Image (Ubuntu 18.04 LTS)
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

---

### `variables.tf`

```hcl
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}

variable "location" {
  type        = string
  description = "Azure region (e.g., East US)"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "admin_password" {
  type        = string
  description = "Admin password (should be strong)"
}
```

---

### `terraform.tfvars`

```hcl
resource_group_name = "rg-suhail"
location            = "East US"
vnet_name           = "vnet-suhail"
subnet_name         = "subnet-suhail"
vm_name             = "vm-suhail"
admin_username      = "suhail"
admin_password      = "P@ssw0rd123!"  # Use a stronger one in real-world use
```

---

### ✅ Commands to Deploy

```bash
terraform init      # Download required plugins
terraform plan      # Preview what will be created
terraform apply     # Apply the config to Azure
```

---

## 📘 Explanation: Why VNet and Subnet?

| Term      | Real-world analogy | Purpose in Azure                                  |
|-----------|--------------------|----------------------------------------------------|
| VNet      | Office building     | Provides a **private IP space** for your resources |
| Subnet    | Floor/room inside   | Splits VNet into smaller parts for organization     |

> Every VM **must** be inside a **subnet**, and every subnet must be inside a **VNet**.

---

## 📦 What is `Standard_B1s`, and how to choose VM size?

| Size Name       | vCPU | RAM  | Use Case         |
|------------------|------|------|------------------|
| Standard_B1s     | 1    | 1 GB | Small/testing     |
| Standard_B2s     | 2    | 4 GB | Web/app servers   |
| D2s_v3           | 2    | 8 GB | Medium workloads  |

> Run `az vm list-sizes --location "East US" -o table` to view all VM SKUs.

---

## 🧠 Optional Next Steps

- Add public IP for SSH access
- Add `tags` for cost tracking
- Add `output.tf` to print IP or VM name
- Use SSH keys instead of passwords

---

## 📎 Reference Links

- [Terraform AzureRM Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure VM Sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes)
- [Azure Regions](https://azure.microsoft.com/en-in/explore/global-infrastructure/geographies)

---

## 🧹 Cleanup

When you're done testing:

```bash
terraform destroy
```

---



## Terraform Workflow Commands
- terraform init     : Initializes Terraform, downloads provider plugins
- terraform validate : Validates the syntax and logic
- terraform plan     : Shows what changes will be made
- terraform apply    : Applies the plan and creates resources
- terraform destroy  : Deletes everything managed by Terraform

---
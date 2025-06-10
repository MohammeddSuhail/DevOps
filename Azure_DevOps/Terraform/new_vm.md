# Steps to Create a New RHEL 8 VM in Azure

This document outlines the resources required and their configurations to deploy a **RHEL 8 Virtual Machine** in Azure.

---

## **1. Virtual Network (VNet)**
- **Purpose**: Provides network connectivity for the VM.
- **Components**:
  - **VNet**: The virtual network where the VM will reside.
  - **Subnet**: A logical subdivision of the VNet for organizing resources.
  - **Network Security Group (NSG)**: Controls inbound and outbound traffic to the VM.
  - **Public IP (Optional)**: If the VM needs to be accessible from the internet.

---

## **2. Network Interface (NIC)**
- **Purpose**: Connects the VM to the VNet and assigns IP addresses.
- **Components**:
  - **Private IP**: Assigned from the subnet.
  - **Public IP (Optional)**: For external access.
  - **NSG Association**: Attach the NSG to the NIC.

---

## **4. Virtual Machine**
- **Purpose**: The compute resource running the RHEL 8 operating system.
- **Components**:
  - **VM Size**: Choose based on workload (e.g., `Standard_E2s_v3` for general-purpose or `Standard_E16bs_v5` for memory-intensive workloads).
  - **Image**: Use the RHEL 8 image from Azure Marketplace.
    - Publisher: `RedHat`
    - Offer: `RHEL`
    - SKU: `8-lvm-gen2`
  - **Admin Credentials**:
    - Username and password or SSH key for login.

---

## **5. Availability Options (Optional)**
- **Purpose**: Ensures high availability and fault tolerance.
- **Options**:
  - **Availability Set**: Distributes VMs across fault and update domains.
  - **Availability Zone**: Places VMs in different physical zones within a region.

---

## **6. Boot Diagnostics (Optional)**
- **Purpose**: Enables troubleshooting by capturing boot logs.
- **Components**:
  - Storage account for diagnostic logs.

---

## **7. Monitoring and Management (Optional)**
- **Purpose**: Provides insights and management capabilities.
- **Components**:
  - **Azure Monitor**: For performance and health monitoring.
  - **Log Analytics**: For centralized logging.
  - **Backup**: For VM snapshots and disaster recovery.

---

## **Terraform Example for RHEL 8 VM**

Below is a Terraform configuration example for deploying a RHEL 8 VM:

```hcl
# Virtual Network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  location            = "East US"
  resource_group_name = "example-rg"
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "example_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_virtual_network.example_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "example_nsg" {
  name                = "example-nsg"
  location            = "East US"
  resource_group_name = "example-rg"
}

# Network Interface
resource "azurerm_network_interface" "example_nic" {
  name                = "example-nic"
  location            = "East US"
  resource_group_name = "example-rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Managed Disk
resource "azurerm_managed_disk" "example_disk" {
  name                 = "example-os-disk"
  location             = "East US"
  resource_group_name  = "example-rg"
  storage_account_type = "Premium_LRS"
  create_option        = "FromImage"
  disk_size_gb         = 64
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "example-vm"
  location            = "East US"
  resource_group_name = "example-rg"
  size                = "Standard_E2s_v3"
  admin_username      = "adminuser"
  admin_password      = "Password1234!"

  network_interface_ids = [
    azurerm_network_interface.example_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }
}
```
---




or






## **can use default os_disk in vm block or we explictly create it(managed disk)**

Below is a Terraform configuration example for deploying a RHEL 8 VM with both an OS disk and an additional managed data disk:

```hcl
# Virtual Network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  location            = "East US"
  resource_group_name = "example-rg"
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "example_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_virtual_network.example_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "example_nsg" {
  name                = "example-nsg"
  location            = "East US"
  resource_group_name = "example-rg"
}

# Network Interface
resource "azurerm_network_interface" "example_nic" {
  name                = "example-nic"
  location            = "East US"
  resource_group_name = "example-rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# OS Disk (Defined within the VM)
resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "example-vm"
  location            = "East US"
  resource_group_name = "example-rg"
  size                = "Standard_E2s_v3"
  admin_username      = "adminuser"
  admin_password      = "Password1234!"

  network_interface_ids = [
    azurerm_network_interface.example_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }
}

# Additional Managed Data Disk
resource "azurerm_managed_disk" "example_data_disk" {
  name                 = "example-data-disk"
  location             = "East US"
  resource_group_name  = "example-rg"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
}

# Attach Data Disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "example_data_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.example_data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.example_vm.id
  lun                = 0
  caching            = "ReadWrite"
}

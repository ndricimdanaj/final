terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "terraform-ansible-kubernetes"
  location = "East US"
}

resource "azurerm_resource_group" "tak" {
  name = "my_terraform_CentOS_rg"
  location = "West Europe"
  tags = {
        "environment" = "production"
  }
}

resource "azurerm_virtual_network" "vnetprod019" {
  name                = "vnetprod019"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name
  tags                = {
	"environment" = "production"
  }
}

resource "azurerm_subnet" "subnet019" {
  name                 = "subnet019"
  resource_group_name  = azurerm_resource_group.tak.name
  virtual_network_name = azurerm_virtual_network.vnetprod019.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "publicip019c" {
  name                = "publicip019c"
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "production"
  }
}

resource "azurerm_network_interface" "nicprod019c" {
  name                = "nicprod019c"
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name
  tags                = {
        "environment" = "production"
  }
  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet019.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip019c.id
  }
}

# Create public IPs
resource "azurerm_public_ip" "publicip0192c" {
  name                = "publicip0192c"
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "production"
  }
}

resource "azurerm_network_interface" "nicprod0192c" {
  name                = "nicprod0192c"
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name
  tags                = {
        "environment" = "production"
  }
  ip_configuration {
    name                          = "myNicConfiguration2"
    subnet_id                     = azurerm_subnet.subnet019.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip0192c.id
  }
}

# Create public IPs
resource "azurerm_public_ip" "publicip0191c" {
  name                = "publicip0191c"
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "production"
  }
}

resource "azurerm_network_interface" "nicprod0191c" {
  name                = "nicprod0191c"
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name
  tags                = {
        "environment" = "production"
  }
  ip_configuration {
    name                          = "myNicConfiguration1"
    subnet_id                     = azurerm_subnet.subnet019.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip0191c.id
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsgprod019" {
  name                = "nsgprod019"
  location            = azurerm_resource_group.tak.location
  resource_group_name = azurerm_resource_group.tak.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nicprod019c.id
  network_security_group_id = azurerm_network_security_group.nsgprod019.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association1" {
  network_interface_id      = azurerm_network_interface.nicprod0192c.id
  network_security_group_id = azurerm_network_security_group.nsgprod019.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association2" {
  network_interface_id      = azurerm_network_interface.nicprod0191c.id
  network_security_group_id = azurerm_network_security_group.nsgprod019.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage" {
  name                     = "diag36c9ea47765b022d"
  resource_group_name      = azurerm_resource_group.tak.name
  location                 = azurerm_resource_group.tak.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}
# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage1" {
  name                     = "alt12345678c"
  resource_group_name      = azurerm_resource_group.tak.name
  location                 = azurerm_resource_group.tak.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage2" {
  name                     = "alt123456782c"
  resource_group_name      = azurerm_resource_group.tak.name
  location                 = azurerm_resource_group.tak.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm019c" {
  name                = "linuxvm019c"
  resource_group_name = azurerm_resource_group.tak.name
  location            = azurerm_resource_group.tak.location
  size                = "Standard_D2s_v3"
  admin_username      = "ndricimdanaj"
  computer_name  = "myvm"
  admin_password = "Cimicimi123!@#"
  disable_password_authentication = false
  encryption_at_host_enabled      = false 
  network_interface_ids = [
    azurerm_network_interface.nicprod019c.id,
  ]

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm0191c" {
  name                = "linuxvm0191c"
  resource_group_name = upper(azurerm_resource_group.tak.name)
  location            = azurerm_resource_group.tak.location
  size                = "Standard_DS1_v2"
  admin_username      = "ndricimdanaj"
  computer_name  = "myvm1"
  admin_password = "Cimicimi123!@#"
  disable_password_authentication = false
  encryption_at_host_enabled      = false 
  network_interface_ids = [
    azurerm_network_interface.nicprod0191c.id,
  ]

  os_disk {
    name                =  "myOsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage1.primary_blob_endpoint
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm0192c" {
  name                = "linuxvm0192c"
  resource_group_name = upper(azurerm_resource_group.tak.name)
  location            = azurerm_resource_group.tak.location
  size                = "Standard_DS1_v2"
  admin_username      = "ndricimdanaj"
  computer_name  = "myvm2"
  admin_password = "Cimicimi123!@#"
  disable_password_authentication = false
  encryption_at_host_enabled      = false 
  network_interface_ids = [
    azurerm_network_interface.nicprod0192c.id,
  ]

  os_disk {
    name                =  "myOsDisk2"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage2.primary_blob_endpoint
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  tags = {
    environment = "production"
  }
}

# Null resource for run the ansible playbooks
resource "null_resource" "kubernetes" {
  # Run the ansible playbook
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.yaml ansible_kubernetes.yaml"
  }
}
# Your Terraform code goes here...
# Random password
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

# Public IP for VM1
resource "azurerm_public_ip" "vm1_ip" {
  name                    = "VM1-ip"
  location                = data.azurerm_resource_group.rg.location
  resource_group_name     = data.azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  sku                     = "Basic"
  idle_timeout_in_minutes = 4
}

# Public IP for VM2
resource "azurerm_public_ip" "vm2_ip" {
  name                    = "VM2-ip"
  location                = data.azurerm_resource_group.rg.location
  resource_group_name     = data.azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  sku                     = "Basic"
  idle_timeout_in_minutes = 4
}

# Network Interface for VM1
resource "azurerm_network_interface" "vm1_nic" {
  name                = "VM1-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.app_subnet["frontend"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1_ip.id
  }
}

# Network Interface for VM2
resource "azurerm_network_interface" "vm2_nic" {
  name                = "VM2-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.app_subnet["backend"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm2_ip.id
  }
}

# Virtual Machine 1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                            = "VM1"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  size                            = "Standard_DS1_v2"
  admin_username                  = "AzureAdmin"
  admin_password                  = random_password.admin_password.result
  network_interface_ids           = [azurerm_network_interface.vm1_nic.id]
  disable_password_authentication = false

  os_disk {
    name                 = "VM1_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.common_tags
}

# Virtual Machine 2
resource "azurerm_linux_virtual_machine" "vm2" {
  name                            = "VM2"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  size                            = "Standard_DS1_v2"
  admin_username                  = "AzureAdmin"
  admin_password                  = random_password.admin_password.result
  network_interface_ids           = [azurerm_network_interface.vm2_nic.id]
  disable_password_authentication = false

  os_disk {
    name                 = "VM3_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.common_tags
}

# Creating application security group
resource "azurerm_application_security_group" "app-backend-asg" {
  name                = "app-backend-asg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = local.common_tags
}

# Associate ASG with VM2
resource "azurerm_network_interface_application_security_group_association" "app-backend-asg-association" {
  network_interface_id          = azurerm_network_interface.vm2_nic.id
  application_security_group_id = azurerm_application_security_group.app-backend-asg.id
}


# Create network security group
resource "azurerm_network_security_group" "app-vnet-nsg" {
  name                = "app-vnet-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                                       = "allow-ssh"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.app-backend-asg.id]
    destination_port_range                     = "22"
  }

  tags = local.common_tags
}

# Associate NSG with Backend Subnet
resource "azurerm_subnet_network_security_group_association" "app-vnet-nsg-association" {
  subnet_id                 = azurerm_subnet.app_subnet["backend"].id
  network_security_group_id = azurerm_network_security_group.app-vnet-nsg.id
}

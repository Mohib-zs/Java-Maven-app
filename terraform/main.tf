provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  # use_msi         = true
}

resource "azurerm_resource_group" "my-app" {
  name     = "${var.env_prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "my-app" {
  name                = "${var.env_prefix}-vnet"
  resource_group_name = azurerm_resource_group.my-app.name
  location            = azurerm_resource_group.my-app.location
  address_space       = [var.vnet_address]
}

resource "azurerm_subnet" "my-app" {
  name                 = "${var.env_prefix}-subnet-1"
  resource_group_name  = azurerm_resource_group.my-app.name
  virtual_network_name = azurerm_virtual_network.my-app.name
  address_prefixes     = [var.subnet_address]
}

resource "azurerm_network_security_group" "my-app" {
  name                = "${var.env_prefix}-nsg"
  location            = azurerm_resource_group.my-app.location
  resource_group_name = azurerm_resource_group.my-app.name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }
  security_rule {
  name                       = "SSH"
  priority                   = 301
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = var.jenkins_ip
  destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web-host"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  

}

resource "azurerm_public_ip" "my-app" {
  name                = "${var.env_prefix}-public-ip"
  resource_group_name = azurerm_resource_group.my-app.name
  location            = azurerm_resource_group.my-app.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "my-app" {
  name                = "${var.env_prefix}-nic"
  location            = azurerm_resource_group.my-app.location
  resource_group_name = azurerm_resource_group.my-app.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my-app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my-app.id
  }
}

resource "azurerm_network_interface_security_group_association" "my-app" {
  network_interface_id      = azurerm_network_interface.my-app.id
  network_security_group_id = azurerm_network_security_group.my-app.id
}

resource "azurerm_linux_virtual_machine" "my-app" {
  name                = "${var.env_prefix}-machine"
  resource_group_name = azurerm_resource_group.my-app.name
  location            = azurerm_resource_group.my-app.location
  size                = var.vm_size
  admin_username      = var.vm_username
  custom_data         = base64encode(file("startup-script.sh"))
  network_interface_ids = [
    azurerm_network_interface.my-app.id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = "my-app-key-pair"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}

data "azurerm_public_ip" "my-app" {
  name                = azurerm_public_ip.my-app.name
  resource_group_name = azurerm_linux_virtual_machine.my-app.resource_group_name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.my-app.ip_address
}


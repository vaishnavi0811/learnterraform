provider "azurerm" {
	 features {}
}

resource "azurerm_virtual_network" "vnet" {
    name = "testvnet"
    location = "south india"
    resource_group_name = "Learning"
    address_space = ["20.0.0.0/16"]

    tags = {
        environmet = "Test"
    }
}

resource "azurerm_subnet" "subnet" {
    name = "subnet0"
    resource_group_name = "Learning"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["20.0.1.0/24"]
    depends_on = [azurerm_virtual_network.vnet,azurerm_network_security_group.azurensg]
}

resource "azurerm_network_security_group" "azurensg" {
    name = "nsg01"
    location = azurerm_virtual_network.vnet.location
    resource_group_name = azurerm_virtual_network.vnet.resource_group_name

    security_rule {
        name = "nsgrule1"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsgassociate" {
  subnet_id = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.azurensg.id
}

resource "azurerm_virtual_network" "vnet1" {
    name = "testvnet1"
    location = "south india"
    resource_group_name = azurerm_virtual_network.vnet.resource_group_name
    address_space = ["30.0.0.0/16"]

    tags = {
        environmet = "Test"
    }
}

resource "azurerm_subnet" "subnet0" {
    name = "subnet1"
    resource_group_name = azurerm_virtual_network.vnet.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet1.name
    address_prefixes = ["30.0.1.0/24"]
    depends_on = [azurerm_virtual_network.vnet1]
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_network_interface" "nic" {
  name                = "NIC01"
  location            = azurerm_virtual_network.vnet.location
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  depends_on = [azurerm_virtual_network.vnet,azurerm_subnet.subnet]

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "azurevm" {
  name                = "testvm"
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "Password@2021"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  depends_on = [azurerm_network_interface.nic]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
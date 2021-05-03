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
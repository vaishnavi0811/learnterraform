resource "azurerm_virtual_network" "vnet0" {
    name = "vnet0"
    location = "south india"
    resource_group_name = "Learning"
    address_space = ["40.0.0.0/16"]

    tags = {
        environmet = "Test"
    }
}

resource "azurerm_network_security_group" "azurensg" {
    name = "nsg01"
    location = azurerm_virtual_network.vnet0.location
    resource_group_name = azurerm_virtual_network.vnet0.resource_group_name

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

resource "azurerm_subnet" "subnet0" {
    name = "sbn00"
    resource_group_name = "Learning"
    virtual_network_name = azurerm_virtual_network.vnet0.name
    address_prefixes = ["40.0.1.0/24"]
    depends_on = [azurerm_virtual_network.vnet0,azurerm_network_security_group.azurensg]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociate" {
  subnet_id = azurerm_subnet.subnet0.id
  network_security_group_id = azurerm_network_security_group.azurensg.id
}
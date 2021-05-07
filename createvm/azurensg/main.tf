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

resource "azurerm_subnet_network_security_group_association" "nsgassociate" {
  subnet_id = azurerm_subnet.subnet0.id
  network_security_group_id = azurerm_network_security_group.azurensg.id
}
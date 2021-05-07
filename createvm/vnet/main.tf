resource "azurerm_virtual_network" "vnet0" {
    name = "vnet0"
    location = "south india"
    resource_group_name = "Learning"
    address_space = ["40.0.0.0/16"]

    tags = {
        environmet = "Test"
    }
}

resource "azurerm_subnet" "subnet0" {
    name = "sbn00"
    resource_group_name = "Learning"
    virtual_network_name = azurerm_virtual_network.vnet0.name
    address_prefixes = ["40.0.1.0/24"]
    depends_on = [azurerm_virtual_network.vnet0,azurerm_network_security_group.azurensg]
}
provider "azurerm" {
	 features {}
}

resource "azurerm_virtual_network" "samplevnet" {
    name = "testvnet"
    location = "south india"
    resource_group_name = "Learning"
    address_space = ["20.0.0.0/16"]

    tags = {
        environmet = "Test"
    }
}

resource "azurerm_subnet" "example" {
    name = "subnet0"
    resource_group_name = "Learning"
    virtual_network_name = azurerm_virtual_network.samplevnet.name
    address_prefixes = ["20.0.1.0/24"]
}
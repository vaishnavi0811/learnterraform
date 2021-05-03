provider "azurerm" {
	 features {}
}

resource "azurerm_virtual_network" "samplevnet" {
    name = "azurevnet"
    location = "south india"
    resource_group_name = "Learning"
    address_space = ["10.0.0.0/16"]

    subnet {
        name = "subnet0"
        address_prefixes = ["10.0.1.0/24"]
    }
    tags = {
        environmet = "Test"
    }
}
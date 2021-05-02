provider "azurerm" {
	 features {}
}

resource "azurerm_virtual_network" "samplevnet" {
    name = "azurevnet"
    location = "south india"
    resource_group_name = "Learning"
    address_space = ["10.0.0.0/24"]
    tags = {
        environmet = "Test"
    }
}
provider "azurerm" {
	 features {}
}

module "vnet" {
    source = "./vnet"
}

module "virtualmachine" {
    source = "./virtualmachine"
}
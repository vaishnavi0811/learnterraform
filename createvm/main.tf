variable
provider "azurerm" {
	 features {}
}

module "vnet" {
    source = "./vnet"
}

module "virtualmachine" {
    source = "./virtualmachine"
    subnetid = module.vnet.subnetid
    rsgname = module.vnet.rsgname
    location = module.vnet.location
}
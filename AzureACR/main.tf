provider "azurerm" {
	 features {}
}

resource "azurerm_virtual_network" "example" {
  name                = "acrvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "South india"
  resource_group_name = "Learning"
}

resource "azurerm_subnet" "storage" {
  name                                           = "acrsubnet"
  resource_group_name                            = "Learning"
  virtual_network_name                           = azurerm_virtual_network.example.name
  address_prefix                                 = "10.0.1.0/24"
  enforce_private_link_endpoint_network_policies = false
  service_endpoints                              = ["Microsoft.Storage"]
}  

resource "azurerm_storage_account" "example" {
  name                     = "acrstorage001"
  resource_group_name       = "Learning"
  location                  = "South india"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "example" {
  name                  = "acrcontainer"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "example" {
  name                = "acrendpoint"
  location            = "South india"
  resource_group_name = "Learning"
  subnet_id           = azurerm_subnet.storage.id

  private_service_connection {
    name                           = "acrserviceconnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.example.id
    subresource_names              = ["blob"]
  }
}
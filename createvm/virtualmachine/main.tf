variable "subnetid" {
    type = string
}
variable "rsgname" {
    type = string
}
variable "location" {
    type = string
}

resource "azurerm_network_interface" "nic" {
  name                = "NIC01"
  location            = var.location
  resource_group_name = var.rsgname
  

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "azurevm" {
  name                = "testvm"
  resource_group_name = var.rsgname
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "Password@2021"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  depends_on = [azurerm_network_interface.nic]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

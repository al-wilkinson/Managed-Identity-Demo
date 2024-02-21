resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.Location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-demo-01"
  address_space       = [var.vnet_ip]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
  name                 = "snet-demo-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.snet1_ip]
}

resource "azurerm_public_ip" "pubip" {
  name                = "pip-vm-demo-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # Comment/uncomment the sku below to default to Basic SKU
  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_network_interface" "vnic" {
  name                = "nic-vm-demo-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ip-vm-demo-01"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "terrastuff-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  size           = "Standard_B1s"
  admin_username = "adminuser"
  # Don't use passwords other than quick tear down tests
  disable_password_authentication = "false"
  admin_password                  = var.admin_password

  network_interface_ids = [azurerm_network_interface.vnic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }  
}
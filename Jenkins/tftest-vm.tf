resource "azurerm_network_interface" "tftest_nic" {
  name                = "tftest-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    # No public IP to save cost
  }
}

resource "azurerm_network_interface_security_group_association" "tftest_nic_nsg" {
  network_interface_id      = azurerm_network_interface.tftest_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "tftest_vm" {
  name                = "tftest-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1ls"  # Cheapest available VM size
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.tftest_nic.id
  ]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/Sharif_pc/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
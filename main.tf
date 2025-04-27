provider "azurerm" {
  features {}
  subscription_id = "59eba330-2ce9-4f7a-904e-57de924d31ac"
}

resource "azurerm_public_ip" "frontend" {
  name                = "frontend"
  resource_group_name = "project-setup-1"
  location            = "Uk West"
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
resource "azurerm_network_interface" "frontend" {
  name                = "frontend"
  location            = "Uk West"
  resource_group_name = "project-setup-1"

  ip_configuration {
    name                          = "frontend-nic"
    subnet_id                     = "/subscriptions/59eba330-2ce9-4f7a-904e-57de924d31ac/resourceGroups/project-setup-1/providers/Microsoft.Network/virtualNetworks/test-network/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "frontend" {
  name                  = "frontend-vm"
  location              = "Uk West"
  resource_group_name   = "project-setup-1"
  network_interface_ids = [azurerm_network_interface.frontend.id]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true

  storage_image_reference {
    id="/subscriptions/59eba330-2ce9-4f7a-904e-57de924d31ac/resourceGroups/project-setup-1/providers/Microsoft.Compute/images/image-devops-practice"
  }
  storage_os_disk {
    name              = "frontend-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "frontend"
    admin_username = "azuser"
    admin_password = "Marchmonth@12345"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
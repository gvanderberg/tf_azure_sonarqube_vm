data "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.subnet_resource_group_name
  virtual_network_name = var.subnet_virtual_network_name
}

resource "random_integer" "this" {
  min = 1000
  max = 5000
}

resource "azurerm_network_interface" "this" {
  name                = format("%s-nic-%s", var.virtual_machine_name, random_integer.this.result)
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = format("ipconfig-%s", random_integer.this.result)
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "dynamic"
  }

  tags = var.tags

  depends_on = [random_integer.this]
}

resource "azurerm_user_assigned_identity" "this" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.virtual_machine_name
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  network_interface_ids           = [azurerm_network_interface.this.id]
  size                            = var.virtual_machine_size
  disable_password_authentication = false
  admin_username                  = var.os_profile_admin_username
  admin_password                  = var.os_profile_admin_password
  computer_name                   = var.os_profile_computer_name

  identity {
    identity_ids = [azurerm_user_assigned_identity.this.id]
    type         = "UserAssigned"
  }

  os_disk {
    name                 = format("%s_os_disk_1_%s", var.virtual_machine_name, random_integer.this.result)
    caching              = "ReadWrite"
    disk_size_gb         = "128"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = var.tags

  depends_on = [azurerm_network_interface.this, azurerm_user_assigned_identity.this]
}

resource "azurerm_managed_disk" "this" {
  name                 = format("%s_data_disk_1_%s", var.virtual_machine_name, random_integer.this.result)
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  tags                 = var.tags

  depends_on = [azurerm_linux_virtual_machine.this]
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  managed_disk_id    = azurerm_managed_disk.this.id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = "0"
  caching            = "ReadWrite"

  depends_on = [azurerm_linux_virtual_machine.this, azurerm_managed_disk.this]
}

# resource "azurerm_virtual_machine_extension" "this" {
#   count = var.virtual_machine_count

#   name                 = "AzureDevOpsTools"
#   virtual_machine_id   = azurerm_virtual_machine.this.id
#   publisher            = "Microsoft.OSTCExtensions"
#   type                 = "CustomScriptForLinux"
#   type_handler_version = "1.5"

#   settings = <<SETTINGS
#   {
#   "fileUris": ["https://raw.githubusercontent.com/gvanderberg/devops-agents/master/ubuntu/18.04/amd64/setup.sh"],
#   "commandToExecute": "sudo ./setup.sh",
#   "timestamp" : "10"
#   }
# SETTINGS

#   tags = var.tags
# }

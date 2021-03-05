output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.this.id
}

output "virtual_machine_identity_principal_id" {
  value = azurerm_linux_virtual_machine.this.identity.0.principal_id
}

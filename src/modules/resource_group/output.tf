output "id" {
  value = element(coalescelist(azurerm_resource_group.this.*.id, data.azurerm_resource_group.this.*.id), 0)
}

output "name" {
  value = element(coalescelist(azurerm_resource_group.this.*.name, data.azurerm_resource_group.this.*.name), 0)
}

output "location" {
  value = element(coalescelist(azurerm_resource_group.this.*.location, data.azurerm_resource_group.this.*.location), 0)
}

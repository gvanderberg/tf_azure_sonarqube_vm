output "id" {
  value = module.vm.*.virtual_machine_id
}

output "principal_id" {
  value = module.vm.*.virtual_machine_identity_principal_id
}

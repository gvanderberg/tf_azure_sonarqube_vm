variable "admin_username" {
  default = "__admin_username__"
}

variable "admin_password" {
  default = "__admin_password__"
}

variable "computer_name" {
  default = "__computer_name__"
}

variable "location" {
  default = "__location__"
}

variable "resource_group_create" {
  default = "__resource_group_create__"
}

variable "resource_group_name" {
  default = "__resource_group_name__"
}

variable "subnet_name" {
  default = "__subnet_name__"
}

variable "subnet_resource_group_name" {
  default = "__subnet_resource_group_name__"
}

variable "subnet_virtual_network_name" {
  default = "__subnet_virtual_network_name__"
}

variable "virtual_machine_name" {
  default = "__virtual_machine_name__"
}

variable "virtual_machine_size" {
  default = "__virtual_machine_size__"
}

variable "tags" {
  default = {
    applicationName = "SonarQube"
    costCentre      = "IT Dev"
    createdBy       = "Terraform"
    environment     = "__tags_environment__"
    location        = "__tags_location__"
    managedBy       = "__tags_managed_by__"
  }
}

variable "os_profile_admin_username" {
  description = "Specifies the name of the local administrator account."
  type        = string
}

variable "os_profile_admin_password" {
  description = "The password associated with the local administrator account."
  type        = string
}

variable "os_profile_computer_name" {
  description = "Specifies the name of the Virtual Machine."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container Group."
  type        = string
}

variable "resource_group_location" {
  description = "Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "subnet_name" {
  description = "Specifies the name of the Subnet."
  type        = string
}

variable "subnet_resource_group_name" {
  description = "Specifies the name of the resource group the Virtual Network is located in."
  type        = string
}

variable "subnet_virtual_network_name" {
  description = "Specifies the name of the Virtual Network this Subnet is located within."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
}

variable "virtual_machine_name" {
  description = "Specifies the name of the Virtual Machine."
  type        = string
}

variable "virtual_machine_size" {
  description = "Specifies the size of the Virtual Machine."
  type        = string
}

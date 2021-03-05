variable "resource_group_create" {
  description = "Should the resource group be created."
  type        = bool
}

variable "resource_group_location" {
  description = "The location where the resource group should be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(any)
}

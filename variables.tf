variable "resource_group_name" {}
variable "location" {}

variable "vnet_name" {}
variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_name" {}
variable "subnet_prefixes" {
  type = list(string)
}
variable "subnet_id" {}

variable "nsg_name" {}

variable "vmss_name" {}
variable "vmss_size" {}

variable "instance_count" {
  default = 2
}

variable "admin_username" {}
variable "admin_password" {}

variable "lb_name" {}

variable "nat_gateway_name" {}

variable "bastion_name" {}

variable "autoscale_name" {}

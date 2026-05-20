variable "resource_group_name" {}
variable "location" {}

variable "vmss_name" {}
variable "vmss_size" {}

variable "instance_count" {
    type = number
}

variable "admin_username" {}
variable "admin_password" {
    sensitive = true
}

variable "subnet_id" {}

variable "backend_pool_id" {}

variable "health_probe_id" {}
module "rg" {
  source = "./modules/resource_group"

  resource_group_name = var.resource_group_name
  location = var.location
}

module "vnet" {
  source = "./modules/vnet"

  resource_group_name = module.rg.resource_group_name
  location = module.rg.location

  vnet_name = var.vnet_name
  vnet_address_space = var.vnet_address_space
}

module "subnet" {
  source = "./modules/subnet"

  resource_group_name = module.rg.resource_group_name

  subnet_name = var.subnet_name
  subnet_prefixes = var.subnet_prefixes

  vnet_name = var.vnet_name

  depends_on = [
    module.vnet
  ]

}

module "nsg" {
  source = "./modules/nsg"

  resource_group_name = module.rg.resource_group_name
  location = module.rg.location

  nsg_name = var.nsg_name
  subnet_id = module.subnet.subnet_id
}

module "lb" {
  source = "./modules/load_balancer"

  lb_name            = var.lb_name
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  nat_gateway_name   = var.nat_gateway_name

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  subnet_id          = module.subnet.subnet_id
}

module "vmss" {
  source = "./modules/vmss"

  vmss_name          = var.vmss_name

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  vmss_size = var.vmss_size
  subnet_id          = module.subnet.subnet_id

  backend_pool_id    = module.lb.backend_pool_id

  health_probe_id     = module.lb.health_probe_id

  admin_username     = var.admin_username
  admin_password     = var.admin_password

  instance_count     = var.instance_count
}

module "bastion" {
  source = "./modules/bastion"

  bastion_name = var.bastion_name

  resource_group_name = module.rg.resource_group_name
  location = module.rg.location
  
  vnet_name = module.vnet.vnet_name

  bastion_subnet_id = module.bastion.bastion_subnet_id
}

module "autoscale" {

  source = "./modules/autoscale"

  autoscale_name = var.autoscale_name

  resource_group_name = module.rg.resource_group_name

  location = module.rg.location

  vmss_id = module.vmss.vmss_id
}
resource "azurerm_public_ip" "lb_pip" {
  name                = "${var.lb_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Standard"

  zones = ["1"]
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku = "Standard"

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backend-pool"
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.lb.id

  name = "http-probe"
  port = 80
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id = azurerm_lb.lb.id

  name = "http-rule"

  protocol      = "Tcp"
  frontend_port = 80
  backend_port  = 80

  frontend_ip_configuration_name = "public-ip"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.backend.id
  ]

  probe_id = azurerm_lb_probe.http.id
}
resource "azurerm_public_ip" "nat_pip" {
  name                = "${var.nat_gateway_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Standard"

  zones = ["1"]
}

resource "azurerm_nat_gateway" "nat" {
  name                = var.nat_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name = "Standard"

  zones = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
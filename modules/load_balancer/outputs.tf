output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.backend.id
}

output "health_probe_id" {
  value = azurerm_lb_probe.http.id
}

output "public_ip_address" {
  value = azurerm_public_ip.lb_pip.ip_address
}
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {

  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku       = var.vmss_size
  instances = var.instance_count

  zones = ["1"]

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  computer_name_prefix = "webvm"

  upgrade_mode = "Manual"
  
  //health_probe_id = var.health_probe_id
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true

      subnet_id = var.subnet_id

      load_balancer_backend_address_pool_ids = [
        var.backend_pool_id
      ]
    }
  }

  custom_data = base64encode(
    file("${path.module}/bootstrap.sh")
  )

  boot_diagnostics {}
}
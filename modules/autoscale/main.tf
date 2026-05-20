resource "azurerm_monitor_autoscale_setting" "autoscale" {

  name                = var.autoscale_name

  resource_group_name = var.resource_group_name

  location            = var.location

  target_resource_id  = var.vmss_id

  profile {

    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 5
    }

    # =====================================================
    # SCALE OUT RULE
    # =====================================================

    rule {

      metric_trigger {

        metric_name        = "Percentage CPU"

        metric_resource_id = var.vmss_id

        time_grain = "PT1M"

        statistic = "Average"

        time_window = "PT5M"

        time_aggregation = "Average"

        operator = "GreaterThan"

        threshold = 75
      }

      scale_action {

        direction = "Increase"

        type = "ChangeCount"

        value = "1"

        cooldown = "PT5M"
      }
    }

    # =====================================================
    # SCALE IN RULE
    # =====================================================

    rule {

      metric_trigger {

        metric_name        = "Percentage CPU"

        metric_resource_id = var.vmss_id

        time_grain = "PT1M"

        statistic = "Average"

        time_window = "PT10M"

        time_aggregation = "Average"

        operator = "LessThan"

        threshold = 25
      }

      scale_action {

        direction = "Decrease"

        type = "ChangeCount"

        value = "1"

        cooldown = "PT10M"
      }
    }
  }
}
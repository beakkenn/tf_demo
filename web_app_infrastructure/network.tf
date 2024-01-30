locals {
  resource_group_network = var.create_resource_group ? azurerm_resource_group.network[0] : data.azurerm_resource_group.network[0]
  resource_group_network_name = "rg-${var.global_settings.workload_network}-${var.global_settings.environment}-${var.global_settings.location_short}-01"
}


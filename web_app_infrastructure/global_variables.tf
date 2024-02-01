locals {
  resource_group_webapp      = var.create_resource_group ? azurerm_resource_group.rg[0] : data.azurerm_resource_group.rg[0]
  resource_group_webapp_name = "rg-${var.global_settings.workload}-${var.global_settings.location_short}-01"
}


variable "global_settings" {
  description = "Settings used through the deployment, passed via .auto.tfvars files for the environment"
  type = object({
    workload             = string
    workload_database    = string
    workload_network     = string
    workload_vm_scaleset = string
    environment          = string
    location             = string
    location_short       = string
    tags                 = map(string)
  })
}
variable "create_resource_group" {
  description = <<-EOF
    When set to `true` it will cause a Resource Group creation.  Name of the newly specified RG is controlled by `resource_group_name`.
    When set to `false` the `resource_group_name` parameter is used to specificy a name of an existing Resource Group.
    EOF
  default     = true
  type        = bool
}
resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = local.resource_group_webapp_name
  location = var.global_settings.location
  tags     = var.global_settings.tags
}

data "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 0 : 1
  name  = local.resource_group_webapp_name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
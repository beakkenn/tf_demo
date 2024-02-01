variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}
/*
variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}*/

variable "subnet_app_address_prefixes" {
  description = "The address prefix for the application subnet"
  type        = list(string)
}

variable "subnet_db_address_prefixes" {
  description = "The address prefix for the database subnet"
  type        = list(string)
}

variable "subnet_app_name" {
  description = "The name of the app subnet"
  type        = string
}

variable "subnet_db_name" {
  description = "The name of the db subnet"
  type        = string
}

resource "azurerm_resource_group" "network" {
  count    = var.create_resource_group ? 1 : 0
  name     = local.resource_group_webapp_name
  location = var.global_settings.location
  tags     = var.global_settings.tags
}

data "azurerm_resource_group" "network" {
  count = var.create_resource_group ? 0 : 1
  name  = local.resource_group_webapp_name
}

module "network" {
  source                      = "../modules/network"
  vnet_name                   = var.vnet_name
  address_space               = var.address_space
  location                    = var.global_settings.location
  resource_group_name         = local.resource_group_webapp_name
  subnet_app_address_prefixes = var.subnet_app_address_prefixes
  subnet_db_address_prefixes  = var.subnet_db_address_prefixes
  subnet_app_name             = var.subnet_app_name
  subnet_db_name              = var.subnet_db_name
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.resource_group_webapp_name
}

resource "azurerm_private_dns_zone" "postgresql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = local.resource_group_webapp_name
}


/*
output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the virtual network"
}

output "subnet_app_id" {
  value       = azurerm_subnet.subnet_app.id
  description = "The ID of the application subnet"
}

output "subnet_db_id" {
  value       = azurerm_subnet.subnet_db.id
  description = "The ID of the database subnet"
}

output "nsg_app_id" {
  value       = azurerm_network_security_group.nsg_app.id
  description = "The ID of the application network security group"
}

output "nsg_db_id" {
  value       = azurerm_network_security_group.nsg_db.id
  description = "The ID of the database network security group"
}
*/
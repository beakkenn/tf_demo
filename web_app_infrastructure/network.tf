locals {
  resource_group_network = var.create_resource_group ? azurerm_resource_group.network[0] : data.azurerm_resource_group.network[0]
  resource_group_network_name = "rg-${var.global_settings.workload_network}-${var.global_settings.environment}-${var.global_settings.location_short}-01"
}

variable "vnets" {
  description = <<-EOF
  A map defining VNETs.
  
  For detailed documentation on each property refer to [module documentation](../../modules/virtual_network_with_secured_subnets/README.md)

  - `create_virtual_network` : (default: `true`) when set to `true` will create a VNET, `false` will source an existing VNET, in both cases the name of the VNET is specified with `name`
  - `name` :  A name of a VNET.
  - `resource_group_name` :  (default: current RG) a name of a Resource Group in which the VNET will reside
  - `address_space` : a list of CIDRs for VNET
  - `dns_servers` : (default: `Azure Provided`) a list of DNS Servers for the vNet.

  - `create_subnets` : (default: `true`) if true, create the Subnets inside the Virtual Network, otherwise use pre-existing subnets
  - `subnets` : map of Subnets to create

  - `network_security_groups` : map of Network Security Groups to create
  - `route_tables` : map of Route Tables to create.
  EOF

}
variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}

variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_app_address_prefixes" {
  description = "The address prefix for the application subnet"
  type        = list(string)
}

variable "subnet_db_address_prefixes" {
  description = "The address prefix for the database subnet"
  type        = list(string)
}

resource "azurerm_resource_group" "network" {
  count    = var.create_resource_group ? 1 : 0
  name     = local.resource_group_network_name
  location = var.global_settings.location
  tags     = var.global_settings.tags
}

data "azurerm_resource_group" "network" {
  count = var.create_resource_group ? 0 : 1
  name  = local.resource_group_network_name
}

module "network" {
  source                      = "modules/network"
  vnet_name                   = var.vnet_name
  address_space               = var.address_space
  location                    = var.location
  resource_group_name         = var.resource_group_name
  subnet_app_address_prefixes = var.subnet_app_address_prefixes
  subnet_db_address_prefixes  = var.subnet_db_address_prefixes
}

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

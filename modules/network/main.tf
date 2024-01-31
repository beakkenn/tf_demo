# Variables

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "location" {
  description = "Azure region to deploy the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_app_name" {
  description = "Name of the application subnet"
  type        = string
}

variable "subnet_app_address_prefixes" {
  description = "Address prefixes for the application subnet"
  type        = list(string)
}

variable "subnet_app_service_endpoints" {
  description = "List of service endpoints for the application subnet"
  type        = list(string)
  default     = []
}

variable "subnet_db_name" {
  description = "Name of the database subnet"
  type        = string
}

variable "subnet_db_address_prefixes" {
  description = "Address prefixes for the database subnet"
  type        = list(string)
}

variable "subnet_db_service_endpoints" {
  description = "List of service endpoints for the database subnet"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

# Virtual Network

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_app" {
  name                 = var.subnet_app_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_app_address_prefixes
}

resource "azurerm_subnet" "subnet_db" {
  name                 = var.subnet_db_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_db_address_prefixes
}

resource "azurerm_network_security_group" "nsg_app" {
  name                = "nsg-${var.subnet_app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_app" {
  subnet_id                 = azurerm_subnet.subnet_app.id
  network_security_group_id = azurerm_network_security_group.nsg_app.id
}

resource "azurerm_network_security_group" "nsg_db" {
  name                = "nsg-${var.subnet_db_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_db" {
  subnet_id                 = azurerm_subnet.subnet_db.id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
}



# Outputs

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


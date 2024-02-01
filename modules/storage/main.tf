variable "storage_account" {
  description = "The configuration of the storage account."
  type = object({
    name                     = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
    containers               = list(object({
      name                 = string
      container_access_type = string
    }))
    private_endpoints = list(object({
      name                           = string
      subnet_id                      = string
      private_service_connection_name = string
    }))
  })
}


variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account.name
  resource_group_name      = var.resource_group_name
  location                 = var.storage_account.location
  account_tier             = var.storage_account.account_tier
  account_replication_type = var.storage_account.account_replication_type

  tags = var.storage_account.tags
}

resource "azurerm_storage_container" "container" {
  for_each             = { for container in var.storage_account.containers : container.name => container }
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name
  container_access_type = each.value.container_access_type
}

resource "azurerm_private_endpoint" "pep" {
  for_each             = { for pep in var.storage_account.pep : pep.name => pep }
  name                 = each.value.name
  location             = azurerm_storage_account.storage_account.location
  resource_group_name  = azurerm_storage_account.storage_account.resource_group_name
  subnet_id            = each.value.subnet_id

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}


output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}
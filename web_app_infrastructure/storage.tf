


variable "storage_accounts" {
  description = "A map of storage account configurations."
  type = map(object({
    name                     = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
  }))
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

module "storage_account" {
  source              = "../modules/storage"
  for_each            = var.storage_accounts
  resource_group_name = local.resource_group_webapp_name
  storage_account     = each.value
}
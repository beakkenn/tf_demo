


variable "storage_accounts" {
  description = "A map of storage account configurations."
  type = map(object({
    name                     = string
    # resource_group_name      = string
    # location                 = string
    account_tier             = string
    account_replication_type = string
    default_network_access_rule = string
    ip_rules                 = list(string)
    # tags                     = map(string)
  }))
}



module "storage_account" {
  for_each            = var.storage_accounts
  source              = "../modules/storage"
  
  name                = each.value.name
  resource_group_name = local.resource_group_webapp_name
  location            = var.global_settings.location
  account_tier        = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  default_network_access_rule = each.value.default_network_access_rule
  ip_rules            = each.value.ip_rules
  tags                = var.global_settings.tags
}
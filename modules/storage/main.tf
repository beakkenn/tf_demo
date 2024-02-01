variable "name" {
  description = "Specifies the name of the storage account."
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the name of the resource group in which to create the storage account."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account."
  type        = string
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account."
  type        = string
}

variable "default_network_access_rule" {
  description = "Specifies the default action of allow or deny when no other rules match."
  default     = "deny"
  type        = string
}

variable "ip_rules" {
  description = "A list of IP addresses or IP address ranges in CIDR format."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}


resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  network_rules {
    default_action             = var.default_network_access_rule
    ip_rules                   = var.ip_rules
  }

  tags = var.tags
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

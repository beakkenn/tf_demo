global_settings = {
  workload             = "webapp",
  workload_database    = "database",
  workload_network     = "network",
  workload_vm_scaleset = "vm_scaleset",
  environment          = "dev",
  location             = "eastus",
  location_short       = "eus",
  tags = {
    "Subscription" = "Non-Production"
    "Environment"  = "Development"
  },
}



vnet_name     = "vnet-webapp-eus01"
address_space = ["10.0.0.0/16"]
# location                     = "eastus"
# resource_group_name          = "myResourceGroup"
subnet_app_address_prefixes = ["10.0.1.0/24"]
subnet_db_address_prefixes  = ["10.0.2.0/24"]
subnet_app_name             = "snet-app-eus"
subnet_db_name              = "snet-db-eus"



storage_accounts = {
  "account1" = {
    name                     = "examplestoracc1"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags                     = { "Environment" = "Dev" }
    containers = [
      {
        name                  = "container1"
        container_access_type = "private"
      }
    ]
    private_endpoints = [
      {
        name                           = "pe-examplestoracc1"
        subnet_id                      = azurerm_subnet.example.id
        private_service_connection_name = "psc-examplestoracc1"
      }
    ]
  }
  # Additional storage accounts as needed
}


global_settings = {
  workload               = "webapp",
  workload_database      = "database",
  workload_network       = "network",
  workload_vm_scaleset   = "vm_scaleset",
  environment            = "dev",
  location               = "eastus2",
  location_short         = "eus2",
  tags = {
    "Subscription" = "Non-Production"
    "Environment"  = "Development"
  },
}

vnet_name                    = "vnet-webapp-eus01"
address_space                = ["10.0.0.0/16"]
# location                     = "eastus"
# resource_group_name          = "myResourceGroup"
subnet_app_address_prefixes  = ["10.0.1.0/24"]
subnet_db_address_prefixes   = ["10.0.2.0/24"]
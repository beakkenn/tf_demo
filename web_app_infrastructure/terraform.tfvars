#vnet_name                    = "vnet-webapp-eus01"
address_space                = ["10.0.0.0/16"]
location                     = "eastus"
resource_group_name          = "myResourceGroup"
subnet_app_address_prefixes  = ["10.0.1.0/24"]
subnet_db_address_prefixes   = ["10.0.2.0/24"]
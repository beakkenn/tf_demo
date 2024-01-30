variable "global_settings" {
    description = "Settings used through the deployment, passed via .auto.tfvars files for the environment"
    type = object({
      workload = string
      workload_database = string
      workload_network = string
      workload_vm_scaleset = string
      environment = string
      location = string
      location_short = string
      tags = map(string)
    })
}
variable "create_resource_group" {
    description = <<-EOF
    When set to `true` it will cause a Resource Group creation.  Name of the newly specified RG is controlled by `resource_group_name`.
    When set to `false` the `resource_group_name` parameter is used to specificy a name of an existing Resource Group.
    EOF
    default = true
    type = bool
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
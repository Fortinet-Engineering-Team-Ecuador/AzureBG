resource "fortios_system_sdnconnector" "this" {
  name            = var.sdn_name
  status          = var.sdn_status
  type            = "azure"

  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret

  resource_group  = var.azure_resource_group
  azure_region    = var.azure_region

  update_interval  = var.sdn_update_interval
  use_metadata_iam = var.sdn_use_metadata_iam
}

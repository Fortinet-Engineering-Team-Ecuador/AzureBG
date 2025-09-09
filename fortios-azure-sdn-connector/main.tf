module "azure_sdn_connector" {
  source = "./modules/fortios-sdn-connector"

  sdn_name              = var.sdn_name
  sdn_status            = var.sdn_status
  azure_tenant_id       = var.azure_tenant_id
  azure_subscription_id = var.azure_subscription_id
  azure_client_id       = var.azure_client_id
  azure_client_secret   = var.azure_client_secret
  azure_resource_group  = var.azure_resource_group
  azure_region          = var.azure_region
  sdn_update_interval   = var.sdn_update_interval
  sdn_use_metadata_iam  = var.sdn_use_metadata_iam
}

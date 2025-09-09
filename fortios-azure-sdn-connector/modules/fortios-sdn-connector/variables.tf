variable "sdn_name" { type = string }
variable "sdn_status" { type = string }
variable "azure_tenant_id" { type = string }
variable "azure_subscription_id" { type = string }
variable "azure_client_id" { type = string }
variable "azure_client_secret" { type = string, sensitive = true }
variable "azure_resource_group" { type = string }
variable "azure_region" { type = string }
variable "sdn_update_interval" { type = number }
variable "sdn_use_metadata_iam" { type = string }

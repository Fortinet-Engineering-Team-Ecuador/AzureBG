variable "fos_hostname" { type = string }
variable "fos_token" { type = string, sensitive = true }
variable "fos_vdom" { type = string, default = "root" }
variable "fos_insecure" { type = bool, default = false }
variable "fos_cabundlefile" { type = string, default = null }

variable "sdn_name" { type = string, default = "azure-sdn" }
variable "sdn_status" { type = string, default = "enable" }
variable "azure_tenant_id" { type = string }
variable "azure_subscription_id" { type = string }
variable "azure_client_id" { type = string }
variable "azure_client_secret" { type = string, sensitive = true }
variable "azure_resource_group" { type = string }
variable "azure_region" { type = string, default = "global" }
variable "sdn_update_interval" { type = number, default = 60 }
variable "sdn_use_metadata_iam" { type = string, default = "disable" }

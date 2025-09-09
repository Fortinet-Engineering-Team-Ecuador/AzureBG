provider "fortios" {
  hostname      = var.fos_hostname
  token         = var.fos_token
  vdom          = var.fos_vdom
  insecure      = var.fos_insecure
  cabundlefile  = var.fos_cabundlefile
}

provider "azurerm" {
  features {}
}

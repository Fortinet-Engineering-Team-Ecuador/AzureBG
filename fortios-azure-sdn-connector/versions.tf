terraform {
  required_version = ">= 1.6.0"

  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = "~> 1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112"
    }
  }
}

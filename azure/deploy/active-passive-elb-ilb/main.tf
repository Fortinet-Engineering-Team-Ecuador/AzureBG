##############################################################################################################
#
# FortiGate Active/Passive High Availability with Azure Standard Load Balancer - External and Internal
# Terraform deployment template for Microsoft Azure
#
##############################################################################################################
##############################################################################################################
# Resource Group
##############################################################################################################
# Data source para usar un RG existente
data "azurerm_resource_group" "resourcegroup" {
  name = var.rg
}

##############################################################################################################
# Virtual Network - VNET
##############################################################################################################
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = var.vnet
  location            = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnets" {
  for_each = { for s in var.subnets : s.name => s }

  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.cidr
}

##############################################################################################################
# Load Balancers
##############################################################################################################
module "elb" {
  source                       = "Azure/loadbalancer/azurerm"
  resource_group_name          = data.azurerm_resource_group.resourcegroup.name
  name                         = "${var.prefix}-externalloadbalancer"
  type                         = "public"
  lb_floating_ip_enabled       = true
  lb_probe_interval            = 5
  lb_probe_unhealthy_threshold = 2
  lb_sku                       = "Standard"
  pip_name                     = "${var.prefix}-elb-pip"
  pip_sku                      = "Standard"

  lb_port = {
    http     = ["80", "Tcp", "80"]
    udp10551 = ["10551", "Udp", "10551"]
  }
  lb_probe = {
    lbprobe = ["Tcp", "8008", ""]
  }
  tags       = var.fortinet_tags
  depends_on = [data.azurerm_resource_group.resourcegroup]
}

module "ilb" {
  source                       = "Azure/loadbalancer/azurerm"
  resource_group_name          = data.azurerm_resource_group.resourcegroup.name
  name                         = "${var.prefix}-internalloadbalancer"
  type                         = "private"
  lb_floating_ip_enabled       = true
  lb_probe_interval            = 5
  lb_probe_unhealthy_threshold = 2
  lb_sku                       = "Standard"
  frontend_subnet_id           = azurerm_subnet.subnets["subnet-internal"].id

  lb_port = {
    haports = ["0", "All", "0"]
  }
  lb_probe = {
    lbprobe = ["Tcp", "8008", ""]
  }
  tags       = var.fortinet_tags
  depends_on = [data.azurerm_resource_group.resourcegroup]
}

##############################################################################################################
# Public IP for management interface of the FortiGate
##############################################################################################################
resource "azurerm_public_ip" "fgtamgmtpip" {
  name                = "${var.prefix}-fgt-a-mgmt-pip"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-fgt-a-mgmt-pip"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "fgtbmgmtpip" {
  name                = "${var.prefix}-fgt-b-mgmt-pip"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-fgt-b-mgmt-pip"
  sku                 = "Standard"
}


##############################################################################################################
# FortiGate
##############################################################################################################
module "fgt" {
  #  source = "github.com/40net-cloud/terraform-azure-fortigate/modules/active-passive"
  source = "../../modules/active-passive"

  prefix                             = var.prefix
  location                           = var.location
  resource_group_name                = data.azurerm_resource_group.resourcegroup.name
  username                           = var.username
  password                           = var.password
  virtual_network_id                 = azurerm_virtual_network.vnet.id
  virtual_network_address_space      = azurerm_virtual_network.vnet.address_space
  subnet_names                       = slice([for s in var.subnets : s.name], 0, 4)
  fgt_image_sku                      = var.fgt_image_sku
  fgt_version                        = var.fgt_version
  fgt_byol_license_file_a            = var.fgt_byol_license_file_a
  fgt_byol_license_file_b            = var.fgt_byol_license_file_b
  fgt_byol_fortiflex_license_token_a = var.fgt_byol_fortiflex_license_token_a
  fgt_byol_fortiflex_license_token_b = var.fgt_byol_fortiflex_license_token_b
  fgt_accelerated_networking         = var.fgt_accelerated_networking
  fgt_ip_configuration               = local.fgt_ip_configuration
  fgt_a_customdata_variables         = local.fgt_a_vars
  fgt_b_customdata_variables         = local.fgt_b_vars
  fgt_availability_set               = var.fgt_availability_set
  fgt_datadisk_size                  = var.fgt_datadisk_size
  fgt_datadisk_count                 = var.fgt_datadisk_count
}

##############################################################################################################

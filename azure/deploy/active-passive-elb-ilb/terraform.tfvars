############################################################################################################################################
#Required variables for deployment of FortiGate Active/Passive High Availability with Azure Standard Load Balancer - External and Internal #
############################################################################################################################################

# Added name to each deployed resource
prefix = "azforti01"

# Added RG to deploy resource
rg = "rg-forti-prod-001"

# Azure region
location = "eastus2"

# Username for FortiGate admin
username = "quiron"

# Password for FortiGate admin
password = "Fortibg.123"

# Azure subscription ID
subscription_id = "cf72478e-c3b0-4072-8f60-41d037c1d9e9"

# Azure Marketplace image SKU: PAYG ('fortinet_fg-vm_payg_2023') or BYOL ('fortinet_fg-vm')
fgt_image_sku = "fortinet_fg-vm"

# FortiGate version, defaults to latest available in Azure Marketplace
fgt_version = "7.4.4"

# Deploy FortiGate in a new Availability Set or Availability Zone (true:Availability Set false:Availability Zone )
fgt_availability_set = false

# Azure VM size for FortiGate instances
fgt_vmsize = "Standard_F4s"

# Size in GB for FortiGate data disks
fgt_datadisk_size = 64

# Number of data disks to attach to each FortiGate
fgt_datadisk_count = 1


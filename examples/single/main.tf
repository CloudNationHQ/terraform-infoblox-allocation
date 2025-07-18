locals {
  vnets = {
    # single scenario
    weu = {
      vnet_name = "vnet-we-p-gmdss-001"
      location  = "westeurope"
      network = {
        name          = "nw-we-p-gmdss-001"
        parent_cidr   = "10.192.0.0/16"
        prefix_length = 27
        comment       = "nw-we-p-gmdss-001"
        ext_attrs = {
          "Network Object Name" = "net-we-nw-p-gmdss-001"
          "Network Function"    = "Azure Landing Zone"
        }
      }
      subnets = {
        subnet1 = {
          name          = "sn-we-p-gmdss-001"
          nsg_name      = "nsg-we-p-gmdss-001"
          prefix_length = 27
          ext_attrs = {
            "Network Object Name" = "net-we-sn-p-gmdss-001"
            "Network Function"    = "Azure Landing Zone"
          }
        }
      }
    }
  }

  vnet_configs = {
    for vnet_key, vnet_config in local.vnets : vnet_key => {
      name           = vnet_config.vnet_name
      location       = vnet_config.location
      resource_group = module.rg.groups.network.name
      address_space  = [module.allocation_network[vnet_key].main_network_cidr]
      dns_servers    = ["10.224.2.6", "10.228.2.6"]

      subnets = {
        for subnet_name, subnet_config in vnet_config.subnets : subnet_name => {
          name             = subnet_config.name
          address_prefixes = [module.allocation_network[vnet_key].main_network_cidr] # Use container CIDR directly
          network_security_group = {
            name = subnet_config.nsg_name
          }
        }
      }
    }
  }
}

module "allocation_network" {
  source = "git::https://github.com/CloudNationHQ/terraform-infoblox-allocation.git?ref=feat/small-refactor"

  for_each = local.vnets

  network_view = "default"
  network      = each.value.network
  subnets      = {} # Empty - using container directly as subnet
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    network = {
      name     = "rg-we-p-network-001"
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 8.0"

  for_each = local.vnets

  naming = local.naming
  vnet   = local.vnet_configs[each.key]
}

module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 1.0"
}

locals {
  naming = module.naming.naming
}


locals {
  vnets = {
    # multiple scenario
    weu = {
      vnet_name = "vnet-we-p-multi-001"
      location  = "westeurope"
      network = {
        name          = "nw-p-multi-001"
        parent_cidr   = "10.192.0.0/16"
        prefix_length = 27
        comment       = "nw-p-multi-001"
        ext_attrs = {
          "Network Object Name" = "net-we-nw-p-multi-001"
          "Network Function"    = "Azure Landing Zone"
        }
      }
      subnets = {
        app = {
          name          = "sn-we-p-app-001"
          nsg_name      = "nsg-we-p-multi-app-001"
          prefix_length = 30
          comment       = "net-we-p-multi-app-001"
          ext_attrs = {
            "Network Object Name" = "net-we-sn-p-multi-app-001"
            "Network Function"    = "Azure Landing Zone"
          }
        }
        db = {
          name          = "sn-we-p-db-001"
          nsg_name      = "nsg-we-p-multi-db-001"
          prefix_length = 30
          comment       = "net-we-p-multi-db-001"
          ext_attrs = {
            "Network Object Name" = "net-we-sn-p-multi-db-001"
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
          address_prefixes = [module.allocation_subnets[vnet_key].subnet_cidrs[subnet_name]]
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
  subnets      = {}  # Empty - using separate subnet module
}

module "allocation_subnets" {
  source = "git::https://github.com/CloudNationHQ/terraform-infoblox-allocation.git//modules/network?ref=feat/small-refactor"

  for_each = local.vnets

  subnets      = each.value.subnets
  parent_cidr  = module.allocation_network[each.key].main_network_cidr
  network_view = "default"
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
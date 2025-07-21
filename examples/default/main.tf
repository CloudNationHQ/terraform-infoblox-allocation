locals {
  vnets = {
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
          name             = "sn-we-p-gmdss-001"
          nsg_name         = "nsg-we-p-gmdss-001"
          prefix_length    = 27
          comment          = "sn-we-p-gmdss-001"
          network_function = "azure landing zone"
          location_code    = "euaz"
          network_view     = "default"
          ext_attrs = {
            "Network Object Name" = "net-we-nw-p-001 sn-we-p-gmdss-001"
            "Network Function"    = "Azure Landing Zone"
          }
        }
      }
    }
  }

  flattened_subnets = merge([
    for vnet_key, vnet_config in local.vnets : {
      for subnet_key, subnet_config in vnet_config.subnets :
      "${vnet_key}_${subnet_key}" => merge(subnet_config, {
        vnet_key = vnet_key
      })
    }
  ]...)

  vnet_configs = {
    for vnet_key, vnet_config in local.vnets : vnet_key => {
      name           = vnet_config.vnet_name
      location       = vnet_config.location
      resource_group = module.rg.groups.network.name
      address_space = [
        module.allocation_network[vnet_key].azure_vnet_address_space
      ]
      dns_servers = ["10.224.2.6", "10.228.2.6"]
      subnets = {
        for subnet_name, subnet_config in vnet_config.subnets : subnet_name => {
          network_security_group = {
            name = subnet_config.nsg_name
          }
          address_prefixes = [module.allocation_network[vnet_key].azure_vnet_address_space]
          name             = subnet_config.name
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
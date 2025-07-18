locals {
  vnets = {
    weu = {
      vnet_name = "vnet-we-p-runners-001"
      location  = "westeurope"
      network = {
        name          = "nw-p-runners-001"
        parent_cidr   = "10.192.0.0/16"
        prefix_length = 27
        comment       = "nw-p-001"
        ext_attrs = {
          "Network Object Name" = "net-we-nw-p-runners-001"
          "Network Function"    = "Azure Landing Zone"
        }
      }
      subnets = {
        runners = {
          name             = "sn-we-p-runners-001"
          nsg_name         = "nsg-we-p-runners-001"
          prefix_length    = 27
          comment          = "sn-we-p-runners-001"
          network_function = "azure landing zone"
          location_code    = "euaz"
          network_view     = "default"
          ext_attrs = {
            "Network Object Name" = "net-we-nw-p-001 sn-we-p-runners-001"
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
      resource_group = module.rg.groups.runners.name
      address_space  = [
        module.allocation_network[vnet_key].azure_vnet_address_space
      ]
      dns_servers    = ["10.224.2.6", "10.228.2.6"]
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

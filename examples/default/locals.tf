locals {
  vnets = {
    # Scenario 1: VNet /27 with 1 subnet /27 (same size - uses container CIDR)
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
          name          = "sn-we-p-runners-001"
          nsg_name      = "nsg-we-p-runners-001"
          prefix_length = 27
          comment       = "sn-we-p-runners-001"
          ext_attrs = {
            "Network Object Name" = "net-we-sn-p-runners-001"
            "Network Function"    = "Azure Landing Zone"
          }
        }
      }
    }

    # Scenario 2: VNet /27 with 2 subnets /30 (smaller - gets separate allocations)
    neu = {
      vnet_name = "vnet-ne-p-multi-001"
      location  = "northeurope"
      network = {
        name          = "nw-p-multi-001"
        parent_cidr   = "10.192.0.0/16"
        prefix_length = 27
        comment       = "nw-p-multi-001"
        ext_attrs = {
          "Network Object Name" = "net-ne-nw-p-multi-001"
          "Network Function"    = "Azure Landing Zone"
        }
      }
      subnets = {
        app = {
          name          = "sn-ne-p-multi-app-001"
          nsg_name      = "nsg-ne-p-multi-app-001"
          prefix_length = 30
          comment       = "sn-ne-p-multi-app-001"
          ext_attrs = {
            "Network Object Name" = "net-ne-sn-p-multi-app-001"
            "Network Function"    = "Azure Landing Zone"
          }
        }
        db = {
          name          = "sn-ne-p-multi-db-001"
          nsg_name      = "nsg-ne-p-multi-db-001"
          prefix_length = 30
          comment       = "sn-ne-p-multi-db-001"
          ext_attrs = {
            "Network Object Name" = "net-ne-sn-p-multi-db-001"
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
      resource_group = module.rg.groups.runners.name
      address_space  = [module.allocation_network[vnet_key].azure_vnet_address_space]
      dns_servers    = ["10.224.2.6", "10.228.2.6"]

      subnets = {
        for subnet_name, subnet_config in vnet_config.subnets : subnet_name => {

          name             = subnet_config.name
          address_prefixes = [module.allocation_network[vnet_key].subnet_cidrs[subnet_name]]
          network_security_group = {
            name = subnet_config.nsg_name
          }
        }
      }
    }
  }
}

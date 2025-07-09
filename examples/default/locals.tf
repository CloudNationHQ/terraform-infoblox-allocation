locals {
  subnets = {
    sql = {
      prefix_length    = 25
      comment          = "Azure SQL subnet"
      network_function = "Azure Landing Zone"
      location_code    = "EUAZ"
    }
    web = {
      prefix_length    = 25
      comment          = "Azure Web subnet"
      network_function = "Azure Landing Zone"
      location_code    = "EUAZ"
    }
  }
}

locals {
  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    address_space  = [module.infoblox_main_network.azure_vnet_address_space]
    dns_servers    = ["10.224.2.6", "10.228.2.6"]

    subnets = {
      for subnet_name, subnet_config in local.subnets : subnet_name => {
        network_security_group = {}
        address_prefixes       = [module.infoblox_subnets[subnet_name].subnet_cidr]
      }
    }
  }
}


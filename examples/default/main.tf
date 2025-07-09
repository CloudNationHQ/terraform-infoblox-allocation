module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "infoblox_main_network" {
  source  = "cloudnationhq/network/infoblox"
  version = "~> 1.0"

  network_view = "default"

  main_network = {
    name          = "demo"
    parent_cidr   = "10.207.252.0/22"
    prefix_length = 24
    comment       = "Main network for demo"
    ext_attrs = {
      "Customer"    = "YourCompany"
      "Environment" = "Production"
    }
  }
}

module "infoblox_subnets" {
  source  = "cloudnationhq/network/infoblox//modules/subnet"
  version = "~> 1.0"

  for_each = local.subnets

  network_view     = "default"
  parent_cidr      = module.infoblox_main_network.main_network_cidr
  prefix_length    = each.value.prefix_length
  comment          = each.value.comment
  network_function = each.value.network_function
  location_code    = each.value.location_code
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 8.0"
  naming  = local.naming

  vnet = local.vnet

  depends_on = [
    module.infoblox_main_network,
    module.infoblox_subnets
  ]
}

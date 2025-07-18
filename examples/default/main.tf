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

module "allocation_network" {
  source  = "cloudnationhq/allocation/infoblox"
  version = "~> 1.0"

  for_each = local.vnets

  network_view = "default"
  network      = each.value.network
}

module "allocation_subnets" {
  source  = "cloudnationhq/allocation/infoblox//modules/network"
  version = "~> 1.0"

  for_each = local.flattened_subnets

  network_view     = each.value.network_view
  parent_cidr      = module.allocation_network[each.value.vnet_key].main_network_cidr
  prefix_length    = each.value.prefix_length
  comment          = each.value.comment
  network_function = each.value.network_function
  location_code    = each.value.location_code
  ext_attrs        = each.value.ext_attrs
}

module "network" {
  source   = "cloudnationhq/vnet/azure"
  version  = "~> 8.0"
  for_each = local.vnets

  naming = local.naming
  vnet   = local.vnet_configs[each.key]
}

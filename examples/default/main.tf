module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = [var.location, var.environment]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    network = {
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

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 8.0"

  for_each = local.vnets

  naming = local.naming
  vnet   = local.vnet_configs[each.key]
}

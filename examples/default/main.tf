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
  source = "git::https://github.com/CloudNationHQ/terraform-infoblox-allocation.git?ref=feat/small-refactor"

  for_each = local.vnets

  network_view = "default"
  network      = each.value.network
  subnets      = each.value.subnets
}

module "network" {
  source   = "cloudnationhq/vnet/azure"
  version  = "~> 8.0"

  for_each = local.vnets

  naming = local.naming
  vnet   = local.vnet_configs[each.key]
}

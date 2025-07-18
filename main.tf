# data source for existing network container
data "infoblox_ipv4_network_container" "parent_container" {
  filters = {
    network_view = var.network_view
    network      = var.network.parent_cidr
  }
}

# container network
resource "infoblox_ipv4_network_container" "network" {
  parent_cidr         = data.infoblox_ipv4_network_container.parent_container.filters.network
  allocate_prefix_len = var.network.prefix_length
  network_view        = data.infoblox_ipv4_network_container.parent_container.filters.network_view
  comment             = var.network.comment
  ext_attrs           = jsonencode(var.network.ext_attrs)
}

# subnet networks - always create subnet resources
resource "infoblox_ipv4_network" "subnets" {
  for_each = var.subnets

  parent_cidr         = infoblox_ipv4_network_container.network.cidr
  allocate_prefix_len = each.value.prefix_length
  network_view        = var.network_view
  comment             = each.value.comment
  ext_attrs           = jsonencode(each.value.ext_attrs)
}

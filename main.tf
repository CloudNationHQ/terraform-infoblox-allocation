# container network
resource "infoblox_ipv4_network_container" "network" {
  parent_cidr         = var.network.parent_cidr
  allocate_prefix_len = var.network.prefix_length
  network_view        = var.network_view
  comment             = var.network.comment
  ext_attrs           = jsonencode(var.network.ext_attrs)
}

# subnets - only when subnets are smaller than the container
resource "infoblox_ipv4_network" "subnets" {
  for_each = {
    for k, v in var.subnets : k => v
    if v.prefix_length > var.network.prefix_length
  }

  parent_cidr         = infoblox_ipv4_network_container.network.cidr
  allocate_prefix_len = each.value.prefix_length
  network_view        = var.network_view
  comment             = each.value.comment
  ext_attrs           = jsonencode(each.value.ext_attrs)
}

# subnet networks
resource "infoblox_ipv4_network" "subnets" {
  for_each = var.subnets

  parent_cidr         = var.parent_cidr
  allocate_prefix_len = each.value.prefix_length
  network_view        = var.network_view
  comment             = each.value.comment
  ext_attrs           = jsonencode(each.value.ext_attrs)
}
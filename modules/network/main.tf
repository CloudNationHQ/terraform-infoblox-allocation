resource "infoblox_ipv4_network" "subnet" {
  parent_cidr         = var.parent_cidr
  allocate_prefix_len = var.prefix_length
  network_view        = var.network_view
  reserve_ip          = var.reserve_ip
  gateway             = var.gateway
  comment             = var.comment
  ext_attrs           = jsonencode(var.ext_attrs)
}

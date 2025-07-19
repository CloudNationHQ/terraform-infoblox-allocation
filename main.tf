# single network allocation - serves as vnet allocation only
resource "infoblox_ipv4_network" "network" {
  parent_cidr         = var.network.parent_cidr
  allocate_prefix_len = var.network.prefix_length
  network_view        = var.network_view
  comment             = var.network.comment
  ext_attrs           = jsonencode(var.network.ext_attrs)
}

# existing containers
data "infoblox_ipv4_network_container" "existing_parent" {
  for_each = toset(compact([var.network.parent_cidr]))
  filters = {
    network_view = var.network_view
    network      = each.value
  }
}

# container network
resource "infoblox_ipv4_network_container" "network" {
  parent_cidr         = var.network.parent_cidr
  allocate_prefix_len = var.network.prefix_length
  network_view        = var.network_view
  comment             = var.network.comment
  ext_attrs           = jsonencode(var.network.ext_attrs)

  depends_on = [
    data.infoblox_ipv4_network_container.existing_parent
  ]
}

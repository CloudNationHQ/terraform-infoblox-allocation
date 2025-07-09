output "subnet_cidr" {
  description = "Subnet CIDR"
  value       = infoblox_ipv4_network.subnet.cidr
}

output "subnet_details" {
  description = "Complete subnet details"
  value = {
    cidr         = infoblox_ipv4_network.subnet.cidr
    network_view = infoblox_ipv4_network.subnet.network_view
    gateway      = infoblox_ipv4_network.subnet.gateway
    reserve_ip   = infoblox_ipv4_network.subnet.reserve_ip
    comment      = infoblox_ipv4_network.subnet.comment
    parent_cidr  = var.parent_cidr
  }
}

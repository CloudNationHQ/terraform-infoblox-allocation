output "azure_vnet_address_space" {
  description = "Main VNet CIDR for Azure consumption"
  value       = infoblox_ipv4_network.network.cidr
}

output "allocation_cidr" {
  description = "Allocated network CIDR"
  value       = infoblox_ipv4_network.network.cidr
}

output "network_details" {
  description = "Complete network details"
  value = {
    cidr         = infoblox_ipv4_network.network.cidr
    network_view = infoblox_ipv4_network.network.network_view
    comment      = infoblox_ipv4_network.network.comment
    parent_cidr  = var.network.parent_cidr
  }
}
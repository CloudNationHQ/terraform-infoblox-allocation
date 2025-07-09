output "main_network_cidr" {
  description = "Main network CIDR - like allocation_cidr"
  value       = infoblox_ipv4_network_container.network.cidr
}

output "azure_vnet_address_space" {
  description = "Main VNet CIDR for Azure consumption - like allocation_cidr"
  value       = infoblox_ipv4_network_container.network.cidr
}

output "main_network_details" {
  description = "Complete main network details"
  value = {
    cidr         = infoblox_ipv4_network_container.network.cidr
    network_view = infoblox_ipv4_network_container.network.network_view
    comment      = infoblox_ipv4_network_container.network.comment
    parent_cidr  = var.main_network.parent_cidr
  }
}

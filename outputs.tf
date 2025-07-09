output "containers" {
  description = "Created network containers with their details"
  value = {
    for k, v in infoblox_ipv4_network_container.containers : k => {
      cidr         = v.cidr
      network_view = v.network_view
      comment      = v.comment
    }
  }
}

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

output "container_cidrs" {
  description = "Simple map of container names to CIDR blocks"
  value = {
    for k, v in infoblox_ipv4_network_container.containers : k => v.cidr
  }
}

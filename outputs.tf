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
    parent_cidr  = var.network.parent_cidr
  }
}

output "debug_subnets" {
  description = "Debug subnet resources"
  value = {
    for key, subnet in infoblox_ipv4_network.subnets : key => {
      cidr = subnet.cidr
      comment = subnet.comment
    }
  }
}

output "subnet_cidrs" {
  description = "Map of subnet CIDRs"
  value = {
    for key, subnet_config in var.subnets : key => infoblox_ipv4_network.subnets[key].cidr
  }
}

output "subnet_details" {
  description = "Complete subnet details"
  value = {
    for key, subnet_config in var.subnets : key => {
      cidr         = infoblox_ipv4_network.subnets[key].cidr
      network_view = infoblox_ipv4_network.subnets[key].network_view
      comment      = infoblox_ipv4_network.subnets[key].comment
      parent_cidr  = infoblox_ipv4_network_container.network.cidr
    }
  }
}

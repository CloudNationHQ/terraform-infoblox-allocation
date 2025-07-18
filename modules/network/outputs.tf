output "subnet_cidrs" {
  description = "Map of subnet CIDRs"
  value = {
    for key in keys(var.subnets) : key => infoblox_ipv4_network.subnets[key].cidr
  }
}

output "subnet_details" {
  description = "Complete subnet details"
  value = {
    for key, subnet_config in var.subnets : key => {
      cidr         = infoblox_ipv4_network.subnets[key].cidr
      network_view = infoblox_ipv4_network.subnets[key].network_view
      comment      = infoblox_ipv4_network.subnets[key].comment
      parent_cidr  = var.parent_cidr
    }
  }
}
output "azure_vnet_address_space" {
  description = "Contains the virtual network address space in CIDR notation."
  value       = infoblox_ipv4_network.network.cidr
}

variable "network_view" {
  description = "Infoblox network view"
  type        = string
  default     = "default"
}

variable "parent_cidr" {
  description = "Parent network CIDR to create subnet within"
  type        = string
}

variable "prefix_length" {
  description = "Subnet prefix length"
  type        = number
}

variable "reserve_ip" {
  description = "Number of IPs to reserve"
  type        = number
  default     = 4
}

variable "gateway" {
  description = "Gateway configuration"
  type        = string
  default     = "none"
}

variable "comment" {
  description = "Comment for the subnet"
  type        = string
  default     = ""
}

variable "network_function" {
  description = "Network function for Infoblox extension attribute"
  type        = string
  default     = ""
}

variable "location_code" {
  description = "Location code for Infoblox extension attribute"
  type        = string
  default     = ""
}

variable "ext_attrs" {
  description = "Additional extension attributes"
  type        = map(string)
  default     = {}
}

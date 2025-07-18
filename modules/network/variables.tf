variable "subnets" {
  description = "Contains subnet configurations"
  type = map(object({
    name             = string
    prefix_length    = number
    comment          = optional(string, "")
    network_function = optional(string, "")
    location_code    = optional(string, "")
    ext_attrs        = optional(map(string), {})
  }))
}

variable "parent_cidr" {
  description = "Parent CIDR for subnets"
  type        = string
}

variable "network_view" {
  description = "Infoblox network view"
  type        = string
}
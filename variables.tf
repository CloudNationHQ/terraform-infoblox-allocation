variable "network_view" {
  description = "Infoblox network view"
  type        = string
  default     = "default"
}

variable "containers" {
  description = "Map of network containers to create (optional - will create if they don't exist)"
  type = map(object({
    cidr      = string
    comment   = optional(string, "")
    ext_attrs = optional(map(string), {})
  }))
  default = {}
}

variable "network" {
  description = "Contains network configuration"
  type = object({
    name             = string
    parent_cidr      = string
    prefix_length    = number
    comment          = optional(string, "")
    network_function = optional(string, "")
    location_code    = optional(string, "")
    ext_attrs        = optional(map(string), {})
  })
}

terraform {
  required_version = ">= 1.3"

  required_providers {
    infoblox = {
      source  = "infobloxopen/infoblox"
      version = "~> 2.0"
    }
  }
}

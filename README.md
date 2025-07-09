# Infoblox Network

This terraform module streamlines IPv4 network allocation from infoblox with dynamic subnet assignment and container management.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3)

- <a name="requirement_infoblox"></a> [infoblox](#requirement\_infoblox) (~> 2.0)

## Providers

The following providers are used by this module:

- <a name="provider_infoblox"></a> [infoblox](#provider\_infoblox) (~> 2.0)

## Resources

The following resources are used by this module:

- [infoblox_ipv4_network_container.network](https://registry.terraform.io/providers/infobloxopen/infoblox/latest/docs/resources/ipv4_network_container) (resource)
- [infoblox_ipv4_network_container.existing_parent](https://registry.terraform.io/providers/infobloxopen/infoblox/latest/docs/data-sources/ipv4_network_container) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_network"></a> [network](#input\_network)

Description: Contains network configuration

Type:

```hcl
object({
    name             = string
    parent_cidr      = string
    prefix_length    = number
    comment          = optional(string, "")
    network_function = optional(string, "")
    location_code    = optional(string, "")
    ext_attrs        = optional(map(string), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_containers"></a> [containers](#input\_containers)

Description: Map of network containers to create (optional - will create if they don't exist)

Type:

```hcl
map(object({
    cidr      = string
    comment   = optional(string, "")
    ext_attrs = optional(map(string), {})
  }))
```

Default: `{}`

### <a name="input_network_view"></a> [network\_view](#input\_network\_view)

Description: Infoblox network view

Type: `string`

Default: `"default"`

## Outputs

The following outputs are exported:

### <a name="output_azure_vnet_address_space"></a> [azure\_vnet\_address\_space](#output\_azure\_vnet\_address\_space)

Description: Main VNet CIDR for Azure consumption - like allocation\_cidr

### <a name="output_container_cidrs"></a> [container\_cidrs](#output\_container\_cidrs)

Description: Simple map of container names to CIDR blocks

### <a name="output_containers"></a> [containers](#output\_containers)

Description: Created network containers with their details

### <a name="output_main_network_cidr"></a> [main\_network\_cidr](#output\_main\_network\_cidr)

Description: Main network CIDR - like allocation\_cidr

### <a name="output_main_network_details"></a> [main\_network\_details](#output\_main\_network\_details)

Description: Complete main network details
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-infoblox-network/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-infoblox-network" />
</a>

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-sa/blob/main/LICENSE) for full details.

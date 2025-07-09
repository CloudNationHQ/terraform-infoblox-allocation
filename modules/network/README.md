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

- [infoblox_ipv4_network.subnet](https://registry.terraform.io/providers/infobloxopen/infoblox/latest/docs/resources/ipv4_network) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_parent_cidr"></a> [parent\_cidr](#input\_parent\_cidr)

Description: Parent network CIDR to create subnet within

Type: `string`

### <a name="input_prefix_length"></a> [prefix\_length](#input\_prefix\_length)

Description: Subnet prefix length

Type: `number`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_comment"></a> [comment](#input\_comment)

Description: Comment for the subnet

Type: `string`

Default: `""`

### <a name="input_ext_attrs"></a> [ext\_attrs](#input\_ext\_attrs)

Description: Additional extension attributes

Type: `map(string)`

Default: `{}`

### <a name="input_gateway"></a> [gateway](#input\_gateway)

Description: Gateway configuration

Type: `string`

Default: `"none"`

### <a name="input_location_code"></a> [location\_code](#input\_location\_code)

Description: Location code for Infoblox extension attribute

Type: `string`

Default: `""`

### <a name="input_network_function"></a> [network\_function](#input\_network\_function)

Description: Network function for Infoblox extension attribute

Type: `string`

Default: `""`

### <a name="input_network_view"></a> [network\_view](#input\_network\_view)

Description: Infoblox network view

Type: `string`

Default: `"default"`

### <a name="input_reserve_ip"></a> [reserve\_ip](#input\_reserve\_ip)

Description: Number of IPs to reserve

Type: `number`

Default: `4`

## Outputs

The following outputs are exported:

### <a name="output_subnet_cidr"></a> [subnet\_cidr](#output\_subnet\_cidr)

Description: Subnet CIDR

### <a name="output_subnet_details"></a> [subnet\_details](#output\_subnet\_details)

Description: Complete subnet details
<!-- END_TF_DOCS -->
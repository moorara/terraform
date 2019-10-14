# Infra

This Terraform _module_ provides an infrastructure for deploying a cluster of distributed resources.
The deployment can be a _Kubernetes_, _Database_, or any other highly available cluster.

## Inputs

| Variable             | Type           | Default                    | Description |
|----------------------|----------------|----------------------------|-------------|
| `vpc_cidrs`          | `map(string)`  | See [here](./variables.tf) |             |
| `trusted_cidrs`      | `list(string)` | `["0.0.0.0/0"]`            |             |
| `enable_vpc_logs`    | `bool`         | `false`                    |             |
| `az_count`           | `number`       | _available zones_          |             |
| `bastion_public_key` | `string`       |                            |             |
| `name`               | `string`       |                            |             |
| `environment`        | `string`       |                            |             |
| `region`             | `string`       |                            |             |
| `common_tags`        | `map(string)`  |                            |             |
| `region_tag`         | `map(string)`  |                            |             |

## Outputs

| Name                   | Type           | Description |
|------------------------|----------------|-------------|
| `vpc_cidr`             | `string`       |             |
| `public_subnet_cidrs`  | `map(string)`  |             |
| `private_subnet_cidrs` | `map(string)`  |             |
| `elastic_ips`          | `list(string)` |             |
| `bastion_key_name`     | `string`       |             |

## Examples

```hcl
module "infra" {
  source = "github.com/moorara/terraform/modules/aws/infra"

  az_count           = 3
  bastion_public_key = "public_key.pub"
  name               = "test"
  environment        = "dev"
  region             = "us-east-1"
  common_tags        = {}
  region_tag         = {}
}
```

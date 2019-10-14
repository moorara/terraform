# Certificate

This Terraform _module_ creates an AWS Certificate for HTTPS and TLS connections.

## Inputs

| Variable           | Type           | Default | Description |
|--------------------|----------------|---------|-------------|
| `domain`           | `string`       |         |             |
| `cert_domain`      | `string`       |         |             |
| `cert_alt_domains` | `list(string)` |         |             |
| `tags`             | `map(string)`  |         |             |

## Outputs

| Name              | Type     | Description |
|-------------------|----------|-------------|
| `certificate_arn` | `string` |             |

## Examples

```hcl
module "certificate" {
  source = "github.com/moorara/terraform/modules/aws/certificate"

  domain           = "example.com"
  cert_domain      = "dev.example.com"
  cert_alt_domains = [ "api.dev.example.com" ]

  tags = {
    "Name"        = "test"
    "Environment" = "dev"
  }
}
```

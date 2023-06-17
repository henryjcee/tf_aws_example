# Route53 subdomain setup

To allow per-env DNS management, the subdomain zone nameservers (in this example, `dev.` is the only subdomain) need to
be passed to the apex zone (managed as part of the `prod` env) in order to create `NS` records for the subdomains and 
delegate subdomain DNS control to the subdomain Route53 zone.

This is done via an optional `example_com_subdomain_nameservers` variable in `route53_zone.tf` that passes a map of `NS`
records to the `./zone` module. The prod `route53_zone` Terragrunt module includes a dependency on the `dev` zone to
populate the variable with the relevant nameserver details.

```hcl
dependency "dev_route53_zone" {
  config_path = "../../dev/route53_zone"
}

inputs = {
  example_com_subdomain_nameservers = [dependency.dev_route53_zone.outputs.nameservers]
}
```

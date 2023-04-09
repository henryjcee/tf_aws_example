# Route53 Setup

This stuff is a little bit non-obvious. There are no zones defined in the root account so if you want per-env subdomains (e.g. dev.example.com) you can create the zone in the relevant account. Many records only need to be defined at the top level domain and to do that you can do something like:

```terraform
resource "aws_route53_record" "example_keybase" {
  zone_id = module.example.zone_info.zone_id
  name    = local.example_domain_name
  type    = "TXT"
  ttl     = "300"
  records = ["keybase-site-verification=ISXysaiUMnB3HF1NxSRz1I2LBsufQw-wGNAFUkDMAkk"]
  count   = var.env == "prod" ? 1 : 0
}
```

which will make sure it only gets created in the prod zone.

## N.B. per-env subdomain setup
If you do have per-env subdomains you'll need to take the nameservers from the subdomain and provide them as an input `<domain_name>_subdomain_nameservers` in the `terragrunt.hcl` for the root route53 config.

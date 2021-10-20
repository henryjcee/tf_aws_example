variable "domain" {
  type = string
}

variable "subdomain_nameservers" {
  type = list(object({subdomain=string, nameservers=set(string)}))
  default = []
}

resource "aws_route53_zone" "zone" {
  name = var.domain
}

output "zone_id" {
  value = aws_route53_zone.zone.zone_id
}

output "nameservers" {
  value = aws_route53_zone.zone.name_servers
}

output "zone_info" {
  value = {
    zone_id = aws_route53_zone.zone.zone_id
    nameservers = aws_route53_zone.zone.name_servers
  }
}

// Generate NS records for any subdomains
resource "aws_route53_record" "subdomain_ns" {
  name = var.subdomain_nameservers[count.index].subdomain
  type = "NS"
  ttl = 300
  zone_id = aws_route53_zone.zone.zone_id
  records = var.subdomain_nameservers[count.index].nameservers
  count = length(var.subdomain_nameservers)
}


terraform {
  source = "../../../modules//route53"
}

dependency "route53_zone" {
  config_path = "../route53_zone"
}

inputs = {
  example_com_zone_id = dependency.route53_zone.outputs.example_com_zone_info.zone_id
}

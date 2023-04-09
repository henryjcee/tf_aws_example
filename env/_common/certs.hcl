terraform {
  source = "../../../../modules//certs"
}

dependency "lets_encrypt" {
  config_path = "../../lets_encrypt"
}

inputs = {
  example_com_acme_certificate = dependency.lets_encrypt.outputs.acme_certificate
}

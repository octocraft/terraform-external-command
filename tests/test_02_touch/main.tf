terraform {
  required_version = ">= 0.11"
}

module "file" {
  source      = "../../"
  module_path = "${path.module}"
  command     = "echo hello > test.dat"
}

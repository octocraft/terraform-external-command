terraform {
  required_version = ">= 0.11"
}

module "os" {
  source = "git::https://github.com/octocraft/terraform-module-ostype" #?ref=v1.0.0"
}

locals {
  module_path = "${replace("${path.module}","\\","/")}"
  extension   = "${"${module.os.type}" == "windows" ? ".bat" : "${"${module.os.type}" == "unix" ? ".sh" : ""}"}"
}

data "external" "bash" {
  program = ["${local.module_path}/run${local.extension}", "${local.module_path}"]

  query = {
    module_path = "${var.module_path}"
    command     = "${var.command}"
  }
}

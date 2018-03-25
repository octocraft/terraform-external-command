terraform {
  required_version = ">= 0.11"
}

module "colors" {
  source      = "../../"
  module_path = "${path.module}"
  command     = "jq -r '.colors[] | select(.color == \"'${var.color}'\")' < $module_path/test-data.json"
}

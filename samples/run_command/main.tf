module "command" {
  source      = "github.com/octocraft/terraform-module-data_external_command"
  module_path = "${path.module}"
  command     = "jq -n --arg v \"$(echo bar)\" '{\"foo\": $v}'"
}

output "foo" {
  value = "${lookup(module.command.result, "foo")}"
}

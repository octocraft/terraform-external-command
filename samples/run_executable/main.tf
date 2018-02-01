module "command" {
  source      = "github.com/octocraft/terraform-module-data_external_command"
  module_path = "${path.module}"
  command     = "$module_path/bin/$OS/foo"
}

output "foo" {
  value = "${lookup(module.command.result, "foo")}"
}

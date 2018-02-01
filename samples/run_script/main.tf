module "command" {
  source      = "github.com/octocraft/terraform-module-data_external_command"
  module_path = "${path.module}"
  command     = "./$modulepath/run.sh"
}

output "foo" {
  value = "${lookup(module.command.result, "foo")}"
}

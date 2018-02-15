# data_external_command

This module reads an output from a command/script.

## Why
Terraform does not provide the possibility (yet) to store custom variables in `null_resource`, which means that `null_resource` with `local-exec` can be used to created/update/delete resources through external commands, but they can not be referenced.

The `data "external"` module helps to encapsulate and reference not (yet fully) supported resources, but it lacks cross-plattform support. This module is a wrapper which allows you to run a bash script on window and unix.

## Usage

```hcl
module "command" {
  source      = "github.com/octocraft/terraform-module-data_external_command"
  module_path = "${path.module}"
  command     = "jq -n --arg v \"$(echo bar)\" '{\"foo\": $v}'"
}
```

### Variables

#### module_path

Pass ${path.module} to this variable to access it via $module_path from the shell

#### command

The command to be executed (bash shell).

`jq` can be used to filter/modify json data easily. If the command is not available, the version from `/bin/$OS/` is used. More Details: https://stedolan.github.io/jq/

The command must return valid JSON. This module uses internally `data "external"`. I.e.
 - If you want to pass quotes you have to double escape them \\\\\\"
 - Terraform does not execute the program through a shell, so it is not necessary to escape shell metacharacters nor add quotes around arguments containing spaces.

More Details: https://www.terraform.io/docs/providers/external/data_source.html

**Sample command**
```bash
jq -n --arg v "$(echo bar)" '{"foo": $v}'
```
returns
```json
{
  "foo": "bar"
}
```

**Environment Variables**

The module exposes the following variables to the command/script:

**$module_path**
The directory of the module.

**$OS**
The type of the operating system. `$OS` is set to 'darwin', 'freebsd', 'linux', 'openbsd', 'solaris' or 'windows'. 

**$OSTYPE**
On Unix systems $OSTYPE is already set. On Windows this is set to "windows". 

### Outputs

#### result
The result returned by the command.

To access keys of the result you have to use lookup
```hcl
output "foo" {
  value = "${lookup(module.command.result, "foo")}"
}
```
returns
```bash
foo = bar
```

## Notes

This module ships with binaries for all platforms supported by Terraform but only the 64 bit versions (Maс OSX, FreeBSD, Linux, OpenBSD, Solaris and Windows).

It comes with a bash shell for Windows, but it does not ship with any functions (i.e. you will most likely not be able to run many scripts due to dependencies on Unix functions). Also the shell used is quite old (win bash uses bash 1.14.2). 

If you are on Windows and you prefer Cygwin you can tweak `run.sh.bat` to use it instead of `bash.exe`.

If you don't care about Windows you can safely use any commands which are available on your OS, but please keep in mind, that your code is platform dependent and Terraform may fail in certain environments due to missing dependencies. 

## License

MIT


variable "module_path" {
  description = "Pass $${path.module} to access $module_path from the shell"
  default     = ""
}

variable "command" {
  description = "The command to execute"
}

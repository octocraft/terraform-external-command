output "result" {
  description = "The result returned by the command"
  value       = "${data.external.bash.result}"
}

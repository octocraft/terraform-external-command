output "value" {
  description = "The color code of the selected color"
  value       = "${lookup(module.colors.result, "value")}"
}

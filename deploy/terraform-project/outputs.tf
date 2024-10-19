output "eip" {
  value = <<EOT
The app IPs are:
${join("\n", [for ip in module.workers.workers_public_ips : "${ip}:30005"])}
EOT
}

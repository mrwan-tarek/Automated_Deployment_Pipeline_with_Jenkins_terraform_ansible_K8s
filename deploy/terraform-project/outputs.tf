output "eip" {
  value = <<EOT
The app IPs are:
${join("\n", [for ip in module.workers.workers_public_ips : 8080 ])}
EOT
}
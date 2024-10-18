output "eip" {
  value = <<EOT
The app IPs are:
${join(":8080\n", module.workers.workers_public_ips)}
EOT
}
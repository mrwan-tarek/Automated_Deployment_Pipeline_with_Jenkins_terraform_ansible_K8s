output "eip" {
  value = <<EOT
The app IPs are:
${join(":30005\n", module.workers.workers_public_ips)}
EOT
}
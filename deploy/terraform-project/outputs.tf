output "eip" {
  value = ["$aws_instance.workers.*.public_ip"]
}
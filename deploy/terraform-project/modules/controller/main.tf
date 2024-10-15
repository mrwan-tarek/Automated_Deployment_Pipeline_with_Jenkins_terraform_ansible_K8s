resource "aws_instance" "controller" {
  ami             = "ami-04dd23e62ed049936" //we use ubento cuz the ansible use it
  instance_type = var.instance_type
  key_name = var.key_pair_name
  security_groups = [ var.security_group_id ]
  subnet_id = var.public_subnet_1_id
  

  associate_public_ip_address = true

  tags = {
    Name = "controler"
    terraform = "true"
    project = "kube-auto"
  }

  root_block_device {
    delete_on_termination = true
    volume_size = 8
  }
}

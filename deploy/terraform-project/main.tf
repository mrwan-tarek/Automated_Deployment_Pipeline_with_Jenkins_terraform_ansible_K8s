module "sg-create" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block_vpc = "10.0.0.0/16"
  cidr_block_public_subnet_1 = "10.0.1.0/24"
}

module "key-pair-create" {
  source = "./modules/ssh_key_pair"
  key_pair_name = var.key_pair_name
  public_key_path = var.public_key_path
}

module "controller" {
    source = "./modules/controller"
    security_group_id = module.sg-create.sg_id
    key_pair_name = var.key_pair_name
    public_subnet_1_id = module.vpc.public_subnet_1_id
}

module "workers" { 
    source = "./modules/workers"
    security_group_id = module.sg-create.sg_id
 
    worker_count = var.worker_count
    key_pair_name = var.key_pair_name
    public_subnet_1_id = module.vpc.public_subnet_1_id
}

resource "local_file" "ansible_inventory" {
  depends_on = [
    module.controller,
    module.workers
  ]
    content = templatefile(
      "../hosts.ini",
      {
        master  = module.controller.controller_public_ip
        workers = module.workers.workers_public_ips
      })
      filename = "../inventory.ini"
}

resource "null_resource" "execute-playbook" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.controller.controller_public_ip
      user        = "ubuntu"
      private_key = file(var.private_ssh_key)
    }

    inline = ["echo 'connected!'"]
  }
  depends_on = [
    local_file.ansible_inventory
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ../inventory.ini --private-key ${var.private_ssh_key} '${path.cwd}/../ansible-install-k8s/main.yaml'"
  } //you have to say yes twise in terminal when get to ansible
}
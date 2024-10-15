
variable "region" {
   type    = string 
   default = "us-west-2"
}

variable "worker_count" {
  type    = string
  default = "1"
}

variable "public_key_path" {
  default = "/home/yusuf/.ssh/id_rsa.pub"
}

variable "private_ssh_key" {
  default = "/home/yusuf/.ssh/id_rsa" //first you have to generate them 
}

variable "key_pair_name" {
  default = "cluster_key"
}



data "aws_vpc" "default_vpc"{
  default = true
}

variable "public_subnet_1_id" {
  type        = string
}

variable "security_group_id" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "instance_type" {
    default = "t2.medium" //"t2.micro"
}

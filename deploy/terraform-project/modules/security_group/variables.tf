variable "allowed_cidr" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}

variable "vpc_id" {
  description = "VPC ID"
}
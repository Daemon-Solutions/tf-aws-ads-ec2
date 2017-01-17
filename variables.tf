# Enviroment Tags
variable "customer" {}
variable "envname" {}
variable "envtype" {}

# VPC ID
variable "vpc_id" {}

# VPC CIDR Range
variable "vpc_cidr" {}

# Private Subnets IDs
variable "private_subnet_ids" {
  type = "list"
}

# Private Subnet Count
# !! Use of interpolation causes cycle error !!
variable "private_subnet_count" {}

# AD DS Domain Configuration
variable "domain_name" {}
variable "domain_password" {}

# Instance Key Name
variable "key_name" {}

# AWS Microsoft Windows AMIs
variable "windows_ami_names" {
  type = "map"
  default = {
    "2008" = "Windows_Server-2008-R2_SP1-English-64Bit-Base*"
    "2012" = "Windows_Server-2012-R2_RTM-English-64Bit-Base*"
    "2016" = "Windows_Server-2016-English-Full-Base-*"
  }
}

# Microsoft Windows Version
variable "windows_ver" {
  default = "2016"
}

# Instance Type
variable "instance_type" {
  default = "t2.medium"
}

# Instance EBS Type
variable "instance_ebs_type" {
  default = "gp2"
}

# Instance EBS Size
variable "instance_ebs_size" {
  default = "100"
}

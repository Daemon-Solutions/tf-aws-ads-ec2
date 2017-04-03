# Enviroment Tags
variable "customer" {}

variable "envname" {}
variable "envtype" {}

# VPC ID
variable "vpc_id" {}

# VPC CIDR Range
#variable "vpc_cidr" {}

# Private Subnets IDs
#variable "private_subnet_ids" {
#  type = "list"
#}

variable "private_subnets" {
  type    = "list"
  default = []
}

# Private Subnet Count
# !! Use of interpolation causes cycle error !!
variable "private_subnet_count" {}

variable "local_password" {}

# AD DS Domain Configuration
variable "domain_name" {}

#variable "domain_password" {}
variable "domain_mode" {}

variable "forest_mode" {}
variable "domain_netbios_name" {}
variable "domain_safe_mode_admin_password" {}
variable "domain_enterprise_admin_account" {}
variable "domain_enterprise_admin_password" {}

# Common AD DS TCP Ports
variable "common_ad_tcp_ports" {
  type    = "list"
  default = ["53", "88", "135", "139", "389", "445", "464", "636", "3268", "3269", "5722", "9389"]
}

# Common AD DS UDP Ports
variable "common_ad_udp_ports" {
  type    = "list"
  default = ["53", "67", "88", "123", "135", "137", "138", "389", "445", "464"]
}

# Common AD DS Dynamic Port Range
variable "common_ad_dyn_ports" {
  type    = "list"
  default = ["49152", "65535"]
}

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
  default = "2012"
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

# Enviroment Tags
variable "customer" {}

variable "envname" {}
variable "envtype" {}

# VPC

variable "azs" {
  type = "list"
}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "private_subnets" {
  type    = "list"
  default = []
}

variable "private_subnet_cidrs" {
  type    = "list"
  default = []
}

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
variable "domain_controller_name" {}

# Common AD DS TCP Ports
variable "common_ad_tcp_ports" {
  type    = "list"
  default = ["53", "88", "135", "139", "389", "445", "464", "636", "3268", "3269"]
}

# Common AD DS UDP Ports
variable "common_ad_udp_ports" {
  type    = "list"
  default = ["53", "67", "88", "123", "135", "137", "138", "389", "445", "464"]
}

# Common AD DS Dynamic Port Range
variable "common_ad_dyn_ports" {
  type    = "list"
  default = ["1024", "65535"]
}

# Instance Key Name
variable "key_name" {}

# Microsoft Windows Base AMI ID
variable "windows_base_ami_id" {}

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

variable "timezone" {
  default = "GMT Standard Time"
}

variable "security_groups" {
  default = [""]
}

#variable "dc_count" {}

variable "disable_api_termination" {
  default = true
}

variable "patch_group" {
  default = "static"
}

variable "lifecycle" {
  default = [""]
  type    = "list"
}

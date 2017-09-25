/* Environment variables */
variable "customer" {
  description = "This value will be the first name prefix and value for the 'Customer' tag on resources created by this module"
  type = "string"
}

variable "envname" {
  description = "This value will be the second name prefix and value for the 'Environment' tag on resources created by this module"
  type = "string"
}

variable "envtype" {
  description = "This value will be the third name prefix and value for the 'EnvironmentType' tag on resources created by this module"
  type = "string"
}

/* VPC variables */
variable "azs" {
  description = "List of AWS Availability Zones to create AD EC2 instances in, length serves as the count of instances to create"
  type = "list"
}

variable "vpc_id" {
  description = "The ID of the VPC in which the AD EC2 instances are created"
  type = "string"
}

variable "vpc_cidr" {
  description = "The CIDR block ranges used by the AD Controller Security Group rules"
  type = "string"
}

variable "private_subnets" {
  description = "List of private subnet IDs where the AD EC2 instances will reside"
  type    = "list"
  default = []
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks to go with the values from 'private_subnets'"
  type    = "list"
  default = []
}

/* Active Directory forest variables */
variable "domain_name" {
  description = "The fully qualified domain name for the Active Directory Domain Services instance"
  type = "string"
}

variable "local_password" {
  description = "The local password to set for the admin user, which becomes the domain admin user"
  type = "string"
}
variable "domain_mode" {
  description = "Specifies the domain functional level, valid range is 2..7 for 2003..2016"
  type = "string"
  default = 6
}

variable "forest_mode" {
  description = "Specifies the forest functional level, valid range is 2..7 for 2003..2016"
  type = "string"
  default = 6
}

variable "domain_netbios_name" {
  description = "The desired NetBIOS name for the domain"
  type = "string"
}

variable "domain_safe_mode_admin_password" {
  description = "The Domain Controller safe mode and Directory Services Restore mode password"
  type = "string"
}

variable "domain_enterprise_admin_account" {
  description = "The enterprise administrator account to create"
  type = "string"
}

variable "domain_enterprise_admin_password" {
  description = "The password for the account specified in 'domain_enterprise_admin_account'"
  type = "string"
}

variable "domain_controller_name" {
  description = "The base name for all Domain Controllers, will be suffixed with a number dependent on Availability Zone"
  type = "string"
}

/* AWS Security Group variables */
variable "common_ad_tcp_ports" {
  description = "A list of common AD TCP ports for the AWS Security Group rules"
  type    = "list"
  default = ["53", "88", "135", "139", "389", "445", "464", "636", "3268", "3269"]
}

variable "common_ad_udp_ports" {
  description = "A list of common AD UDP ports for the AWS Security Group rules"
  type    = "list"
  default = ["53", "67", "88", "123", "135", "137", "138", "389", "445", "464"]
}

variable "common_ad_dyn_ports" {
  description = "Dynamic port range for the AWS Security Group rules"
  type    = "list"
  default = ["1024", "65535"]
}

/* Instance variables */
variable "key_name" {
  description = "The name of the EC2 Key Pair to associate with this instance"
  type = "string"
}

variable "windows_base_ami_id" {
  description = "The ID for the AMI you wish to build your Domain Controllers from"
  type = "string"
}

variable "instance_type" {
  description = "The instance type to use for your Domain Controllers"
  type = "string"
  default = "t2.medium"
}

variable "instance_ebs_type" {
  description = "The type of EBS storage to add to your Domain Controllers"
  type = "string"
  default = "gp2"
}

variable "instance_ebs_size" {
  description = "The size of EBS volumes to add to your Domain Controllers"
  type = "string"
  default = "100"
}

variable "timezone" {
  description = "The timezone to set for all Domain Controllers"
  type = "string"
  default = "GMT Standard Time"
}

variable "security_groups" {
  description = "A list of security group IDs to associate with the Domain Controllers"
  type = "string"
  default = [""]
}

variable "disable_api_termination" {
  description = "Bool indicating whether to allow termination of these instances via API"
  type = "string"
  default = true
}

variable "patch_group" {
  description = "This value will be added as the 'Patch Group' tag value, for use with SSM updates"
  type = "string"
  default = "static"
}

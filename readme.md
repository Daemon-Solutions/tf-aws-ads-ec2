tf-aws-ads-ec2
==============

AWS EC2 Directory Service - Terraform Module

Resources
---------

This module will create the following resources:

- AD EC2 instance for each private subnet specified
- Security Group and associated ingress/egress rules

Usage
-----

```js
module "ads-ec2" {
  source = "../localmodules/tf-aws-ads-ec2"

  customer                         = "${var.customer}"
  envname                          = "${var.envname}"
  envtype                          = "${var.envtype}"
  vpc_id                           = "${module.vpc.vpc_id}"
  vpc_cidr                         = "${var.vpc_cidr}"
  local_password                   = "${var.local_password}"
  private_subnets                  = "${module.vpc.private_subnets}"
  domain_name                      = "${var.domain_name}"
  domain_netbios_name              = "${var.domain_netbios_name}"
  domain_mode                      = "${var.domain_mode}"
  forest_mode                      = "${var.forest_mode}"
  domain_safe_mode_admin_password  = "${var.domain_safe_mode_admin_password}"
  domain_enterprise_admin_account  = "${var.domain_enterprise_admin_account}"
  domain_enterprise_admin_password = "${var.domain_enterprise_admin_password}"
  domain_controller_name           = "${var.domain_controller_name}"
  security_groups                  = ["${aws_security_group.mgmt_internal.id}"]
  key_name                         = "${var.key_name}"
  windows_base_ami_id              = "${var.windows_base_ami_id}"
}
```

Variables
---------

- `customer`             - customer name to identify resources
- `envname`              - environment name
- `envtype`              - environment type
- `vpc_id`               - the ID of the VPC in which the AD EC2 instances are created
- `vpc_cidr`             - the CIDR block ranges used by the AD Controller Security Group rules
- `local_password`       - password for the local administrator account
- `private_subnets`      - the private subnets where the AD EC2 instances will reside
- `domain_name`          - the fully qualified domain name of Active Directory Domain Services (AD DS)
- `domain_netbios_name`  - the domain netbios name
- `domain_mode`          - 
- `forest_mode`          -
- `domain_safe_mode_admin_password` -
- `domain_enterprise_admin_account` -
- `domain_enterprise_admin_password` -
- `domain_controller_name` - the name of the domain controllers. Powershell will assign a number increment.
- `key_name`             - AWS EC2 Key Pair

Outputs
-------

- `ads_dns`                 - ip addresses of dns servers
- `ads_sg_id`               - ad security group id

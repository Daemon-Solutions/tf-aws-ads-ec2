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
  source = "git@gogs.bashton.net:Bashton-Terraform-Modules/tf-aws-ads-ec2.git"

  customer                = "${var.customer}"
  envname                 = "${var.envname}"
  envtype                 = "${var.envtype}"

  vpc_id                  = "${module.vpc.vpc_id}"
  private_subnet_ids      = "${module.vpc.private_subnets}"
  private_subnet_count    = "3"
  domain_name             = "${var.domain_name}"
  domain_password         = "${var.domain_password}"
  key_name                = "${var.key_name}"
}
```

Variables
---------

- `customer`             - customer name to identify resources
- `envname`              - environment name
- `envtype`              - environment type

- `vpc_id`               - the ID of the VPC in which the AD EC2 instances are created
- `private_subnets`      - the private subnets where the AD EC2 instances will reside
- `private_subnet_count` - the number of private subnets created within VPC.  * Variable currently exists whilst cycle error is determined when interpolation is performed against the variable `private_subnets`  *
- `domain_name`          - the fully qualified domain name of Active Directory Domain Services (AD DS)
- `domain_password`      - the AD DS Administrator password
- `key_name`             - AWS EC2 Key Pair

Outputs
-------

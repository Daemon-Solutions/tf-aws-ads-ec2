# Microsoft Windows Base AMI
data "aws_ami" "windows" {
  filter {
    name   = "image-id"
    values = ["${var.windows_base_ami_id}"]
  }
}

# Primary Domain Controller
data "template_file" "primary_domain_controller" {
  template = "${file("${path.module}/include/primary_domain_controller.ps1.tpl")}"

  vars {
    local_password = "${var.local_password}"
    domain_name    = "${var.domain_name}"

    domain_mode                      = "${var.domain_mode}"
    forest_mode                      = "${var.forest_mode}"
    domain_netbios_name              = "${var.domain_netbios_name}"
    domain_safe_mode_admin_password  = "${var.domain_safe_mode_admin_password}"
    domain_enterprise_admin_account  = "${var.domain_enterprise_admin_account}"
    domain_enterprise_admin_password = "${var.domain_enterprise_admin_password}"
    domain_controller_name           = "${var.domain_controller_name}"
    timezone                         = "${var.timezone}"
    aws_vpc_dns                      = "${cidrhost(var.vpc_cidr, 2)}"
  }
}

# Secondary, Tertiary ... Domain Controllers
data "template_file" "domain_controllers" {
  template = "${file("${path.module}/include/domain_controllers.ps1.tpl")}"

  vars {
    local_password = "${var.local_password}"
    domain_name    = "${var.domain_name}"

    domain_mode                      = "${var.domain_mode}"
    forest_mode                      = "${var.forest_mode}"
    domain_netbios_name              = "${var.domain_netbios_name}"
    domain_safe_mode_admin_password  = "${var.domain_safe_mode_admin_password}"
    domain_enterprise_admin_account  = "${var.domain_enterprise_admin_account}"
    domain_enterprise_admin_password = "${var.domain_enterprise_admin_password}"
    domain_controller_name           = "${var.domain_controller_name}"
    timezone                         = "${var.timezone}"
  }
}

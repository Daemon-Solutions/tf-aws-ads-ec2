# Domain Controller Instances
resource "aws_instance" "domain_controller" {
  count                   = "${var.dc_count}"
  ami                     = "${data.aws_ami.windows.id}"
  instance_type           = "${var.instance_type}"
  key_name                = "${var.key_name}"
  subnet_id               = "${element(var.private_subnets, count.index )}"
  iam_instance_profile    = "${module.iam_instance_profile_domain_controllers.profile_id}"
  vpc_security_group_ids  = ["${var.security_groups}", "${aws_security_group.sg_domain_controllers.id}"]
  user_data               = "${count.index == 0 ? "<powershell>${data.template_file.primary_domain_controller.rendered}</powershell><persist>true</persist>" : "<powershell>${data.template_file.domain_controllers.rendered}</powershell><persist>true</persist>" }"
  disable_api_termination = "${var.disable_api_termination}"

  root_block_device {
    volume_type = "${var.instance_ebs_type}"
    volume_size = "${var.instance_ebs_size}"
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }

  tags {
    Name            = "${var.domain_controller_name}${count.index + 1}"
    Customer        = "${var.customer}"
    Environment     = "${var.envname}"
    EnvironmentType = "${var.envtype}"
    Service         = "Active Directory"
    Role            = "Domain Controller"
    "Patch Group"   = "${var.patch_group}"
  }
}

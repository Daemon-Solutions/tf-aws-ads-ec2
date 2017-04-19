# Domain Controller Instances
resource "aws_instance" "domain_controller" {
  count                  = "${var.private_subnet_count}"
  ami                    = "${data.aws_ami.windows.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${element(var.private_subnets, count.index )}"
  iam_instance_profile   = "${module.iam_instance_profile_domain_controllers.profile_id}"
  vpc_security_group_ids = ["${aws_security_group.sg_common_ad.id}"]
  user_data              = "${count.index == 0 ? "<powershell>${data.template_file.primary_domain_controller.rendered}</powershell><persist>true</persist>" : "<powershell>${data.template_file.domain_controllers.rendered}</powershell><persist>true</persist>" }"

  root_block_device {
    volume_type = "${var.instance_ebs_type}"
    volume_size = "${var.instance_ebs_size}"
  }

  tags {
    Name            = "${var.domain_controller_name}00${count.index + 1}"
    Customer        = "${var.customer}"
    Environment     = "${var.envname}"
    EnvironmentType = "${var.envtype}"
    Service         = "Active Directory"
    Role            = "Domain Controller"
  }
}

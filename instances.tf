# Instance Domain Controllers
resource "aws_instance" "domain_controller" {
  count                   = "${var.private_subnet_count}"
  ami                     = "${data.aws_ami.windows.id}"
  instance_type           = "${var.instance_type}"
  key_name                = "${var.key_name}"
  subnet_id               = "${element(var.private_subnet_ids, count.index)}"
  vpc_security_group_ids  = ["${aws_security_group.ads_security_group.id}"]
  user_data               = "<powershell>${data.template_file.rename_instance.id}</powershell>"
  root_block_device {
      volume_type = "${var.instance_ebs_type}"
      volume_size = "${var.instance_ebs_size}"
  }
  tags {
    Name             = "ADS-DC-${count.index}"
    Customer         = "${var.customer}"
    Environment      = "${var.envname}"
    EnvironmentType  = "${var.envtype}"
  }
}

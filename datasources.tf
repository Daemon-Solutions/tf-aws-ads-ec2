# Get latest Microsoft Windows AMI
data "aws_ami" "windows" {
  most_recent = true
  filter {
    name = "name"
    values = ["${lookup(var.windows_ami_names,var.windows_ver)}"]
  }
}

# Primary Domain Controller
data "template_file" "primary_domain_controller" {
  template = "${file("${path.module}/include/primary_domain_controller.ps1.tpl")}"
}

# Secondary, Tertiary ... Domain Controllers
data "template_file" "domain_controllers" {
  template = "${file("${path.module}/include/domain_controllers.ps1.tpl")}"
}

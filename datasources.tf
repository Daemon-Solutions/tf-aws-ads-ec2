# Get latest Microsoft Windows AMI
data "aws_ami" "windows" {
  most_recent = true
  filter {
    name = "name"
    values = ["${lookup(var.windows_ami_names,var.windows_ver)}"]
  }
}

# Rename Instance
data "template_file" "rename_instance" {
  template = "${file("${path.module}/include/rename_instance.ps1.tpl")}"
}

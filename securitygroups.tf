resource "aws_security_group" "ads_security_group" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.envname}-${var.envtype}-ads"
  description = "Security Group ${var.envname}-${var.envtype}-ads"

    ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
       Customer         = "${var.customer}"
       Environment      = "${var.envname}"
       EnvironmentType  = "${var.envtype}"
    }
}

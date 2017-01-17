
# Domain Controller TCP Ports
variable "domain_controller_tcp_ports" {
  default = "53,88,135,139,389,445,464,636,3268,3269,5722,9389"
}

# Domain Controller UDP Ports
variable "domain_controller_udp_ports" {
  default = "53,67,88,123,135,137,138,389,445,464"
}

# Domain Controller Dynamic Port Range
variable "domain_controller_dyn_ports" {
  default = "49152,65535"
}

resource "aws_security_group" "sg_domain_controller" {
  vpc_id              = "${var.vpc_id}"
  name                = "${var.envname}-${var.envtype}-ads"
  description         = "Security Group for all Domain Controller instances"

  tags {
    Name              = "sgDomainController"
    Customer          = "${var.customer}"
    Environment       = "${var.envname}"
    EnvironmentType   = "${var.envtype}"
  }
}

resource "aws_security_group_rule" "ir_domain_controller_tcp" {
  count             = "${length(split(",",var.domain_controller_tcp_ports))}"
  type              = "ingress"
  from_port         = "${element(split(",", var.domain_controller_tcp_ports), count.index)}"
  to_port           = "${element(split(",", var.domain_controller_tcp_ports), count.index)}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_domain_controller_udp" {
  count             = "${length(split(",",var.domain_controller_udp_ports))}"
  type              = "ingress"
  from_port         = "${element(split(",", var.domain_controller_udp_ports), count.index)}"
  to_port           = "${element(split(",", var.domain_controller_udp_ports), count.index)}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_domain_controller_tcp_dyn" {
  type              = "ingress"
  from_port         = "${element(split(",", var.domain_controller_dyn_ports), 0 )}"
  to_port           = "${element(split(",", var.domain_controller_dyn_ports), 1 )}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_domain_controller_udp_dyn" {
  type              = "ingress"
  from_port         = "${element(split(",", var.domain_controller_dyn_ports), 0 )}"
  to_port           = "${element(split(",", var.domain_controller_dyn_ports), 1 )}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  self              = true
}

resource "aws_security_group_rule" "er_domain_controller_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

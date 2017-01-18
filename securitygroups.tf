
resource "aws_security_group" "sg_domain_controller" {
  vpc_id              = "${var.vpc_id}"
  name                = "${var.envname}-${var.envtype}-ads"
  description         = "Security Group for all Domain Controller instances"

  tags {
    Name              = "sg-domain-controller"
    Customer          = "${var.customer}"
    Environment       = "${var.envname}"
    EnvironmentType   = "${var.envtype}"
    Service           = "Active Directory"
    Role              = "Domain Controller"
  }
}

resource "aws_security_group_rule" "ir_domain_controller_tcp" {
  count             = "${length(var.domain_controller_tcp_ports)}"
  type              = "ingress"
  from_port         = "${element(var.domain_controller_tcp_ports, count.index)}"
  to_port           = "${element(var.domain_controller_tcp_ports, count.index)}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_domain_controller_udp" {
  count             = "${length(var.domain_controller_udp_ports)}"
  type              = "ingress"
  from_port         = "${element(var.domain_controller_udp_ports, count.index)}"
  to_port           = "${element(var.domain_controller_udp_ports, count.index)}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_domain_controller_tcp_dyn" {
  type              = "ingress"
  from_port         = "${element(var.domain_controller_dyn_ports, 0 )}"
  to_port           = "${element(var.domain_controller_dyn_ports, 1 )}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controller.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_domain_controller_udp_dyn" {
  type              = "ingress"
  from_port         = "${element(var.domain_controller_dyn_ports, 0 )}"
  to_port           = "${element(var.domain_controller_dyn_ports, 1 )}"
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

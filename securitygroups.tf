
resource "aws_security_group" "sg_common_ad" {
  vpc_id              = "${var.vpc_id}"
  name                = "${var.envname}-${var.envtype}-common-ad"
  description         = "Security Group for all Domain Controller instances"

  tags {
    Name              = "sg-common-ad"
    Customer          = "${var.customer}"
    Environment       = "${var.envname}"
    EnvironmentType   = "${var.envtype}"
    Service           = "Active Directory"
    Role              = "Domain Controller"
  }
}

resource "aws_security_group_rule" "ir_common_ad_tcp" {
  count             = "${length(var.common_ad_tcp_ports)}"
  type              = "ingress"
  from_port         = "${element(var.common_ad_tcp_ports, count.index)}"
  to_port           = "${element(var.common_ad_tcp_ports, count.index)}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_common_ad.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_common_ad_udp" {
  count             = "${length(var.common_ad_udp_ports)}"
  type              = "ingress"
  from_port         = "${element(var.common_ad_udp_ports, count.index)}"
  to_port           = "${element(var.common_ad_udp_ports, count.index)}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_common_ad.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_common_ad_tcp_dyn" {
  type              = "ingress"
  from_port         = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port           = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_common_ad.id}"
  self              = true
}

resource "aws_security_group_rule" "ir_common_ad_udp_dyn" {
  type              = "ingress"
  from_port         = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port           = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_common_ad.id}"
  self              = true
}

resource "aws_security_group_rule" "er_common_ad_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_common_ad.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

## Security Groups

## Domain Controller Instances
resource "aws_security_group" "sg_domain_controllers" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.envname}-${var.envtype}-domain-controllers"
  description = "Security Group for all Domain Controller instances"

  tags {
    Name            = "sg-domain-controllers"
    Customer        = "${var.customer}"
    Environment     = "${var.envname}"
    EnvironmentType = "${var.envtype}"
    Service         = "Active Directory"
    Role            = "Domain Controller"
  }
}

# Ingress Rules
resource "aws_security_group_rule" "ir_domain_controllers_tcp" {
  count             = "${length(var.common_ad_tcp_ports)}"
  type              = "ingress"
  from_port         = "${element(var.common_ad_tcp_ports, count.index)}"
  to_port           = "${element(var.common_ad_tcp_ports, count.index)}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ir_domain_controllers_udp" {
  count             = "${length(var.common_ad_udp_ports)}"
  type              = "ingress"
  from_port         = "${element(var.common_ad_udp_ports, count.index)}"
  to_port           = "${element(var.common_ad_udp_ports, count.index)}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ir_domain_controllers_tcp_dyn" {
  type              = "ingress"
  from_port         = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port           = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ir_domain_controllers_udp_dyn" {
  type              = "ingress"
  from_port         = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port           = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ir_domain_controllers_all_all" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  self              = true
}

# Egress Rules
resource "aws_security_group_rule" "er_domain_controllers_tcp" {
  count             = "${length(var.common_ad_tcp_ports)}"
  type              = "egress"
  from_port         = "${element(var.common_ad_tcp_ports, count.index)}"
  to_port           = "${element(var.common_ad_tcp_ports, count.index)}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "er_domain_controllers_udp" {
  count             = "${length(var.common_ad_udp_ports)}"
  type              = "egress"
  from_port         = "${element(var.common_ad_udp_ports, count.index)}"
  to_port           = "${element(var.common_ad_udp_ports, count.index)}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "er_domain_controllers_tcp_dyn" {
  type              = "egress"
  from_port         = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port           = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol          = "TCP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "er_domain_controllers_udp_dyn" {
  type              = "egress"
  from_port         = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port           = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol          = "UDP"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "er_domain_controllers_all_all" {
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_domain_controllers.id}"
  self              = true
}

## Domain Member Instances

# Ingress Rules
resource "aws_security_group" "sg_domain_members" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.envname}-${var.envtype}-domain-members"
  description = "Security Group for all Domain Member instances"

  tags {
    Name            = "sg-domain-members"
    Customer        = "${var.customer}"
    Environment     = "${var.envname}"
    EnvironmentType = "${var.envtype}"
    Service         = "Active Directory"
    Role            = "Domain Member"
  }
}

resource "aws_security_group_rule" "ir_domain_members_tcp" {
  count                    = "${length(var.common_ad_tcp_ports)}"
  type                     = "ingress"
  from_port                = "${element(var.common_ad_tcp_ports, count.index)}"
  to_port                  = "${element(var.common_ad_tcp_ports, count.index)}"
  protocol                 = "TCP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

resource "aws_security_group_rule" "ir_domain_members_udp" {
  count                    = "${length(var.common_ad_udp_ports)}"
  type                     = "ingress"
  from_port                = "${element(var.common_ad_udp_ports, count.index)}"
  to_port                  = "${element(var.common_ad_udp_ports, count.index)}"
  protocol                 = "UDP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

resource "aws_security_group_rule" "ir_domain_members_tcp_dyn" {
  type                     = "ingress"
  from_port                = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port                  = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol                 = "TCP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

resource "aws_security_group_rule" "ir_domain_members_udp_dyn" {
  type                     = "ingress"
  from_port                = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port                  = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol                 = "UDP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

# Egress Rules

resource "aws_security_group_rule" "er_domain_members_tcp" {
  count                    = "${length(var.common_ad_tcp_ports)}"
  type                     = "egress"
  from_port                = "${element(var.common_ad_tcp_ports, count.index)}"
  to_port                  = "${element(var.common_ad_tcp_ports, count.index)}"
  protocol                 = "TCP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

resource "aws_security_group_rule" "er_domain_members_udp" {
  count                    = "${length(var.common_ad_udp_ports)}"
  type                     = "egress"
  from_port                = "${element(var.common_ad_udp_ports, count.index)}"
  to_port                  = "${element(var.common_ad_udp_ports, count.index)}"
  protocol                 = "UDP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

resource "aws_security_group_rule" "er_domain_members_tcp_dyn" {
  type                     = "egress"
  from_port                = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port                  = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol                 = "TCP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

resource "aws_security_group_rule" "er_domain_members_udp_dyn" {
  type                     = "egress"
  from_port                = "${element(var.common_ad_dyn_ports, 0 )}"
  to_port                  = "${element(var.common_ad_dyn_ports, 1 )}"
  protocol                 = "UDP"
  security_group_id        = "${aws_security_group.sg_domain_members.id}"
  source_security_group_id = "${aws_security_group.sg_domain_controllers.id}"
}

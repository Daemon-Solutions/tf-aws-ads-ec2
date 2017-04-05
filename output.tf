output "ads_dns" {
  value = ["${aws_instance.domain_controller.*.private_ip}"]
}

output "ads_sg_id" {
  value = "${aws_security_group.sg_common_ad.id}"
}

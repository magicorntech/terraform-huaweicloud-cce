resource "huaweicloud_networking_secgroup" "main" {
  name        = "${var.tenant}-${var.name}-cce-sg-${var.cluster_name}-${var.environment}"
  description = "Security Group for ${var.tenant}-${var.name}-cce-${var.cluster_name}-${var.environment}"

  tags = local.all_tags
}

resource "huaweicloud_networking_secgroup_rule" "main" {
  security_group_id = huaweicloud_networking_secgroup.main.id
  direction         = "ingress"
  action            = "allow"
  remote_ip_prefix  = var.cidr_block
  ethertype         = "IPv4"
}

resource "huaweicloud_networking_secgroup_rule" "main_additional" {
  for_each          = { for idx, rule in var.additional_ips : idx => rule }
  security_group_id = huaweicloud_networking_secgroup.main.id
  direction         = "ingress"
  action            = "allow"
  remote_ip_prefix  = each.value
  ethertype         = "IPv4"
}
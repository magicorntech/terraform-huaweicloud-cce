resource "huaweicloud_cce_cluster" "main" {
  name                   = "${var.tenant}-${var.name}-cce-${var.cluster_name}-${var.environment}"
  vpc_id                 = var.vpc_id
  subnet_id              = var.pvt_subnet_ids[0]
  eni_subnet_id          = join(",", var.cce_subnet_ids)
  security_group_id      = huaweicloud_networking_secgroup.main.id
  cluster_version        = var.cluster_version
  flavor_id              = var.cluster_flavor
  container_network_type = "eni"
  kube_proxy_mode        = "iptables"
  ipv6_enable            = false
  multi_az               = true
  delete_evs             = true

  tags = local.all_tags
}
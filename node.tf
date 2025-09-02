resource "huaweicloud_cce_node_pool" "main" {
  cluster_id               = huaweicloud_cce_cluster.main.id
  security_groups          = [huaweicloud_networking_secgroup.main.id]
  name                     = "${var.tenant}-${var.name}-cce-mainnode-${var.environment}"
  flavor_id                = var.main_instance_types
  subnet_list              = var.pvt_subnet_ids
  key_pair                 = var.public_key
  os                       = var.main_os
  initial_node_count       = var.main_scaling_config.desired
  min_node_count           = var.main_scaling_config.min
  max_node_count           = var.main_scaling_config.max
  scale_down_cooldown_time = var.main_scaling_config.cooldown
  scall_enable             = var.auto_scaler_profile.autoscaling_enabled

  root_volume {
    size       = var.root_disk_size
    volumetype = var.root_disk_type
    iops       = var.root_disk_iops
    throughput = var.root_disk_throughput
    kms_key_id = var.kms_key_id
  }

  data_volumes {
    size       = var.data_disk_size
    volumetype = var.data_disk_type
    iops       = var.data_disk_iops
    throughput = var.data_disk_throughput
    kms_key_id = var.kms_key_id
  }

  extend_params {
    agency_name = huaweicloud_identity_agency.node.name
    max_pods    = var.main_max_pods
  }

  lifecycle {
    ignore_changes = [ initial_node_count ]
  }

  tags = local.all_tags
}

resource "huaweicloud_cce_node_pool" "extra" {
  count                    = (var.extra_nodes_deploy == true) ? 1 : 0
  cluster_id               = huaweicloud_cce_cluster.main.id
  security_groups          = [huaweicloud_networking_secgroup.main.id]
  name                     = "${var.tenant}-${var.name}-cce-extranode-${var.environment}"
  flavor_id                = var.extra_instance_types
  subnet_list              = var.pvt_subnet_ids
  key_pair                 = var.public_key
  os                       = var.extra_os
  initial_node_count       = var.extra_scaling_config.desired
  min_node_count           = var.extra_scaling_config.min
  max_node_count           = var.extra_scaling_config.max
  scale_down_cooldown_time = var.extra_scaling_config.cooldown
  scall_enable             = var.auto_scaler_profile.autoscaling_enabled

  root_volume {
    size       = var.root_disk_size
    volumetype = var.root_disk_type
    iops       = var.root_disk_iops
    throughput = var.root_disk_throughput
    kms_key_id = var.kms_key_id
  }

  data_volumes {
    size       = var.data_disk_size
    volumetype = var.data_disk_type
    iops       = var.data_disk_iops
    throughput = var.data_disk_throughput
    kms_key_id = var.kms_key_id
  }

  extend_params {
    agency_name = huaweicloud_identity_agency.node.name
    max_pods    = var.extra_max_pods
  }

  lifecycle {
    ignore_changes = [ initial_node_count ]
  }

  tags = local.all_tags
}

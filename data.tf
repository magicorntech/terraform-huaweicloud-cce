data "huaweicloud_availability_zones" "main" {}
data "huaweicloud_identity_projects" "current" {
  name = var.region
}
data "huaweicloud_elb_flavors" "main" {
  name = "L7_flavor.elb.pro.max"
}

data "huaweicloud_cce_addon_template" "autoscaler" {
  count      = var.auto_scaler_profile.autoscaling_enabled ? 1 : 0
  cluster_id = huaweicloud_cce_cluster.main.id
  name       = "autoscaler"
  version    = var.auto_scaler_profile.autoscaler_version
}

data "huaweicloud_cce_addon_template" "metrics_server" {
  cluster_id = huaweicloud_cce_cluster.main.id
  name       = "metrics-server"
  version    = var.metrics_server_version
}

locals {
  default_tags = {
    Name        = "${var.tenant}-${var.name}-cce-${var.cluster_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }

  all_tags = merge(local.default_tags)
}

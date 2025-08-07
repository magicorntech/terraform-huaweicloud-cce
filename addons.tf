# Get current project/tenant information
resource "huaweicloud_cce_addon" "autoscaler" {
  count         = var.autoscaling_enabled ? 1 : 0
  cluster_id    = huaweicloud_cce_cluster.main.id
  template_name = "autoscaler"
  version       = var.autoscaler_version

  values {
    #basic_json = jsonencode(jsondecode(data.huaweicloud_cce_addon_template.autoscaler[0].spec).basic)
    basic_json = jsonencode(merge(
      jsondecode(data.huaweicloud_cce_addon_template.autoscaler[0].spec).basic,
      {
        rbac_enabled    = true,
        cluster_version = var.cluster_version
      }
    ))
    custom_json = jsonencode(merge(
      jsondecode(data.huaweicloud_cce_addon_template.autoscaler[0].spec).parameters.custom,
      {
        cluster_id = huaweicloud_cce_cluster.main.id
        tenant_id  = data.huaweicloud_identity_projects.current.projects[0].id
      }
    ))
    #flavor_json = jsonencode(jsondecode(data.huaweicloud_cce_addon_template.autoscaler[0].spec).parameters.flavor1)
    flavor_json = jsonencode(merge(
      jsondecode(data.huaweicloud_cce_addon_template.autoscaler[0].spec).parameters.flavor1,
      {
        resources = [
          {
            name        = "autoscaler"
            requestsCpu = "50m"
            requestsMem = "768Mi"
            limitsCpu   = "250m"
            limitsMem   = "768Mi"
            replicas    = 1
          }
        ]
      },
      {
        category = ["CCE", "Turbo"]
      },
      {
        replicas = 1
      }
    ))
  }

  depends_on = [huaweicloud_cce_node_pool.main, huaweicloud_cce_node_pool.extra]
}

resource "huaweicloud_cce_addon" "metrics_server" {
  cluster_id    = huaweicloud_cce_cluster.main.id
  template_name = "metrics-server"
  version       = var.metrics_server_version

  values {
    basic_json = jsonencode(jsondecode(data.huaweicloud_cce_addon_template.metrics_server.spec).basic)
    custom_json = jsonencode(merge(
      jsondecode(data.huaweicloud_cce_addon_template.metrics_server.spec).parameters.custom,
      {
        cluster_id = huaweicloud_cce_cluster.main.id
        tenant_id  = data.huaweicloud_identity_projects.current.projects[0].id
      }
    ))
    flavor_json = jsonencode(merge(
      jsondecode(data.huaweicloud_cce_addon_template.metrics_server.spec).parameters.flavor1,
      {
        resources = [
          {
            name        = "metrics-server"
            requestsCpu = "100m"
            requestsMem = "300Mi"
            limitsCpu   = "500m"
            limitsMem   = "1000Mi"
            replicas    = 2
          }
        ]
      },
      {
        category = ["CCE", "Turbo"]
      },
      {
        replicas = 2
      }
    ))
  }

  depends_on = [huaweicloud_cce_node_pool.main, huaweicloud_cce_node_pool.extra]
}

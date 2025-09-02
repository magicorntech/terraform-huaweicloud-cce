# terraform-huaweicloud-cce

Magicorn made Terraform Module for Huawei Cloud Provider
--
```
module "cce" {
  source         = "magicorntech/cce/huaweicloud"
  version        = "0.0.2"
  tenant         = var.tenant
  name           = var.name
  environment    = var.environment
  region         = var.region
  vpc_id         = module.vpc.vpc_id
  cidr_block     = module.vpc.cidr_block
  pbl_subnet_ids = module.vpc.pbl_subnet_ids_os
  pvt_subnet_ids = module.vpc.pvt_subnet_ids
  cce_subnet_ids = module.vpc.cce_subnet_ids_os
  public_key     = module.dew.ecs_keypair_name[0]
  kms_key_id     = module.dew.cce_key_id[0]
  additional_ips = ["10.140.0.112/32"]

  # CCE Configuration
  cluster_name            = "master"
  cluster_version         = "v1.30"
  cluster_flavor          = "cce.s2.small"
  load_balancer_enabled   = true
  load_balancer_bandwidth = 300
  metrics_server_version  = "1.3.68"

  # Auto Scaler Configuration
  auto_scaler_profile = {
    autoscaling_enabled              = true
    autoscaler_version               = "1.30.51"
    expander                         = "least-waste"
    scale_down_utilization_threshold = 0.65
  }

  # Node Configuration
  main_instance_types = "c7n.large.4"
  main_os             = "Huawei Cloud EulerOS 2.0"
  main_max_pods       = 250
  main_scaling_config = {
    cooldown = 300,
    desired  = 2,
    min      = 2,
    max      = 2
  }

  extra_nodes_deploy   = true
  extra_instance_types = "c7n.large.4"
  extra_os             = "Huawei Cloud EulerOS 2.0"
  extra_max_pods       = 250
  extra_scaling_config = {
    cooldown = 300,
    desired  = 0,
    min      = 0,
    max      = 10
  }

  # Storage Configuration
  root_disk_size       = 40
  root_disk_type       = "GPSSD2"
  root_disk_iops       = 3000
  root_disk_throughput = 125

  data_disk_size       = 100
  data_disk_type       = "GPSSD2"
  data_disk_iops       = 3000
  data_disk_throughput = 125

  # SFS Turbo storage configuration
  sfs_turbo_storages = [
    # {
    #   name          = "app-data"
    #   size          = 3686
    #   share_type    = "HPC"
    #   hpc_bandwidth = "20M"
    #   description   = "Application data storage - Basic HDD performance"
    # }
  ]
}

```
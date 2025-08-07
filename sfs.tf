# SFS Turbo storage resource
# Available share_type options based on Terraform provider documentation:
# - "STANDARD"     : 500-32,768 GB (basic performance)
# - "PERFORMANCE"  : 500-32,768 GB (enhanced performance)  
# - "HPC"          : 3,686-1,048,576 GB with hpc_bandwidth (20M, 40M, 125M, 250M, 500M, 1000M)
# - "HPC_CACHE"    : 4,096-1,048,576 GB (ultra high performance with cache)
#
# HPC bandwidth mapping to UI values:
# - 20M   = 20 MB/s/TiB (default, minimum 3,686 GB)
# - 40M   = 40 MB/s/TiB (minimum 1,228 GB)  
# - 125M  = 125 MB/s/TiB (minimum 1,228 GB)
# - 250M  = 250 MB/s/TiB (minimum 1,228 GB)
# - 500M  = 500 MB/s/TiB (minimum 1,228 GB)
# - 1000M = 1000 MB/s/TiB (minimum 1,228 GB)

resource "huaweicloud_sfs_turbo" "main" {
  for_each = { for idx, storage in var.sfs_turbo_storages : idx => storage }

  name              = "${var.tenant}-${var.name}-sfs-${each.value.name}-${var.environment}"
  size              = each.value.size
  share_proto       = lookup(each.value, "share_proto", "NFS")
  vpc_id            = var.vpc_id
  subnet_id         = var.pvt_subnet_ids[0]
  security_group_id = huaweicloud_networking_secgroup.main.id
  share_type        = lookup(each.value, "share_type", "HPC")
  hpc_bandwidth     = lookup(each.value, "hpc_bandwidth", "20M")
  availability_zone = lookup(each.value, "availability_zone", data.huaweicloud_availability_zones.main.names[0])
  crypt_key_id      = lookup(each.value, "crypt_key_id", var.kms_key_id)

  tags = merge(local.all_tags, {
    Name        = "${var.tenant}-${var.name}-sfs-${each.value.name}-${var.environment}"
    Description = lookup(each.value, "description", "SFS Turbo storage for ${each.value.name}")
  })
}
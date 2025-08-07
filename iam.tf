resource "huaweicloud_identity_agency" "node" {
  name                   = "${var.tenant}-${var.name}-cce-${var.cluster_name}-node-agency-${var.environment}"
  description            = "Agency for CCE to access ECS, AS, IMS, etc."
  delegated_service_name = "op_svc_cce"
  duration               = "FOREVER"

  project_role {
    project = var.region
    roles = [
      "CCE Administrator",
      "ECS ReadOnlyAccess",
      "IMS FullAccess",
      "VPC ReadOnlyAccess",
      "NAT ReadOnlyAccess",
      "KMS CMKFullAccess",
      "SMN Administrator",
      "OBS ReadOnlyAccess",
      "LTS Administrator",
      "ELB FullAccess",
      "EVS FullAccess",
      "CSMS ReadOnlyAccess",
      "BMS ReadOnlyAccess",
      "CCE cluster policies",
      "Tenant Guest"
    ]
  }
}
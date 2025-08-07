resource "huaweicloud_vpc_eip" "main" {
  count = var.load_balancer_enabled ? 1 : 0
  name = "${var.tenant}-${var.name}-cce-lb-eip-${var.cluster_name}-${var.environment}-eip"

  publicip {
    type       = "5_bgp"
    ip_version = 4
  }

  bandwidth {
    name        = "${var.tenant}-${var.name}-cce-bandwidth-${var.cluster_name}-${var.environment}-eip"
    share_type  = "PER"
    charge_mode = "traffic"
    size        = var.load_balancer_bandwidth
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = local.all_tags
}

resource "huaweicloud_elb_loadbalancer" "main" {
  count                      = var.load_balancer_enabled ? 1 : 0
  name                       = "${var.tenant}-${var.name}-cce-lb-${var.cluster_name}-${var.environment}"
  l7_flavor_id               = data.huaweicloud_elb_flavors.main.flavors[0].id
  description                = "Managed by Magicorn"
  cross_vpc_backend          = true
  vpc_id                     = var.vpc_id
  ipv4_subnet_id             = var.pbl_subnet_ids[0]
  backend_subnets            = var.pvt_subnet_ids
  ipv4_eip_id                = huaweicloud_vpc_eip.main[0].id
  availability_zone          = data.huaweicloud_availability_zones.main.names
  deletion_protection_enable = true

  tags = local.all_tags
}

resource "huaweicloud_elb_listener" "http" {
  count                       = var.load_balancer_enabled ? 1 : 0
  name                        = "${var.tenant}-${var.name}-cce-lb-http-${var.cluster_name}-${var.environment}"
  loadbalancer_id             = huaweicloud_elb_loadbalancer.main[0].id
  description                 = "Managed by Magicorn"
  advanced_forwarding_enabled = true
  protocol                    = "HTTP"
  protocol_port               = 80

  idle_timeout     = 60
  request_timeout  = 60
  response_timeout = 60

  tags = local.all_tags
}

resource "huaweicloud_elb_l7policy" "http" {
  count       = var.load_balancer_enabled ? 1 : 0
  name        = "${var.tenant}-${var.name}-cce-lb-http-policy-${var.cluster_name}-${var.environment}"
  description = "Managed by Magicorn"
  action      = "REDIRECT_TO_URL"
  listener_id = huaweicloud_elb_listener.http[0].id

  redirect_url_config {
    status_code = "301"
    protocol    = "HTTPS"
    port        = 443
    host        = "$${host}"
    path        = "$${path}"
    query       = "$${query}"
  }
}

resource "huaweicloud_elb_l7rule" "http" {
  count        = var.load_balancer_enabled ? 1 : 0
  l7policy_id  = huaweicloud_elb_l7policy.http[0].id
  type         = "SOURCE_IP"
  compare_type = "EQUAL_TO"

  conditions {
    value = "0.0.0.0/0"
  }
}

# resource "huaweicloud_elb_listener" "https" {
#   name               = "${var.tenant}-${var.name}-cce-lb-https-${var.cluster_name}-${var.environment}"
#   loadbalancer_id    = huaweicloud_elb_loadbalancer.main.id
#   description        = "Managed by Magicorn"
#   protocol           = "HTTPS"
#   protocol_port      = 443
#   server_certificate = "a07c4652b0bc45b59af32c5e8c0fbd18"
#   sni_certificate    = ["a07c4652b0bc45b59af32c5e8c0fbd18"]
#   tls_ciphers_policy = "tls-1-2"

#   idle_timeout     = 60
#   request_timeout  = 60
#   response_timeout = 60

#   tags = local.all_tags
# }

# resource "huaweicloud_elb_l7policy" "https" {
#   name                    = "${var.tenant}-${var.name}-cce-lb-https-policy-${var.cluster_name}-${var.environment}"
#   description             = "Managed by Magicorn"
#   action                  = "REDIRECT_TO_POOL"
#   listener_id             = huaweicloud_elb_listener.https.id
#   redirect_pool_id        = huaweicloud_elb_pool.https.id
# }

# resource "huaweicloud_elb_pool" "https" {
#   name            = "${var.tenant}-${var.name}-cce-lb-https-pool-${var.cluster_name}-${var.environment}"
#   description     = "Managed by Magicorn"
#   protocol        = "HTTP"
#   lb_method       = "ROUND_ROBIN"
#   listener_id     = huaweicloud_elb_listener.https.id
# }

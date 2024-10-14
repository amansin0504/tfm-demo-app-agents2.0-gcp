## redis application
# Instance template for redis
resource "google_compute_instance_template" "redis" {
  name                      = format("%s-%s",var.cec,"redis")
  labels                    = {application = "redis"}
  instance_description      = "redis group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = file("scripts/redis.sh")

  scheduling {
    automatic_restart       = true
    on_host_maintenance     = "MIGRATE"
  }
  disk {
    source_image            = "ubuntu-2004-focal-v20200720"
    auto_delete             = true
    boot                    = true
  }
  network_interface {
    subnetwork              = google_compute_subnetwork.dbsubnet1.id
  }
}
# redis autoscaler
resource "google_compute_autoscaler" "redis-autoscaler" {
  name                      = format("%s-%s",var.cec,"redis-autoscaler")
  target                    = google_compute_instance_group_manager.redis-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 3
    max_replicas            = 3
    cpu_utilization {
      target                = 0.7
    }
  }
}
# redis instance group
resource "google_compute_instance_group_manager" "redis-manager" {
  name                    = format("%s-%s",var.cec,"redis-manager")
  base_instance_name      = format("%s-%s",var.cec,"redis")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.redis.self_link
  }
  named_port {
    name = "redisportttp"
    port = 8998
  }
}


# redis health check
resource "google_compute_health_check" "redis-health-check" {
  name                    = format("%s-%s",var.cec,"redis-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8998
  }
}
# redis backend service
resource "google_compute_region_backend_service" "redis-backend-service" {
  name                    = format("%s-%s",var.cec,"redis-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.redis-manager.instance_group
  }
  health_checks           = [google_compute_health_check.redis-health-check.self_link]
}
# redis loadbalancer or forwarding rule
resource "google_compute_forwarding_rule" "redis-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"redis-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.dbsubnet1.id
  backend_service       = google_compute_region_backend_service.redis-backend-service.self_link
  ports                 = ["8998"]
}

# create internal dns record
resource "google_dns_record_set" "redis-record" {
  name         = "redis.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.redis-internal-forwarding-rule.ip_address]
}
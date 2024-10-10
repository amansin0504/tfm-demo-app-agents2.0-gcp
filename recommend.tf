## recommend application
# Instance template for recommend
resource "google_compute_instance_template" "recommend" {
  name                      = format("%s-%s",var.cec,"recommend")
  labels                    = {application = "recommend"}
  instance_description      = "recommend group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = file("scripts/recommendation.sh")

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
    subnetwork              = google_compute_subnetwork.appsubnet1.id
  }
}
# recommend autoscaler
resource "google_compute_autoscaler" "recommend-autoscaler" {
  name                      = format("%s-%s",var.cec,"recommend-autoscaler")
  target                    = google_compute_instance_group_manager.recommend-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# recommend instance group
resource "google_compute_instance_group_manager" "recommend-manager" {
  name                    = format("%s-%s",var.cec,"recommend-manager")
  base_instance_name      = format("%s-%s",var.cec,"recommend")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.recommend.self_link
  }
  named_port {
    name = "recommendportttp"
    port = 8991
  }
}


# recommend health check
resource "google_compute_health_check" "recommend-health-check" {
  name                    = format("%s-%s",var.cec,"recommend-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8991
  }
}
# recommend backend service
resource "google_compute_region_backend_service" "recommend-backend-service" {
  name                    = format("%s-%s",var.cec,"recommend-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.recommend-manager.instance_group
  }
  health_checks           = [google_compute_health_check.recommend-health-check.self_link]
}
# recommend lorecommendbalancer or forwarding lorecommendbalancer
resource "google_compute_forwarding_rule" "recommend-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"recommend-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.recommend-backend-service.self_link
  ports                 = ["8991"]
}

# create internal dns record
resource "google_dns_record_set" "recommend-record" {
  name         = "recommend.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.recommend-internal-forwarding-rule.ip_address]
}
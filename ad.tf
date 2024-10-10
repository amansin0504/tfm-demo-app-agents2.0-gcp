## ad application
# Instance template for ad
resource "google_compute_instance_template" "ad" {
  name                      = format("%s-%s",var.cec,"ad")
  labels                    = {application = "ad"}
  instance_description      = "ad group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = file("scripts/ad.sh")

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
# ad autoscaler
resource "google_compute_autoscaler" "ad-autoscaler" {
  name                      = format("%s-%s",var.cec,"ad-autoscaler")
  target                    = google_compute_instance_group_manager.ad-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# ad instance group
resource "google_compute_instance_group_manager" "ad-manager" {
  name                    = format("%s-%s",var.cec,"ad-manager")
  base_instance_name      = format("%s-%s",var.cec,"ad")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.ad.self_link
  }
  named_port {
    name = "adportttp"
    port = 8990
  }
}


# ad health check
resource "google_compute_health_check" "ad-health-check" {
  name                    = format("%s-%s",var.cec,"ad-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8990
  }
}
# ad backend service
resource "google_compute_region_backend_service" "ad-backend-service" {
  name                    = format("%s-%s",var.cec,"ad-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.ad-manager.instance_group
  }
  health_checks           = [google_compute_health_check.ad-health-check.self_link]
}
# ad loadbalancer or forwarding loadbalancer
resource "google_compute_forwarding_rule" "ad-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"ad-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.ad-backend-service.self_link
  ports                 = ["8990"]
}

# create internal dns record
resource "google_dns_record_set" "ad_record" {
  name         = "ad.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.ad-internal-forwarding-rule.ip_address]
}
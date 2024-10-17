## currency application
# Instance template for currency
resource "google_compute_instance_template" "currency" {
  name                      = format("%s-%s",var.cec,"currency")
  labels                    = {application = "currency"}
  instance_description      = "currency group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = templatefile("scripts/currency.sh", {downloadurl = var.cswinstaller})

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
# currency autoscaler
resource "google_compute_autoscaler" "currency-autoscaler" {
  name                      = format("%s-%s",var.cec,"currency-autoscaler")
  target                    = google_compute_instance_group_manager.currency-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# currency instance group
resource "google_compute_instance_group_manager" "currency-manager" {
  name                    = format("%s-%s",var.cec,"currency-manager")
  base_instance_name      = format("%s-%s",var.cec,"currency")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.currency.self_link
  }
  named_port {
    name = "currencyportttp"
    port = 8996
  }
}


# currency health check
resource "google_compute_health_check" "currency-health-check" {
  name                    = format("%s-%s",var.cec,"currency-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8996
  }
}
# currency backend service
resource "google_compute_region_backend_service" "currency-backend-service" {
  name                    = format("%s-%s",var.cec,"currency-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.currency-manager.instance_group
  }
  health_checks           = [google_compute_health_check.currency-health-check.self_link]
}
# currency loadbalancer or forwarding rule
resource "google_compute_forwarding_rule" "currency-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"currency-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.currency-backend-service.self_link
  ports                 = ["8996"]
}

# create internal dns record
resource "google_dns_record_set" "currency-record" {
  name         = "currency.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.currency-internal-forwarding-rule.ip_address]
}
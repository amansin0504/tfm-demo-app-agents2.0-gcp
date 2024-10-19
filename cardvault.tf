## cardvault application
# Instance template for cardvault
resource "google_compute_instance_template" "cardvault" {
  name                      = format("%s-%s",var.cec,"cardvault")
  labels                    = {application = "cardvault"}
  instance_description      = "cardvault group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = templatefile("scripts/cardvault.sh", {downloadurl = var.cswinstaller})

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
# cardvault autoscaler
resource "google_compute_autoscaler" "cardvault-autoscaler" {
  name                      = format("%s-%s",var.cec,"cardvault-autoscaler")
  target                    = google_compute_instance_group_manager.cardvault-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# cardvault instance group
resource "google_compute_instance_group_manager" "cardvault-manager" {
  name                    = format("%s-%s",var.cec,"cardvault-manager")
  base_instance_name      = format("%s-%s",var.cec,"cardvault")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.cardvault.self_link
  }
  named_port {
    name = "cardvaultportttp"
    port = 8996
  }
}


# cardvault health check
resource "google_compute_health_check" "cardvault-health-check" {
  name                    = format("%s-%s",var.cec,"cardvault-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8996
  }
}
# cardvault backend service
resource "google_compute_region_backend_service" "cardvault-backend-service" {
  name                    = format("%s-%s",var.cec,"cardvault-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.cardvault-manager.instance_group
  }
  health_checks           = [google_compute_health_check.cardvault-health-check.self_link]
}
# cardvault loadbalancer or forwarding rule
resource "google_compute_forwarding_rule" "cardvault-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"cardvault-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.cardvault-backend-service.self_link
  ports                 = ["8996"]
}

# create internal dns record
resource "google_dns_record_set" "cardvault-record" {
  name         = "cardvault.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.cardvault-internal-forwarding-rule.ip_address]
}
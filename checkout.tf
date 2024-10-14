## Frontend application
# Instance template for frontend
resource "google_compute_instance_template" "checkout" {
  name                      = format("%s-%s",var.cec,"checkout")
  labels                    = {application = "checkout"}
  instance_description      = "checkout group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = file("scripts/checkout.sh")

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
# Checkout autoscaler
resource "google_compute_autoscaler" "checkout-autoscaler" {
  name                      = format("%s-%s",var.cec,"checkout-autoscaler")
  target                    = google_compute_instance_group_manager.checkout-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 2
    max_replicas            = 2
    cpu_utilization {
      target                = 0.7
    }
  }
}
# Checkout instance group
resource "google_compute_instance_group_manager" "checkout-manager" {
  name                    = format("%s-%s",var.cec,"checkout-manager")
  base_instance_name      = format("%s-%s",var.cec,"checkout")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.checkout.self_link
  }
  named_port {
    name = "checkoutportttp"
    port = 8989
  }
}


# Checkout health check
resource "google_compute_health_check" "checkout-health-check" {
  name                    = format("%s-%s",var.cec,"checkout-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8989
  }
}
# Checkout backend service
resource "google_compute_region_backend_service" "checkout-backend-service" {
  name                    = format("%s-%s",var.cec,"checkout-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.checkout-manager.instance_group
  }
  health_checks           = [google_compute_health_check.checkout-health-check.self_link]
}
# Checkout loadbalancer or forwarding loadbalancer
resource "google_compute_forwarding_rule" "checkout-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"checkout-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.checkout-backend-service.self_link
  ports                 = ["8989"]
}

# create internal dns record
resource "google_dns_record_set" "checkout-record" {
  name         = "checkout.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.checkout-internal-forwarding-rule.ip_address]
}
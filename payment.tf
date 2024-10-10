## payment application
# Instance template for payment
resource "google_compute_instance_template" "payment" {
  name                      = format("%s-%s",var.cec,"payment")
  labels                    = {application = "payment"}
  instance_description      = "payment group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = file("scripts/payment.sh")

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
# payment autoscaler
resource "google_compute_autoscaler" "payment-autoscaler" {
  name                      = format("%s-%s",var.cec,"payment-autoscaler")
  target                    = google_compute_instance_group_manager.payment-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# payment instance group
resource "google_compute_instance_group_manager" "payment-manager" {
  name                    = format("%s-%s",var.cec,"payment-manager")
  base_instance_name      = format("%s-%s",var.cec,"payment")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.payment.self_link
  }
  named_port {
    name = "paymentportttp"
    port = 8992
  }
}


# payment health check
resource "google_compute_health_check" "payment-health-check" {
  name                    = format("%s-%s",var.cec,"payment-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8992
  }
}
# payment backend service
resource "google_compute_region_backend_service" "payment-backend-service" {
  name                    = format("%s-%s",var.cec,"payment-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.payment-manager.instance_group
  }
  health_checks           = [google_compute_health_check.payment-health-check.self_link]
}
# payment loadbalancer or forwarding rule
resource "google_compute_forwarding_rule" "payment-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"payment-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.payment-backend-service.self_link
  ports                 = ["8992"]
}

# create internal dns record
resource "google_dns_record_set" "payment-record" {
  name         = "payment.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.payment-internal-forwarding-rule.ip_address]
}
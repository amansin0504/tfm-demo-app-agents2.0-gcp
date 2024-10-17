## shipping application
# Instance template for shipping
resource "google_compute_instance_template" "shipping" {
  name                      = format("%s-%s",var.cec,"shipping")
  labels                    = {application = "shipping"}
  instance_description      = "shipping group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = templatefile("scripts/shipping.sh", {downloadurl = var.cswinstaller})

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
# shipping autoscaler
resource "google_compute_autoscaler" "shipping-autoscaler" {
  name                      = format("%s-%s",var.cec,"shipping-autoscaler")
  target                    = google_compute_instance_group_manager.shipping-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# shipping instance group
resource "google_compute_instance_group_manager" "shipping-manager" {
  name                    = format("%s-%s",var.cec,"shipping-manager")
  base_instance_name      = format("%s-%s",var.cec,"shipping")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.shipping.self_link
  }
  named_port {
    name = "shippingportttp"
    port = 8995
  }
}


# shipping health check
resource "google_compute_health_check" "shipping-health-check" {
  name                    = format("%s-%s",var.cec,"shipping-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8995
  }
}
# shipping backend service
resource "google_compute_region_backend_service" "shipping-backend-service" {
  name                    = format("%s-%s",var.cec,"shipping-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.shipping-manager.instance_group
  }
  health_checks           = [google_compute_health_check.shipping-health-check.self_link]
}
# shipping loadbalancer or forwarding rule
resource "google_compute_forwarding_rule" "shipping-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"shipping-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.shipping-backend-service.self_link
  ports                 = ["8995"]
}

# create internal dns record
resource "google_dns_record_set" "shipping-record" {
  name         = "shipping.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.shipping-internal-forwarding-rule.ip_address]
}
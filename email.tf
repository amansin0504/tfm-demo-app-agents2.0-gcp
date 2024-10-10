## email application
# Instance template for email
resource "google_compute_instance_template" "email" {
  name                      = format("%s-%s",var.cec,"email")
  labels                    = {application = "email"}
  instance_description      = "email group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = file("scripts/email.sh")

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
# email autoscaler
resource "google_compute_autoscaler" "email-autoscaler" {
  name                      = format("%s-%s",var.cec,"email-autoscaler")
  target                    = google_compute_instance_group_manager.email-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# email instance group
resource "google_compute_instance_group_manager" "email-manager" {
  name                    = format("%s-%s",var.cec,"email-manager")
  base_instance_name      = format("%s-%s",var.cec,"email")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.email.self_link
  }
  named_port {
    name = "emailportttp"
    port = 8993
  }
}


# email health check
resource "google_compute_health_check" "email-health-check" {
  name                    = format("%s-%s",var.cec,"email-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8993
  }
}
# email backend service
resource "google_compute_region_backend_service" "email-backend-service" {
  name                    = format("%s-%s",var.cec,"email-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.email-manager.instance_group
  }
  health_checks           = [google_compute_health_check.email-health-check.self_link]
}
# email loadbalancer or forwarding rule
resource "google_compute_forwarding_rule" "email-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"email-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.email-backend-service.self_link
  ports                 = ["8993"]
}

# create internal dns record
resource "google_dns_record_set" "email-record" {
  name         = "email.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.email-internal-forwarding-rule.ip_address]
}
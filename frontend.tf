## Frontend application
# Instance template for frontend
resource "google_compute_instance_template" "frontend" {
  name        = format("%s-%s",var.cec,"frontend")
  labels      = {application = "frontend"}
  instance_description = "frontend group"
  machine_type         = "e2-medium"
  can_ip_forward       = false
  metadata_startup_script = file("scripts/frontend.sh")

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  disk {
    source_image      = "ubuntu-2004-focal-v20200720"
    auto_delete       = true
    boot              = true
  }
  network_interface {
    subnetwork              = google_compute_subnetwork.websubnet1.id
    access_config {}
  }
}
# Instance group manager for frontend
resource "google_compute_instance_group_manager" "frontend-manager" {
  name                    = format("%s-%s",var.cec,"frontend-manager")
  base_instance_name      = format("%s-%s",var.cec,"frontend")
  zone                    = var.zone
  named_port {
    name = "http"
    port = 8080
  }
  version {
    instance_template     = google_compute_instance_template.frontend.self_link
  }
}
# Instance autoscaler for frontend
resource "google_compute_autoscaler" "frontend-autoscaler" {
  name                 = format("%s-%s",var.cec,"frontend-autoscaler")
  target               = google_compute_instance_group_manager.frontend-manager.self_link
  zone                 = var.zone
  autoscaling_policy {
    min_replicas       = 1
    max_replicas       = 1
    cpu_utilization {
      target          = 0.7
    }
  }
}
# Frontend health check
resource "google_compute_health_check" "frontend-health-check" {
  name                    = format("%s-%s",var.cec,"frontend-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8080
  }
}
# Frontend backend service
resource "google_compute_backend_service" "frontend-backend-service" {
  name                    = format("%s-%s",var.cec,"frontend-backend-service")
  protocol                = "HTTP"
  timeout_sec             = 10
  port_name               = "http"
  backend {
    group                = google_compute_instance_group_manager.frontend-manager.instance_group
  }
  health_checks           = [google_compute_health_check.frontend-health-check.self_link]
}
# Frontend URL access
resource "google_compute_url_map" "frontend-url-map" {
  name                    = format("%s-%s",var.cec,"frontend-url-map")
  default_service         = google_compute_backend_service.frontend-backend-service.self_link
}
# Frontend target http proxy
resource "google_compute_target_http_proxy" "target-http-proxy" {
  name                    = format("%s-%s",var.cec,"frontend-target-http-proxy")
  url_map                 = google_compute_url_map.frontend-url-map.self_link
}
# Frontend forwarding rule
resource "google_compute_global_forwarding_rule" "frontend-forwarding-rule" {
  name                    = format("%s-%s",var.cec,"frontend-forwarding-rule")
  load_balancing_scheme   = "EXTERNAL"
  port_range              = "8080-8080"
  target                 = google_compute_target_http_proxy.target-http-proxy.self_link
}
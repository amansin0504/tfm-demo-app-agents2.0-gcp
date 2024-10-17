## productcatalog application
# Instance template for productcatalog
resource "google_compute_instance_template" "productcatalog" {
  name                      = format("%s-%s",var.cec,"productcatalog")
  labels                    = {application = "productcatalog"}
  instance_description      = "productcatalog group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = templatefile("scripts/productcatalog.sh", {downloadurl = var.cswinstaller})

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
# productcatalog autoscaler
resource "google_compute_autoscaler" "productcatalog-autoscaler" {
  name                      = format("%s-%s",var.cec,"productcatalog-autoscaler")
  target                    = google_compute_instance_group_manager.productcatalog-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# productcatalog instance group
resource "google_compute_instance_group_manager" "productcatalog-manager" {
  name                    = format("%s-%s",var.cec,"productcatalog-manager")
  base_instance_name      = format("%s-%s",var.cec,"productcatalog")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.productcatalog.self_link
  }
  named_port {
    name = "productcatalogportttp"
    port = 8994
  }
}


# productcatalog health check
resource "google_compute_health_check" "productcatalog-health-check" {
  name                    = format("%s-%s",var.cec,"productcatalog-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8994
  }
}
# productcatalog backend service
resource "google_compute_region_backend_service" "productcatalog-backend-service" {
  name                    = format("%s-%s",var.cec,"productcatalog-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.productcatalog-manager.instance_group
  }
  health_checks           = [google_compute_health_check.productcatalog-health-check.self_link]
}
# productcatalog loproductcatalogbalancer or forwarding loproductcatalogbalancer
resource "google_compute_forwarding_rule" "productcatalog-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"productcatalog-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.productcatalog-backend-service.self_link
  ports                 = ["8994"]
}

# create internal dns record
resource "google_dns_record_set" "productcatalog-record" {
  name         = "productcatalog.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.productcatalog-internal-forwarding-rule.ip_address]
}
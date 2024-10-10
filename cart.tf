## cart application
# Instance template for cart
resource "google_compute_instance_template" "cart" {
  name                      = format("%s-%s",var.cec,"cart")
  labels                    = {application = "cart"}
  instance_description      = "cart group"
  machine_type              = "e2-medium"
  can_ip_forward            = false
  metadata_startup_script   = file("scripts/cart.sh")

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
# cart autoscaler
resource "google_compute_autoscaler" "cart-autoscaler" {
  name                      = format("%s-%s",var.cec,"cart-autoscaler")
  target                    = google_compute_instance_group_manager.cart-manager.self_link
  zone                      = var.zone
  autoscaling_policy {
    min_replicas            = 1
    max_replicas            = 1
    cpu_utilization {
      target                = 0.7
    }
  }
}
# cart instance group
resource "google_compute_instance_group_manager" "cart-manager" {
  name                    = format("%s-%s",var.cec,"cart-manager")
  base_instance_name      = format("%s-%s",var.cec,"cart")
  zone                    = var.zone
  version {
    instance_template     = google_compute_instance_template.cart.self_link
  }
  named_port {
    name = "cartportttp"
    port = 8997
  }
}


# cart health check
resource "google_compute_health_check" "cart-health-check" {
  name                    = format("%s-%s",var.cec,"cart-health-check")
  check_interval_sec      = 10
  timeout_sec             = 5
  healthy_threshold       = 2
  unhealthy_threshold     = 2
  tcp_health_check {
    port                  = 8997
  }
}
# cart backend service
resource "google_compute_region_backend_service" "cart-backend-service" {
  name                    = format("%s-%s",var.cec,"cart-backend-service")
  protocol                = "TCP"
  region                  = var.region
  timeout_sec             = 10

  backend {
    group       = google_compute_instance_group_manager.cart-manager.instance_group
  }
  health_checks           = [google_compute_health_check.cart-health-check.self_link]
}
# cart loadbalancer or forwarding rule
resource "google_compute_forwarding_rule" "cart-internal-forwarding-rule" {
  name                  = format("%s-%s",var.cec,"cart-internal-forwarding-rule")
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  network               = google_compute_network.csw-demo-network.id
  subnetwork            = google_compute_subnetwork.appsubnet1.id
  backend_service       = google_compute_region_backend_service.cart-backend-service.self_link
  ports                 = ["8997"]
}

# create internal dns record
resource "google_dns_record_set" "cart_record" {
  name         = "cart.csw.lab."
  managed_zone = google_dns_managed_zone.demo_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_forwarding_rule.cart-internal-forwarding-rule.ip_address]
}
#Create subnets in VNET network 
resource "google_compute_network" "csw-demo-network" {
  name                    = format("%s-%s",var.cec,"csw-demo-network")
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "websubnet1" {
    name                 = format("%s-%s",var.cec,"websubnet1")
    region               = var.region
    network              = google_compute_network.csw-demo-network.id
    ip_cidr_range        = var.websubnet1
    log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    }
}
resource "google_compute_subnetwork" "websubnet2" {
    name                 = format("%s-%s",var.cec,"websubnet2")
    region        = var.region
    network       = google_compute_network.csw-demo-network.id
    ip_cidr_range = var.websubnet2
    log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    }
}
resource "google_compute_subnetwork" "appsubnet1" {
    name                 = format("%s-%s",var.cec,"appsubnet1")
    region        = var.region
    network       = google_compute_network.csw-demo-network.id
    ip_cidr_range = var.appsubnet1
    log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    }
}
resource "google_compute_subnetwork" "appsubnet2" {
    name                 = format("%s-%s",var.cec,"appsubnet2")
    region        = var.region
    network       = google_compute_network.csw-demo-network.id
    ip_cidr_range = var.appsubnet2
    log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    }
}
resource "google_compute_subnetwork" "dbsubnet1" {
    name                 = format("%s-%s",var.cec,"dbsubnet1")
    region        = var.region
    network       = google_compute_network.csw-demo-network.id
    ip_cidr_range = var.dbsubnet1
    log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    }
}
resource "google_compute_subnetwork" "dbsubnet2" {
    name                 = format("%s-%s",var.cec,"dbsubnet2")
    region        = var.region
    network       = google_compute_network.csw-demo-network.id
    ip_cidr_range = var.dbsubnet2
    log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    }

}

#Create firewall rules
resource "google_compute_firewall" "csw-demo-firewall" {
  name    = format("%s-%s",var.cec,"csw-demo-firewall")
  network = google_compute_network.csw-demo-network.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "22", "8000-9000"]
  }
  source_ranges = ["0.0.0.0/0"]
}

#Create cloud nat for outbound connectivity from private VMs.
resource "google_compute_router" "csw-demo-router" {
  name    = format("%s-%s",var.cec,"csw-demo-router")
  region  = var.region
  network = google_compute_network.csw-demo-network.id

  bgp {
    asn = 64514
  }
}
resource "google_compute_router_nat" "csw-demo-nat" {
  name                               = format("%s-%s",var.cec,"csw-demo-nat")
  router                             = google_compute_router.csw-demo-router.name
  region                             = google_compute_router.csw-demo-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_dns_managed_zone" "demo_zone" {
  name     = "demo-zone"
  dns_name = "csw.lab."
  visibility = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.csw-demo-network.self_link
    }
  }
}
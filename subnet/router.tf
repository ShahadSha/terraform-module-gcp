resource "google_compute_router" "router" {
  project    = var.project_name
  name       = "test-router"
  network    = var.vpc_name
  region     = var.region
  depends_on = [google_compute_subnetwork.subnets]

  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "test-nat-config"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  depends_on                         = [google_compute_subnetwork.subnets]

  subnetwork {
    name                    = "private-subnet-1"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
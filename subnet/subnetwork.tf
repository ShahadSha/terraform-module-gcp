resource "google_compute_subnetwork" "subnets" {
  count         = length(var.subnets)
  name          = var.subnets[count.index].name
  network       = var.vpc_name
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region        = var.region
  depends_on    = [var.vpc_name]
}
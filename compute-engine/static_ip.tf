resource "google_compute_address" "static_ip" {
  count = var.allocate_external_ip ? length(var.virtual_machines) : 0
  name  = "${var.virtual_machines[count.index]}-external-ip-${count.index}"
  labels = {
    node = element(var.virtual_machines, 0)
  }
  lifecycle {
    ignore_changes = [users[0]]
  }
}

resource "google_compute_address" "internal_with_gce_endpoint" {
  count        = length(var.virtual_machines)
  name         = "${var.virtual_machines[count.index]}-internal-ip-${count.index}"
  address_type = "INTERNAL"
  address      = var.internal_ip[count.index]
  subnetwork   = var.subnet_name
  region       = var.region
  purpose      = "GCE_ENDPOINT"
}

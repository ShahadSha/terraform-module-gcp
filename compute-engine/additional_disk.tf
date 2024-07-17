resource "google_compute_disk" "additional_disk" {
  count = var.create_additional_disk ? length(var.virtual_machines) : 0
  name  = "additional-disk-${var.virtual_machines[count.index]}"
  type  = "pd-ssd"
  zone  = var.zone
  size  = var.secondary_disk_space

  lifecycle {
    prevent_destroy = false
  }
}
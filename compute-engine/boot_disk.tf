resource "google_compute_disk" "boot_disk" {
  count = length(var.virtual_machines)
  name  = var.virtual_machines[count.index]
  zone  = var.zone
  type  = "pd-balanced"
  image = var.os_image
  size  = var.boot_disk_space
}

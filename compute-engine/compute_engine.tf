
resource "google_compute_instance" "instance" {
  count = length(var.virtual_machines)

  name         = var.virtual_machines[count.index]
  machine_type = var.machine_type

  boot_disk {
    source = google_compute_disk.boot_disk[count.index].name
  }
  # boot_disk {
  #   auto_delete = true
  #   device_name = var.virtual_machines[count.index]

  #   initialize_params {
  #     image = var.os_image
  #     size  = var.boot_disk_space
  #     type  = "pd-ssd"
  #   }
  #   mode = "READ_WRITE"
  # }

  dynamic "attached_disk" {
    for_each = var.create_additional_disk ? [1] : []
    content {
      source      = google_compute_disk.additional_disk[count.index].id
      device_name = "additional-disk-${var.virtual_machines[count.index]}"
    }
  }
  # provisioner "file" {
  #   source      = "./bash_scripts/mount.sh"
  #   destination = "/tmp/mount.sh"
  # }
  # connection {
  #   type        = "ssh"
  #   user        = var.ssh_user
  #   private_key = file(var.private_key_path)
  #   host        = self.network_interface.0.access_config.0.nat_ip
  # }
  # provisioner "remote-exec" {

  #   # when   = var.create_additional_disk ? "create" : "destroy"

  #   inline = [
  #     "chmod +x /tmp/mount.sh",
  #     "/tmp/mount.sh ${var.mount_point}"
  #   ]
  # }


  can_ip_forward            = false
  deletion_protection       = false
  enable_display            = false
  allow_stopping_for_update = true


  labels = {
    google-src = "vm_add-tf"
  }

  network_interface {
    network_ip = google_compute_address.internal_with_gce_endpoint[count.index].address

    dynamic "access_config" {
      for_each = var.allocate_external_ip ? [1] : []
      content {
        network_tier = "PREMIUM"
        nat_ip       = var.allocate_external_ip ? google_compute_address.static_ip[count.index].address : null
      }
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = var.subnet_name
  }


  metadata = {
    ssh-keys = "ubuntu:${local.file_exists ? 1 : tls_private_key.ssh[0].public_key_openssh}"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"

    preemptible        = false
    provisioning_model = "STANDARD"
  }
  service_account {

    # email = var.service_account_email
    email = "default"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  lifecycle {
    ignore_changes = [
      service_account[0].email
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }
  tags = ["http-server", "https-server", "lb-health-check"]
  zone = var.zone
}

resource "null_resource" "provision" {
  count = var.allocate_external_ip && var.create_additional_disk ? 1 : 0

  provisioner "file" {
    source      = "${path.module}/bash_scripts/mount.sh"
    destination = "/tmp/mount.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = google_compute_instance.instance[count.index].network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "remote-exec" {

    # when   = var.create_additional_disk ? "create" : "destroy"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = google_compute_instance.instance[count.index].network_interface.0.access_config.0.nat_ip
    }
    inline = [
      "chmod +x /tmp/mount.sh",
      "/tmp/mount.sh ${var.mount_point}"
    ]
  }
}

output "public_ip" {
  value = google_compute_address.static_ip
}

output "private_key" {
  value     = local.file_exists ? local.existing_private_key : tls_private_key.ssh[0].private_key_pem
  sensitive = true
}

output "public_key" {
  value = local.file_exists ? local.existing_public_key : tls_private_key.ssh[0].public_key_pem
}

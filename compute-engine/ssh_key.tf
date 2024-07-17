provider "tls" {

}

data "external" "file_exists" {
  program = ["./bash_scripts/check_file_exists.sh", ".${var.private_key_path}"]
  query = {
    path = ".${var.private_key_path}"
  }
}

locals {
  file_exists          = data.external.file_exists.result.exists
  existing_public_key  = local.file_exists ? file(var.public_key_path) : ""
  existing_private_key = local.file_exists ? file(var.private_key_path) : ""
}

resource "tls_private_key" "ssh" {
  count     = local.file_exists ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  count           = local.file_exists ? 0 : 1
  content         = tls_private_key.ssh[0].private_key_pem
  filename        = var.private_key_path
  file_permission = "0600"

  depends_on = [tls_private_key.ssh]
}

resource "local_file" "ssh_public_key_pem" {
  count    = local.file_exists ? 0 : 1
  filename = var.public_key_path
  content  = tls_private_key.ssh[0].public_key_pem

  depends_on = [tls_private_key.ssh]

}

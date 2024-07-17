variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}
variable "subnet_name" {
  type = string
}

variable "virtual_machines" {
  type = list(string)
}
variable "machine_type" {
  type = string
}
variable "os_image" {
  type = string
}
variable "boot_disk_space" {
  type = number
}
variable "secondary_disk_space" {
  type = number
}
variable "internal_ip" {
  type = list(string)
}
variable "allocate_external_ip" {
  type = bool
}
variable "create_additional_disk" {
  type = bool
}
# variable "service_account_email" {
#   type = string
# }
variable "ssh_user" {
  type = string
}
variable "private_key_path" {
  type = string
}
variable "public_key_path" {
  type = string
}

variable "mount_point" {
  type = string
}

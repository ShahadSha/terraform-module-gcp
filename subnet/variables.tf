variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}
variable "vpc_name" {
  type = string
}

variable "subnets" {
  type = list(object({
    name          = string
    ip_cidr_range = string
  }))
}
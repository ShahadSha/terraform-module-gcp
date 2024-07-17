terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.31.1"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_path)
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}
resource "google_project_service" "cloud_resource_manager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

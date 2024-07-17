terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.31.1"
    }
  }
}
provider "google" {
  credentials = file("/home/sha/Documents/prod1-1f.json")
  project     = var.project_name
  region      = var.region
}

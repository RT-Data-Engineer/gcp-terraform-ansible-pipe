variable "gcp_region" { type = string }
variable "gcp_zone" { type = string }
variable "gcp_project" { type = string }
variable "gcp_auth_file" { type = string }
variable "bucket-name" { type = string }
variable "storage-class" { type = string }

terraform {
  backend "gcs" {
    bucket      = @bucket-name
    prefix      = "greenplum"
  }
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "google_compute_instance" "greenplum" {
  name         = "greenplum"
  machine_type = "e2-standard-2"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

    metadata_startup_script = "ls -la"
    tags = ["open-all-greenplum"]
}

resource "google_compute_firewall" "open-all-greenplum" {
  name    = "default-allow-all-terraform-greenplum"
  network = "default"
  allow {	   
    protocol = "tcp"	    
    ports    = ["80"]
    }  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["open-all-greenplum"]
}

output "greenplum" {
  value = "${google_compute_instance.greenplum.network_interface.0.access_config.0.nat_ip}"
}

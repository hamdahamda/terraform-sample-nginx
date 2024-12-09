# terraform {
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "6.8.0"
#     }
#   }
# }

# provider "google" {
#   project = var.project
#   region  = var.region
#   zone    = var.zone

  
#   credentials = file("C:/Users/Hamda/Downloads/testing.json")
# }

# resource "google_compute_network" "vpc_network" {
#   name = "terraform-network"
# }

# resource "google_compute_firewall" "allow_http_ssh" {
#   name    = "allow-http-ssh"
#   network = google_compute_network.vpc_network.name

#   allow {
#     protocol = "tcp"
#     ports    = ["22", "80"] # SSH dan HTTP
#   }

#   source_ranges = ["0.0.0.0/0"]
# }


# resource "google_compute_instance" "vm_instance" {
#   name         = "terraform-testing"
#   machine_type = "e2-medium" # 2 vCPU, 2 GB RAM
#   zone         = "us-central1-c"
#   tags         = ["web","dev"]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#       size  = 20
#     }
#   }

#   network_interface {
#     network = google_compute_network.vpc_network.self_link

#     access_config {
#       # Mengatur IP ephemeral (dinamis)
#       nat_ip = null
#     }
#   }
# }

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = file("C:/Users/Hamda/Downloads/testing.json")
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"] # SSH dan HTTP
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-testing"
  machine_type = "e2-medium" # 2 vCPU, 2 GB RAM
  zone         = "us-central1-c"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link

    access_config {
      # Mengatur IP ephemeral (dinamis)
      nat_ip = null
    }
  }

  metadata = {
    # BARIS BARU: Menambahkan startup script untuk pull image NGINX
    startup-script = <<-EOT
      #!/bin/bash
      sudo apt update -y
      sudo apt install -y docker.io
      sudo systemctl start docker
      sudo docker run -d -p 80:80 nginx
    EOT
  }
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "seymour-family"

    workspaces {
      name = "terraform-nextcloud"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_ssh_keys" "keys" {}

resource "digitalocean_vpc" "nextcloud" {
  name     = "nextcloud-sfo3"
  region   = "sfo3"
  ip_range = "10.0.0.0/24"
}

# resource "digitalocean_droplet" "nextcloud" {
#   image              = "debian-10-x64"
#   name               = "nextcloud-${digitalocean_vpc.nextcloud.region}-1"
#   region             = digitalocean_vpc.nextcloud.region
#   size               = "s-2vcpu-4gb"
#   vpc_uuid           = digitalocean_vpc.nextcloud.id
#   monitoring         = true
#   private_networking = true
#   tags               = ["nextcloud"]
#   ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys[*].id
# }

resource "digitalocean_spaces_bucket" "nextcloud" {
  name   = "cloud-seymour-family"
  region = digitalocean_vpc.nextcloud.region
}

resource "digitalocean_project" "nextcloud" {
  name        = "nextcloud"
  description = "Project for Seymour family nextcloud resources"
  purpose     = "Web Application"
  environment = "Production"
  resources = [
    # digitalocean_droplet.nextcloud.urn,
    digitalocean_spaces_bucket.nextcloud.urn
  ]
}

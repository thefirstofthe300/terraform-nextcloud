data "digitalocean_ssh_keys" "keys" {}

resource "digitalocean_vpc" "nextcloud" {
  name     = "home-sfo3"
  region   = "sfo3"
  ip_range = "10.0.0.0/16"
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

resource "digitalocean_project" "family" {
  name        = "Family"
  description = "Project for Seymour family self-hosting resources"
  purpose     = "Web Application"
  environment = "Production"
  resources = [
    digitalocean_droplet.paperless.urn,
    digitalocean_droplet.gateway_vpn.urn,
    digitalocean_spaces_bucket.nextcloud.urn
  ]
}

resource "digitalocean_droplet" "paperless" {
  image              = "debian-10-x64"
  name               = "paperless-${digitalocean_vpc.nextcloud.region}-1"
  region             = digitalocean_vpc.nextcloud.region
  size               = "s-1vcpu-1gb"
  vpc_uuid           = digitalocean_vpc.nextcloud.id
  monitoring         = true
  private_networking = true
  tags               = ["paperless"]
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys[*].id
  user_data          = file("${path.module}/files/routes/cloud-init.yaml")
}

resource "digitalocean_droplet" "gateway_vpn" {
  image              = "debian-10-x64"
  name               = "gateway-${digitalocean_vpc.nextcloud.region}-1"
  region             = digitalocean_vpc.nextcloud.region
  size               = "s-1vcpu-1gb"
  vpc_uuid           = digitalocean_vpc.nextcloud.id
  monitoring         = true
  private_networking = true
  tags               = ["gateway"]
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys[*].id
  user_data          = templatefile("${path.module}/files/gateway/cloud-init.yaml", {
    droplet_subnet = digitalocean_vpc.nextcloud.ip_range,
    home_ip = var.home_ip,
    home_subnet = var.home_subnet,
    vpn_secret = var.vpn_secret
  })
}

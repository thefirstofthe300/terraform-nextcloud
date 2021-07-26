resource "digitalocean_droplet" "gateway_vpn" {
  image              = var.droplet_image
  name               = "gateway-${var.region}-1"
  region             = var.region
  size               = "s-1vcpu-1gb"
  vpc_uuid           = digitalocean_vpc.home.id
  monitoring         = true
  private_networking = true
  tags               = ["gateway"]
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys[*].id
  user_data = templatefile("${path.module}/files/gateway/cloud-init.yaml", {
    droplet_subnet = digitalocean_vpc.home.ip_range,
    home_ip        = var.home_ip,
    home_subnet    = var.home_subnet,
    vpn_secret     = var.vpn_secret
  })
}

resource "digitalocean_droplet" "paperless" {
  image              = var.droplet_image
  name               = "paperless-${var.region}-1"
  region             = var.region
  size               = "s-1vcpu-1gb"
  vpc_uuid           = digitalocean_vpc.home.id
  monitoring         = true
  private_networking = true
  tags               = ["paperless"]
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys[*].id
  user_data = templatefile("${path.module}/files/routes/cloud-init.yaml", {
    gateway_ip = digitalocean_droplet.gateway_vpn.ipv4_address_private
  })
}

resource "digitalocean_droplet" "nextcloud" {
  image              = var.droplet_image
  name               = "nextcloud-${var.region}-1"
  region             = var.region
  size               = "s-2vcpu-4gb"
  vpc_uuid           = digitalocean_vpc.home.id
  monitoring         = true
  private_networking = true
  tags               = ["nextcloud"]
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys[*].id
  user_data = templatefile("${path.module}/files/routes/cloud-init.yaml", {
    gateway_ip = digitalocean_droplet.gateway_vpn.ipv4_address_private
  })
}
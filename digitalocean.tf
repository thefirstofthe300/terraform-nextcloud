data "digitalocean_ssh_keys" "keys" {}

resource "digitalocean_project" "family" {
  name        = "Family"
  description = "Project for Seymour family self-hosting resources"
  purpose     = "Web Application"
  environment = "Production"
  resources = [
    digitalocean_droplet.paperless.urn,
    digitalocean_droplet.gateway_vpn.urn,
  ]
}

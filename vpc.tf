resource "digitalocean_vpc" "home" {
  name     = "home"
  region   = var.region
  ip_range = "10.0.0.0/16"
}

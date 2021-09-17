resource "cloudflare_zone" "seymour_family" {
  zone = "seymour.family"
}

resource "cloudflare_zone_dnssec" "seymour_family" {
  zone_id = cloudflare_zone.seymour_family.id
}

resource "cloudflare_record" "paperless" {
  zone_id = cloudflare_zone.seymour_family.id
  name    = "paperless"
  value   = digitalocean_droplet.paperless.ipv4_address
  type    = "A"
  ttl     = 300
}

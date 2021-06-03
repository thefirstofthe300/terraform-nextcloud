resource cloudflare_zone seymour_family {
    zone = "seymour.family"
}

resource cloudflare_zone_dnssec seymour_family {
    zone_id = cloudflare_zone.seymour_family.id
}

# resource "cloudflare_record" "nextcloud" {
#   zone_id = cloudflare_zone.seymour_family.id
#   name    = "cloud"
#   value   = digitalocean_droplet.nextcloud.ipv4_address
#   type    = "A"
#   ttl     = 300
# }

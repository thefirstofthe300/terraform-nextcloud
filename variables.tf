variable "region" {
  type    = string
  default = "sfo3"
}

variable "home_ip" {
  type = string
}

variable "home_subnet" {
  type = string
}

variable "vpn_secret" {
  sensitive = true
}

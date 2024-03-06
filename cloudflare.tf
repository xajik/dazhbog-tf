data "http" "cloudflare_ipv4" {
  url = "https://www.cloudflare.com/ips-v4"
}

data "http" "cloudflare_ipv6" {
  url = "https://www.cloudflare.com/ips-v6"
}

locals {
  cloudflare_ipv4_cidr_blocks = [for cidr_block in split("\n", trimspace(data.http.cloudflare_ipv4.response_body)) : cidr_block]
  cloudflare_ipv6_cidr_blocks = [for cidr_block in split("\n", trimspace(data.http.cloudflare_ipv6.response_body)) : cidr_block]
}
data "http" "host-external-ip" {
    url = "http://ipv4.icanhazip.com"
}

locals {
    host_external_cidr = "${chomp(data.http.host-external-ip.body)}/32"
}
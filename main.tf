terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.16.0"
    }
  }
}

provider "linode" {
  token = var.token
}

resource "linode_instance" "grafana" {
  image           = "linode/debian10"
  label           = "grafana"
  group           = "Terraform"
  region          = var.region
  type            = "g6-standard-1"
  authorized_keys = [var.authorized_keys]
  root_pass       = var.root_pass
  tags            = ["work"]
}

resource "linode_domain" "hegedus_wtf" {
  type = "master"
  domain = "hegedus.wtf"
  soa_email = var.soa_email
}

resource "linode_domain_record" "grafana" {
  domain_id = linode_domain.hegedus_wtf.id
  name = linode_instance.grafana.label
  target = linode_instance.grafana.ip_address
  record_type = "A"
}
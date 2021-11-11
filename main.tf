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

resource "linode_domain" "hegedus_wtf" {
  type      = "master"
  domain    = "hegedus.wtf"
  soa_email = var.soa_email
}

resource "linode_instance" "grafana" {
  count           = 1
  image           = "linode/debian10"
  label           = "grafana${count.index + 1}.hegedus.wtf"
  group           = "grafana"
  region          = var.region
  type            = "g6-standard-1"
  authorized_keys = [var.authorized_keys]
  root_pass       = var.root_pass
  tags            = ["work"]
}

resource "linode_domain_record" "grafana" {
  count       = length(linode_instance.grafana)
  domain_id   = linode_domain.hegedus_wtf.id
  name        = trimsuffix(linode_instance.grafana[count.index].label, ".${linode_domain.hegedus_wtf.domain}")
  target      = linode_instance.grafana[count.index].ip_address
  record_type = "A"
}

resource "linode_rdns" "grafana" {
  count = length(linode_instance.grafana)
  address = linode_instance.grafana[count.index].ip_address
  rdns = linode_instance.grafana[count.index].label
}

resource "linode_instance" "githubrunner" {
  count           = 1
  image           = "linode/debian10"
  label           = "githubrunner${count.index + 1}.hegedus.wtf"
  group           = "githubrunner"
  region          = var.region
  type            = "g6-standard-1"
  authorized_keys = [var.authorized_keys]
  root_pass       = var.root_pass
  tags            = ["work"]
}

resource "linode_domain_record" "githubrunner" {
  count       = length(linode_instance.githubrunner)
  domain_id   = linode_domain.hegedus_wtf.id
  name        = trimsuffix(linode_instance.githubrunner[count.index].label, ".${linode_domain.hegedus_wtf.domain}")
  target      = linode_instance.githubrunner[count.index].ip_address
  record_type = "A"
}

resource "linode_rdns" "githubrunner" {
  count = length(linode_instance.githubrunner)
  address = linode_instance.githubrunner[count.index].ip_address
  rdns = linode_instance.githubrunner[count.index].label
}
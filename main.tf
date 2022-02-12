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

resource "linode_instance" "k3s_server" {
  count           = 1
  image           = "linode/debian11"
  label           = "k3s-server${count.index + 1}.hegedus.wtf"
  group           = "k3s"
  region          = var.region
  type            = "g6-standard-1"
  authorized_keys = [var.authorized_keys]
  root_pass       = var.root_pass
  tags            = ["work"]
}

resource "linode_domain_record" "k3s_server" {
  count       = length(linode_instance.k3s_server)
  domain_id   = linode_domain.hegedus_wtf.id
  name        = trimsuffix(linode_instance.k3s_server[count.index].label, ".${linode_domain.hegedus_wtf.domain}")
  target      = linode_instance.k3s_server[count.index].ip_address
  record_type = "A"
}

resource "linode_rdns" "k3s_server" {
  count = length(linode_instance.k3s_server)
  address = linode_instance.k3s_server[count.index].ip_address
  rdns = linode_instance.k3s_server[count.index].label
}

resource "linode_instance" "k3s_agent" {
  count           = 2
  image           = "linode/debian11"
  label           = "k3s-agent${count.index + 1}.hegedus.wtf"
  group           = "k3s-agents"
  region          = var.region
  type            = "g6-standard-2"
  authorized_keys = [var.authorized_keys]
  root_pass       = var.root_pass
  tags            = ["work"]
}

resource "linode_domain_record" "k3s_agent" {
  count       = length(linode_instance.k3s_agent)
  domain_id   = linode_domain.hegedus_wtf.id
  name        = trimsuffix(linode_instance.k3s_agent[count.index].label, ".${linode_domain.hegedus_wtf.domain}")
  target      = linode_instance.k3s_agent[count.index].ip_address
  record_type = "A"
}

resource "linode_rdns" "k3s_agent" {
  count = length(linode_instance.k3s_agent)
  address = linode_instance.k3s_agent[count.index].ip_address
  rdns = linode_instance.k3s_agent[count.index].label
}

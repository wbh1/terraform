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

resource "linode_instance" "ghost" {
  label             = "wbhegedus.me"
  region            = var.region
  tags = [
    "personal",
    "blog"
  ]
  type = "g6-nanode-1"

  config {
    kernel       = "linode/grub2"
    label        = "My Debian 10 Disk Profile"
    memory_limit = 0
    root_device  = "/dev/sda"
    run_level    = "default"
    virt_mode    = "paravirt"

    devices {
      sda {
        disk_label = "Debian 10 Disk"
        volume_id  = 0
      }

      sdb {
        disk_label = "512 MB Swap Image"
        volume_id  = 0
      }
    }
  }

  disk {
    filesystem = "ext4"
    label      = "Debian 10 Disk"
    read_only  = false
    size       = 25088
  }
  disk {
    filesystem = "swap"
    label      = "512 MB Swap Image"
    read_only  = false
    size       = 512
  }

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
  count   = length(linode_instance.k3s_server)
  address = linode_instance.k3s_server[count.index].ip_address
  rdns    = linode_instance.k3s_server[count.index].label
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
  count   = length(linode_instance.k3s_agent)
  address = linode_instance.k3s_agent[count.index].ip_address
  rdns    = linode_instance.k3s_agent[count.index].label
}

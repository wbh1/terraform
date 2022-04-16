terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.26.1"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_lke_cluster" "flux-test" {
  label       = "flux-test"
  k8s_version = "1.22"
  region      = "us-east"
  tags        = ["work", "test"]

  pool {
    type  = "g6-standard-2"
    count = 3
  }
}

resource "local_file" "flux-test-kubeconfig" {
  filename             = "/Users/whegedus/.kube/config-flux-test"
  content_base64       = linode_lke_cluster.flux-test.kubeconfig
  file_permission      = "0600"
  directory_permission = "0755"
}

output "kubeconfig" {
  value = local_file.flux-test-kubeconfig.filename
}

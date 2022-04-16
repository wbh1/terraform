terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.26.1"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.12.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

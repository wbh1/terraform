variable "token" {}
variable "authorized_keys" {}
variable "root_pass" {}
variable "region" {
  default = "us-east"
}
variable "soa_email" {}

variable "github_owner" {
  type        = string
  description = "github owner"
  default     = "wbh1"
}

variable "github_token" {
  type        = string
  description = "github token"
}

variable "github_deploy_key_title" {
  type        = string
  description = "Name of Github Deploy Key"
  default = "flux"
}

variable "repository_name" {
  type        = string
  default     = "flux-infra"
  description = "github repository name"
}

variable "repository_visibility" {
  type        = string
  default     = "private"
  description = "How visible is the github repo"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"
}

variable "target_path" {
  type        = string
  default     = "staging-cluster"
  description = "flux sync target path"
}

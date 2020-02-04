variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "cluster"
}

variable "iam_profile_prefix" {
  type = string
  default = "k8sProfile"
}

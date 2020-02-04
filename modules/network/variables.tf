variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "cluster"
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(map(string))
}

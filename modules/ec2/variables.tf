variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "cluster"
}

variable "num_instances" {
  type = number
  default = 1
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3a.small"
}

variable "subnets" {
  type = set(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "enable_monitoring" {
  type = bool
  default = false
}

variable "ebs_optimized" {
  type = bool
  default = true
}

variable "root_volume_type" {
  type = string
  default = "gp2"
}

variable "root_volume_size_gb" {
  type = number
  default = 8
}

variable "root_volume_encrypted" {
  type = bool
  default = false
}

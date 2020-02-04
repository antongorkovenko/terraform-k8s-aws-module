variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "k8s-cluster"
}

variable "iam_profile_prefix" {
  type = string
  default = "k8s"
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = set(map(string))
}

variable "master_ami_id" {
  type = string
}

variable "master_instance_type" {
  type = string
  default = "t3a.medium"
}

variable "master_subnets" {
  type = set(string)
}

variable "master_root_volume_size_gb" {
  type = number
  default = 15
}

variable "worker_ami_id" {
  type = string
}

variable "worker_instance_type" {
  type = string
  default = "t3a.large"
}

variable "worker_asg_min" {
  type = number
  default = 3
}

variable "worker_asg_max" {
  type = number
  default = 3
}

variable "worker_asg_desired_capacity" {
  type = number
  default = 3
}

variable "worker_root_volume_device_name" {
  type = string
  default = "/dev/xvda"
}

variable "worker_root_volume_size_gb" {
  type = number
  default = 15
}

variable "worker_subnets" {
  type = set(string)
}

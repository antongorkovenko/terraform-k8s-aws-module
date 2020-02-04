variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "cluster"
}

variable "group_name" {
  type = string
  default = "cluster-asg"
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = set(string)
}

variable "min_size" {
  type = number
  default = 1
}

variable "max_size" {
  type = number
  default = 1
}

variable "desired_capacity" {
  type = number
  default = 1
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3a.medium"
}

variable "iam_instance_profile_arn" {
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

variable "root_volume_device_name" {
  type = string
  default = "/dev/xvda"
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

variable "use_spot_instances" {
  type = bool
  default = true
}

//variable "on_demand_percentage_above_base_capacity" {
//  default = 0
//}
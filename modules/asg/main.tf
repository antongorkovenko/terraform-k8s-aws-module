provider "aws" {
  region = var.region
}

data "aws_subnet_ids" "selected" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = var.subnets
  }
}

// Name                        = {var.group_name}-launch-template
// AMI ID                      = {var.ami_id}
// Instance type               = {var.instance_type}
// Key pair name               = none
// Network type                = VPC
// Security Groups             = don't include
// IAM instance profile        = {var.iam_instance_profile_arn}
// Purchasing option: use spot = {var.use_spot_instances}
// Monitoring                  = {var.enable_monitoring}
// Storage:
//   Device name               = {var.root_volume_device_name}
//   Volume type               = {var.root_volume_type}
//   Size(GiB)                 = {var.root_volume_size_gb}
//   Encryption                = {var.root_volume_encrypted}
resource "aws_launch_template" "node" {
  name          = join("-", [var.group_name, "launch-template"])
  image_id      = var.ami_id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = var.root_volume_device_name

    ebs {
      volume_size = var.root_volume_size_gb
      volume_type = var.root_volume_type
      encrypted = var.root_volume_encrypted
    }
  }

  instance_market_options {
    market_type = var.use_spot_instances ? "spot" : ""
  }

  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

  monitoring {
    enabled = var.enable_monitoring
  }
}

// Group name                = {var.group_name}
// Launch Template           = from "aws_launch_template"."node"
// Launch Template Version   = Latest
// Fleet Composition         = Adhere to the launch template
// Group size                = {var.desired_capacity}
// Minimum Group Size        = {var.min_size}
// Maximum Group Size        = {var.max_size}
// Network                   = from subnet
// Subnet                    = {var.subnet_ids}
// Health Check Grace Period = 300
// Health Check Type         = EC2
// Tags:
//   kubernetes.io/cluster/<var.cluster_name>     = "owned"
//   k8s.io/cluster/<var.cluster_name>            = "owned"
//   k8s.io/cluster-autoscaler/enabled            = "owned"
//   k8s.io/cluster-autoscaler/<var.cluster_name> = "owned"
resource "aws_autoscaling_group" "asg" {
  for_each = var.subnets

  name = var.group_name

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = false

  launch_template {
    id      = "${aws_launch_template.node.id}"
    version = "$Latest"
  }

  vpc_zone_identifier = data.aws_subnet_ids.selected[each.key].id

  tag {
    key                 = join("/", ["kubernetes.io", "cluster", var.cluster_name])
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = join("/", ["k8s.io", "cluster", var.cluster_name])
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = join("/", ["k8s.io", "cluster-autoscaler", "enabled"])
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = join("/", ["k8s.io", "cluster-autoscaler", var.cluster_name])
    value               = "owned"
    propagate_at_launch = true
  }
}

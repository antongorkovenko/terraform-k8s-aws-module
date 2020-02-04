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

// AMI ID                = {var.ami_id}
// Instance type         = {var.instance_type}
// Subnet                = {var.vpc_subnet_id}
// Auto-assign Public IP = No
// IAM role              = {var.iam_instance_profile}
// Monitoring            = {var.enable_monitoring}
// EBS Optimized         = {var.ebs_optimized}
// Storage:
//   Type      = {var.root_volume_type}
//   Size      = {var.root_volume_size_gb}
//   Encrypted = {var.root_volume_encrypted}
// Tags:
//   kubernetes.io/cluster/<var.cluster_name> = "owned"
//   k8s.io/cluster/<var.cluster_name>        = "owned"
resource "aws_instance" "ec2" {
  for_each = data.aws_subnet_ids.selected.ids

  ami = var.ami_id
  instance_type = var.instance_type

//  count = var.num_instances

  monitoring = var.enable_monitoring

  ebs_optimized = var.ebs_optimized
  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size_gb
    encrypted = var.root_volume_encrypted
  }

  subnet_id = each.value
  associate_public_ip_address = false

  iam_instance_profile = var.iam_instance_profile

  tags = map(
    join("/", ["kubernetes.io", "cluster", var.cluster_name]), "owned",
    join("/", ["k8s.io", "cluster", var.cluster_name]), "owned"
  )
}

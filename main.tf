provider "aws" {
  region = var.region
}

module "iam_profile" {
  source = "./modules/iam_profile"

  region = var.region
  iam_profile_prefix = var.iam_profile_prefix
}

module "subnet" {
  source = "./modules/network"

  region = var.region
  cluster_name = var.cluster_name
  vpc_id = var.vpc_id
  subnets = var.subnets
}

module "master_instance" {
  source = "./modules/ec2"

  //instance_name = join("-", [var.cluster_name, "master"])

  ami_id = var.master_ami_id
  instance_type = var.master_instance_type
  iam_instance_profile = module.iam_profile.master_profile_name
  subnets = var.master_subnets

  region = var.region
  vpc_id = var.vpc_id

  root_volume_size_gb = var.master_root_volume_size_gb
}

module "worker_asg" {
  source = "./modules/asg"

  cluster_name = var.cluster_name
  group_name = join("-", [var.cluster_name, "worker"])

  min_size         = var.worker_asg_min
  max_size         = var.worker_asg_max
  desired_capacity = var.worker_asg_desired_capacity

  region = var.region
  vpc_id = var.vpc_id
  subnets = var.worker_subnets

  ami_id = var.worker_ami_id
  instance_type = var.worker_instance_type
  use_spot_instances = true
  iam_instance_profile_arn = module.iam_profile.worker_role_arn

  root_volume_device_name = var.worker_root_volume_device_name
  root_volume_size_gb = var.worker_root_volume_size_gb
}

# terraform-k8s-aws

Terraform module to provision infra for kubernetes in AWS cloud

| Name | Description | Default |
|------|-------------|:-------:|
| region | Region to create cluster in | us-west-1 |
| cluster_name | Cluster name | k8s-cluster |
| iam_profile_prefix | Prefix for IAM entities | k8s |
| vpc_id | VPC to create cluster in | |
| subnet_az | Availability zone to create subnet in | us-west-1a |
| subnet_cidr | CIDR for cluster subnet | 10.0.0.0/16 |
| master_ami_id | AMI id for master instances (pre-created) | |
| master_instance_type | Master instance type | t3a.medium |
| master_num_instances | Number of master instances | 1 |
| worker_ami_id | AMI id for worker instances (pre-created) | |
| worker_instance_type | Worker instance type | t3a.large |
| worker_asg_min | Worker autoscale group: min number | 3 |
| worker_asg_max | Worker autoscale group: max number | 3 |
| worker_asg_desired_capacity | Worker autoscale group: initial number | 3 |

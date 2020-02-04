provider "aws" {
  region = var.region
}

// VPC                             = {var.vpc_id}
// IPv4 CIDR                       = {var.subnet_cidr}
// Availability Zone               = {var.subnet_az}
// Auto-assign public IPv4 address = No
// Auto-assign IPv6 address        = No
// Tags:
//   Name                                     = {var.subnet_name}
//   kubernetes.io/cluster/<var.cluster_name> = "owned"
//   k8s.io/cluster/<var.cluster_name>        = "owned"
resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id     = var.vpc_id

  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = map(
    "Name", each.value.name,
    join("/", ["kubernetes.io", "cluster", var.cluster_name]), "owned",
    join("/", ["k8s.io", "cluster", var.cluster_name]), "owned"
  )
}

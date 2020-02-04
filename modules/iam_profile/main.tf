provider "aws" {
  region = var.region
}

resource "aws_iam_instance_profile" "master_iam_profile" {
  name = join("", [var.iam_profile_prefix, "MasterProfile"])
  role = "${aws_iam_role.master_iam_role.name}"
}

resource "aws_iam_instance_profile" "worker_iam_profile" {
  name = join("", [var.iam_profile_prefix, "WorkerProfile"])
  role = "${aws_iam_role.worker_iam_role.name}"
}

resource "aws_iam_role" "master_iam_role" {
  name = join("", [var.iam_profile_prefix, "MasterRole"])

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "worker_iam_role" {
  name = join("", [var.iam_profile_prefix, "WorkerRole"])

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "master_base_iam_policy_attachment" {
  policy_arn = "${aws_iam_policy.master_base_iam_policy.arn}"
  role = "${aws_iam_role.master_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "master_lb_iam_policy_attachment" {
  policy_arn = "${aws_iam_policy.loadbalancer_manager_iam_policy.arn}"
  role = "${aws_iam_role.master_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "master_as_iam_policy_attachment" {
  policy_arn = "${aws_iam_policy.autoscaling_iam_policy.arn}"
  role = "${aws_iam_role.master_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "master_pv_iam_policy_attachment" {
  policy_arn = "${aws_iam_policy.pv_manager_iam_policy.arn}"
  role = "${aws_iam_role.master_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "master_network_iam_policy_attachment" {
  policy_arn = "${aws_iam_policy.cni_network_iam_policy.arn}"
  role = "${aws_iam_role.master_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "worker_base_iam_policy_attachment" {
  policy_arn = "${aws_iam_policy.worker_base_iam_policy.arn}"
  role = "${aws_iam_role.worker_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "worker_network_iam_role_policy_attachment" {
  policy_arn = "${aws_iam_policy.cni_network_iam_policy.arn}"
  role = "${aws_iam_role.worker_iam_role.name}"
}

resource "aws_iam_policy" "master_base_iam_policy" {
  name = join("", [var.iam_profile_prefix, "MasterBasePolicy"])

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:CreateTags",
        "ec2:DescribeAccountAttributes",
        "ec2:ModifyInstanceAttribute"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcs",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeRouteTables",
        "ec2:DescribeInternetGateways",
        "ec2:CreateSecurityGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateRoute",
        "ec2:DeleteRoute",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/kubernetes.io/cluster/${var.cluster_name}": "owned"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "loadbalancer_manager_iam_policy" {
  name = join("", [var.iam_profile_prefix, "LBManagerRolePolicy"])

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcs",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "pv_manager_iam_policy" {
  name = join("", [var.iam_profile_prefix, "PVManagerRolePolicy"])

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumesModifications",
        "ec2:CreateVolume",
        "ec2:ModifyVolume"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:DeleteVolume",
        "ec2:DetachVolume"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/kubernetes.io/cluster/${var.cluster_name}": "owned"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "autoscaling_iam_policy" {
  name = join("", [var.iam_profile_prefix, "AutoscalingPolicy"])

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "worker_base_iam_policy" {
  name = join("", [var.iam_profile_prefix, "WorkerBasePolicy"])

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cni_network_iam_policy" {
  name = join("", [var.iam_profile_prefix, "CNINetworkingPolicy"])

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DetachNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:CreateTags",
      "Resource": "arn:aws:ec2:*:*:network-interface/*"
    }
  ]
}
EOF
}

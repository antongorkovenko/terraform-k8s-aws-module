output "master_profile_arn" {
  value = aws_iam_instance_profile.master_iam_profile.arn
}

output "worker_profile_arn" {
  value = aws_iam_instance_profile.worker_iam_profile.arn
}

output "master_profile_name" {
  value = aws_iam_instance_profile.master_iam_profile.name
}

output "worker_profile_name" {
  value = aws_iam_instance_profile.worker_iam_profile.name
}

output "master_role_arn" {
  value = aws_iam_role.master_iam_role.arn
}

output "worker_role_arn" {
  value = aws_iam_role.worker_iam_role.arn
}

output "master_role_name" {
  value = aws_iam_role.master_iam_role.name
}

output "worker_role_name" {
  value = aws_iam_role.worker_iam_role.name
}

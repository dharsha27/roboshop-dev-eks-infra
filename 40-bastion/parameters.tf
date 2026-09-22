resource "aws_ssm_parameter" "bastion_iam_role_arn" {
  name  = "/${var.project}/${var.environment}/bastion_iam_role_arn"
  type  = "String"
  value = aws_iam_role.bastion.arn
  overwrite = true
}

resource "aws_ssm_parameter" "runner_iam_role_arn" {
  name  = "/${var.project}/${var.environment}/runner_iam_role_arn"
  type  = "String"
  value = aws_iam_role.runner.arn
  overwrite = true
}
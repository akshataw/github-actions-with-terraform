resource "aws_ssm_parameter" "endpoint" {
  name        = "/database/${var.name}/endpoint"
  description = "Endpoint to connect to the ${var.name} database"
  type        = "SecureString"
  value       = aws_rds_cluster.default.endpoint
}

resource "aws_ssm_parameter" "user" {
  name        = "/database/${var.name}/user"
  description = "User of the ${var.name} database"
  type        = "SecureString"
  value       = var.user
}

resource "aws_ssm_parameter" "password" {
  name        = "/database/${var.name}/password"
  description = "Password to the ${var.name} database"
  type        = "SecureString"
  value       = var.password
}

resource "aws_ssm_parameter" "name" {
  name        = "/database/${var.name}/name"
  description = "Name of the ${var.name} database"
  type        = "SecureString"
  value       = var.name
}
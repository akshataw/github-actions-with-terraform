provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "remote" {
        organization = "example-organization"
        workspaces {
            name = "example-workspace"
        }
    }
}

resource "aws_rds_cluster" "default" {
    cluster_identifier = "pokemon-database"
    engine = "aurora-mysql"
    engine_mode = "serverless"
    availability_zones = ["us-east-1a", "us-east-1b"]
    database_name = var.name
    master_username = var.user
    master_password = var.password
    backup_retention_period = 1
    enable_http_endpoint = true
    skip_final_snapshot = false
}

variable "name" {
  default = "pokemondb"
  sensitive = true
}

variable "user" {
  default = "admin"
  sensitive = true
}

variable "password" {
  default = "abcd1234"
  sensitive = true
}
provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "remote" {
        organization = "example-organization"
        workspaces {
            name = "example-workspace"
        }
        token = "1mcVbnEYdqXJuw.atlasv1.4VIgdoXO60yADLHj0kubN0ySOYq17CsiWaAyy31L9i7wgwZc5hKTK9a3vJM2jznoy0s"
    }
}

resource "aws_rds_cluster" "default" {
    cluster_identifier = "pokemon-database1"
    engine = "aurora-mysql"
    engine_mode = "serverless"
    availability_zones = ["us-east-1a", "us-east-1b"]
    database_name = var.name
    master_username = var.user
    master_password = var.password
    backup_retention_period = 1
    enable_http_endpoint = true
    skip_final_snapshot = true

    lifecycle {
      ignore_changes = [
        cluster_identifier,
        cluster_identifier_prefix,
        availability_zones,
      ]
    }
}

resource "aws_security_group" "ci-sg" {
    name = "ci-sg"
    description = "Allow TLS inbound traffic for CI/CD Demo"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["172.31.0.0/16"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

variable "name" {
  default = ""
}

variable "user" {
  default = ""
}

variable "password" {
  default = ""
}
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

    scaling_configuration {
      auto_pause               = true
      max_capacity             = 1
      min_capacity             = 1
      seconds_until_auto_pause = 300
    }

    db_subnet_group_name    = module.vpc.database_subnet_group
    vpc_security_group_ids  = [aws_security_group.ci-sg.id]

    lifecycle {
      ignore_changes = [
        cluster_identifier,
        cluster_identifier_prefix,
        availability_zones,
      ]
    }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "cicd-vpc"
  cidr = "10.0.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  private_subnets = []
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  create_database_subnet_group = true
  create_database_subnet_route_table = true
  create_database_internet_gateway_route = true
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "ci-sg" {
    name = "ci-sg"
    description = "Allow TLS inbound traffic for CI/CD Demo"
    vpc_id = module.vpc.default_vpc_id
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "ci-sg"
    }

    lifecycle {
      ignore_changes = [
        tags,
      ]
    }
}


resource "aws_s3_bucket" "awcibucket1" {
  bucket = "awcibucket1"
  acl = "private"
  force_destroy = true
  tags = {
    Name = "My CI/CD Bucket"
    Environment = "Dev"
  }
  lifecycle {
      ignore_changes = [
        bucket,
        bucket_prefix,
        tags,
      ]
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
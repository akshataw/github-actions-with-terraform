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

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mycicddb"
  username             = var.user
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_rds_cluster" "default" {
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

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "cd-sg" {
    name = "cd-sg"
    description = "Allow TLS inbound traffic for CD Demo"
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
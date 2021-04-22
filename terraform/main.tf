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
terraform {
  # Terraform version
  required_version = ">=1.1.0"

  # Provider versions
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.7.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}
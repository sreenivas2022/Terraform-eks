terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

 /# assume_role {
   # role_arn = var.role_arn
  #}

  default_tags {
    tags = {
      Environment  = var.environment
      Created_By   = var.created_by
      Created_Date = var.created_date
      Project      = var.project
    }
  }
}
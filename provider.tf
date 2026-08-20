terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }

        random = {
            source  = "hashicorp/random"
            version = "~> 3.0"
        }
    }

    backend "s3" {
    bucket         = "project-letz-go-tfstate"
    key            = "project01-infra-automation/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile = true
    encrypt        = true
    }
}

provider "aws" {
    region = "ap-south-1"
}
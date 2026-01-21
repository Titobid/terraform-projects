terraform {
  required_version = "~> 1.7"

  backend "s3" {
    bucket = "example-bucket-1e2bb2d4c938"
    region = "ca-central-1"
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}

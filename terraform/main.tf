terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "donkey"
  region  = "eu-west-2"
}


data "aws_availability_zones" available {
  state = "available"
}


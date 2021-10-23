provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "ubuntus3bucket1212"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "javahome-tf"
  }
}


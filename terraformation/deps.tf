provider "aws" {
    region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "jamie-yetanother-tf"
    key    = "asg/tfstate"
    region = "eu-west-1"
  }
}

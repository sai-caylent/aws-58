terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Sai"
      Project     = "F45"
    }
  }
}

data "aws_region" "primary" {}

provider "aws" {
  alias  = "alternate_region"
  region = "us-east-1"
}
data "aws_region" "alternate" {
  provider = aws.alternate_region
}

output "primary" {
  value = data.aws_region.primary.name

}
output "alternate" {
  value = data.aws_region.alternate.name

}
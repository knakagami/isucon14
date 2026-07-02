terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  # splunk-on-eks と同じ state バケット・ロックテーブルを共有（key のみ分離）
  backend "s3" {
    bucket         = "splunk-prod-tfstate-124593756704"
    key            = "isucon-splunk/lab/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    profile        = "SPLKAdministratorAccess-124593756704"
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "SPLKAdministratorAccess-124593756704"
}

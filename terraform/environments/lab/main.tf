locals {
  project_name = "isucon-splunk-o11y"
  region       = "us-east-2"

  # splunk-on-eks (environments/prod) と同じ既存 VPC
  vpc_id = "vpc-0fc32cd1d32cd27e8"

  public_subnet_ids = [
    "subnet-0ac0ec588acf31b4c", # us-east-2a
    "subnet-05d97e7ef9810bb23", # us-east-2b
    "subnet-06ce40d1161fe69de", # us-east-2c
  ]

  # 既存キーペア (us-east-2)
  key_name = "splunk_aws_key"

  # SSM 接続用（Ansible / 運用）
  iam_instance_profile = "its-prd-gso-ssm-minimal-instance-profile"

  # 空のままなら SSH は閉じ、SSM Session Manager を使用
  ssh_allowed_cidrs = []

  common_tags = {
    Project                      = local.project_name
    Environment                  = "lab"
    ManagedBy                    = "terraform"
    splunkit_data_classification = "public"
    splunkit_environment_type    = "non-prd"
  }

  bootstrap_user_data = file("${path.module}/../../../splunk/scripts/instance-bootstrap.sh")
}

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "isucon_ec2" {
  source = "../../modules/isucon-ec2"

  project_name         = local.project_name
  vpc_id               = local.vpc_id
  public_subnet_ids    = local.public_subnet_ids
  ami_id               = data.aws_ami.ubuntu_2404.id
  key_name             = local.key_name
  iam_instance_profile = local.iam_instance_profile
  ssh_allowed_cidrs    = local.ssh_allowed_cidrs
  bootstrap_user_data  = local.bootstrap_user_data
  tags                 = local.common_tags

  instances = {
    app-1 = {
      role          = "app"
      instance_type = "c5.large"
      subnet_index  = 0
    }
    app-2 = {
      role          = "app"
      instance_type = "c5.large"
      subnet_index  = 1
    }
    app-3 = {
      role          = "app"
      instance_type = "c5.large"
      subnet_index  = 2
    }
    db-1 = {
      role          = "db"
      instance_type = "c5.large"
      subnet_index  = 0
    }
    bench-1 = {
      role          = "bench"
      instance_type = "c5.xlarge"
      subnet_index  = 1
    }
  }
}

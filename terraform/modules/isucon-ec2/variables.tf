variable "project_name" {
  type        = string
  description = "プロジェクト名（タグ・SG 名に使用）"
}

variable "vpc_id" {
  type        = string
  description = "既存 VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "パブリックサブネット ID 一覧"
}

variable "ami_id" {
  type        = string
  description = "EC2 AMI ID"
}

variable "key_name" {
  type        = string
  description = "SSH キーペア名"
}

variable "iam_instance_profile" {
  type        = string
  description = "SSM 等に使用する IAM instance profile 名"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "SSH(22) を許可する CIDR 一覧。空なら SSH インバウンドなし（SSM 推奨）"
  default     = []
}

variable "bootstrap_user_data" {
  type        = string
  description = "全インスタンス共通の cloud-init user data"
}

variable "root_volume_size_gb" {
  type        = number
  description = "ルート EBS サイズ (GiB)"
  default     = 20
}

variable "tags" {
  type        = map(string)
  description = "全リソースに付与する共通タグ"
  default     = {}
}

variable "instances" {
  type = map(object({
    role          = string
    instance_type = string
    subnet_index  = number
  }))
  description = "起動する EC2 インスタンス定義"
}

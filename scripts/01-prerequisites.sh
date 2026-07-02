#!/usr/bin/env bash
set -euo pipefail

echo "=== ISUCON Splunk: 前提条件確認 ==="
echo ""
echo "splunk-on-eks と同じ Terraform state バケットを再利用します:"
echo "  bucket: splunk-prod-tfstate-124593756704"
echo "  key:    isucon-splunk/lab/terraform.tfstate"
echo ""
echo "初回のみ、splunk-on-eks の scripts/01-prerequisites.sh で"
echo "バケットと DynamoDB ロックテーブルが作成済みであることを確認してください。"
echo ""

aws --profile SPLKAdministratorAccess-124593756704 sts get-caller-identity
terraform --version

aws --profile SPLKAdministratorAccess-124593756704 s3api head-bucket \
  --bucket splunk-prod-tfstate-124593756704

echo ""
echo "OK。次: scripts/02-deploy-infra.sh"

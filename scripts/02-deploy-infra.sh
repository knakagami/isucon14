#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/../terraform/environments/lab"
PROFILE="SPLKAdministratorAccess-124593756704"

echo "=== Terraform: ISUCON Splunk lab EC2 ==="

aws sso login --profile "$PROFILE" || true

cd "$TERRAFORM_DIR"

echo "--- terraform init ---"
terraform init

echo "--- terraform plan ---"
terraform plan -out=lab.tfplan

echo ""
echo "plan を確認してください。続行しますか？ [y/N]"
read -r CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "中止しました。"
  exit 0
fi

echo "--- terraform apply ---"
terraform apply lab.tfplan

echo ""
echo "--- outputs ---"
terraform output

echo ""
echo "次のステップ:"
echo "  scripts/03-generate-ansible-inventory.sh"
echo "  # その後 provisioning/ansible で playbook 実行（Phase 2）"

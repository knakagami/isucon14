# Terraform: ISUCON14 + Splunk O11y lab

[splunk-on-eks](https://github.com/knakagami/splunk-on-eks) と同じパターンで、**既存 VPC + S3 backend + AWS SSO プロファイル** を使います。

## 構成

| リソース | 内容 |
|---------|------|
| `app-1`〜`app-3` | c5.large（競技者 VM 相当） |
| `db-1` | c5.large（MySQL 専用） |
| `bench-1` | c5.xlarge（ベンチマーカー） |

- **VPC**: `vpc-0fc32cd1d32cd27e8`（o11y-demo-02、splunk-on-eks と同じ）
- **リージョン**: `us-east-2`
- **プロファイル**: `SPLKAdministratorAccess-124593756704`
- **State**: `s3://splunk-prod-tfstate-124593756704/isucon-splunk/lab/terraform.tfstate`

## デプロイ手順（WSL 推奨）

```bash
cd "/mnt/c/Users/knakagam/OneDrive - Cisco/isucon-with-splunk-o11y"

aws sso login --profile SPLKAdministratorAccess-124593756704

bash scripts/01-prerequisites.sh
bash scripts/02-deploy-infra.sh
bash scripts/03-generate-ansible-inventory.sh
```

## SSH

デフォルトでは **SSH 22 は閉じています**（`ssh_allowed_cidrs = []`）。接続は SSM Session Manager を推奨します。

```bash
aws ssm start-session --target <instance-id> --profile SPLKAdministratorAccess-124593756704
```

Ansible で SSH を使う場合は `terraform/environments/lab/main.tf` の `ssh_allowed_cidrs` に自分の IP を追加して `terraform apply` してください。

## 次のステップ

1. `provisioning/ansible` で `application.yml` / `benchmark.yml` を実行
2. `splunk/ansible`（未実装）で Collector + OTel 計装を配布

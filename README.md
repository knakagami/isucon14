# ISUCON14 × Splunk Observability Cloud (Free Edition)

ISUCON14（ISURIDE）に OpenTelemetry Native 計装と Splunk DB Monitoring を追加し、パフォーマンスチューニング体験を Splunk O11y（jp0 フリーエディション）で可視化するための fork リポジトリです。

## 参照

- 上流: [isucon/isucon14](https://github.com/isucon/isucon14)
- Fork: [knakagami/isucon14](https://github.com/knakagami/isucon14)
- [ISUCON14 まとめ](https://isucon.net/archives/58818382.html)
- [問題の解説と講評](https://isucon.net/archives/58869617.html)
- Splunk APM (jp0): https://app.jp0.observability.splunkcloud.com

## Phase 0 状態

| 項目 | 状態 |
|------|------|
| MCP `user-splunk_o11y_free` (jp0) | 接続確認済み |
| GitHub fork | [knakagami/isucon14](https://github.com/knakagami/isucon14) |
| ローカル clone | 本ワークスペース |
| Linux EC2 `dev-1` | **保留** — SCP で `ec2:RunInstances` 拒否。代わりに **WSL2 Ubuntu** を開発端末に使用 |

## インフラ（Terraform）

[splunk-on-eks](https://github.com/knakagami/splunk-on-eks) と同様に、**Terraform で EC2 を起動**し、Ansible で ISUCON + Splunk 設定を流し込みます。

詳細: [`terraform/README.md`](terraform/README.md)

```bash
# WSL
aws sso login --profile SPLKAdministratorAccess-124593756704
bash scripts/02-deploy-infra.sh
bash scripts/03-generate-ansible-inventory.sh
```

| インスタンス | 役割 |
|-------------|------|
| app-1〜3 | nginx + isuride Go |
| db-1 | MySQL + DB Monitoring Collector |
| bench-1 | ベンチマーカー |

## 開発環境

### 推奨: WSL2 Ubuntu + AWS SSO

Corp AWS では新規 EC2 起動が SCP で拒否されるため、**WSL2 を開発端末**とする。

```bash
# WSL からリポジトリへ
cd "/mnt/c/Users/knakagam/OneDrive - Cisco/isucon-with-splunk-o11y"

# AWS（WSL 内で SSO ログイン）
aws sso login --profile SPLKAdministratorAccess-124593756704
aws --profile SPLKAdministratorAccess-124593756704 sts get-caller-identity
```

| ツール | WSL 状態 | Phase 1 前の作業 |
|--------|---------|-----------------|
| Docker | 済 | — |
| AWS CLI + SSO プロファイル | 済 | 必要時 `aws sso login` |
| Go | 1.22.2 | **1.23 に更新** |
| Task | 未 | **インストール** |

Cursor（Windows）で編集、WSL で `task` / `docker` / `aws` を実行するハイブリッド構成。

### Splunk O11y（MCP / jp0）

Cursor MCP `user-splunk_o11y_free` で操作。UI: https://app.jp0.observability.splunkcloud.com

```bash
# 例
SPLUNK_ACCESS_TOKEN=<your-token>
SPLUNK_REALM=jp0
OTEL_EXPORTER_OTLP_ENDPOINT=http://127.0.0.1:4317
OTEL_SERVICE_NAME=isuride
OTEL_RESOURCE_ATTRIBUTES=deployment.environment=isucon14-lab
```

## ローカル起動（ISUCON14 標準）

```bash
task up
task go:run
cd bench && task run-local
```

## ディレクトリ（Splunk 追加分）

```
splunk/
├── collector/     # OTel Collector 設定（Phase 2）
├── ansible/       # 計装デプロイ用（Phase 2）
└── scripts/       # bootstrap 等
docs/
└── blog-notes.md  # ブログ用メモ（Phase 3）
```

## 次のステップ（Phase 1）

1. `webapp/go` に OpenTelemetry Native 計装を追加
2. ローカルでベンチ走行 → Splunk APM に `isuride` が表示されることを確認

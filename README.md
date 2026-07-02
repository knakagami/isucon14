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
| Linux EC2 `dev-1` | **未作成** — AWS アカウント SCP により `ec2:RunInstances` が拒否（要別アカウント or 承認） |

## 開発環境

### 推奨: Linux EC2 `dev-1`

- Ubuntu 24.04, Docker, Go 1.23, Task, Ansible
- bootstrap スクリプト: [`splunk/scripts/dev-1-user-data.sh`](splunk/scripts/dev-1-user-data.sh)
- Cursor 接続: SSH Remote または Cloud Agent（`move_agent_to_root`）

### AWS 認証

```powershell
aws sso login --profile SPLKAdministratorAccess-124593756704
aws --profile SPLKAdministratorAccess-124593756704 sts get-caller-identity
```

### Splunk O11y

- Realm: `jp0`
- Ingest token は `.env` に置く（リポジトリにコミットしない）

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

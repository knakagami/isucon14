# ブログ執筆メモ

## Splunk 環境

- Realm: jp0
- APM: https://app.jp0.observability.splunkcloud.com/#/apm?orgId=HJ_pc-CCEAQ
- MCP: `user-splunk_o11y_free` 接続確認済み（2026-07-01）

## 講評との対応（記事の骨子）

| 講評の論点 | Splunk で見る場所 | 修正の方向 |
|-----------|------------------|-----------|
| MySQL CPU / スロークエリ | DB Monitoring Top Queries | INDEX 追加 |
| `/api/app/notification` ポーリング | APM Endpoints p99 | クエリ最適化 / SSE |
| `/api/chair/coordinate` | APM + DB span | 書き込み最適化 |
| `/api/internal/matching` | APM Endpoints | マッチング間隔・バルク化 |
| DB 分離 | Infrastructure ホスト CPU | MySQL を別 VM へ |

## スクショ取得タイミング

- [ ] ベースライン（チューニング前）ベンチ + APM
- [ ] DB Monitoring Top Queries（初期）
- [ ] INDEX 追加後
- [ ] DB 分離後
- [ ] 通知・マッチング改善後

output "project_name" {
  description = "プロジェクト名"
  value       = local.project_name
}

output "ami_id" {
  description = "起動に使用した Ubuntu 24.04 AMI"
  value       = data.aws_ami.ubuntu_2404.id
}

output "security_group_id" {
  description = "ISUCON 用セキュリティグループ ID"
  value       = module.isucon_ec2.security_group_id
}

output "instance_ids" {
  description = "インスタンス名 → instance ID"
  value       = module.isucon_ec2.instance_ids
}

output "public_ips" {
  description = "インスタンス名 → パブリック IP"
  value       = module.isucon_ec2.public_ips
}

output "app_public_ips" {
  description = "アプリサーバのパブリック IP 一覧"
  value       = module.isucon_ec2.app_public_ips
}

output "db_public_ip" {
  description = "DB サーバのパブリック IP"
  value       = module.isucon_ec2.db_public_ip
}

output "bench_public_ip" {
  description = "ベンチマーカのパブリック IP"
  value       = module.isucon_ec2.bench_public_ip
}

output "ansible_inventory_command" {
  description = "Ansible inventory 生成コマンド"
  value       = "../../scripts/03-generate-ansible-inventory.sh"
}

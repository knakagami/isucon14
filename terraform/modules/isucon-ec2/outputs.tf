output "security_group_id" {
  value = aws_security_group.isucon.id
}

output "instance_ids" {
  value = { for name, inst in aws_instance.isucon : name => inst.id }
}

output "public_ips" {
  value = { for name, inst in aws_instance.isucon : name => inst.public_ip }
}

output "private_ips" {
  value = { for name, inst in aws_instance.isucon : name => inst.private_ip }
}

output "app_public_ips" {
  value = [
    for name, inst in aws_instance.isucon : inst.public_ip
    if var.instances[name].role == "app"
  ]
}

output "db_public_ip" {
  value = try([
    for name, inst in aws_instance.isucon : inst.public_ip
    if var.instances[name].role == "db"
  ][0], null)
}

output "bench_public_ip" {
  value = try([
    for name, inst in aws_instance.isucon : inst.public_ip
    if var.instances[name].role == "bench"
  ][0], null)
}

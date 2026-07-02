#!/bin/bash
# Common cloud-init bootstrap for ISUCON + Splunk lab EC2 instances.
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ca-certificates curl gnupg git ansible python3-pip docker.io amazon-ssm-agent

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

curl -fsSL https://go.dev/dl/go1.23.4.linux-amd64.tar.gz -o /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' > /etc/profile.d/go.sh
ln -sf /usr/local/go/bin/go /usr/local/bin/go

curl -fsSL https://github.com/go-task/task/releases/download/v3.40.1/task_linux_amd64.deb -o /tmp/task.deb
apt-get install -y /tmp/task.deb

install -d -o ubuntu -g ubuntu /home/ubuntu/isucon-with-splunk-o11y

touch /var/log/isucon-splunk-bootstrap.done

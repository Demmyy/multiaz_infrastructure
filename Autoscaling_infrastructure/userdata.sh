#!/bin/bash

set -e

yum update -y
yum install -y python3 python3-pip git

mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

git clone https://github.com/Demmyy/multiaz_infrastructure.git .

pip3 install -r requirements.txt

cat > /etc/environment << 'EOF'
DB_HOST=my-production-db.cg5206i6wmpe.us-east-1.rds.amazonaws.com
DB_PORT=3306
DB_USER=admin
DB_PASSWORD=Cyberway_22
DB_NAME=statusdashboard
EOF

cat > /etc/systemd/system/statusdashboard.service << 'EOF'
[Unit]
Description=Team Status Dashboard
After=network.target

[Service]
Type=simple
User=root
EnvironmentFile=/etc/environment
WorkingDirectory=/home/ec2-user/app
ExecStart=/usr/bin/python3 /home/ec2-user/app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable statusdashboard
systemctl start statusdashboard
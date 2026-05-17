#!/bin/bash
apt update -y
apt install -y apache2 awscli
systemctl start apache2
systemctl enable apache2

aws s3 cp s3://manjunath-terraform-project-2026/index.html /var/www/html/index.html
chmod 644 /var/www/html/index.html
#!/bin/bash

# =========================================================
# Jenkins Installation Script for Amazon Linux 2023
# Author: Daniyal
# Description: Automates installation of Git, Maven, Java 21, and Jenkins
# =========================================================

echo "🔄 Updating system packages..."
sudo yum update -y

echo "✅ Installing Git and Maven..."
sudo yum install git maven -y

echo "🔧 Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "☕ Installing Java 21 (Amazon Corretto)..."
sudo yum install java-21-amazon-corretto -y

echo "📦 Installing Jenkins..."
sudo yum install jenkins -y

echo "🧠 Remounting /tmp to increase size..."
sudo mount -o remount,size=2G /tmp

echo "🚀 Starting Jenkins service..."
sudo systemctl start jenkins

echo "🩺 Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

echo "⚙️ Enabling Jenkins to start on boot..."
sudo systemctl enable jenkins

# Optional older command (works only on older distros)
# chkconfig jenkins on

echo "🔑 Jenkins Installation Completed Successfully!"
echo ""
echo "🌐 Access Jenkins at: http://<your-server-public-ip>:8080"
echo "🔍 To get the initial admin password, run:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "🧠 Tip: Make sure port 8080 is open in your AWS Security Group."

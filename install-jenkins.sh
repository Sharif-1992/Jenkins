#!/bin/bash
set -e

# Update system and install Java
apt-get update -y
apt-get install -y openjdk-11-jdk curl gnupg2

# Add Jenkins repo and key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins net-tools

# Reload systemd and try to start Jenkins service
systemctl daemon-reexec || true
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

# Confirm Jenkins status
systemctl status jenkins || journalctl -xeu jenkins.service

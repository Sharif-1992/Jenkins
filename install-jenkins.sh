#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y gnupg2 curl openjdk-11-jdk

# Add Jenkins GPG key and repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt-get update -y
sudo apt-get install -y jenkins

# Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

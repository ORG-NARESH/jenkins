#!/bin/bash

set -e  # Exit on any command failure

echo "=== Checking Java version (pre-install) ==="
java -version || echo "Java not found, proceeding with installation..."

echo "=== Installing OpenJDK 17 ==="
sudo dnf install -y java-17-openjdk

echo "=== Verifying Java version ==="
java -version

echo "=== Installing EPEL repository (if needed) ==="
sudo dnf install -y epel-release

echo "=== Adding Jenkins repository ==="
sudo tee /etc/yum.repos.d/jenkins.repo > /dev/null <<EOF
[jenkins]
name=Jenkins-stable
baseurl=https://pkg.jenkins.io/redhat-stable
gpgcheck=1
gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
EOF

echo "=== Importing Jenkins GPG key ==="
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "=== Installing Jenkins ==="
sudo dnf install -y jenkins

echo "=== Enabling and starting Jenkins ==="
sudo systemctl enable --now jenkins

echo "=== Jenkins service status ==="
sudo systemctl status jenkins --no-pager || true

echo "=== Jenkins initial admin password ==="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword || echo "Password file not found (Jenkins may still be starting)."

echo "=== Jenkins installation complete! Access via: http://<your-server-ip>:8080 ==="

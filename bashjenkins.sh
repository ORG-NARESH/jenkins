#!/bin/bash

set -e  # Exit on any command failure

sudo set-hostname jenkins

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
sudo sleep 30 ; cat /var/lib/jenkins/secrets/initialAdminPassword || echo "Password file not found (Jenkins may still be starting)."

echo "=== Jenkins installation complete! Access via: http://<your-server-ip>:8080 ==="


sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform


dnf install git -y



# sudo growpart /dev/xvda 4
# sudo lvextend -l +60%FREE /dev/mapper/RootVG-homeVol
# sudo lvextend -l +1000%FREE /dev/mapper/RootVG-varVol
# sudo xfs_growfs  /var ; sudo xfs_growfs  /home

#Add the disk ( On UI ) 
sudo growpart /dev/nvme0n1 4
sudo lvextend -l +20%FREE /dev/mapper/RootVG-homeVol
sudo lvextend -l +60%FREE /dev/mapper/RootVG-varTmpVol
#sudo lvextend -l +30%FREE /dev/mapper/RootVG-varVol
sudo xfs_growfs  /var ; sudo xfs_growfs  /home
df -h

After attaching volume to ec2 - one disk is created
To convert disk to parttition
sudo gdisk /dev/nvme1n1
sudo partprobe
sudo pvcreate /dev/nvme1n1p1
sudo vgextend RootVG /dev/nvme1n1p1
sudo pvs
sudo vgs -o +devices
lsblk
sudo lvextend -l +40%FREE /dev/mapper/RootVG-varVol
lsblk
sudo lvextend -l +40%FREE /dev/mapper/RootVG-varTmpVol
lsblk
sudo lvextend -l +40%FREE /dev/mapper/RootVG-logVol
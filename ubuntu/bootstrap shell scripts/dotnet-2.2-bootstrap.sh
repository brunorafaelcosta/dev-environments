#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

# Root privileges
sudo su

# Update packages
apt-get update

# GIT 
apt-get install git -y
git config --global user.name "${env_git_username}"
git config --global user.email "${env_git_email}"

# .NET Core 2.2
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
add-apt-repository universe
apt-get update
apt-get install apt-transport-https -y
apt-get update
apt-get install dotnet-sdk-2.2 -y

# Docker
apt-get update
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-get update
apt-get install docker-ce -y
usermod -aG docker ${env_username}

# Update packages and clean
apt-get update
apt-get upgrade -y
apt-get autoremove -y

# Firewall configuration
if [ -n "$env_ip_address" ]
then
    ufw --force enable

    # SSH on both interfaces
    ufw allow ssh
    ufw allow in on $(ifconfig | grep -B1 $env_ip_address | grep -o "^\w*") to any port 22
fi

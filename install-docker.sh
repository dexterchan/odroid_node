#!/usr/bin/env bash
set -e
arch=$(uname -m)

if [ "$arch" = "aarch64" ]; then
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ${USER}
fi


if [ "$arch" = "armv7l" ]; then
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=armhf] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
mkdir -p /etc/docker
apt-get install -y docker-ce

usermod -a -G docker droid
fi
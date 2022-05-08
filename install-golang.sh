#!/bin/sh
VERSION=1.18.1
PLATFORM=arm64
cd /tmp
wget https://go.dev/dl/go${VERSION}.linux-${PLATFORM}.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${VERSION}.linux-${PLATFORM}.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
go version

#!/bin/sh

#unblock the ports in firewall
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 6443
sudo ufw allow from 192.168.1.0/24 proto udp to any port 8472
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 10250
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 2379:2380



conn_str=$(sudo sh /media/boot/postgredb.connection_string.sh)
SECRET=$(date +%s | sha256sum | base64 | head -c 32 )
echo off
echo $SECRET | sudo tee /media/boot/k3s_secret_token
curl -sfL https://get.k3s.io | sh -s - server \
  --token=$SECRET \
  --datastore-endpoint="${conn_str}"

echo on

# Reference from https://rancher.com/docs/k3s/latest/en/quick-start/
# curl -sfL https://get.k3s.io | sh -
# Check for Ready node,
#takes maybe 30 seconds
sleep 30
k3s kubectl get node
#
#[INFO]  Failed to find memory cgroup, you may need to add "cgroup_memory=1 cgroup_enable=memory" to your linux cmdline (/boot/cmdline.txt on a Raspberry Pi)
#[INFO]  systemd: Enabling k3s unit



#!/bin/sh

#unblock the ports in firewall
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 6443
sudo ufw allow from 192.168.1.0/24 proto udp to any port 8472
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 10250
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 2379:2380


sudo apt-get install -y curl
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install -y apt-transport-https
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update -y
sudo apt-get install -y helm


conn_str=$(sudo sh postgredb.connection_string.sh)
SECRET=$(date +%s | sha256sum | base64 | head -c 32 )
echo off
echo $SECRET | sudo tee /media/boot/k3s_secret_token
SECRET=$(cat /media/boot/k3s_secret_token)
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

k3s_grp=k3s
sudo groupadd --system   ${k3s_grp}
sudo usermod -a -G ${k3s_grp} odroid

sudo usermod -a -G ${k3s_grp} droid
sudo chgrp ${k3s_grp} /etc/rancher/k3s/k3s.yaml
sudo chmod 660 /etc/rancher/k3s/k3s.yaml
#Without this, you got Error: Kubernetes cluster unreachable
echo export KUBECONFIG=/etc/rancher/k3s/k3s.yaml >> ~/.bashrc

#SMB driver for k3s
#https://github.com/kubernetes-csi/csi-driver-smb/tree/master/charts
#helm repo add csi-driver-smb https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts
#helm install csi-driver-smb csi-driver-smb/csi-driver-smb --namespace kube-system --version v1.5.0
#example
#https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md
echo uninstall with '/usr/local/bin/k3s-uninstall.sh'

# nginx controller replacement
# https://www.suse.com/support/kb/doc/?id=000020082

# opening port for ingress
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 80
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 443

kubectl label nodes $(hostname) type=driver

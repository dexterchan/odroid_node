#!/bin/sh

#unblock the ports in firewall
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 6443
# sudo ufw allow from 192.168.1.0/24 proto udp to any port 8472
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 10250
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 2379:2380


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
K3S_VERSION=v1.23.9+k3s1
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--no-deploy traefik --cluster-cidr=172.16.0.0/16" sh -s - server \
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
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
#SMB driver for k3s
#https://github.com/kubernetes-csi/csi-driver-smb/tree/master/charts
#helm repo add csi-driver-smb https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts
#helm install csi-driver-smb csi-driver-smb/csi-driver-smb --namespace kube-system --version v1.5.0
#example
#https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md
echo uninstall with '/usr/local/bin/k3s-uninstall.sh'

# nginx controller replacement
# https://kubernetes.github.io/ingress-nginx/deploy/
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
  
# opening port for ingress
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 80
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 443

kubectl label nodes $(hostname) type=driver
kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule

#An example NGINX Ingress that makes use of the controller:
#   apiVersion: networking.k8s.io/v1
#   kind: Ingress
#   metadata:
#     name: example
#     namespace: foo
#   spec:
#     ingressClassName: nginx
#     rules:
#       - host: www.example.com
#         http:
#           paths:
#             - pathType: Prefix
#               backend:
#                 service:
#                   name: exampleService
#                   port:
#                     number: 80
#               path: /
#     # This section is only required if TLS is to be enabled for the Ingress
#     tls:
#       - hosts:
#         - www.example.com
#         secretName: example-tls

# If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

#   apiVersion: v1
#   kind: Secret
#   metadata:
#     name: example-tls
#     namespace: foo
#   data:
#     tls.crt: <base64 encoded cert>
#     tls.key: <base64 encoded key>
#   type: kubernetes.io/tls



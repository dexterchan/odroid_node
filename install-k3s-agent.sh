#!/bin/sh
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 6443
sudo ufw allow from 192.168.1.0/24 proto udp to any port 8472
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 10250
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 2379:2380


# install k3s service
echo install k3s service
# curl -sfL https://get.k3s.io | sh -


echo "Enter the k3s token: "  
read SECRET

echo "Enter the server hostname: "
read server_hostname

# curl -sfL https://get.k3s.io | K3S_URL=https://${server_hostname}:6443 \
#                                K3S_TOKEN=$SECRET sh -


curl -sfL https://get.k3s.io | sh -s - agent \
                                --token $SECRET \
                                --node-label workload=highdemand \
                                --server https://${server_hostname}:6443
                                #--node-taint workload=highdemand:NoExecute \

echo uninstall with '/usr/local/bin/k3s-agent-uninstall.sh'

node_name=$(cat /etc/hostname)
kubectl labels nodes ${node_name} type=compute
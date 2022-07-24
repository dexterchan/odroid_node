#!/bin/sh
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 6443
# sudo ufw allow from 192.168.1.0/24 proto udp to any port 8472
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 10250
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 2379:2380


# install k3s service
echo install k3s service
# curl -sfL https://get.k3s.io | sh -

logfile=/var/log/k3_agent.log

echo "Enter the k3s token: "  
read SECRET
echo "Got secret: ${SECRET}"

echo "Enter the master server ipaddress: "
read server_ipaddress
echo "Got master server: ${server_ipaddress}"

# curl -sfL https://get.k3s.io | K3S_URL=https://${server_ipaddress}:6443 \
#                                K3S_TOKEN=$SECRET sh -

K3S_VERSION=v1.23.9+k3s1
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" sh -s - agent \
                                --token $SECRET \
                                --server https://${server_ipaddress}:6443 \
                                --log /var/log/k3_agent.log \
                                --node-label type=compute \
                                --node-taint workload=high:NoSchedule

echo uninstall with '/usr/local/bin/k3s-agent-uninstall.sh'

node_name=$(cat /etc/hostname)
echo kubectl label nodes ${node_name} type=compute
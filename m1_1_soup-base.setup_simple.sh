#!/bin/bash
host_name=$1
sudo apt update -y
sudo apt --fix-broken install -y

sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sudo locale-gen

#Then edit  /etc/default/locale 
cat <<EOF > /tmp/locale 
LANG=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
EOF
sudo mv /tmp/locale /etc/default/locale 

APPUSER=droid
HOMEDIR=/home/${APPUSER}
sudo mkdir -p ${HOMEDIR}
sudo groupadd --system --gid=9999  ${APPUSER} 
sudo useradd --system --home-dir $HOMEDIR --uid=9999 --gid=${APPUSER} ${APPUSER}


if [ -z "$host_name" ]; then
    host_name="k3s-node"
fi
echo $host_name | sudo tee /etc/hostname

cat << EOF | sudo tee -a /etc/hosts
127.0.1.1       ${host_name}
EOF
sudo apt update -y
sudo apt full-upgrade -y
#As of APR2022
#Odroid Ubuntu failed to have complete iptable to support ufw
sudo apt install -y  avahi-daemon curl unzip nfs-common resolvconf

cd /tmp
curl -fsSL https://get.docker.com -o get-docker.sh
echo 'alias temp="cat /sys/devices/virtual/thermal/thermal_zone0/temp"' | sudo tee -a /home/odroid/.bashrc 
echo 'alias temp="cat /sys/devices/virtual/thermal/thermal_zone0/temp"' | sudo tee -a /home/${APPUSER}/.bashrc 

sudo usermod -a -G sudo $APPUSER
#Amend /etc/avahi/avahi-daemon.conf
sudo sed -i 's/#host-name=foo/host-name='${host_name}'/g' /etc/avahi/avahi-daemon.conf
sudo chown -R ${APPUSER}:${APPUSER} $HOMEDIR

#Fix the DNS issue
sudo dpkg-reconfigure resolvconf


# #sudo apt-get install ufw -y
# #Disable ipv6 as the current version iptableV6 not working 
# sudo sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw



# # Known issue of nftables, need to revert back to iptables-legacy
# sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
# sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
# sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
# sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy

# sudo ln -s /etc/alternatives/iptables /sbin/iptables
# sudo ln -s /etc/alternatives/iptables-save /sbin/iptables-save
# sudo ln -s /etc/alternatives/iptables-restore /sbin/iptables-restore
# sudo ln -s /etc/alternatives/ip6tables /sbin/ip6tables
# sudo ln -s /etc/alternatives/ip6tables-save /sbin/ip6tables-save
# sudo ln -s /etc/alternatives/ip6tables-restore /sbin/ip6tables-restore

# echo "restart before applying below"
# echo sudo ufw allow from 192.168.1.0/24 proto tcp to any port 22
# echo sudo ufw deny from 192.168.1.3 to any
# echo sudo ufw deny from 192.168.1.17 to any


# echo sudo ufw --force default deny incoming
# echo sudo ufw --force enable 
sudo reboot now
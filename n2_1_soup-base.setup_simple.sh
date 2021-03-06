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
mkdir -p ${HOMEDIR}
groupadd --system --gid=9999  ${APPUSER} 
useradd --system --home-dir $HOMEDIR --uid=9999 --gid=${APPUSER} ${APPUSER}


if [ -z "$host_name" ]; then
    host_name="ant-node"
fi

echo $host_name | sudo tee /etc/hostname

cat << EOF | sudo tee -a /etc/hosts
127.0.1.1       ${host_name}
EOF

sudo apt update -y
sudo apt full-upgrade -y

sudo apt install -y avahi-daemon curl unzip nfs-common 

cd /tmp
echo 'alias temp="cat /sys/devices/virtual/thermal/thermal_zone0/temp"' >> ~/.bashrc 
echo 'alias temp="cat /sys/devices/virtual/thermal/thermal_zone0/temp"' >> /home/${APPUSER}/.bashrc 

sudo usermod -a -G sudo $APPUSER
#Amend /etc/avahi/avahi-daemon.conf
sudo sed -i 's/#host-name=foo/host-name='${host_name}'/g' /etc/avahi/avahi-daemon.conf
sudo chown -R ${APPUSER}:${APPUSER} $HOMEDIR

sh ./install_swap_drive.sh
# sudo ufw allow from 192.168.1.0/24 proto tcp to any port 22
# sudo ufw deny from 192.168.1.3 to any
# sudo ufw deny from 192.168.1.17 to any
# sudo ufw --force default deny incoming
# sudo ufw --force enable 
sudo reboot now
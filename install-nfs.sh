#!/bin/sh
#Reference: https://linuxize.com/post/how-to-install-and-configure-an-nfs-server-on-ubuntu-20-04/
sudo apt update
sudo apt install nfs-kernel-server

mkdir -p /mnt/data
chmod 777 /mnt/data

APPUSER=nfs
HOMEDIR=/home/${APPUSER}
mkdir -p ${HOMEDIR}
groupadd --system   ${APPUSER} 
useradd --system --home-dir $HOMEDIR --gid=${APPUSER} ${APPUSER}
sudo chown -R ${APPUSER}:${APPUSER} $HOMEDIR

sudo chown -R ${APPUSER}:${APPUSER} /mnt/data


sudo mkdir -p /srv/nfs4

cat << EOF | sudo tee -a /etc/fstab
/dev/sda1  /mnt/data ext4 defaults 0 1
EOF
sudo mount -a

cat << EOF | sudo tee -a /etc/fstab
/mnt/data /srv/nfs4  none   bind   0   0
EOF

sudo mount -a

cat << EOF | sudo tee -a /etc/exports
/srv/nfs4         192.168.1.0/24(rw,sync,no_subtree_check,crossmnt,fsid=0)
EOF

sudo exportfs -ar
sudo exportfs -v

sudo ufw allow from 192.168.1.0/24 to any port nfs

echo "Client use following command to mount the nfs directory"
echo "sudo mount -t nfs -o vers=4 192.168.1.27:/ /mnt/nfs"
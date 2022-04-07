#!/bin/sh

sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib
USERNAME=droid
sudo usermod -aG postgres $USERNAME

sudo -u postgres createuser $USERNAME
DBNAME=k3scluster
sudo -u postgres createdb -O $USERNAME $DBNAME

conf_file=$(sudo find / -name "postgresql.conf" | grep etc)
sudo cp $conf_file ${conf_file}.bk
sudo sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '192.168.*'|g" $conf_file


pg_conf_file=$(sudo find / -name pg_hba.conf)
cat <<EOF | sudo tee -a ${pg_conf_file}
host    all             all              0.0.0.0/0                       md5
host    all             all              ::/0                            md5
EOF

sudo systemctl restart  postgresql

#Update firewall 
sudo ufw allow from 192.168.1.0/24 proto tcp to any port 5432

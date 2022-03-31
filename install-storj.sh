
#!/bin/sh

cat << EOF | sudo tee -a /etc/fstab
/dev/sda2  /mnt/storj ext4 defaults 0 1
EOF
sudo mount -a

curl -L https://github.com/storj/storj/releases/latest/download/identity_linux_arm.zip -o identity_linux_arm.zip
unzip -o identity_linux_arm.zip
chmod +x identity
sudo mv identity /usr/local/bin/identity

cd /tmp
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
tar xf noip-duc-linux.tar.gz
cd noip-2.1.9-1/
sudo make install
sudo chmod 600 /usr/local/etc/no-ip2.conf

cat << EOF | sudo tee /etc/systemd/system/noip2.service
[Unit]
Description=noip2 service

[Service]
Type=forking
ExecStart=/usr/local/bin/noip2
Restart=always

[Install]
WantedBy=default.target

EOF
sudo chmod +x /etc/init.d/noip2.sh

sudo systemctl daemon-reload
sudo systemctl enable noip2
sudo systemctl start noip2

echo update the config with /usr/local/bin/noip2 -C

sudo ufw allow from 192.168.1.0/24 proto tcp to any port 14002
sudo ufw allow 28967
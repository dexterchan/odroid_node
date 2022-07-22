#!/bin/bash
sudo dd if=/dev/zero of=/mnt/swapfile bs=1M count=1024
sudo chown 0600 /mnt/swapfile 
sudo mkswap /mnt/swapfile
sudo swapon /mnt/swapfile
echo "/mnt/swapfile none swap sw 00" | sudo tee -a /etc/fstab
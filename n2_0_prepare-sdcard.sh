#!/bin/sh
cp ~/.ssh/wpa_supplicant.conf /Volumes/boot
cp ~/.ssh/postgredb.connection_string.sh /Volumes/boot
cp ~/.ssh/surfshark.credential  /Volumes/boot
#echo cgroup_memory=1 cgroup_enable=memory $(cat /Volumes/boot/cmdline.txt ) > /Volumes/boot/cmdline.txt
cp n2_1_soup-base.setup_no_docker.sh /Volumes/boot
cp install-docker.sh /Volumes/boot
cp install-k3s-server.sh /Volumes/boot
cp install-postgre.sh /Volumes/boot
cp install-nfs-server.sh /Volumes/boot

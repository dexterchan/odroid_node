#!/bin/sh
cp ~/.ssh/wpa_supplicant.conf /Volumes/boot
#echo cgroup_memory=1 cgroup_enable=memory $(cat /Volumes/boot/cmdline.txt ) > /Volumes/boot/cmdline.txt
cp 1_soup-base.setup_no_docker.sh /Volumes/boot
cp install-docker.sh /Volumes/boot
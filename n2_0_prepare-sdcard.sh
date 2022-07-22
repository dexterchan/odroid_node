#!/bin/bash
cp ~/.ssh/wpa_supplicant.conf /Volumes/boot
cp ~/.ssh/postgredb.connection_string.sh /Volumes/boot
cp ~/.ssh/surfshark.credential  /Volumes/boot
#echo cgroup_memory=1 cgroup_enable=memory $(cat /Volumes/boot/cmdline.txt ) > /Volumes/boot/cmdline.txt
cp n2_1_soup-base.setup_no_docker.sh /Volumes/boot
cp install-docker.sh /Volumes/boot
cp install-k3s-server.sh /Volumes/boot
cp install-postgre.sh /Volumes/boot
cp install-nfs-server.sh /Volumes/boot
cp install-k3s-agent.sh /Volumes/boot
cp install-golang.sh /Volumes/boot
cp install-ssmagent.sh /Volumes/boot
cp n2_1_soup-base.setup_simple.sh /Volumes/boot
cp install_swap_drive.sh /Volumes/boot
pushd aws_cli_sys_mgr
sh Create_Activation_Code.sh 
cp /tmp/activation.json /Volumes/boot

popd
#!/bin/sh
roottmpfolder=$TMPDIR
tmpfolder=${roottmpfolder}odroid_pack
mkdir -p $tmpfolder
cp ~/.ssh/wpa_supplicant.conf $tmpfolder
cp ~/.ssh/postgredb.connection_string.sh $tmpfolder
cp ~/.ssh/surfshark.credential  $tmpfolder
#echo cgroup_memory=1 cgroup_enable=memory $(cat $tmpfolder/cmdline.txt ) > $tmpfolder/cmdline.txt
cp m1_1_soup-base.setup_no_docker.sh $tmpfolder
cp install-docker.sh $tmpfolder
cp install-k3s-server.sh $tmpfolder
cp install-k3s-agent.sh $tmpfolder
cp install-postgre.sh $tmpfolder
cp install-nfs-server.sh $tmpfolder
cp install-golang.sh $tmpfolder
cp install-ssmagent.sh $tmpfolder
cp m1_1_soup-base.setup_simple.sh $tmpfolder

curpath=$(pwd)
cd $roottmpfolder
tar cvf odroid_pack.tar odroid_pack
mv odroid_pack.tar /tmp/
cd $curpath


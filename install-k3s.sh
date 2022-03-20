#!/bin/sh
# Reference from https://rancher.com/docs/k3s/latest/en/quick-start/
curl -sfL https://get.k3s.io | sh -
# Check for Ready node,
#takes maybe 30 seconds
sleep 30
k3s kubectl get node
#
#[INFO]  Failed to find memory cgroup, you may need to add "cgroup_memory=1 cgroup_enable=memory" to your linux cmdline (/boot/cmdline.txt on a Raspberry Pi)
#[INFO]  systemd: Enabling k3s unit

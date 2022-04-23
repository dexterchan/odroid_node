#!/bin/sh

SSM_ACTIVATION_CODE_FILE=$1
sudo apt-get install jq -y

activation_code=$(cat $SSM_ACTIVATION_CODE_FILE | jq -r ".ActivationCode")
activation_id=$(cat $SSM_ACTIVATION_CODE_FILE | jq -r ".ActivationId")
region=us-east-1

mkdir /tmp/ssm

curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_arm64/amazon-ssm-agent.deb -o /tmp/ssm/amazon-ssm-agent.deb
sudo dpkg -i /tmp/ssm/amazon-ssm-agent.deb
sudo service amazon-ssm-agent stop
sudo -E amazon-ssm-agent -register -code $activation_code -id $activation_id -region $region -y
sudo service amazon-ssm-agent start
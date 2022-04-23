#!/bin/bash

region="us-east-1"
SSM_Service_Role=SSM-${region}-Hybrid-Service-Role
device=my-iot-devices
tags="group=iot"
expiry_time=$(gdate -d '+30 days' -u +'%Y-%m-%dT%H:%M:%S')
echo Activate code to expire on $expiry_time
SSM_ACTIVATION_CODE=/tmp/activation.json
aws ssm create-activation \
    --default-instance-name ${device} \
    --iam-role ${SSM_Service_Role} \
    --registration-limit 10 \
    --region $region \
    --expiration-date "${expiry_time}" \
    --tags "Key=group,Value=iot" "Key=Environment,Value=Test" > $SSM_ACTIVATION_CODE

echo activation code file is located in $SSM_ACTIVATION_CODE
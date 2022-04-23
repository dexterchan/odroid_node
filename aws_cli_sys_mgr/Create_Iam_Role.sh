#!/bin/sh
account=$(aws sts get-caller-identity | jq -r ".Account")
region="us-east-1"
temp_file=/tmp/iamrole_hybrid.json
cat <<EOF | tee $temp_file
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"",
         "Effect":"Allow",
         "Principal":{
            "Service":"ssm.amazonaws.com"
         },
         "Action":"sts:AssumeRole",
         "Condition":{
            "StringEquals":{
               "aws:SourceAccount":"${account}"
            },
            "ArnEquals":{
               "aws:SourceArn":"arn:aws:ssm:${region}:${account}:*"
            }
         }
      }
   ]
}
EOF

SSM_Service_Role=SSM-${region}-Hybrid-Service-Role
aws iam create-role \
    --role-name ${SSM_Service_Role} \
    --assume-role-policy-document file://${temp_file}


echo "Service Role ${SSM_Service_Role} created"

aws iam attach-role-policy \
    --role-name ${SSM_Service_Role} \
    --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore  
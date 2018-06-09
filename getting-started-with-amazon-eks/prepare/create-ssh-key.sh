#!/bin/bash -eu

mkdir -p $EKS_SECRET_DIR

aws ec2 create-key-pair \
    --key-name $EKS_KEY_NAME \
    --query 'KeyMaterial' \
    --output text \
    > $EKS_KEY_FILE

chmod 600 $EKS_KEY_FILE

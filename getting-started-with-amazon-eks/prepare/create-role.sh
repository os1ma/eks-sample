#!/bin/bash -eu

POLICY_FILE=eks-role-policy.json

cd `dirname $0`

aws iam create-role \
    --role-name $EKS_ROLE_NAME \
    --assume-role-policy-document file://$POLICY_FILE

aws iam attach-role-policy \
    --role-name $EKS_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

aws iam attach-role-policy \
    --role-name $EKS_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKSServicePolicy

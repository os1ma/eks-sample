#!/bin/bash -eu

aws cloudformation delete-stack \
    --stack-name $EKS_WORKER_STACK_NAME
aws cloudformation wait stack-delete-complete \
    --stack-name $EKS_WORKER_STACK_NAME

aws eks delete-cluster \
    --name $EKS_CLUSTER_NAME

while [ `aws eks list-clusters --query clusters | grep \"$EKS_CLUSTER_NAME\" | wc -l` -eq 1 ]
do
    echo 'waiting deleting master...'
    sleep 10
done

aws cloudformation delete-stack \
    --stack-name $EKS_VPC_STACK_NAME
aws cloudformation wait stack-delete-complete \
    --stack-name $EKS_VPC_STACK_NAME

aws ec2 delete-key-pair --key-name $EKS_KEY_NAME
rm -f $EKS_KEY_FILE

rm -f $EKS_KUBE_CONFIG_FILE

aws iam detach-role-policy \
    --role-name $EKS_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

aws iam detach-role-policy \
    --role-name $EKS_ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKSServicePolicy

aws iam delete-role --role-name $EKS_ROLE_NAME

#!/bin/bash -eu

ROLE_ARN=$(aws iam get-role \
    --role-name $EKS_ROLE_NAME \
    --query 'Role.Arn' \
    | sed -E 's/.(.*)./\1/')

SUBNET_IDS=$(aws cloudformation describe-stacks \
    --stack-name $EKS_VPC_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`SubnetIds`].[OutputValue][0][0]' \
    | sed -E 's/.(.*)./\1/')

SECURITY_GROUP_IDS=$(aws cloudformation describe-stacks \
    --stack-name $EKS_VPC_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`SecurityGroups`].[OutputValue][0][0]' \
    | sed -E 's/.(.*)./\1/')

aws eks create-cluster \
    --name $EKS_CLUSTER_NAME \
    --role-arn $ROLE_ARN \
    --resources-vpc-config subnetIds=$SUBNET_IDS,securityGroupIds=$SECURITY_GROUP_IDS


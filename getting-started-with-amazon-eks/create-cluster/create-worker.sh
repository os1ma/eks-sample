#!/bin/bash -eu

CLUSTER_CONTROL_PLANE_SECURITY_GROUP=$(aws cloudformation describe-stacks \
    --stack-name $EKS_VPC_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`SecurityGroups`].[OutputValue][0][0]' \
    | sed -E 's/.(.*)./\1/')

NODE_GROUP_NAME=eks-worker-node-group
NODE_AUTO_SCALING_GROUP_MIN_SIZE=1
NODE_AUTO_SCALING_GROUP_MAX_SIZE=3
NODE_INSTANCE_TYPE=t2.small
# TODO Support us-east-1
NODE_IMAGE_ID=ami-73a6e20b
KEY_NAME=eks-key

VPC_ID=$(aws cloudformation describe-stacks \
    --stack-name $EKS_VPC_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`VpcId`].[OutputValue][0][0]' \
    | sed -E 's/.(.*)./\1/')
SUBNETS=$(aws cloudformation describe-stacks \
    --stack-name $EKS_VPC_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`SubnetIds`].[OutputValue][0][0]')
#    | sed -E 's/.(.*)./\1/')

aws cloudformation create-stack \
    --stack-name $EKS_WORKER_STACK_NAME \
    --template-body https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-nodegroup.yaml \
    --parameters \
        ParameterKey=ClusterName,ParameterValue=$EKS_CLUSTER_NAME \
        ParameterKey=ClusterControlPlaneSecurityGroup,ParameterValue=$CLUSTER_CONTROL_PLANE_SECURITY_GROUP \
        ParameterKey=NodeGroupName,ParameterValue=$NODE_GROUP_NAME \
        ParameterKey=NodeAutoScalingGroupMinSize,ParameterValue=$NODE_AUTO_SCALING_GROUP_MIN_SIZE \
        ParameterKey=NodeAutoScalingGroupMaxSize,ParameterValue=$NODE_AUTO_SCALING_GROUP_MAX_SIZE \
        ParameterKey=NodeInstanceType,ParameterValue=$NODE_INSTANCE_TYPE \
        ParameterKey=NodeImageId,ParameterValue=$NODE_IMAGE_ID \
        ParameterKey=KeyName,ParameterValue=$EKS_KEY_NAME \
        ParameterKey=VpcId,ParameterValue=$VPC_ID \
        ParameterKey=Subnets,ParameterValue=$SUBNETS \
    --capabilities CAPABILITY_IAM

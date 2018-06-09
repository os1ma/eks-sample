#!/bin/bash -eu

VPC_BLOCK=192.168.0.0/16
SUBNET_01_BLOCK=192.168.64.0/18
SUBNET_02_BLOCK=192.168.128.0/18
SUBNET_03_BLOCK=192.168.192.0/18

aws cloudformation create-stack \
    --stack-name $EKS_VPC_STACK_NAME \
    --template-body https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-vpc-sample.yaml \
    --parameters \
        ParameterKey=VpcBlock,ParameterValue=$VPC_BLOCK \
        ParameterKey=Subnet01Block,ParameterValue=$SUBNET_01_BLOCK \
        ParameterKey=Subnet02Block,ParameterValue=$SUBNET_02_BLOCK \
        ParameterKey=Subnet03Block,ParameterValue=$SUBNET_03_BLOCK

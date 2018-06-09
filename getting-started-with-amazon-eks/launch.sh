#!/bin/bash -eu

cd `dirname $0`

source set-env.sh

./prepare/create-role.sh
./prepare/create-ssh-key.sh

./prepare/create-vpc.sh
aws cloudformation wait stack-create-complete \
    --stack-name $EKS_VPC_STACK_NAME

./create-cluster/create-master.sh
while [ `aws eks describe-cluster --name $EKS_CLUSTER_NAME --query cluster.status` = \"CREATING\" ]
do
    echo 'Creating master...'
    sleep 10
done

./create-cluster/create-worker.sh
aws cloudformation wait stack-create-complete \
    --stack-name $EKS_WORKER_STACK_NAME

./create-cluster/set-kubectl.sh
./create-cluster/enable-worker.sh


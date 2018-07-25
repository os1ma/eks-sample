#!/bin/bash -eu

IMAGE_NAME=eks-kubectl

HOST_AWS_DIR=`pwd`/.aws
CONTAINER_AWS_DIR=/root/.aws

HOST_KUBE_DIR=`pwd`/.kube
CONTAINER_KUBE_DIR=/root/.kube

docker run \
    --rm \
    -v $HOST_AWS_DIR:$CONTAINER_AWS_DIR \
    -v $HOST_KUBE_DIR:$CONTAINER_KUBE_DIR \
    $IMAGE_NAME \
    $@

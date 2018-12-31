#!/bin/bash -eux

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
PROJECT_HOME=$SCRIPT_DIR/..

cd $PROJECT_HOME/terraform
CLUSTER_NAME=$(terraform output -json \
    | jq -r '.k8s_cluster_name.value')
export KUBECONFIG=$PROJECT_HOME/terraform/kubeconfig_$CLUSTER_NAME

kubectl delete -R -f $PROJECT_HOME/k8s-manifests/apps

helm delete --purge `helm ls -aq`

cd $PROJECT_HOME/terraform
terraform destroy -auto-approve

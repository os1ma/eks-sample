#!/bin/bash -eux

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
PROJECT_HOME=$SCRIPT_DIR/..

cd $PROJECT_HOME/terraform
terraform init
terraform apply -auto-approve

# k8sのセットアップ
CLUSTER_NAME=$(terraform output -json \
    | jq -r '.k8s_cluster_name.value')
export KUBECONFIG=$PROJECT_HOME/terraform/kubeconfig_$CLUSTER_NAME

# k8s addonのデプロイ
cd $PROJECT_HOME/k8s-manifests/addons

# Initialize Helm without Tiller
kubectl apply -f helm/rbac.yaml
helm init --service-account tiller
# Wait until tiller is ready.
sleep 30

# Install Metrics Server
METRICS_SERVER_VERSION=2.0.4
helm upgrade --install \
    metrics-server \
    stable/metrics-server \
    --version $METRICS_SERVER_VERSION \
    --namespace kube-system

# Install Cluster Autoscaler
CLUSTER_AUTOSCALER_VERSION=0.11.0
helm upgrade --install \
    cluster-autoscaler \
    stable/cluster-autoscaler \
    --version $CLUSTER_AUTOSCALER_VERSION \
    --namespace kube-system \
    --values cluster-autoscaler/values.yaml \
    --set autoDiscovery.clusterName=$CLUSTER_NAME

# Install AWS ALB Ingress Controlelr
AWS_ALB_INGRESS_CONTROLLER_VERSION=0.1.4
helm repo add \
    incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm upgrade --install \
    aws-alb-ingress-controller \
    incubator/aws-alb-ingress-controller \
    --version $AWS_ALB_INGRESS_CONTROLLER_VERSION \
    --namespace kube-system \
    --values aws-alb-ingress-controller/values.yaml \
    --set clusterName=$CLUSTER_NAME \

# k8s Applicationのデプロイ
kubectl apply -R -f $PROJECT_HOME/k8s-manifests/apps

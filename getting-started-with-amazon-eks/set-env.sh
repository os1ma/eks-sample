# aws cli setting
export AWS_DEFAULT_REGION=us-west-2

# aws resource name
export EKS_WORKER_STACK_NAME=eks-worker-stack
export EKS_CLUSTER_NAME=eks-cluster
export EKS_VPC_STACK_NAME=eks-vpc-stack
export EKS_ROLE_NAME=eks-role
export EKS_KEY_NAME=eks-key

# local directories and files
export EKS_SECRET_DIR=`pwd`/secret
export EKS_KEY_FILE=$EKS_SECRET_DIR/$EKS_KEY_NAME.pem
export EKS_KUBE_CONFIG_FILE=~/.kube/config-$EKS_CLUSTER_NAME

# kubectl configuration
export KUBECONFIG=$KUBECONFIG:$EKS_KUBE_CONFIG_FILE

#!/bin/bash -eu

ENDPOINT_URL=`aws eks describe-cluster \
    --name $EKS_CLUSTER_NAME \
    --query cluster.endpoint`
BASE64_ENCODED_CA_CERT=`aws eks describe-cluster \
    --name $EKS_CLUSTER_NAME \
    --query cluster.certificateAuthority.data`

mkdir -p ~/.kube

cat << EOT > $EKS_KUBE_CONFIG_FILE
apiVersion: v1
clusters:
- cluster:
    server: $ENDPOINT_URL
    certificate-authority-data: $BASE64_ENCODED_CA_CERT
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "$EKS_CLUSTER_NAME"
        # - "-r"
        # - "<role-arn>"
EOT

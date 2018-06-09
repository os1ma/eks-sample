#!/bin/bash -eu

ROLE_ARN=$(aws cloudformation describe-stacks \
    --stack-name $EKS_WORKER_STACK_NAME \
    --query 'Stacks[0].Outputs[0].OutputValue' \
    | sed -E 's/.(.*)./\1/')

cat << EOT | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: $ROLE_ARN
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOT

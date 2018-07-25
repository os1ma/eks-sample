# eks-kubectl
kubectl wrapper script for Amazon EKS

## Requirement
- docker

## Preparation

Build Docker image.

```
./build.sh
```

Create AWS and Kubernetes config files.

- .aws/config
- .aws/credentials
- .kube/config

## Usage

Following command is an example.

```
./eks-kubectl.sh get node
```

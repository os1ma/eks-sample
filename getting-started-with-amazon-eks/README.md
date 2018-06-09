# Getting Started with Amazon EKS
Automated EKS tutorial

## Usage

### Launch EKS

```
source set-env.sh
./launch.sh
```

### Launch sample application

```
./sample-application/launch-guest-book.sh
```

### Delete sample application

```
./sample-application/delete-guest-book.sh
```

If the VPC can not be deleted, please check whether there is any remaining load balancer or security group.

### Cleanup EKS

```
source set-env.sh
./cleanup.sh
```

## References
- https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

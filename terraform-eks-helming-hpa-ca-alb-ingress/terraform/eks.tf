locals {
  cluster_name = "test-eks-${random_string.suffix.result}"
  worker_groups = [
    {
      instance_type       = "t2.small"
      subnets             = "${join(",", module.vpc.private_subnets)}"
      asg_min_size = 2
      asg_max_size = 10
      asg_desired_capacity = 2
      autoscaling_enabled = true
      protect_from_scale_in = true
    },
  ]
  tags = {
    Environment = "test"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  cluster_name                         = "${local.cluster_name}"
  subnets                              = ["${module.vpc.private_subnets}"]
  tags                                 = "${local.tags}"
  vpc_id                               = "${module.vpc.vpc_id}"
  worker_groups                        = "${local.worker_groups}"
  worker_group_count                   = "1"
  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
}

locals {
  cluster_name = "hosono-test-eks"
  worker_groups = [
    {
      instance_type       = "m5.large"
      asg_max_size  = 5
      tags = [{
        key                 = "foo"
        value               = "bar"
        propagate_at_launch = true
      }]
    },
  ]
  tags = {
    Environment = "test"
  }
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  cluster_name                         = local.cluster_name
  subnets                              = module.vpc.private_subnets
  tags                                 = local.tags
  vpc_id                               = module.vpc.vpc_id
  worker_groups                        = local.worker_groups
  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
}
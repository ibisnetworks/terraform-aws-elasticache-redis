# terraform-aws-elasticache-redis

Terraform module to provision an [`ElastiCache`](https://aws.amazon.com/elasticache/) Redis Cluster

Originally forked from `CloudPosse` but heavily modified; do not rebase the fork without talking to Mark Madsen.  The original has interactions with Route53 DNS that we do not need or want.  I also added snapshots and other variables to the module that we want.  

## Usage

Include this repository as a module in your existing terraform code:

```hcl

module "elasticache_redis_prod_cluster" {
  source  = "git@github.com:ibisnetworks/terraform-aws-elasticache-redis.git"
  version = "0.7.0"
  name    = "ibiscloud-prod-db"

  enabled                  = "true"
  namespace                = "production"
  name                     = "ibiscloud"
  stage                    = "prod"
  vpc_id                   = "${data.terraform_remote_state.vpc.vpc_id}"
  engine_version           = "3.2.10"
  cluster_size             = "2"
  port                     = "6379"
  subnets                  = "${data.terraform_remote_state.vpc.elasticache_subnets}"
  availability_zones       = "${data.terraform_remote_state.vpc.elasticache_subnets_azs}"
  apply_immediately        = "true"
  security_groups          = ["${data.terraform_remote_state.sg.ec_redis_sg_id}"]
  instance_type            = "cache.m3.large"
  automatic_failover       = "true"
  snapshot_retention_limit = "7"

  alarm_memory_threshold_bytes = "10000000"
  notification_topic_arn       = "${module.ec_redis_prod_sns_pagerduty.pagerduty_sns_topic_arn}"

  tags = {
    "Name"        = "redis-prod"
    "Environment" = "production"
    "Cluster"     = "production.infra.ibis.io"
    "Terraform"   = "true"
  }
}

```



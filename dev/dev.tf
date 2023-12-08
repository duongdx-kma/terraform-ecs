# need provision ecr and push docker image first
#module "ecr" {
#  source = "../modules/ecr"
#  aws_region = var.aws_region
#  tags = var.tags
#}

# VPC module
module "vpc" {
  source     = "../modules/vpc"
  env        = var.env
  aws_region = var.aws_region
  tags       = var.tags
}


module "vpc-endpoint" {
  source = "../modules/vpc-endpoint"
  env        = var.env
  aws_region = var.aws_region
  tags       = var.tags
  vpc_id = module.vpc.vpc_id
  vpc_endpoint_sg_ids = [module.security-groups.endpoint-sg-id]
  vpc_endpoint_subnet_ids = slice(module.vpc.private_subnets, 0, 3)
}

# Security group module
module "security-groups" {
  source = "../modules/security-groups"
  env = var.env
  vpc_id =  module.vpc.vpc_id
  aws_region = var.aws_region
  tags = var.tags
  alb-ingress = [{
    from_port: var.lb-listen-port
    to_port: var.lb-listen-port
    protocol: var.lb-listen-protocol
    cidr_blocks: ["0.0.0.0/0"]
  }]

  instance-ingress = [{
    from_port: var.instance-port
    to_port: var.instance-port
    protocol: "TCP"
  }]

  endpoint-ingress = [{
    from_port: "443"
    to_port: "443"
    protocol: "TCP"
  }]
}

module "roles" {
  source     = "../modules/roles"
  env        = "dev"
  aws_region = var.aws_region
  tags       = var.tags
}

module "alb" {
  source     = "../modules/alb"
  env        = "dev"
  vpc_id     = module.vpc.vpc_id
  tags       = var.tags
  alb-sg-ids = [module.security-groups.alb-sg-id]
  alb-public-subnet-ids = slice(module.vpc.public_subnets, 0, 3)
  health-check-count = 3
  lb-listen-port = var.lb-listen-port
  lb-listen-protocol = var.lb-listen-protocol
}

module "policies" {
  source = "../modules/policies"
  task-execution-role-name = module.roles.ecs-task-execution-role.name
  task-role-name = module.roles.ecs-task-role.name
  alb-arn = module.alb.lb-arn
}

module "ecs" {
  source = "../modules/ecs"
  aws_region = var.aws_region
  tags = var.tags
  env = "dev"
  task-execution-role-arn = module.roles.ecs-task-execution-role.arn
  task-role-arn = module.roles.ecs-task-role.arn
  repository-url = "240993297305.dkr.ecr.ap-southeast-1.amazonaws.com/my-ecr"
  private-subnet-ids = slice(module.vpc.private_subnets, 0, 3)
  private-sg-ids = [module.security-groups.instance-sg-id]
  target-group-arn = module.alb.target-group-arn
}

module "auto-scaling" {
  source = "../modules/auto-scaling"
  ecs_cluster = module.ecs.ecs_cluster
  ecs_service = module.ecs.ecs_service
}

module "route53" {
  source = "../modules/route53"
  elb-dns-name = module.alb.lb-dns
  elb-zone-id = module.alb.lb-zone-id
  hosted_zone_id = "Z10021163CFESZLAG77PX"
}
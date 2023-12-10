module "ecr" {
  source     = "../modules/ecr"
  aws_region = var.aws_region
  tags       = var.tags
}

# VPC module
module "vpc" {
  source     = "../modules/vpc"
  env        = var.env
  aws_region = var.aws_region
  tags       = var.tags
}

module "vpc-endpoint" {
  source                     = "../modules/vpc-endpoint"
  env                        = var.env
  tags                       = var.tags
  vpc_id                     = module.vpc.vpc_id
  aws_region                 = var.aws_region
  vpc_endpoint_sg_ids        = [module.security-groups.endpoint-sg-id]
  vpc_endpoint_subnet_ids    = slice(module.vpc.private_subnets, 0, 2) // private-subnet-a, private-subnet-b
  vpc-private-route-table-id = [module.vpc.private-route-table-id]
}

# Security group module
module "security-groups" {
  source     = "../modules/security-groups"
  env        = var.env
  tags       = var.tags
  vpc_id     =  module.vpc.vpc_id
  aws_region = var.aws_region

  alb-ingress = [{
    from_port: var.lb-listen-port
    to_port: var.lb-listen-port
    protocol: "TCP"
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
  env        = var.env
  tags       = var.tags
  aws_region = var.aws_region
}

module "alb" {
  source                = "../modules/alb"
  env                   = var.env
  tags                  = var.tags
  vpc_id                = module.vpc.vpc_id
  alb-sg-ids            = [module.security-groups.alb-sg-id]
  lb-listen-port        = var.lb-listen-port
  health-check-count    = 3
  lb-listen-protocol    = var.lb-listen-protocol
  alb-public-subnet-ids = slice(module.vpc.public_subnets, 0, 2) // public-subnet-a, public-subnet-b
}

module "policies" {
  source                     = "../modules/policies"
  alb-arn                    = module.alb.lb-arn
  task-role-name             = module.roles.ecs-task-role.name
  task-execution-role-name   = module.roles.ecs-task-execution-role.name
}

module "jenkins-instance" {
  source                    = "../modules/jenkins-instance"
  user-data                 = data.cloudinit_config.cloudinit-jenkins.rendered
  public-key                = file(var.path-to-public-key)
  ubuntu-ami                = var.ubuntu-ami[var.aws_region]
  instance-device-name      = var.instance-device-name
  instance-type             = var.instance-type
  jenkins-ingress = [{
    from_port: 22
    to_port: 22
    protocol: "TCP"
    cidr_blocks: ["0.0.0.0/0"]
  }, {
    from_port: 80
    to_port: 80
    protocol: "TCP"
    cidr_blocks: ["0.0.0.0/0"]
  }, {
    from_port: 8080
    to_port: 8080
    protocol: "TCP"
    cidr_blocks: ["0.0.0.0/0"]
  }]
}

module "ecs" {
  source                  = "../modules/ecs"
  env                     = var.env
  tags                    = var.tags
  aws_region              = var.aws_region
  task-role-arn           = module.roles.ecs-task-role.arn
  private-sg-ids          = [module.security-groups.instance-sg-id]
  repository-url          = "${module.ecr.ecr-output}:${var.commit-id}"
  target-group-arn        = module.alb.target-group-arn
  private-subnet-ids      = slice(module.vpc.private_subnets, 0, 2) // private-subnet-a, private-subnet-b
  express-service-count   = var.express-service-count
  task-execution-role-arn = module.roles.ecs-task-execution-role.arn
}

##module "auto-scaling" {
##  source      = "../modules/auto-scaling"
##  ecs_cluster = module.ecs.ecs_cluster
##  ecs_service = module.ecs.ecs_service
##}
#
module "route53" {
  source         = "../modules/route53"
  elb-dns-name   = module.alb.lb-dns
  elb-zone-id    = module.alb.lb-zone-id
  hosted_zone_id = "Z10021163CFESZLAG77PX"
}
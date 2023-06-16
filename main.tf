terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "cidr-subnets" {
  source          = "./modules/cidrsubnets"
  ipv4-cidr-block = var.vpc-cidr-block
  list_newbits    = var.list_newbits
}

module "network" {
  source = "./modules/network"

  vpc-cidr-block     = var.vpc-cidr-block
  no-private-subnets = var.no-private-subnets
  no-public-subnets  = var.no-public-subnets
  cidr-subnets       = module.cidr-subnets.cidr-subnets
  server-port        = var.server-port
}

module "db" {
  source = "./modules/db"

  privatesubnetids = module.network.private-subnet-ids
  db-sg-ids        = module.network.db-sg-ids
  username         = var.db-username
  password         = var.db-password
}

module "ecs" {
  source = "./modules/ecs"

  private-subnet-ids = module.network.private-subnet-ids
  public-subnet-ids  = module.network.public-subnet-id
  app-sg-ids         = module.network.app-sg-ids
  db-host            = module.db.db-host
  lb-name            = module.alb.lb-name
  target-grp-arn     = module.alb.target-grp-arn
  server-port        = var.server-port
  aws-region         = var.region
  docker-image       = var.docker-image
  db-username        = var.db-username
  db-password        = var.db-password
}

module "alb" {
  source = "./modules/alb"

  vpc-id            = module.network.vpc-id
  public-subnet-ids = module.network.public-subnet-id
  lb-sg-ids         = module.network.lb-sg-ids
  server-port       = var.server-port
}

module "autoscaling" {
  source = "./modules/autoscaling"

  cluster-name = module.ecs.cluster-name
  service-name = module.ecs.service-name
}
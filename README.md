# Discussionplatform Infra

## Project Overview
- This repository consists of modules to help deploy the backend of the Discussion Platform application([Link to Application](https://github.com/JasonPauldj/DiscussionPlatform_SpringBoot_Hibernate)) on Amazon Elastic Container Service (Amazon ECS)
- I used Terraform as IaC to deploy the infrastructure
- The application is deployed in Amazon ECS with load balancing and auto scaling configured

## Terraform Modules Overview

| Module | Notes |
| --- | ----------- |
| alb | This module is used to create the Elastic Load Balancing resources - Load Balancer, Target Group, Listener |
| autoscaling | This module is used to register the ECS service as a Scaling Target and creates a TargetTrackingScaling policy |
| cidrsubnets | This module is used to calculate CIDR blocks for subnets within the VPC |
| db | This module is used to create the AWS RDS MySQL resource and DB parameter groups |
| ecs | This module is used to create the resources needed for ECS - Cluster, Associate Capacity Provider to the Cluster, Service and Task Definition |
| network | This module is used to create the network resources - VPC, Subnets, Route Tables, Internet Gateway, Security Groups and Security Group Rules |

## Terraform Commands
- `terraform fmt -recursive .` : To format all the terraform files in the directory
- `terraform apply -auto-approve` : To build the infrastructure. Note use the -auto-approve flag if you want to skip the plan output
- `terraform destroy -auto-approve` : To bring down the infrastructure

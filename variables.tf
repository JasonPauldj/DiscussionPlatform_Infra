variable "region" {
  description = "The region where you want to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "vpc-cidr-block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "no-public-subnets" {
  description = "The number of public subnets"
  type        = number
  default     = 2
}

variable "no-private-subnets" {
  description = "The number of private subnets"
  type        = number
  default     = 2
}

variable "list_newbits" {
  description = "The newbits to be passed to cidrsubnets"
  type        = list(number)
  default     = [4, 4, 4, 4]
}

variable "server-port" {
  description = "The port for the server"
  type        = number
  default     = 8080
}

variable "db-password" {
  description = "The password for the DB"
  type        = string
  sensitive   = true
}

variable "db-username" {
  description = "The name of the root user for the DB"
  type        = string
  sensitive   = true
}

variable "docker-image" {
  description = "The image of the docker to pull"
  type        = string
  default     = "jasonpaulneu/dp:latest"
}
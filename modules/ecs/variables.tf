variable "cluster-name" {
  description = "The name of the cluster"
  type        = string
  default     = "dp-cluster"
}
variable "private-subnet-ids" {
  description = "List of subnet ids to associate with the task or service"
  type        = list(string)
}


variable "public-subnet-ids" {
  description = "List of subnet ids to associate with the task or service"
  type        = list(string)
}

variable "app-sg-ids" {
  description = "List of sec groups ids to associate with the task or service"
  type        = list(string)
}

variable "db-host" {
  description = "The value of the db host"
  type        = string
}

variable "lb-name" {
  description = "The name of the application load balancer"
  type        = string
}

variable "target-grp-arn" {
  description = "The ARN of the Target Group"
  type        = string
}

variable "server-port" {
  description = "The port for the server"
  type        = number
  default     = 8080
}

variable "aws-region" {
  description = "The region for the cloudwatch logs"
  type        = string
  default     = "us-east-1"
}

variable "docker-image" {
  description = "The image of the docker to pull"
  type        = string
  default     = "jasonpaulneu/dp:latest"
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
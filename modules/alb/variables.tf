variable "vpc-id" {
  description = "The id of the VPC in which to create the Target Group"
  type        = string
}

variable "public-subnet-ids" {
  description = "List of public subnet ids"
  type        = list(string)
}

variable "lb-sg-ids" {
  description = "List of SG ids to be assigned to load balancer"
  type        = list(string)
}

variable "server-port" {
  description = "The port for the server"
  type        = number
  default     = 8080
}
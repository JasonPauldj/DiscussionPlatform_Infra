output "cluster-name" {
  description = "The name of the cluster"
  value       = aws_ecs_cluster.ecs-cluster.name
}

output "service-name" {
  description = "The name of the ecs service"
  value       = aws_ecs_service.ecs-service.name
}
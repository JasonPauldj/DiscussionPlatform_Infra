output "lb-name" {
  description = "The name of the application load balancer"
  value       = aws_lb.lb.name
}

output "target-grp-arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.tg.arn
}

output "lb-dns-name" {
  description = "The dns name of the load balancer"
  value       = aws_lb.lb.dns_name
}
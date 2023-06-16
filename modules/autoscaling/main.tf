resource "aws_appautoscaling_target" "ecs-target" {
  max_capacity       = 2
  min_capacity       = 1
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${var.cluster-name}/${var.service-name}"
}

resource "aws_appautoscaling_policy" "ecs-policy" {
  name               = "dp-ecs-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-target.service_namespace
  target_tracking_scaling_policy_configuration {
    target_value       = 2
    disable_scale_in   = false
    scale_in_cooldown  = 20
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
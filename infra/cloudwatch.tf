resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${var.project_name}-service"
  retention_in_days = 7
}

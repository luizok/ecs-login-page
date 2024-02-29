data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_service" {
  name               = "${var.project_name}-service"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json

  inline_policy {
    name = "${var.project_name}-service-policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ecs:DeregisterContainerInstance",
            "ecs:RegisterContainerInstance",
            "ecs:Submit*",
          ],
          Resource = [aws_ecs_cluster.cluster.arn]
        },
        {
          Effect = "Allow",
          Action = [
            "ecs:DiscoverPollEndpoint",
            "ecs:Poll",
            "ecs:StartTelemetrySession",
            "ecr:GetAuthorizationToken",
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
          ],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.project_name}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  inline_policy {
    name = "${var.project_name}-task-policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = "arn:aws:logs:*:*:*"
        },
        {
          Effect = "Allow",
          Action = [
            "cloudwatch:PutMetricData"
          ],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "ecs_events" {
  name               = "ecs-events-for-ecs-scheduled-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_events_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_events_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_events" {
  name   = aws_iam_role.ecs_events.name
  policy = data.aws_iam_policy.ecs_events.policy
}

data "aws_iam_policy" "ecs_events" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_role_policy_attachment" "ecs_events" {
  role       = aws_iam_role.ecs_events.name
  policy_arn = aws_iam_policy.ecs_events.arn
}
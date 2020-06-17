variable "subnet_id" {}
variable "security_group_id" {}
variable "launch_template_id" {}

# ECS role

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role"
  assume_role_policy = file("./queue/ecs_instance_role.json")
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name = "ecs_instance_role"
  role = aws_iam_role.ecs_instance_role.name
}

# Batch role

resource "aws_iam_role" "aws_batch_service_role" {
  name = "aws_batch_service_role"
  assume_role_policy = file("./queue/aws_batch_service_role.json")
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

# Environment

resource "aws_batch_compute_environment" "sample" {
  compute_environment_name = "sample"

  compute_resources {
    instance_role = aws_iam_instance_profile.ecs_instance_role.arn

    instance_type = [
      "optimal"
    ]

    max_vcpus = 4
    min_vcpus = 0
    desired_vcpus = 2

    launch_template {
      launch_template_id = var.launch_template_id
    }

    security_group_ids = [
      var.security_group_id
    ]

    subnets = [
      var.subnet_id
    ]

    ec2_key_pair = "aws-batch-example"

    type = "EC2"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
}

resource "aws_batch_job_queue" "this" {
  name = "aws-batch-sample-job-queue"
  state = "ENABLED"
  priority = "1"
  compute_environments = [
    aws_batch_compute_environment.sample.arn
  ]
  depends_on = [aws_batch_compute_environment.sample]
}

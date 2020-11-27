resource "aws_ecs_cluster" "jil_vlad_ecs_cluster" {
  name = "jil-vlad-ecs-cluster"
}

resource "aws_ecs_task_definition" "jil_vlad_task" {
  family                   = "worker" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "worker",
      "image": "603825719481.dkr.ecr.eu-west-1.amazonaws.com/infra_project_jil_vlad:prod-21163761b4179bd1503fce20d14e25677ab161d9",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.jil_vlad_cw.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "memory": 1024,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 1024
  cpu                      = 512
  execution_role_arn       = aws_iam_role.JilVladEcsTaskExecutionRole.arn
}

resource "aws_ecs_service" "jil_vlad_service" {
  name            = "jil_vlad_service"
  cluster         = aws_ecs_cluster.jil_vlad_ecs_cluster.id
  task_definition = aws_ecs_task_definition.jil_vlad_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.jil_vlad_alb_tg.arn # Referencing our target group from alb.tf file
    container_name   = aws_ecs_task_definition.jil_vlad_task.family
    container_port   = 80
  }

  network_configuration {
    subnets = [
      aws_subnet.jil_vlad_vpc_subnet_one.id,
      aws_subnet.jil_vlad_vpc_subnet_two.id
    ]
    assign_public_ip = true # Providing our containers with public IPs
    security_groups = [aws_security_group.jil_vlad_service_sg.id]
  }
}

resource "aws_security_group" "jil_vlad_service_sg" {
  vpc_id = aws_vpc.jil_vlad_vpc.id
  name   = "jil-vlad-service-sg"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.jil_vlad_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "JilVladEcsTaskExecutionRole" {
  name               = "JilVladEcsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.jil_vlad_assume_role_policy.json
}

data "aws_iam_policy_document" "jil_vlad_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "JilVladEcsTaskExecutionRole_policy" {
  role       = aws_iam_role.JilVladEcsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "jil_vlad_cw" {
  name = "jil-vlad-cw"
}
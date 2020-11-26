resource "aws_alb" "jil_vlad_alb" {
  name               = "jil-vlad-alb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.jil_vlad_vpc_subnet_one.id,
    aws_subnet.jil_vlad_vpc_subnet_two.id,
  ]
  security_groups = [aws_security_group.jil_vlad_alb_sg.id]
}

# Creating a security group for the load balancer
resource "aws_security_group" "jil_vlad_alb_sg" {
  vpc_id = aws_vpc.jil_vlad_vpc.id
  name   = "jil_vlad_alb_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "jil_vlad_alb_tg" {
  name        = "jil-vlad-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.jil_vlad_vpc.id

  depends_on = [
    aws_alb.jil_vlad_alb
  ]

  health_check {
    matcher = "200,301,302"
    path = "/"
    unhealthy_threshold = 2
    interval = 10
  }
}

resource "aws_lb_listener" "jil_vlad_alb_listener" {
  load_balancer_arn = aws_alb.jil_vlad_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jil_vlad_alb_tg.arn
  }
}
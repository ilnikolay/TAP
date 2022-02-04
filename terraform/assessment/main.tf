provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
    address  = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
provider "time" {}

resource "aws_ecr_repository" "this" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

data "aws_ecr_authorization_token" "token" {
  registry_id = aws_ecr_repository.this.registry_id
}

resource "time_static" "this" {}

resource "docker_registry_image" "this" {
  name = "${aws_ecr_repository.this.repository_url}:${formatdate("YYYYMMDD", time_static.this.rfc3339)}"

  build {
    context = "${path.cwd}/docker"
  }
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.common_tag
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet
 
  availability_zone = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.this.id
  map_public_ip_on_launch = true

  tags = {
    Name = "nik-public-${each.key}"
    AZ = each.value["az"]
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet
 
  availability_zone = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.this.id

  tags = {
    Name = "nik-private-${each.key}"
    AZ = each.value["az"]
  }
}

resource "aws_subnet" "database" {
  for_each = var.database_subnet
 
  availability_zone = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.this.id

  tags = {
    Name = "nik-database-${each.key}"
    AZ = each.value["az"]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.common_tag
  }
}

resource "aws_eip" "this" {
  vpc      = true
  tags = {
      Name = var.common_tag
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public["sub-1"].id

  tags = {
    Name = var.common_tag
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnet
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_secretsmanager_secret" "this" {
  name                = "tap-nik-rds-a"
  description = "For the assessment"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.rds_cred)
}

resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Postgres from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_postgres"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "tap-nik"
  subnet_ids = [for subnet in aws_subnet.database : subnet.id]

  tags = {
    Name = var.common_tag
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "tap-nik"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = jsondecode(aws_secretsmanager_secret_version.this.secret_string)["DB_USER"]
  password               = jsondecode(aws_secretsmanager_secret_version.this.secret_string)["DB_PASSWORD"]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
  skip_final_snapshot    = true
  multi_az = false
}

resource "aws_iam_role_policy" "this" {
  name = "tap-nik"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = [
            "${aws_secretsmanager_secret.this.arn}*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "this" {
  name = "tap-nik-ECS-assess"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "this" {
  family                   = "python_app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn = aws_iam_role.this.arn
  task_role_arn = aws_iam_role.this.arn
  container_definitions    = jsonencode([
        {
            "name": "python-rds-app", 
            "image": "${aws_ecr_repository.this.repository_url}:20220204",
             "portMappings": [
                {
                    "containerPort": 80, 
                    "hostPort": 80, 
                    "protocol": "tcp"
                }
            ],
            "enviroment": [
                {
                    "name": "DB_HOST",
                    "value": "${aws_db_instance.rds.address}"
                },
                {
                    "name": "DB_NAME",
                    "value": "postgres"
                }
            ],
            "essential": true,
            "command": ["postgres", "postgres", "${aws_db_instance.rds.address}", "qwerty123"]
            "secrets": [
                {
                    "name": "DB_USER",
                    "valueFrom": "${aws_secretsmanager_secret.this.arn}:DB_USER::"
                },
                {
                    "name": "DB_PASSWORD",
                    "valueFrom": "${aws_secretsmanager_secret.this.arn}:DB_PASSWORD::"
                }

            ]
        }
    ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


resource "aws_ecs_cluster" "this" {
  name = var.common_tag

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_ecs_service" "this" {
  name            = "python-app"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = [for subnet in aws_subnet.private : subnet.id]
    security_groups = [aws_security_group.allow_http.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "python-rds-app"
    container_port   = 80
  }

}

resource "aws_lb" "this" {
  name               = "tap-nik-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]


  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "tap-nik"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group" "alb" {
  name        = "allow_http_alb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTP"
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

  tags = {
    Name = "allow_http"
  }
}
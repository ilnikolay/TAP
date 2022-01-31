terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket         = "tap-nik-bucket"
    key            = "terraform/remote/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tap-nik-locking"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "main_one" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tap-nik"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main_one.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_one.id

  tags = {
    Name = "tap-nik"
  }
}

resource "aws_default_route_table" "rt" {
  default_route_table_id = aws_vpc.main_one.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main_one.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "ec_connect" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
  }
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "tap-nik_terra"
  }
}

resource "aws_vpc" "rds" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "tap-nik-rds"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.rds.id
  cidr_block              = "10.1.1.0/24"

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "private_az" {
  vpc_id                  = aws_vpc.rds.id
  cidr_block              = "10.1.2.0/24"
  availability_zone = "eu-central-1c"

  tags = {
    Name = "private"
  }
}

resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = aws_vpc.rds.id

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
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_az.id]

  tags = {
    Name = "tap-nik-db-sb-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "tap-nik"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
  skip_final_snapshot    = true
  multi_az = false
}

resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = aws_vpc.main_one.id
  peer_vpc_id = aws_vpc.rds.id
  auto_accept = true

  tags = {
      Name = "tap-nik"
  }
}

resource "aws_default_route_table" "rds_rt" {
  default_route_table_id = aws_vpc.rds.default_route_table_id

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }

  tags = {
    Name = "private"
  }
}
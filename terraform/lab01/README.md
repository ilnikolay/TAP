## 1. Create an S3 bucket and a dynamoDB table from the AWS Console. Set S3 and DynamoDB as the backend and locking service for your Terraform project
 - When we create the DynamoDB table we should set the Partition key to **LockID**
 ```YAMl
  backend "s3" {
    bucket         = "tap-nik-bucket"
    key            = "terraform/remote/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tap-nik-locking"
  }
```
## 2. Create VPC and ec2 t3.micro instance with Ubuntu image and new security group allowing ssh
```YAML

# Creating the VPC and one subnet
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

# Creating internet gateway so we have internet access
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_one.id

  tags = {
    Name = "tap-nik"
  }
}

# Change the default route table to include a route to the IGW and to the VPC peering connectiong
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

# Create security group that allows only ssh
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

# Create EC2 instance
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
```

## 3. Create a new VPC and a t3.micro RDS in a single AZ.
```YAML

# New VPC and two subnets
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

# Create a new route in the default route table so we can have access to the other VPC via VPC peering connection
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

# New security group that allows only 5432 for inboud so we can connect to Postgres
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

# Subnet group that we need for the RDS
resource "aws_db_subnet_group" "default" {
  name       = "tap-nik"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_az.id]

  tags = {
    Name = "tap-nik-db-sb-group"
  }
}

# Create RDS instance with postgres
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
```

## 4. Peer the two VPCs  to access the database from the EC2 instance. Check if you can access it.
```YAML
resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = aws_vpc.main_one.id
  peer_vpc_id = aws_vpc.rds.id
  auto_accept = true

  tags = {
      Name = "tap-nik"
  }
}
```

## 5. Connect to the the EC2 instance:
```bash
~/Downloads$ ssh -i "TAP_NIK.pem" ubuntu@3.120.129.125
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-1022-aws x86_64)

# Connect to the RDS

ubuntu@ip-10-0-1-172:~$ psql -h tap-nik.cohp5mdd9ipi.eu-central-1.rds.amazonaws.com -U postgres -d postgres
Password for user postgres: 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 13.1)
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

postgres-> \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 rdsadmin  | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | rdsadmin=CTc/rdsadmin
 template0 | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/rdsadmin          +
           |          |          |             |             | rdsadmin=CTc/rdsadmin
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)
```
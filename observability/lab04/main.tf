resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "nik-obs"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "tap-nik"
  }
}

resource "aws_default_route_table" "rt" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_security_group" "obs" {
  name        = "allow_obs"
  description = "allow_obs"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self      = true
  }

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow kibana"
    from_port   = 5601
    to_port     = 5601
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
    Name = "allow_obs"
  }
}

resource "aws_instance" "obs" {
  count = 2
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.medium"

  root_block_device {
    volume_type = "gp3"
  }
  key_name               = "TAP_NIK"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.obs.id]
  user_data =  <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y default-jre
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update && sudo apt install -y elasticsearch
sudo apt install -y logstash
sudo apt install -y metricbeat
sudo apt install -y filebeat
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl enable kibana.service

EOF

  tags = {
    Name = "tap-nik_node_${count.index + 1}"
  }
}

resource "aws_instance" "kibana" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.medium"

  root_block_device {
    volume_type = "gp3"
  }
  key_name               = "TAP_NIK"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.obs.id]
  user_data =  <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y default-jre
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update && sudo apt install -y elasticsearch
sudo apt install -y kibana
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl enable kibana.service

EOF

  tags = {
    Name = "tap-nik_kibana"
  }
}
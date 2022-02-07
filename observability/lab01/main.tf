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

resource "aws_security_group" "node" {
  name        = "allow_node_exporter"
  description = "allow_node_exporter"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "allow node exporter"
    from_port   = 9100
    to_port     = 9100
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
    Name = "allow_node_exporter"
  }
}

resource "aws_instance" "nodes" {
  count = 2
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

  root_block_device {
    volume_type = "gp3"
  }
  user_data =  <<EOF
#!/bin/bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
rm -f node_exporter-*.*.gz
cd node_exporter-*.*-amd64
./node_exporter
EOF
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.node.id]

  tags = {
    Name = "tap-nik_node_${count.index + 1}"
  }
}

resource "aws_security_group" "obs" {
  name        = "allow_obs"
  description = "allow_obs"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "allow prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow grafana"
    from_port   = 3000
    to_port     = 3000
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
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

  root_block_device {
    volume_type = "gp3"
  }
  key_name               = "TAP_NIK"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.obs.id]
  user_data =  <<EOF
#!/bin/bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update
sudo apt install -y grafana
sudo systemctl start grafana-server
wget https://github.com/prometheus/prometheus/releases/download/v2.33.1/prometheus-2.33.1.linux-amd64.tar.gz
tar xvf prometheus-*.*-amd64.tar.gz
rm -f prometheus-*.*.gz
cd prometheus-*.*
./prometheus

EOF

  tags = {
    Name = "tap-nik_prometheus"
  }
}
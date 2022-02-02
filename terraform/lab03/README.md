## 1. Create a simple flask hello world style python app, and create a Dockerfile from it.
```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return 'Web App with Python Flask!'

app.run(host='0.0.0.0', port=80)
```
### Docker file:
```Dockerfile
FROM python:alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 80

CMD [ "python", "app.py" ]
```

## 2. Create an AWS ECR where you can store Docker images and policy that allow to push and pull
```
resource "aws_ecr_repository" "this" {
  name                 = "tap_nik_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}
```
### Policy for the repo:
```
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
```
## 3. Use docker provider to build, and push the image to the ECR and use time provider and formatdate() to create a YYYYMMDD format tag for the image.
```YAML
provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
    address  = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
provider "time" {}

data "aws_ecr_authorization_token" "token" {
  registry_id = aws_ecr_repository.this.registry_id
}
# Use time_static to get the time
resource "time_static" "this" {}

resource "docker_registry_image" "this" {
  name = "${aws_ecr_repository.this.repository_url}:${formatdate("YYYYMMDD", time_static.this.rfc3339)}"

  build {
    context = "${path.cwd}/docker"
  }
}
```
## 1. Create an ECS cluster with cli:
```
aws ecs create-cluster \
    --cluster-name tap-nik-ecs \
    --capacity-providers FARGATE FARGATE_SPOT \
    --tags key=Name,value=tap-nik-ecs
```
## 2. Create repo in ECR
```
aws ecr create-repository \
    --repository-name tap-nik-python \
    --image-scanning-configuration scanOnPush=true \
    --encryption-configuration encryptionType=KMS,kmsKey=<Key ID>
```
## 3. Authenticate Docker client to Amazon ECR and push the image:
```bash
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.eu-central-1.amazonaws.com

docker tag 2cc42e02f5cb <aws_account_id>.dkr.ecr.eu-central-1.amazonaws.com/tap-nik-python:latest

docker push <aws_account_id>.dkr.ecr.eu-central-1.amazonaws.com/tap-nik-python:latest
```
## 4. Create task execution role
```
aws iam create-policy --policy-name tap-nik-secrets --policy-document file://tap-nik-secrets.json

aws iam create-role \
      --role-name tap-nik-ecsTaskExecutionRole \
      --assume-role-policy-document file://ecs-tasks-nik-policy.json

aws iam attach-role-policy \
      --role-name tap-nik-ecsTaskExecutionRole \
      --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

aws iam attach-role-policy \
      --role-name tap-nik-ecsTaskExecutionRole \
      --policy-arn arn:aws:iam::<acc id>:policy/tap-nik-secrets
```

## 5. Register task definition:
```
aws ecs register-task-definition --cli-input-json file://task_def.json
aws ecs list-task-definitions
```
## 6. Create Application load balancer:
```
aws elbv2 create-load-balancer --name tap-nik-ecs  \
--subnets subnet-0bdcd34132b2878cd subnet-01085e17d67cb8630 subnet-07dc9eddfc37204fe --security-groups sg-07d62022dd91d1566

aws elbv2 create-target-group --name tap-nik-ecs --protocol HTTP --port 80 \
--vpc-id vpc-0f82e72f46f9593b5 --ip-address-type ipv4 --target-type ip

aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:eu-central-1:<usr id>:loadbalancer/app/tap-nik-ecs/f930acd094b0ab6f \
--protocol HTTP --port 80  \
--default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:eu-central-1:<usr id>:targetgroup/tap-nik-ecs/e07169234614c53a
```
## 7. Create the service:
```
aws ecs create-service --cluster tap-nik-ecs --service-name python-app-srv --task-definition python-app:2 --desired-count 1 --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-024a372f662381b50,subnet-0881d55252c0e8274,subnet-085adc39e627e7a4c],securityGroups=[sg-07d62022dd91d1566]}" --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:eu-central-1:<usr id>:targetgroup/tap-nik-ecs/e07169234614c53a,containerName=python-rds-app,containerPort=80
```
## We can access the application from outside:
```
~/Work/TAP/aws/lab09$ curl tap-nik-ecs-638624110.eu-central-1.elb.amazonaws.com
{
    "user": "postgres",
    "dbname": "postgres",
    "host": "database-tap-nik.cohp5mdd9ipi.eu-central-1.rds.amazonaws.com",
    "port": "5432",
    "tty": "",
    "options": "",
    "sslmode": "prefer",
    "sslcompression": "0",
    "gssencmode": "disable",
    "krbsrvname": "postgres",
    "target_session_attrs": "any"
}
```
## 8. ECS deployment rolling update:
```
aws ecs update-service --cluster tap-nik-ecs --service python-app-srv --deployment-configuration "deploymentCircuitBreaker={enable=true,rollback=true}"
```
## Doesnt work(access denied):
```
aws application-autoscaling register-scalable-target \
--service-namespace ecs --scalable-dimension ecs:service:DesiredCount \
--resource-id service/tap-nik-ecs/python-app-srv \
--min-capacity 1 --max-capacity 3

aws application-autoscaling put-scaling-policy \
--service-namespace ecs --scalable-dimension ecs:service:DesiredCount \
--resource-id service/tap-nik-ecs/python-app-srv \
--policy-name Nik-target-tracking-scaling-policy --policy-type TargetTrackingScaling \
--target-tracking-scaling-policy-configuration '{ "TargetValue": 70.0, "PredefinedMetricSpecification": {"PredefinedMetricType": "ECSServiceAverageCPUUtilization" }, "ScaleOutCooldown": 60,"ScaleInCooldown": 60}'
```
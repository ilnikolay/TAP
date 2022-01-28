## 1. We need to add new policy(allow logs) to the Role which is used by our EC2 instances:
```JSON
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
```
## 2. Install CloudWatch Logs on our EC2 instance:
```bash
sudo yum update -y
sudo yum install -y awslogs
```
## 3. Edit the /etc/awslogs/awslogs.conf file to configure the logs to track
```
[/var/log/nginx/access.log]
datetime_format = %d/%b/%Y:%H:%M:%S %z
file = /var/log/nginx/access.log
buffer_duration = 5000
log_stream_name = nginx_access.log
initial_position = end_of_file
log_group_name = TAP_NIK
```
## 4. Start and enable awslogs service
```bash
sudo systemctl start awslogsd
sudo systemctl enable awslogsd.service
```
# Sync the contents of nginx html from the S3 bucket every 1 hour
## 1. We create the following cronjob:
```bash
ec2-user@ip-10-0-1-97 html]$ sudo crontab -l
0 * * * * aws s3 sync s3://tap-nik-bucket/html/ /usr/share/nginx/html
```
ec2-user@ip-10-0-1-97 html]$ sudo yum install stress

# Sent memory metrics to cloud watch
## 1. Add CloudWatchAgentServerPolicy to the Role used by ec2 instances
## 2. Install CloudWatch agent
```bash
sudo yum install amazon-cloudwatch-agent
```
## 3. Start CloudWatch agent conf wizard:
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```
## 4. After you finish the conf wizard start the CloudWatch agent with conf file we did in previous step:
```bash
[ec2-user@ip-10-0-1-97 ~]$ sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
Configuration validation first phase succeeded
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent -schematest -config /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml
Configuration validation second phase succeeded
Configuration validation succeeded
```
# Auto Scaling Group
## 1. Create AMI from our EC2 instance
## 2. Create Launch TEmplate or Launch configuration
## 3. Create Auto Scaling Group with the launch configuratin from previous point.


# Create CloudWatch alarm when CloudWatch Logs got an 404 error from nginx Send email to your @infinilambda email

## 1. We Create a metric with following filter:
 - [host, logName, user, timestamp, request, statusCode=404, size]
 - Metric Value = 1
 - Unit = Count
## 2. We create an alarm
 - Statistic = Sample count
 - Trigger when metric is Greater/Equal to 1
 - Create an Amazon SNS topic
 - Configure Subscribtion with our email
## 3. This is part of the mail we receive when there is a 404:
```
Alarm Details:
- Name:                       tap-nik-404-alarm
- Description:                Sends mail when there is a 404 
- State Change:               OK -> ALARM
```
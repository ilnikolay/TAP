# Make the S3 bucket a static website with the nginx html contents and publicly accessible
## 1. Enable static website hosting inside bucket properties last option.
## 2. Make the bucket Publicly accessible 
## 3. Add the following policy to the bucket:
```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::tap-nik-bucket/*"
        }
    ]
}
```
## 4. You can access the bucket via the Bucket website endpoint

# Lambda Function
## 1. Create new lambda function as per AWS tutorial:
```
https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html
```
## 2. Add S3 trigger Event type: ObjectCreatedByPut and Prefix: tap-devops-2021
## 3. And use following python code for the lambda function:
```python
from urllib import request, parse
import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        data = ('{"text":"New uploaded file: %s in bucket: %s"}' % (key,bucket)).encode('utf-8')
        req =  request.Request('slack hook URL', data=data)
        resp = request.urlopen(req)
        print("CONTENT TYPE: " + response['ContentType'])
        return response['ContentType']
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
```
# Create a CloudFront distribution for the S3 bucket and limit the access from the CloudFront service only.
## 1.  Create CloudFront distribution as per AWS guide:
### - Set Use a CloudFront origin access identity (OAI) to access the S3 bucket
```
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GettingStarted.SimpleDistribution.html
```
### - Bucket policy
```JSON
{
    "Sid": "2",
    "Effect": "Allow",
    "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3V6FLGNOJ4MN0"
    },
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::tap-nik-bucket/*"
}
```
## 2. Block public access for your S3 bucket so it can be accessed only via CloudFront.

# Download the S3 content from a private EC2
## 1. We just need to create new Endpoint with following properties:
 - Gateway endpoint
 - service name: com.amazonaws.eu-central-1.s3
 - subnet where the EC2 instance is
```bash
c2-user@ip-10-0-7-14 ~]$ aws s3 cp s3://tap-nik-bucket . --recursive
download: s3://tap-nik-bucket/404.html to ./404.html
download: s3://tap-nik-bucket/html/50x.html to html/50x.html
download: s3://tap-nik-bucket/tap-devops-2021-test2 to ./tap-devops-2021-test2
download: s3://tap-nik-bucket/tap-devops-2021-test1 to ./tap-devops-2021-test1
download: s3://tap-nik-bucket/tap-devops-2021-test3 to ./tap-devops-2021-test3
download: s3://tap-nik-bucket/html/test.html to html/test.html
download: s3://tap-nik-bucket/50x.html to ./50x.html
download: s3://tap-nik-bucket/html/404.html to html/404.html
download: s3://tap-nik-bucket/nginx-logo.png to ./nginx-logo.png
download: s3://tap-nik-bucket/html/nginx-logo.png to html/nginx-logo.png
download: s3://tap-nik-bucket/html/icons/poweredby.png to html/icons/poweredby.png
download: s3://tap-nik-bucket/html/poweredby.png to html/poweredby.png
download: s3://tap-nik-bucket/poweredby.png to ./poweredby.png
download: s3://tap-nik-bucket/index.html to ./index.html
download: s3://tap-nik-bucket/icons/poweredby.png to icons/poweredby.png
download: s3://tap-nik-bucket/html/index.html to html/index.html
```
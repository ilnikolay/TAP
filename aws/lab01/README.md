## 1. Task Create  2 custom IAM policies:
named TAP_NAME_VPC_read that provides all read-only VPC permissions but deny all actions to S3
### 1.1. Named TAP_NAME_S3_read that provides all read-only S3 permissions but deny all actions to VPC
aws iam create-policy --policy-name TAP_NIK_S3_read --policy-document file://TAP_NIK_S3_read.json
```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
```

### 1.2. Named TAP_NAME_VPC_read that provides all read-only VPC permissions but deny all actions to S3
aws iam create-policy --policy-name TAP_NIK_VPC_read --policy-document file://TAP_NIK_VPC_read.json
```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeCarrierGateways",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeEgressOnlyInternetGateways",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeLocalGatewayRouteTables",
                "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribePrefixLists",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeStaleSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeVpnGateways"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {"ec2:ResourceTag/Name": "TAP_NIK"}
            }
        }
    ]
}
```
## 2. Create role name TAP_NAME_VPC_read_Role and attach the policy TAP_NAME_VPC_read:
aws iam create-role --role-name TAP_NIK_VPC_read_Role --assume-role-policy-document file://TAP_NIK_VPC_read_Role.json
```JSON
{

    "Version": "2012-10-17",
  
    "Statement": {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
}
```
### Attachthe policy TAP_NAME_VPC_read
```
aws iam put-role-policy --role-name TAP_NIK_VPC_read_Role --policy-name TAP_NIK_VPC_read --policy-document file://TAP_NIK_VPC_read.json
```
## 3. Create an EC2 instance with AmazonLinux OS and 1 CPU and 1 GB of RAM
### KeyPair
```bash
aws ec2 create-key-pair \
    --key-name MyKeyPair \
    --key-type rsa \
    --query "KeyMaterial" \
    --output text > MyKeyPair.pem \
    --region eu-central-1
```
### EC2
```bash
aws ec2 run-instances \
    --image-id ami-05cafdf7c9f772ad2 \
    --instance-type t2.micro \
    --placement AvailabilityZone=eu-central-1a \
    --count 1 \
    --key-name MyKeyPair \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Department,Value=DevOps},{Key=Name,Value=TAP_NIK},{Key=Environment,Value=test}]' \
    --region eu-central-1
```


## 4. Update condition for the IAM policy TAP_NAME_VPC_read only effective with the EC2 with tag “Name”: “TAP_NAME”
### 4.1. Edit the VPC read policy with:
```JSON
            "Resource": "*",
            "Condition": {
                "StringEquals": {"ec2:ResourceTag/Name": "TAP_NIK"}
            }
```
### 4.2. Attach the role TAP_NAME_VPC_read_Role to the EC2
```bash
aws iam create-instance-profile --instance-profile-name TAP_NIK

aws ec2 describe-instances --region eu-central-1

"InstanceId": "i-0ce25667684fef642"

aws iam add-role-to-instance-profile --instance-profile-name TAP_NIK --role-name TAP_NIK_VPC_read_Role

aws ec2 associate-iam-instance-profile --instance-id i-0ce25667684fef642 --iam-instance-profile Name=TAP_NIK --region eu-central-1
```

## 5. List all available VPCs from the EC2 instance:
```
[ec2-user@ip-172-31-30-102 ~]$ aws ec2 describe-vpcs --region eu-central-1
{
    "Vpcs": [
        {
            "VpcId": "vpc-04fafae192bae8e5f", 
            "InstanceTenancy": "default", 
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-00875acea98a8d29f", 
                    "CidrBlock": "172.31.0.0/16", 
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ], 
            "State": "available", 
            "DhcpOptionsId": "dopt-0b4944a054c0da888", 
            "OwnerId": "900990357819", 
            "CidrBlock": "172.31.0.0/16", 
            "IsDefault": true
        }
    ]
}
```
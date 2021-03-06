# Create an RDS instance Postgresql of type t3.micro
## 1. First we need to create new subnet group:
![subnet](subnet_group.png)
## 2. Create the database:
 - Engine is PostrgreSQL
 - Template Dev/Test
 - Do not create a standby instances
 - Connectivity choose our VPC and the subnect group we created
![db](db.png)
## 3. Create a secret with the password
![secret](secret.png)

# Create a private EC2 (Internet-accessible). Use user-data to install client software to access the RDS
## 1. We crete EC2 instance:
 - In the private subnet with the NAT
 - We use IAM role so we can use the session manager
 - With following User data:
```bash
sudo amazon-linux-extras install -y postgresql13
```
## 2. We will use psql to login in to the db and list all dbs:
```bash
[ec2-user@ip-10-0-4-54 ~]$ psql --host=database-tap-nik.cohp5mdd9ipi.eu-central-1.rds.amazonaws.com --port=5432 --username=postgres --password
Password:
psql (13.3, server 13.5)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

postgres=> \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 rdsadmin  | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | rdsadmin=CTc/rdsadmin+
           |          |          |             |             | rdstopmgr=Tc/rdsadmin
 template0 | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/rdsadmin          +
           |          |          |             |             | rdsadmin=CTc/rdsadmin
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

postgres=> \q
```
# Create and RDS snapshot
## 1. Go to snapshot and choose our db instance:
![snapshot](snapshot.png)
## 2. We coppy our snapshot from Frankfurt region to the Ireland region:
![cp_snapshot](cp_snap.png)
## 3. In Ireland we have vpc and 2 private subnets so we create a subnet group with them:
![sg_irl](sg_irl.png)
## 4. Now we can restore from our snapshot
![db_restore](db_restore.png)

# Create a backup plan with AWS Backup
## 1. Create a Backup plan
 - Backup frequency is every week on Saturday
 - Retention period will be 1 Month
 - Default vault
 - Destination Frankfurt
![backup](backup_plan.png)
## 2. Assign a resource to our backup plan. Specify our RDS db and will not use tags
![resource](resource.png)

# Modify RDS to Multi-AZ and Create a read replica on another region.
## 1. Modify our RDS db  Availability and durability:
![multiaz](multiaz.png)
![db](db_modify.png)
## 2. Create a read replica in another region:
![replica](replica.png)
## 3. Our replica is created in the new region
![active_replica](active_replica.png)
## 4. Promote the replica to a standalone master RDS
![promote](promote.png)
## 4. Now we can see that it is not replica anymore,but Instance
![promoted](promoted.png)

# Optional task connect to RDS using client software on personal laptop
## 1. Install the AWS CLI Session Manager plugin
```bash
~/Downloads$ session-manager-plugin

The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.
```
## 2. Create new Policy and assign to the role which we use for the EC2 instance:
```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": [
                "arn:aws:ec2:eu-central-1:<account number>:*",
                "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
            ]
        }
    ]
}
```
## 3. Now we can connect with ssh via session manager:
```bash
~/Downloads$ ssh -i TAP_NIK.pem ec2-user@i-076b997a7f74cf9f4
The authenticity of host 'i-076b997a7f74cf9f4 (<no hostip for proxy command>)' can't be established.
Last login: Mon Jan 24 19:57:10 2022

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-10-0-4-54 ~]$ 
```
## 4. We can make the ssh tunnel
```bash
ssh -i TAP_NIK.pem ec2-user@i-076b997a7f74cf9f4 -L 5432:database-tap-nik.cohp5mdd9ipi.eu-central-1.rds.amazonaws.com:5432
```
## 5. Now we can run locally psql via the tunnel:
```bash
~/Downloads$ psql --username postgres --host 127.0.0.1 --port 5432 --password
Password: 
psql (14.1, server 13.5)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

postgres=> \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 rdsadmin  | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | rdsadmin=CTc/rdsadmin+
           |          |          |             |             | rdstopmgr=Tc/rdsadmin
 template0 | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/rdsadmin          +
           |          |          |             |             | rdsadmin=CTc/rdsadmin
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

postgres=> 
```
# EC2 with docker listening on port 80
## 1. Install docker in our ec2 instance from user data:
```bash
#!/bin/bash
sudo yum update
sudo amazon-linux-extras install -y docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
```
## 2. Create a python listener on port 80:
```python
#!/usr/bin/python3

# import the psycopg2 database adapter for PostgreSQL
from psycopg2 import connect
import os
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
if len(sys.argv) != 5:
    print("Please set corrent number of arguments")
else:
    def conn_stat():
        # instantiate a cursor object from the connection
        try:

    # declare a new PostgreSQL connection object
            conn = connect (
                dbname = sys.argv[1],
                user = sys.argv[2],
                host = sys.argv[3],
                password = sys.argv[4]
                )

    # return a dict object of the connection object's DSN parameters
            dsm_param = conn.get_dsn_parameters()
            info = json.dumps(dsm_param, indent=4)

            return info

        except Exception as err:
            return err

    class handler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200)
            self.send_header('Content-type','text/html')
            self.end_headers()

            message = str(conn_stat()+"\n")
            self.wfile.write(bytes(message, "utf8"))

    with HTTPServer(('', 80), handler) as server:
        server.serve_forever()
```
## 3. Create a docker file
```dockerfile
FROM python:alpine

ENV DB_NAME=$DB_NAME
ENV DB_USER=$DB_USER
ENV DB_HOST=$DB_HOST
ENV DB_PASSWORD=${DB_PASSWORD}


RUN pip3 install psycopg2-binary

WORKDIR /listener

COPY dsn.py .

EXPOSE 80

ENTRYPOINT [ "python", "dsn.py" ]
CMD [ "${DB_NAME}", "${DB_USER}", "${DB_HOST}", "${DB_PASSWORD}" ]
```
## 4. We run docker as follow:
```bash
[ec2-user@ip-10-0-4-54 rds]$ sudo docker run -dp 80:80 rds $DB_NAME $DB_USER $DB_HOST $DB_PASSWORD
64f769513feb9bedd5909d631d71e0bf82ceec9bd584491fe03f02459578b7d8
[ec2-user@ip-10-0-4-54 rds]$ curl localhost
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
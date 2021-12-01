1. Installed nginx:
```
amazon-linux-extras install nginx
```
2. Removed all server config from default file /etc/nginx/nginx.conf.
3. Created new server1.conf file in /etc/nginx/conf.d, with following config:
```
server {
  listen  172.31.10.24:8080;
  index   index.html;
  
  root    /home/ec2-user/websrv/;
}
```
4. Start the nginx service:
```
systemctl start nginx
```

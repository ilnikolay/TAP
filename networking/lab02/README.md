1. Created new server in /etc/nginx/conf.d/server2.conf with following config
```
server {
	listen 80;
	root /home/ec2-user/websrv;
}
```

2. In global config file of nginx added following, also here we are listening on port 8080:
```
	location / {
		proxy_pass http://127.0.0.1:80;
	}
```
3. Used tcpdump to capture traffic on port 80 with any interface, you can check whats captured in the output file.
```
sudo tcpdump -i any -vv port 80
```

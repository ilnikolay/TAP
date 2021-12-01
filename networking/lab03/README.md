1. Together with server1 from LAB01 created new server listening on locahost:81 with following config:
```
server {
  listen  127.0.0.1:81;
  index   index.html;
  
  root    /home/ec2-user/websrv1/;
}
```
2. Will reuse the proxy.conf from LAB02 and will add load balancing functionality to it:
```
upstream backendservers {
	server 127.0.0.1:80;
	server 127.0.0.1:81;
}

server {
  listen 172.31.10.24:8080;
  server_name _;
  
  location / {
    proxy_pass http://backendservers/;
  }
}
```
3. There is tcpdump capture log.
4. Here is a netstat:
![netstat](https://github.com/ilnikolay/TAP/blob/main/networking/lab03/Screenshot%202021-12-01%20at%2012.58.43.png?raw=true "netstat")
